require 'spec_helper'

#
describe service('vpnclient') do
  it { should be_enabled }
  it { should be_running }
end

#
RDBOX_NET_ADRS_VPNSERVER=`../bin/get_hq_variable.sh RDBOX_NET_ADRS_VPNSERVER`.chomp
describe command("ping -c 1 #{RDBOX_NET_ADRS_VPNSERVER} > /dev/null") do
  its(:exit_status) { should eq 0 }
end

#
