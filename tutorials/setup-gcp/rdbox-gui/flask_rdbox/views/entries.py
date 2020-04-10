#!/usr/bin/env python3
from flask import request, Response
from flask_rdbox import app
from flask_rdbox.views.utils import Utils
from flask_rdbox.views.g_cloud_setupper import GCloudSetupper
from googleapiclient import discovery
from oauth2client.client import GoogleCredentials
from os.path import expanduser
import os
import subprocess
import json

@app.route('/api/bootstrap/gcp/login/url', methods=['GET'])
def getLoginURL():
    gcloud_setupper = GCloudSetupper()
    retObj = gcloud_setupper.getURL()
    return json.dumps(retObj)


@app.route('/api/bootstrap/gcp/login/status', methods=['GET'])
def getAuthList():
    try:
        ret = subprocess.run(['gcloud', 'auth', 'list', '--format', 'json'],
                             timeout=30,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)
        if ret.returncode == 0:
            return Response(response=str(ret.stdout.decode("utf8")),
                            status=200)
        else:
            return Response(response=json.dumps({"msg": 'Internal Server Error.'}),
                            status=500)
    except Exception as e:
        return Response(response=json.dumps({"msg": type(e).__name__}),
                        status=500)


@app.route('/api/bootstrap/gcp/login/token', methods=['POST'])
def setLoginToken():
    ret = json.loads(request.get_data())
    gcloud_setupper = GCloudSetupper()
    code, msg = gcloud_setupper.setToken(ret['token'], ret['date'])
    if code == 200:
        subprocess.run(['bash', os.path.dirname(os.path.abspath(__file__))+'/static/hook/afterlogin.sh'])
    return Response(response=json.dumps({'ret': str(code), 'msg': str(msg)}),
                    status=code)


@app.route('/api/bootstrap/gcp/projects', methods=['GET'])
def getProjectList():
    projects = {}
    try:
        credentials = GoogleCredentials.get_application_default()
        service = discovery.build('cloudresourcemanager', 'v1', credentials=credentials)
        request = service.projects().list()
        while request:
            response = request.execute()
            for project in response.get('projects', []):
                if project.get('lifecycleState') == 'ACTIVE':
                    projects.setdefault(project.get('projectId'), project.get('name'))
            request = service.projects().list_next(previous_request=request, previous_response=response)
    except Exception as e:
        return Response(response=json.dumps({"msg": type(e).__name__}),
                        status=500)
    else:
        return Response(response=json.dumps(projects),
                        status=200)


@app.route('/api/bootstrap/gcp/compute/zones', methods=['GET'])
def getZoneList():
    zones = {}
    try:
        credentials = GoogleCredentials.get_application_default()
        service = discovery.build('compute', 'v1', credentials=credentials)
        req = service.zones().list(project=request.args.get('project'))
        while req:
            response = req.execute()
            for zone in response.get('items', []):
                region = zone.get('region').split('/')[-1]
                zones.setdefault(region, [])
                zones[region].append(zone.get('name'))
            req = service.zones().list_next(previous_request=req, previous_response=response)
    except Exception as e:
        return Response(response=json.dumps({"msg": e}),
                        status=500)
    else:
        return Response(response=json.dumps(zones),
                        status=200)


@app.route('/api/bootstrap/gcp/compute/machine-types', methods=['GET'])
def getMachineTypeList():
    machines = {}
    try:
        credentials = GoogleCredentials.get_application_default()
        service = discovery.build('compute', 'v1', credentials=credentials)
        req = service.machineTypes().list(project=request.args.get('project'), zone=request.args.get('zone'))
        while req:
            response = req.execute()
            for machine in response.get('items', []):
                machines.setdefault(machine.get('name'), machine.get('description'))
            req = service.machineTypes().list_next(previous_request=req, previous_response=response)
    except Exception as e:
        return Response(response=json.dumps({"msg": type(e).__name__}),
                        status=500)
    else:
        return Response(response=json.dumps(machines),
                        status=200)


