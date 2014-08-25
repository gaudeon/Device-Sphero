#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More tests => 5;

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

    my $request = Device::Sphero::Request->new({
        command            => 'ping',
        sequence           => 00,
        sop2_reset_timeout => 1,
        sop2_answer        => 1,
    });

    my $response = $sphero->send_request( $request );

    ok( $response->validate_checksum && $response->response_code == 0, 'ping successful' );
    
    $request = Device::Sphero::Request->new({
        command            => 'version',
        sequence           => 00,
        sop2_reset_timeout => 1,
        sop2_answer        => 1,
    });

    $response = $sphero->send_request( $request );
    
    ok( $response->validate_checksum && $response->response_code == 0, 'version successful' );
    
    $request = Device::Sphero::Request->new({
        command            => 'get_bt_name',
        sequence           => 00,
        sop2_reset_timeout => 1,
        sop2_answer        => 1,
    });

    $response = $sphero->send_request( $request );
    
    ok( $response->validate_checksum && $response->response_code == 0, 'get_bt_name successful' );

    $request = Device::Sphero::Request->new({
        command            => 'get_auto_reconnect',
        sequence           => 00,
        sop2_reset_timeout => 1,
        sop2_answer        => 1,
    });

    $response = $sphero->send_request( $request );
    
    print HexDump $response->packet;

    ok( $response->validate_checksum && $response->response_code == 0, 'get_auto_reconnect successful' );
}
