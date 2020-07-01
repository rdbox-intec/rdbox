require 'spec_helper'

#
lst_file_dnsmasq = [ "dnsmasq.conf",
                     "resolv.dnsmasq.conf",
]
lst_file_dnsmasq.each do |file_dnsmasq|
  describe file("/etc/#{file_dnsmasq}") do
    it { should be_file }
    it { should be_mode '644' }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
  end
end

#
lst_package = [ "dnsmasq",
                "ipcalc",
]
lst_package.each do |package|
  describe package("#{package}") do
    it { should be_installed }
  end
end

#
describe service('dnsmasq') do
  it { should be_enabled }
  it { should be_running }
end

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
