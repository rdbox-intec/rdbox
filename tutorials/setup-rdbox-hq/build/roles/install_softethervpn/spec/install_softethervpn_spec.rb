require 'spec_helper'

#
lst_file_vpn = [ "vpnserver",
                 "vpnbridge",
                 "vpnclient",
                 "vpncmd",
]
lst_file_vpn.each do |file_vpn|
  describe file("/usr/local/#{file_vpn}/#{file_vpn}") do
    it { should be_file }
    it { should be_mode '755' }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
  end
end

#
lst_file_service = [ "vpnserver",
                     "vpnbridge",
                     "vpnclient",
]
lst_file_service.each do |file_service|
  describe file("/etc/systemd/system/#{file_service}.service") do
    it { should be_file }
    it { should be_mode '644' }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
  end
end

#
