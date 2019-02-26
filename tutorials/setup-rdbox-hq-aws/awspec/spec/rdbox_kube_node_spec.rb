require 'spec_helper'

describe ec2(ENV['RDBOX_HQ_PREF_NAME'] + "Ec2InstanceKubeNode01") do
  it { should exist }
  it { should be_running }
  its(:image_id) { should eq ENV['AWS_EC2_IMAGE_ID'] }
  its(:instance_type) { should eq ENV['AWS_EC2_INSTANCE_TYPE_KubeNode'] }
  it { should have_security_group(ENV['RDBOX_HQ_PREF_NAME'] + 'SecurityGroup') }
  it { should belong_to_vpc(ENV['RDBOX_HQ_PREF_NAME'] + 'VPC') }
  it { should belong_to_subnet(ENV['RDBOX_HQ_PREF_NAME'] + 'Subnet') }
  it { should_not have_eip() }
#  it { should have_network_interface() }
#  it { should have_credit_specification('standard') }
end

#
