require 'spec_helper'

#describe xxx(ENV['RDBOX_HQ_PREF_NAME'] + "XXXXXXX") do
#  it { should exist }
#end

#
describe vpc(ENV['RDBOX_HQ_PREF_NAME'] + "VPC") do
  it { should exist }
  it { should be_available }
  its(:cidr_block) { should eq ENV['AWS_VPC_CIDR'] }
  it { should have_route_table(ENV['RDBOX_HQ_PREF_NAME'] + "RouteTable") }
  it { should have_vpc_attribute('enableDnsHostnames') }
  it { should have_vpc_attribute('enableDnsSupport') }
end

#
describe internet_gateway(ENV['RDBOX_HQ_PREF_NAME'] + "InternetGateway") do
  it { should exist }
  it { should be_attached_to(ENV['RDBOX_HQ_PREF_NAME'] + "VPC") }
end

# maybe not supported 'dhcp_options'
#describe dhcp_options(ENV['RDBOX_HQ_PREF_NAME'] + "DHCPOptions") do
#  it { should exist }
#end

#
describe subnet(ENV['RDBOX_HQ_PREF_NAME'] + "Subnet") do
  it { should exist }
  it { should be_available }
  it { should belong_to_vpc(ENV['RDBOX_HQ_PREF_NAME'] + "VPC") }
  its(:cidr_block) { should eq ENV['AWS_VPC_CIDR'] }
end

#
describe route_table(ENV['RDBOX_HQ_PREF_NAME'] + "RouteTable") do
  it { should exist }
  it { should belong_to_vpc(ENV['RDBOX_HQ_PREF_NAME'] + "VPC") }
  it { should have_subnet(ENV['RDBOX_HQ_PREF_NAME'] + "Subnet") }
  it { should have_route('0.0.0.0/0').target(gateway: ENV['RDBOX_HQ_PREF_NAME'] + "InternetGateway") }
  it { should have_route(ENV['AWS_VPC_CIDR']).target(gateway: 'local') }
end

#
#describe route(ENV['RDBOX_HQ_PREF_NAME'] + "Route") do
#  it { should exist }
#end

#
describe security_group(ENV['RDBOX_HQ_PREF_NAME'] + "SecurityGroup") do
  it { should exist }
  it { should belong_to_vpc(ENV['RDBOX_HQ_PREF_NAME'] + "VPC") }

  #
  ENV['AWS_SecurityGroupAllowGlobal'].split(",").each do |adrs|
    ["tcp"].each do |protocol|
      [22, 443, 30443].each do |port|
        its(:inbound) { should be_opened(port).protocol(protocol).for(adrs) }
      end
    end
  end

  #
  ENV['AWS_SecurityGroupAllowPrivate'].split(",").each do |adrs|
    ["tcp"].each do |protocol|
      [22, 443, 30443].each do |port|
        its(:inbound) { should be_opened(port).protocol(protocol).for(adrs) }
      end
    end
  end

  #
  ["10.0.0.0/8", ENV['RDBOX_NET_CIDR'], ENV['AWS_VPC_CIDR']].each do |adrs|
    ["tcp", "udp"].each do |protocol|
      port = '0-65535'
      its(:inbound) { should be_opened(port).protocol(protocol).for(adrs) }
    end
  end

  #
  its(:inbound) { should be_opened(-1).protocol("icmp").for("0.0.0.0/0") }

  #
  its(:outbound) { should be_opened.protocol('all').for('0.0.0.0/0') }

  #
end

#
