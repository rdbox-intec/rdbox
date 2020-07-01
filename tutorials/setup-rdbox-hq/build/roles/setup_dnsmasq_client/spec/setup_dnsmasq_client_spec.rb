require 'spec_helper'

#
RDBOX_NET_ADRS_RDBOX_MASTER=`../bin/get_hq_variable.sh RDBOX_NET_ADRS_RDBOX_MASTER`.chomp
RDBOX_NET_NAME_RDBOX_MASTER=`../bin/get_hq_variable.sh RDBOX_NET_NAME_RDBOX_MASTER`.chomp
describe command("host -4 #{RDBOX_NET_NAME_RDBOX_MASTER}.hq.rdbox.lan | awk '{print $4}'") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match("^#{RDBOX_NET_ADRS_RDBOX_MASTER}$") }
end

#
describe command("host www.example.com") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match('^$') }
end

#
describe command("curl -s -L www.example.com | wc -l") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('^[1-9][0-9]*$') }
end
#describe command("curl -s -L www.example.com") do
#  # this is not success.
#  its(:stdout) { should_not match('^$') }
#end

#
