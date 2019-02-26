require 'spec_helper'

#
lst_file = [ "/etc/network/interfaces.d/50-rdbox-init.cfg",
]
lst_file.each do |file|
  describe file("#{file}") do
    it { should be_file }
    it { should be_owned_by('root') }
    it { should be_mode '644' }
  end
end

#
