require 'spec_helper'

#
lst_dir = [ "/etc/kubernetes",
            "/etc/kubernetes/manifests",
            "/etc/kubernetes/pki",
]
lst_dir.each do |dir|
  describe file("#{dir}") do
    it { should be_directory }
    it { should be_owned_by('root') }
    it { should be_mode '755' }
  end
end

#
lst_file = [ "/etc/kubernetes/admin.conf",
             "/etc/kubernetes/controller-manager.conf",
             "/etc/kubernetes/kubelet.conf",
             "/etc/kubernetes/scheduler.conf",
]
lst_file.each do |file|
  describe file("#{file}") do
    it { should be_file }
    it { should be_owned_by('root') }
    it { should be_mode '600' }
  end
end

#
target_user = ENV['TARGET_USER']
describe file("/home/#{target_user}/.kube") do
  it { should be_directory }
  it { should be_owned_by(target_user) }
  it { should be_mode '750' }
end
describe file("/home/#{target_user}/.kube/config") do
  it { should be_file }
  it { should be_owned_by(target_user) }
  it { should be_mode '600' }
end
describe command("diff /etc/kubernetes/admin.conf /home/#{target_user}/.kube/config") do
  its(:exit_status) { should eq 0 }
end
lst_file = [ "kube-proxy-amd64.yml.rej",
             "kube-proxy-arm.yml.rej",
]
lst_file.each do |file|
  describe file("/home/#{target_user}/rdbox/tmp/#{file}") do
    it { should_not exist }
  end
end

#
lst_pod = [ "kube-apiserver",
            "kube-scheduler",
            "kube-controller-manager",
            "kube-proxy-amd64",
            "kube-flannel-ds-amd64-hq-other",
            "coredns",
]
lst_pod.each do |pod|
  describe command("kubectl get pods --namespace kube-system --no-headers=true | grep -c #{pod}") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match('^[1-9][0-9]*$') }
  end
end

# checking node label @setup_kubeadam_init.sh
describe command("kubectl get nodes `hostname` --namespace kube-system --no-headers=true -L node.rdbox.com/location") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(' hq$') }
end

#
RDBOX_NET_ADRS_KUBE_MASTER=`../bin/get_hq_variable.sh RDBOX_NET_ADRS_KUBE_MASTER`.chomp
describe command("ip -d addr | grep vxlan | grep 'rdbox' | grep '#{RDBOX_NET_ADRS_KUBE_MASTER}' | wc -l") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('1') }
end

#
