package Device::Sphero::Request;

use strict;
use warnings;

use Device::Sphero::Constants;
use Throw;

sub new {
    my $class = shift;
    my $args  = shift || {};

    $args = {} unless ref $args eq 'HASH';

    return bless $args, $class;
}

sub command { shift->{'command'} || throw "command required." }

sub command_code {
    my $self = shift;
    
    return $self->{'command_code'} ||= do {
        my $cmd = 'CMD_' . uc( $self->command );
        [ Device::Sphero::Constants->$cmd ];
    };
}

sub sequence { 
    my $self = shift; 
    return $self->{'sequence'} && $self->{'sequence'} >= 0x00 && $self->{'sequence'} <= 0xFF
        ? $self->{'sequence'} 
        : 0x00;
}

sub sop1 { 0xff }

sub sop2_reset_timeout { shift->{'sop2_reset_timeout'} ||= 0; }

sub sop2_answer { shift->{'sop2_answer'} ||= 0; }

sub sop2 {
    my $self = shift;

    return $self->{'sop2'} ||= do {
        my $sop2 = 0xFC;

        $sop2 += 2 if $self->sop2_reset_timeout; # if set, reset client inactivity timeout after calling this command
        $sop2 += 1 if $self->sop2_answer; # if set, expect a reply
    };
}

sub data { 
    my $self = shift;
    my $data = shift;

    # Set data if params where passed
    if($data) {
        $self->{'data'} = ref $data eq 'ARRAY' ? $data : [ split '', $data ];
    }
    else {
        $data = [];
    }

    if(defined $self->{'data'}) {
        $data = ref $self->{'data'} eq 'ARRAY' ? $self->{'data'} : [ split '', $self->{'data'} ];
    }

    return $data;
}

sub length {  scalar( @{ shift->data } ) + 1 };

sub checksum {
    my $self = shift;
    my $sum;

    $sum += 1 * $_ for ( @{ $self->command_code }, $self->sequence, $self->length, @{ $self->data } );
    $sum = $sum % 256;
    $sum = ~$sum & 0xFF;

    return $sum;
}

sub header {
    my $self = shift;

    return ( $self->sop1, $self->sop2, @{ $self->command_code }, $self->sequence, $self->length );
}

sub body {
    my $self = shift;

    return ( @{ $self->data } );
}

sub packet {
    my $self = shift;

    return pack('C*', $self->header, $self->body, $self->checksum);
}

1;

__END__

=pod

=cut
