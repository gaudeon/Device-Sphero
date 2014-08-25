package Device::Sphero::Response::Null;

use strict;
use warnings;

use base qw(Device::Sphero::Response);


sub sop1 { 0 }

sub sop2 { 0 }

sub response_code { 0 }

sub sequence { 0 }

sub length { 1 }

sub data { [] }

sub checksum { 0 }

sub validate_checksum { 1 }

1;

__END__

=pod

=head1 NAME

Device::Sphero::Response::Null - Used to return empty response objects. Useful in cases where no response is required.

=cut
