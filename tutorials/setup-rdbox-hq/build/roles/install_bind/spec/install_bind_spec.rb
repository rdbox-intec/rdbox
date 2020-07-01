require 'spec_helper'

#
describe package("bind9") do
  it { should be_installed }
end