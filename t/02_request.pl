#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More tests => 8;

use Device::Sphero::Request;

use Data::Dumper;
use Data::HexDump;

my $request = Device::Sphero::Request->new({
    command            => 'ping',
    sop2_reset_timeout => 1,
    sop2_answer        => 1,
    sequence           => 82, 
});

ok($request, 'We have a request object');

ok($request->sop1 == 0xFF, 'SOP1 is correct');

ok($request->sop2 == 0xFF, 'SOP2 is correct');

ok(scalar( @{ $request->command_code } ) == 2, 'Command Code is two bytes long');

ok($request->sequence == 0x52, 'Sequence is correct');

ok($request->length == 1, 'Length is correct');

ok(scalar( @{ $request->data } ) == 0, 'Data is empty');

ok($request->checksum == 0xAB, 'Checksum is correct');
