#!/usr/bin/env python3
import yaml
import copy
import sys
import os


class KubeProxyDaemonSet(object):

    def __init__(self, original_data, arch):
        self.original_data = copy.deepcopy(original_data)
        self.arch = arch
        self.__process_nodeSelector()
        self.__process_image()
        self.__process_metadata_name()

    def __process_nodeSelector(self):
        self.original_data.get('spec').get('template').get('spec').get('nodeSelector').setdefault('kubernetes.io/arch', self.arch)

    def __process_image(self):
        containers = self.original_data.get('spec').get('template').get('spec').get('containers')
        for container in containers:
            if 'k8s.gcr.io/kube-proxy:' in container.get('image', ''):
                image_str = container.get('image')
                full_image_name, tag = image_str.split(':')
                repo_name, image_name = full_image_name.split('/')
                container['image'] = repo_name + '/' + image_name + '-' + self.arch + ':' + tag

    def __process_metadata_name(self):
        self.original_data.get('metadata')['name'] = 'kube-proxy-' + self.arch

    def generate_file_name(self):
        return '-'.join(['kube', 'proxy', self.arch]) + '.yaml'

    def write(self, dir_path):
        path = os.path.join(dir_path, self.generate_file_name())
        with open(path, 'w') as f:
            f.write(yaml.safe_dump(self.original_data))


class OriginalApplyFile(object):

    def __init__(self, path):
        self.path = path
        with open(path, 'r') as f:
            self.original_data = yaml.safe_load(f.read())

    def transition_to_rdbox(self, dir_path):
        ds_armhf = KubeProxyDaemonSet(self.original_data, 'arm')
        ds_armhf.write(dir_path)
        ds_arm64 = KubeProxyDaemonSet(self.original_data, 'arm64')
        ds_arm64.write(dir_path)
        ds_amd64 = KubeProxyDaemonSet(self.original_data, 'amd64')
        ds_amd64.write(dir_path)


if __name__ == '__main__':
    args = sys.argv
    if len(args) >= 3:
        input_path = os.path.abspath(os.path.normpath(args[1]))
        dir_path = os.path.abspath(os.path.normpath(args[2]))
        if os.path.exists(input_path) and os.path.exists(dir_path):
            original_apply_file = OriginalApplyFile(input_path)
            original_apply_file.transition_to_rdbox(dir_path)
        else:
            print('directory or file does not exist.')
    else:
        print('Arguments are too short')
