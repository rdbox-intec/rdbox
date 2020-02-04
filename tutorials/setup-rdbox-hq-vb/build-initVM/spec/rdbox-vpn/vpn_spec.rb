require 'serverspec'
require 'net/ssh'
require 'tempfile'

%w{apt-transport-https ipcalc python transproxy curl wget}.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe user('ubuntu') do
  it { should exist }
end

describe service('rdbox-iptables') do
  it { should be_enabled }
  it { should be_running }
end

describe command('iptables -t nat -L|grep MASQUERADE') do
  its(:stdout) { should match /MASQUERADE\s+all\s+-\-\s+anywhere\s+anywhere/ }
end

test_host = 'www.intec.co.jp'
describe host(test_host) do
  it { should be_resolvable.by('dns') }
end

describe command('curl https://www.intec.co.jp/ -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end
