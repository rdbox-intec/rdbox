#!/usr/bin/perl

use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

my $nic_for_del_gw = "";
my $nic_for_add_gw = "";
my $gw = "";

GetOptions(
  'd|i=s' => \$nic_for_del_gw,
  'a|i=s' => \$nic_for_add_gw,
  'r|i=s' => \$gw
  );

($nic_for_add_gw ne "" && $gw eq "") && die "IP address for default-route on interface \"$nic_for_add_gw\" is not set.\n";

while ($line = <>) {
  if ($nic_for_del_gw ne "" && $line =~ /^\s+$nic_for_del_gw:$/) {
    my $pos = index($line, $nic_for_del_gw);
    my $indent_size = $pos / 2;
    my $indent = "";

    for ($i = 0; $i < 3 * $indent_size; $i++) {
      $indent .= " ";
    }
    print $line;
    print $indent . "dhcp4-overrides:\n";

    $indent = "";
    for ($i = 0; $i < 4 * $indent_size; $i++) {
      $indent .= " ";
    }
    print $indent . "use-routes: false\n";
  } elsif ($nic_for_add_gw ne "" && $line =~ /^\s+$nic_for_add_gw:$/) {
    my $pos = index($line, $nic_for_add_gw);
    my $indent_size = $pos / 2;
    my $indent = "";

    for ($i = 0; $i < 3 * $indent_size; $i++) {
      $indent .= " ";
    }
    print $line;
    print $indent . "gateway4: " . $gw . "\n";
  } else {
    print $line;
  }
}
