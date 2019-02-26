#!/usr/bin/perl

use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

my $infile = "Vagrantfile.in";
my $outfile = "Vagrantfile";
my $paramfile = "rdbox-hq-vb.params";
my $paramfileAddOn = "rdbox-hq-vb.params.addon";
my $worker_ip_offset = 10;

GetOptions(
  'infile|i=s' => \$infile,
  'outfile|o=s' => \$outfile,
  'paramfile|p=s' => \$paramfile,
  'help|h' => \$help
  );

my $help_message = "Usage: createVagrantfile.pl [options]
       [options]
        -i  [template of Vagrantfile] - default: Vagrantfile.in
        -o  [output Vagrantfile]      - default: Vagrantfile
        -p  [list of parameter]       - default: rdbox-hq-vb.params
        -h  print this message\n";

if ($help) {
  die $help_message;
}

(-f $infile) || die "$infile: $!\n---\n$help_message";
(-f $paramfile) || die "$paramfile: $!\n---\n$help_message";
  
my $rdbox_network = "RDBOX_NETWORK";
my $private_network = "PRIVATE_NETWORK";
my @network_address = ($private_network, "DEFAULT_NETWORK");
my @netmask = ($rdbox_network, $private_network);
my @network_inv = ($rdbox_network);
my @mac = ("MASTER_PUBLIC_MAC", "VPN_PUBLIC_MAC");
my @exclude_params = ("PUBLIC_BRIDGE_NIC", "WORKER_VMNAME_PREFIX", "WORKER_HOSTNAME_PREFIX");
my @worker_expand_tag = ("WORKER_VMNAME_PREFIX", "WORKER_HOSTNAME_PREFIX");
my @paramsAddOn = (
  "HTTP_ON",
  "HTTPS_ON",
  "RDBOX_NETMASK",
  "RDBOX_NETWORK_INV",
  "PRIVATE_NETMASK",
  "PRIVATE_ADDRESS",
  "DEFAULT_ADDRESS",
  "WORKER_PRIVATE_IP",
  "WORKER_VMNAME",
  "WORKER_HOSTNAME"
  );
my %params = ();

$params{"HTTP_PROXY"} = "";
$params{"HTTPS_PROXY"} = "";
$params{"HTTP_ON"} = "false";
$params{"HTTPS_ON"} = "false";

open(PARAM, "sh -x $paramfile 2>&1 |") || die "$paramfile: $!\n";

while ($line = <PARAM>) {
  if ($line =~ /^\s*\#/) {
    next;
  }
  if ($line =~ /^\+\s*(\S+)\s*=\s*(\S+)\s*$/) {
    my $key = $1;
    my $val = $2;
    if ($key eq "HTTP_PROXY") {
      $params{$key} = $val;
      $params{"HTTP_ON"} = "true";
    } elsif ($key eq "HTTPS_PROXY") {
      $params{$key} = $val;
      $params{"HTTPS_ON"} = "true";
    } else {
      $params{$key} = $val;
    }
  }
}

close(PARAM);

print "creating $infile => $outfile by $paramfile...\n";

for my $key (@network_address) {
  if (!(defined $params{$key})) {
    die "$key not found.";
  }
  my $key2 = $key;
  $key2 =~ s/^(.*)_NETWORK$/$1_ADDRESS/;
  $params{$key2} = $params{$key};
  $params{$key2} =~ s/^([0-9\.]+)\/.*/$1/;
}

for my $key (@netmask) {
  if (!(defined $params{$key})) {
    die "$key not found.";
  }

  my $netmask = $params{$key};
  $netmask =~ s/^([0-9\.]+)\/(\d+)$/$2/;

  my $key2 = $key;
  $key2 =~ s/^(.*)_NETWORK$/$1_NETMASK/;

  $params{$key2} = &get_netmask($netmask);
}

for my $key (@network_inv) {
  if (!(defined $params{$key})) {
    die "$key not found.";
  }

  my $network = $params{$key};
  $network =~ s/^([0-9\.]+)\/(\d+)$/$1/;

  my $key2 = $key . "_INV";

  $params{$key2} = &get_inv($network);
}

$new_worker_tag = &get_unused_worker_tag();

$worker_vmname_tmp = sprintf($params{"WORKER_VMNAME"}, $new_worker_tag);
$params{"WORKER_VMNAME"} = $worker_vmname_tmp;
$worker_hostname_tmp = sprintf($params{"WORKER_HOSTNAME"}, $new_worker_tag);
$params{"WORKER_HOSTNAME"} = $worker_hostname_tmp;

