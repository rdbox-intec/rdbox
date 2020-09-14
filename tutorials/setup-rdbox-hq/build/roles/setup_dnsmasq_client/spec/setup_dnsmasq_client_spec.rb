require 'spec_helper'

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
