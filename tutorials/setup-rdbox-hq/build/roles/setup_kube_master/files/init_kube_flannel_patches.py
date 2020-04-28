#!/usr/bin/env python3
import yaml
import os
import json
import urllib.request
import re
import copy
import sys


class LatestVersion(object):

    URL = 'https://api.github.com/repos/coreos/flannel/tags'
    version = 'v0.0.0'

    def __init__(self):
        self.execute_request()

    def execute_request(self):
        req = urllib.request.Request(self.URL)
        with urllib.request.urlopen(req) as res:
            body = json.loads(res.read())
            self.version = body[0].get('name', 'v0.12.0')

    def toString(self):
        return self.version


class KubeFlannelDaemonSet(object):

    ds = {}
    arch = ''
    location = ''
    role = ''

    def __init__(self, ds, location, role='other'):
        self.ds = copy.deepcopy(ds)
        self.arch = self._perse_arch()
        self.location = location
        self.role = role
        self._process_location()
        self._process_role()
        self._process_resource_name()

    def _perse_arch(self):
        arch = ''
        nodeSelectorTerms = self.ds.get('spec').get('template').get('spec').get('affinity').get('nodeAffinity').get('requiredDuringSchedulingIgnoredDuringExecution').get('nodeSelectorTerms')
        matchExpressions = [v for i, v in enumerate(nodeSelectorTerms) if 'matchExpressions' in v][0].get('matchExpressions', [])
        for i, v in enumerate(matchExpressions):
            if v.get('key') == 'beta.kubernetes.io/arch':
                arch = v.get('values')[0]
        return arch

    def _process_location(self):
        if self.location == 'hq':
            self._process_location_hq()
        elif self.location == 'edge':
            self._process_location_edge()

    def _process_location_hq(self):
        self.ds.get('spec').get('template').get('spec').get('affinity').get('nodeAffinity').get('requiredDuringSchedulingIgnoredDuringExecution').get('nodeSelectorTerms')[0].get('matchExpressions').append(
            {
                'key': 'node.rdbox.com/location',
                'operator': 'In',
                'values': [
                    'hq'
                ]
            }
        )
        containers = self.ds.get('spec').get('template').get('spec').get('containers')
        index_kube_flannel = 0
        for i, v in enumerate(containers):
            if v.get('name') == 'kube-flannel':
                index_kube_flannel = i
        containers[index_kube_flannel].get('args').append('--iface=vpn_rdbox')

    def _process_location_edge(self):
        self.ds.get('spec').get('template').get('spec').get('affinity').get('nodeAffinity').get('requiredDuringSchedulingIgnoredDuringExecution').get('nodeSelectorTerms')[0].get('matchExpressions').append(
            {
                'key': 'node.rdbox.com/location',
                'operator': 'In',
                'values': [
                    'edge'
                ]
            }
        )

    def _process_role(self):
        if self.role == 'rdbox':
            self._process_role_rdbox()
        elif self.role == 'other':
            self._process_role_other()

    def _process_role_rdbox(self):
        self.ds.get('spec').get('template').get('spec').get('affinity').get('nodeAffinity').get('requiredDuringSchedulingIgnoredDuringExecution').get('nodeSelectorTerms')[0].get('matchExpressions').append(
            {
                'key': 'node.rdbox.com/edge',
                'operator': 'In',
                'values': [
                    'master',
                    'slave'
                ]
            }
        )
        containers = self.ds.get('spec').get('template').get('spec').get('containers')
        index_kube_flannel = 0
        for i, v in enumerate(containers):
            if v.get('name') == 'kube-flannel':
                index_kube_flannel = i
        containers[index_kube_flannel].get('args').append('--iface=br0')

    def _process_role_other(self):
        self.ds.get('spec').get('template').get('spec').get('affinity').get('nodeAffinity').get('requiredDuringSchedulingIgnoredDuringExecution').get('nodeSelectorTerms')[0].get('matchExpressions').append(
            {
                'key': 'node.rdbox.com/edge',
                'operator': 'In',
                'values': [
                    'other'
                ]
            }
        )

    def _process_resource_name(self):
        self.ds.get('metadata')['name'] = '-'.join([self.ds.get('metadata').get('name'), self.location, self.role])

    def resource_name(self):
        return self.ds.get('metadata').get('name')

    def file_name(self):
        return '-'.join(['kube', 'flannel', self.arch, self.location, self.role])

    def write(self, dir_path):
        path = os.path.join(dir_path, self.file_name() + '.yaml')
        with open(path, 'w') as f:
            f.write(yaml.safe_dump(self.ds))


class OriginalApplyFile(object):

    BASE_URL = 'https://raw.githubusercontent.com/coreos/flannel'
    SUFFIX_URL = '/Documentation/kube-flannel.yml'
    original_data = []

    def __init__(self):
        self.original_data = self.execute_request()

    def execute_request(self):
        dict_list = []
        url = self.assemble_url()
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req) as res:
            body = res.read().decode('utf-8')
            split_string_list = [v for i, v in enumerate(body.split('---')) if v != '']
            dict_list = [yaml.safe_load(item) for item in split_string_list]
        return dict_list

    def assemble_url(self):
        version = LatestVersion()
        url = self.BASE_URL + '/' + version.toString() + '/' + self.SUFFIX_URL
        return url

    def transition_to_rdbox(self, dir_path):
        group = self.group_for_rdbox()
        for k, v in group.items():
            if k == 'main_damon_set':
                for i, v in enumerate(v):
                    ds_er = KubeFlannelDaemonSet(v, 'edge', 'rdbox')
                    ds_eo = KubeFlannelDaemonSet(v, 'edge', 'other')
                    ds_ho = KubeFlannelDaemonSet(v, 'hq', 'other')
                    ds_er.write(dir_path)
                    ds_eo.write(dir_path)
                    ds_ho.write(dir_path)
            elif k == 'rbac':
                dp = os.path.join(dir_path, 'rbac')
                os.makedirs(dp, exist_ok=True)
                self.write(v, dp, 'kube-flannel-rbac.yaml')
            elif k == 'config':
                self.write(v, dir_path, 'kube-flannel-config.yaml')

    def group_for_rdbox(self):
        group = {}
        for i, v in enumerate(self.original_data):
            if v.get('kind') == 'DaemonSet' and re.search('^kube-flannel-ds', v.get('metadata').get('name')) is not None:
                group.setdefault('main_damon_set', [])
                group.get('main_damon_set').append(v)
            elif re.search('^rbac', v.get('apiVersion')) is not None:
                group.setdefault('rbac', [])
                group.get('rbac').append(v)
            else:
                group.setdefault('config', [])
                group.get('config').append(v)
        return group

    def write(self, content, dir_path, file_name):
        path = os.path.join(dir_path, file_name)
        with open(path, 'w') as f:
            for i, v in enumerate(content):
                f.write('---\n')
                f.write(yaml.safe_dump(v))


if __name__ == '__main__':
    args = sys.argv
    if 2 <= len(args):
        dir_path = os.path.abspath(os.path.normpath(args[1]))
        if os.path.exists(dir_path):
            oap = OriginalApplyFile()
            oap.transition_to_rdbox(dir_path)
        else:
            print('This directory does not exist.')
    else:
        print('Arguments are too short')