@app.route('/api/bootstrap/gcp/deployment-manager/deployments/resources', methods=['GET'])
def getDeploymentResourcesList():
    resources = {
        'done': [],
        'update': [],
        'error': [],
        'emsg': [],
        'status': []
    }
    try:
        credentials = GoogleCredentials.get_application_default()
        service = discovery.build('deploymentmanager', 'v2', credentials=credentials)
        req = service.resources().list(project=request.args.get('project'), deployment=request.args.get('deployment'))
        total = 0
        while req:
            response = req.execute()
            for resource in response.get('resources', []):
                total = total + 1
                if 'update' in resource:
                    if 'error' in resource.get('update'):
                        resources['error'].append(resource.get('name'))
                        for err in resource['update']['error'].get('errors', []):
                            try:
                                message = json.loads(err.get('message'))
                                if 'ResourceErrorMessage' in message:
                                    resources['emsg'].append(message.get('ResourceErrorMessage').get('message', 'unknown'))
                            except Exception:
                                pass
                    else:
                        resources['update'].append(resource.get('name', 'unknown'))
                else:
                    resources['done'].append(resource.get('name', 'unknown'))
            req = service.resources().list_next(previous_request=req, previous_response=response)
        percentage = total if total == 0 else int(len(resources['done']) / total * 100)
        resources['status'].append(str(percentage))
        if resources['status'][0] == '100':
            try:
                process_list = Utils.find_procs_by_name('after_bootstrap.sh')
                if len(process_list) == 0:
                    subprocess.Popen(['bash',
                                      os.path.dirname(os.path.abspath(__file__))+'/static/hook/after_bootstrap.sh',
                                      request.args.get('project'),
                                      request.args.get('deployment')],
                                     stderr=subprocess.PIPE,
                                     stdout=subprocess.PIPE)
            except Exception:
                pass
    except Exception as e:
        return Response(response=json.dumps({"msg": type(e).__name__}),
                        status=500)
    else:
        return Response(response=json.dumps(resources),
                        status=200)


@app.route('/api/bootstrap/gcp/deployment-manager/deployments', methods=['POST'])
def setDeploymentCreateProperties():
    try:
        ret = json.loads(request.get_data())
        secretKey = ret.pop('adminSecretKey')
        publicKey = ret.pop('adminPubKey')
        properties_str = Utils.format_properties(ret)
        template_path = os.path.dirname(os.path.abspath(__file__)) + '/static/deployment_manager/network-template.jinja'
    except Exception:
        return Response(response=json.dumps({"msg": 'Invalid Request.'}),
                        status=400)
    try:
        os.mkdir(os.path.join(expanduser("~"), '.ssh'), 0o700)
        with open(os.path.join(expanduser("~"), '.ssh', 'id_rsa'), mode='w') as f:
            f.write(secretKey)
        with open(os.path.join(expanduser("~"), '.ssh', 'authorized_keys'), mode='w') as f:
            f.write(publicKey)
        with open(os.path.join(expanduser("~"), '.ssh', 'id_rsa.pub'), mode='w') as f:
            f.write(publicKey)
        os.chmod(os.path.join(expanduser("~"), '.ssh', 'id_rsa'), 0o600)
        os.chmod(os.path.join(expanduser("~"), '.ssh', 'authorized_keys'), 0o600)
    except Exception:
        pass
    try:
        ret = subprocess.run(['gcloud', 'deployment-manager', 'deployments', 'create', ret['resourcesPrefix'],
                              '--template', template_path,
                              '--properties', properties_str,
                              '--project', ret['project'],
                              '--format', 'json',
                              '--async'],
                             timeout=30,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)
        if ret.returncode == 0:
            return Response(response=str(ret.stdout.decode("utf8")),
                            status=200)
        else:
            if ret.stdout.decode("utf8") != '':
                subprocess.run(['gcloud', 'deployment-manager', 'deployments', 'delete', ret['resourcesPrefix'],
                                '--delete-policy', 'DELETE',
                                '--project', ret['project'],
                                '--format', 'json',
                                '--async'],
                               timeout=30,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
                return Response(response=str(ret.stdout.decode("utf8")),
                                status=412)
            else:
                return Response(response=json.dumps({"msg": ret.stderr.decode("utf8")}),
                                status=400)
    except subprocess.TimeoutExpired as e:
        return Response(response=json.dumps({"msg": type(e).__name__}),
                        status=500)
    except Exception as e:
        return Response(response=json.dumps({"msg": type(e).__name__}),
                        status=500)
