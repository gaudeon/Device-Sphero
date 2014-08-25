#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More tests => 1;

use Device::Sphero;
use Device::Sphero::Request;
use List::Util qw(first);

use Data::Dumper;
use Data::HexDump;

my $devices = Device::Sphero::remote_devices;

my $device_name = first { $_ =~ /sphero/i } values %$devices;

SKIP: {
    skip 'Sphero device not found' => 5 unless $devices && $device_name;

    my %name_to_key = map { $devices->{ $_ } => $_ } keys %$devices;
    my $addr        = $name_to_key{ $device_name };
    my $sphero      = Device::Sphero->new({ addr => $addr });

    ok( $sphero, 'We have a Device::Sphero object' );
}
