require 'spec_helper'

#
home_dir = "/home/" + ENV['TARGET_USER']

#
describe file("#{home_dir}/.kube/dashboard") do
  it { should be_directory }
  it { should be_mode '750' }
  it { should be_owned_by(ENV['TARGET_USER']) }
end

#
lst_file_dashboard = [ "admin.secret",
                       "admin.token",
]
lst_file_dashboard.each do |file_dashboard|
  describe file("#{home_dir}/.kube/dashboard/#{file_dashboard}") do
    it { should be_file }
    it { should be_mode '400' }
  it { should be_owned_by(ENV['TARGET_USER']) }
  end
end

#
lst_pod = [ "kubernetes-dashboard",
]
lst_pod.each do |pod|
  describe command("kubectl get pods --namespace kubernetes-dashboard --no-headers=true | grep -c #{pod}") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match('^1$') }
  end
end

#
describe port(30443) do
  it { should be_listening }
end

#
