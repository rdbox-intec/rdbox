require 'spec_helper'

#
home_dir = "/home/" + ENV['TARGET_USER']

#
describe file("#{home_dir}/.bashrc.rdbox-hq") do
  it { should be_file }
  it { should be_owned_by(ENV['TARGET_USER']) }
  it { should be_mode '640' }
end

#
if (`../bin/get_hq_variable.sh RDBOX_HQ_BUILD_PF` =~ /^aws$/i) then
  describe file("#{home_dir}/.bashrc.rdbox-hq-aws") do
    it { should be_file }
    it { should be_owned_by(ENV['TARGET_USER']) }
    it { should be_mode '640' }
  end
end

#
describe file("#{home_dir}/rdbox/tmp") do
  it { should be_directory }
  it { should be_owned_by(ENV['TARGET_USER']) }
  it { should be_mode '750' }
end

#
lst_cmd = [ "nslookup",
            "dig",
            "traceroute",
]
lst_cmd.each do |cmd|
  describe command("which #{cmd}") do
    its(:exit_status) { should eq 0 }
  end
end

#
describe port(22) do
  it { should be_listening }
end

#
