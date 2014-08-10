#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 2;

use FindBin;
use lib "$FindBin::Bin/../lib";

use_ok('Device::Sphero');

require_ok('Device::Sphero');
