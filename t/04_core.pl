#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More tests => 3;

use Device::Sphero;
use Device::Sphero::Request;
use List::Util qw(first);

my $devices = Device::Sphero::remote_devices;

my $device_name = first { $_ =~ /sphero/i } values %$devices;

SKIP: {
    skip 'Sphero device not found' => 3 unless $devices && $device_name;

    my %name_to_key = map { $devices->{ $_ } => $_ } keys %$devices;
    my $addr        = $name_to_key{ $device_name };
    my $sphero      = Device::Sphero->new({ addr => $addr });

    ok( $sphero, 'We have a Device::Sphero object' );

    my $request = Device::Sphero::Request->new({
        command            => 'ping',
        sequence           => 00,
        sop2_reset_timeout => 1,
        sop2_answer        => 1,
    });

    my $response = $sphero->send_request( $request );

    ok( $response->validate_checksum && $response->response_code == 0, 'ping successful' );

    $request = Device::Sphero::Request->new({
        command            => 'set_rgb_led',
        sequence           => 00,
        sop2_reset_timeout => 1,
        sop2_answer        => 1,
        data               => [ 0xFF, 0x00, 0x00 ],
    });

    $response = $sphero->send_request( $request );

    ok( $response->validate_checksum && $response->response_code == 0, 'set_rgb_led successful' );
}
