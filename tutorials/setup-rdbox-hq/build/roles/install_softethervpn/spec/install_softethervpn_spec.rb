require 'spec_helper'

#
describe package("softether-vpnserver") do
  it { should be_installed }
end      

#
describe package("softether-vpnclient") do
  it { should be_installed }
end      

#
describe package("softether-vpncmd") do
  it { should be_installed }
end      

#
describe package("softether-vpnbridge") do
  it { should be_installed }
end      