#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More tests => 8;

use Device::Sphero::Response;

use Data::Dumper;
use Data::HexDump;

my $response_header = pack('C*', 0xFF, 0xFF, 0x00, 0x52, 0x01);

my $response_body   = pack('C*', 0xAC);

my $response = Device::Sphero::Response->new( $response_header );

$response->parse_body( $response_body );

ok($response, 'We have a response object');

ok($response->sop1 == 0xFF, 'SOP1 is correct');

ok($response->sop2 == 0xFF, 'SOP2 is correct');

ok($response->response_code == 0, 'Response Code is correct');

ok($response->sequence == 0x52, 'Sequence is correct');

ok($response->length == 1, 'Length is correct');

ok(scalar( @{ $response->data } ) == 0, 'Data is empty');

ok($response->validate_checksum, 'Checksum is correct');
