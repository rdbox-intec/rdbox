#!/usr/bin/env python3

import os
import yaml
import json
from googleapiclient import discovery
from oauth2client.client import GoogleCredentials


def main():
    credentials = GoogleCredentials.get_application_default()

    service = discovery.build('deploymentmanager', 'v2', credentials=credentials)

    project = os.environ.get('RDBOX_GCP_PROJECT')

    deployment = os.environ.get('RDBOX_GCP_DEPLOYMENT')

    request = service.manifests().list(project=project, deployment=deployment)
    response = request.execute()
    _layout = yaml.safe_load(response['manifests'][0]['layout'])
    output_list = _layout['resources'][0]['outputs']

    output_dict = {item['name'].replace('externalIp', ''): item['finalValue'] for item in output_list}

    result = {
        '_meta': {
            'hostvars': {}
        }
    }
    for k, v in output_dict.items():
        if k.startswith('K8sNode'):
            if 'K8sNode' in result:
                result['K8sNode']['hosts'].append(v)
                result['_meta']['hostvars'].setdefault(v, {})
            else:
                result.setdefault('K8sNode', {
                    'hosts': [v],
                    'vars': {}
                })
                result['_meta']['hostvars'].setdefault(v, {})
        else:
            result.setdefault(k, {
                'hosts': [v],
                'vars': {}
            })
            result['_meta']['hostvars'].setdefault(v, {})
    print(json.dumps(result))


if __name__ == '__main__':
    main()
