#!/usr/bin/perl

use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

my $nic = "";

GetOptions(
  'i|i=s' => \$nic
  );

($nic =~ /^$/) && die "interface name is not set.\n";

while ($line = <>) {
  if ($line =~ /^\s+$nic:$/) {
    my $pos = index($line, $nic);
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
  } else {
    print $line;
  }
}
