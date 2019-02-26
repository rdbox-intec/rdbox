require 'spec_helper'

describe ec2(ENV['RDBOX_HQ_PREF_NAME'] + "Ec2InstanceVpnServer") do
  it { should exist }
  it { should be_running }
  its(:image_id) { should eq ENV['AWS_EC2_IMAGE_ID'] }
  its(:instance_type) { should eq ENV['AWS_EC2_INSTANCE_TYPE_VpnServer'] }
  it { should have_security_group(ENV['RDBOX_HQ_PREF_NAME'] + 'SecurityGroup') }
  it { should belong_to_vpc(ENV['RDBOX_HQ_PREF_NAME'] + 'VPC') }
  it { should belong_to_subnet(ENV['RDBOX_HQ_PREF_NAME'] + 'Subnet') }
  it { should have_eip(ENV['RDBOX_HQ_PREF_NAME'] + 'EIPVpnServer') }
#  it { should have_credit_specification('standard') }
end

#
