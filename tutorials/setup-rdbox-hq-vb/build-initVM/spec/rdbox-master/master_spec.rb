require 'serverspec'
require 'net/ssh'
require 'tempfile'

%w{python curl wget}.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe user('ubuntu') do
  it { should exist }
end

test_host = 'www.intec.co.jp'
describe host(test_host) do
  it { should be_resolvable.by('dns') }
end

describe command('curl https://www.intec.co.jp/ -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end