if (!(defined $params{$private_network})) {
    die "$private_network not found.";
}

$params{"WORKER_PRIVATE_IP"} = &get_new_worker_address($params{$private_network}, $worker_ip_offset, $new_worker_tag);

$content = &load_file($infile);

foreach my $key (sort { length $b <=> length $a || $a cmp $b } keys %params) {
  if (grep { $_ eq $key } @exclude_params) {
    next;
  }
  $content =~ s/$key/$params{$key}/g;
}

for my $key (@mac) {
  if (!(defined $params{$key})) {
    $replace = "mac: \"" . $key . "\",";
    $content =~ s/$replace//g;
  }
}

&save_file($outfile, $content);

&save_paramfileAddOn($paramfileAddOn, \%params, @paramsAddOn);

print "done.\n";

#-------------------------------------------------------------

sub load_file() {
  my($filename) = @_;

  open(IN, "< $filename") || die "$filename: $!\n";
  binmode IN;
  local $/ = undef;
  my $data = <IN>;
  close(IN);

  return $data;
}

sub save_file() {
  my($filename, $data) = @_;

  open(OUT, "> $filename") || die "$filename: $!\n";
  binmode OUT;
  local $/ = undef;
  print OUT $data;
  close(OUT);
}

sub save_paramfileAddOn() {
  my($filename, $params, @paramsAddOn) = @_;

  open(OUT, "> $filename") || die "$filename: $!\n";
  binmode OUT;
  local $/ = undef;

  for my $key (@paramsAddOn) {
    if (defined $$params{$key}) {
      print OUT "$key=$$params{$key}\n";
    }
  }
  
  close(OUT);
}

sub get_netmask() {
  my($size) = @_;
  my($ret) = "";

  my $quot = int($size / 8);
  my $rem = $size % 8;

  my $cnt = 0;
  for (;$cnt < $quot; $cnt++) {
    $ret .= "255.";
  }
  
  if ($cnt++ < 4) {
    my $data = 0x01;
    if ($rem == 0) {
      $ret .= "0.";
    } else {
      for ($i = 1; $i < $rem; $i++) {
        $data <<= 1;
        $data |= 0x01;
      }
      for ($i = 0; $i < (8 - $rem); $i++) {
        $data <<= 1;
      }
      $ret .= $data . ".";
    }
  }

  for (;$cnt < 4; $cnt++) {
    $ret .= "0.";
  }

  $ret =~ s/^(.*)\.$/$1/;

  return $ret;
}

sub get_inv() {
  my($network) = @_;
  my @list = reverse(split(/\./, $network));

  my $ret = "";
  foreach my $key (@list) {
    if ($key == 0) {
      next;
    }
    $ret .= $key . ".";
  }
  $ret =~ s/^(.*)\.$/$1/;

  return $ret;
}

sub get_unused_worker_tag() {
  my @used_worker_list = ();
  my $commandline = "VBoxManage list vms | cut -d ' ' -f 1 | sed -e 's/\"//g'";
  
  open(COMMAND, "$commandline |") || die "$commandline: $!\n";
  
  while (my $line = <COMMAND>) {
    if ($line =~ /^\S+_$params{"WORKER_VMNAME_PREFIX"}-(\d+)_[\d_]+$/) {
      push(@used_worker_list, $1);
    }
  }
  
  close(COMMAND);
  
  my $new_tag = 0;
  for ($i = 1; $i < 100; $i++) {
    if (grep { $_ == $i } @used_worker_list) {
      next;
    } else {
      $new_tag = $i;
      last;
    }
  }

  if ($new_tag == 0) {
    die "No space in the number of tags (1-99).";
  }

  return $new_tag;
}

sub get_new_worker_address() {
  my($network, $offset, $tag) = @_;
  my(@iplist) = split(/\./, $network);
  my($num) = 0;
  my($address) = "";

  $num = $iplist[1]*(256**2) + $iplist[2]*256 + $iplist[3];
  $num += $offset + $tag;

  for ($i = 0; $i < 3; $i++) {
    my $ret = $num % 256;
    $address = "$ret.$address";
    $num = int($num/256);
  }
  $address =~ s/^(.*)\.$/$1/;
  return "$iplist[0].$address";
}

sub dump() {
  foreach my $key (sort keys %params) {
    print "$key => $params{$key}\n";
  }
}
