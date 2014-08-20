package Device::Sphero::Constants;

use strict;
use warnings;

# -- MISC -- 

use constant RESPONSE_HEADER_SIZE => 5;

# -- COMMANDS --

# DID CORE - 0x00
use constant CMD_PING    => ( 0x00, 0x01 );
use constant CMD_VERSION => ( 0x00, 0x02 );

# DID DEVICE - 0x02
use constant CMD_SET_RGB_LED => ( 0x02, 0x20 );

# -- RESPONSE CODES --

1;

__END__

=pod

=head1 NAME

Device::Sphero::Constants - Constants for Device::Sphero (General Bluetooth API commands)

=head1 SYNOPSIS

use Device::Sphero::Constants;

my @cmd = Device::Sphero::Constants->CMD_PING;

=cut
