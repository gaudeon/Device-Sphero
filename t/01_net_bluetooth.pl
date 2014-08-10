#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 3;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Device::Sphero;

my $devices = Device::Sphero::remote_devices;

SKIP: {
    skip "Sphero device not found" => 3 unless $devices && scalar ( grep { $_ =~ /sphero/i } values %$devices ); 

    ok( $devices, "Devices returned by remote_devices" );

    my $addr = Device::Sphero->new->find_addr_by_name('Sphero');

    ok( $addr, "Returned address from find_addr_by_name" );

    my $records = Device::Sphero->new({ addr => $addr })->sdp_records;

    ok( $records, "Returned data from sdp_records");

}
