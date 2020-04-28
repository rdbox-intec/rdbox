require 'spec_helper'

#
describe service('softether-vpnserver') do
  it { should be_enabled }
  it { should be_running }
end

#
lst_port = [  992,
             1194,
             5555,
]
lst_port.each do |port|
  describe port(port) do
    it { should_not be_listening }
  end
end

#
lst_port = [ 443,
]
lst_port.each do |port|
  describe port(port) do
    it { should be_listening }
  end
end

#
