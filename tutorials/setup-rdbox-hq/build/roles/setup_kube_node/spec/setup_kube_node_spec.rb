require 'spec_helper'

# setup_kubeadam_init.sh
describe command("kubectl get nodes `hostname` --namespace kube-system --no-headers=true -L node.rdbox.com/location") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(' hq$') }
end

#
describe command("ipcalc -n `ip -d addr | grep vxlan | grep 'rdbox' | awk '{print $5}'` | grep HostMin | awk '{print $2}'") do
  its(:exit_status) { should eq 0 }
end
describe command("ping -c 1 `kubectl get po --all-namespaces -o wide | grep '10\.244\.0\.' | awk '{print $7}' | head -1` > /dev/null") do
  its(:exit_status) { should eq 0 }
end

#
describe command("host www.example.com") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match('^$') }
end

#
