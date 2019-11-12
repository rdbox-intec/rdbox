require 'spec_helper'

#
describe package("docker-ce") do
  it { should be_installed.with_version(ENV["DOCKER_VERSION"]) }
end      

#
lst_cmd = [ "docker-ce",
]
lst_cmd.each do |cmd|
  describe command("apt-mark showhold #{cmd}") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match '^docker-ce$' }
  end
end

#
