package Device::Sphero::Constants;

use strict;
use warnings;

# -- MISC -- 

use constant RESPONSE_HEADER_SIZE => 5;

# -- COMMANDS --

# DID CORE - 0x00
use constant CMD_PING               => ( 0x00, 0x01 );
use constant CMD_VERSION            => ( 0x00, 0x02 );
use constant CMD_CONTROL_UART_TX    => ( 0x00, 0x03 );
use constant CMD_SET_BT_NAME        => ( 0x00, 0x10 );
use constant CMD_GET_BT_NAME        => ( 0x00, 0x11 );
use constant CMD_SET_AUTO_RECONNECT => ( 0x00, 0x12 );
use constant CMD_GET_AUTO_RECONNECT => ( 0x00, 0x13 );
use constant CMD_GET_PWR_STATE      => ( 0x00, 0x20 );
use constant CMD_SET_PWR_NOTIFY     => ( 0x00, 0x21 );
use constant CMD_SLEEP              => ( 0x00, 0x22 );
use constant CMD_GET_POWER_TRIPS    => ( 0x00, 0x23 );
use constant CMD_SET_POWER_TRIPS    => ( 0x00, 0x24 );
use constant CMD_SET_INACTIVE_TIMER => ( 0x00, 0x25 );
use constant CMD_GOTO_BL            => ( 0x00, 0x30 );
use constant CMD_RUN_L1_DIAGS       => ( 0x00, 0x40 );
use constant CMD_RUN_L2_DIAGS       => ( 0x00, 0x41 );
use constant CMD_CLEAR_COUNTERS     => ( 0x00, 0x42 );
use constant CMD_ASSIGN_TIME        => ( 0x00, 0x50 );
use constant CMD_POLL_TIMES         => ( 0x00, 0x51 );

# DID BOOTLOADER - 0x01

# DID DEVICE - 0x02
use constant CMD_SET_CAL                 => ( 0x02, 0x01 );
use constant CMD_SET_RGB_LED             => ( 0x02, 0x20 );
use constant CMD_APPEND_TEMP_MACRO_CHUNK => ( 0x02, 0x58 );

# -- RESPONSE CODES --

use constant ORBOTIX_RSP_CODE_OK           => 0x00;
use constant ORBOTIX_RSP_CODE_EGEN         => 0x01;
use constant ORBOTIX_RSP_CODE_ECHKSUM      => 0x02;
use constant ORBOTIX_RSP_CODE_EFRAG        => 0x03;
use constant ORBOTIX_RSP_CODE_EBAD_CMD     => 0x04;
use constant ORBOTIX_RSP_CODE_EUNSUPP      => 0x05;
use constant ORBOTIX_RSP_CODE_EBAD_MSG     => 0x06;
use constant ORBOTIX_RSP_CODE_EPARAM       => 0x07;
use constant ORBOTIX_RSP_CODE_EEXEC        => 0x08;
use constant ORBOTIX_RSP_CODE_EBAD_DID     => 0x09;
use constant ORBOTIX_RSP_CODE_MEM_BUSY     => 0x0A;
use constant ORBOTIX_RSP_CODE_BAD_PASSWORD => 0x0B;
use constant ORBOTIX_RSP_CODE_POWER_NOGOOD => 0x31;
use constant ORBOTIX_RSP_CODE_PAGE_ILLEGAL => 0x32;
use constant ORBOTIX_RSP_CODE_FLASH_FAIL   => 0x33;
use constant ORBOTIX_RSP_CODE_MA_CORRUPT   => 0x34;
use constant ORBOTIX_RSP_CODE_MSG_TIMEOUT  => 0x35;

1;

__END__

=pod

=head1 NAME

Device::Sphero::Constants - Constants for Device::Sphero (General Bluetooth API commands)

=head1 SYNOPSIS

use Device::Sphero::Constants;

my @cmd = Device::Sphero::Constants->CMD_PING;

=cut
