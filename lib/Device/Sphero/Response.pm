package Device::Sphero::Response;

use strict;
use warnings;

use Device::Sphero::Constants;
use Throw;

sub new {
    my $class = shift;
    my $args  = shift || {};

    $args = parse_header($args) if ! ref $args;

    $args = {} unless ref $args eq 'HASH';

    return bless $args, $class;
}

sub sop1 { shift->{'sop1'} }

sub sop2 { shift->{'sop2'} }

sub response_code { shift->{'response_code'} }

sub response_message_hash {
    
    return +{
        0x00 => 'Command succeeded',
        0x01 => 'General, non-specific error',
        0x02 => 'Received checksum failure',
        0x03 => 'Received command fragment',
        0x04 => 'Unknown command ID',
        0x05 => 'Command currently unsupported',
        0x06 => 'Bad message format',
        0x07 => 'Parameter value(s) invalid',
        0x08 => 'Failed to execute command',
        0x09 => 'Unknown Device ID',
        0x0A => 'Generic RAM access needed but it is busy',
        0x0B => 'Supplied password incorrect',
        0x31 => 'Voltage too low for reflash operation',
        0x32 => 'Illegal page number provided',
        0x33 => 'Page did not reprogram correctly',
        0x34 => 'Main Application corrupt',
        0x35 => 'Msg state machine timed out',
    };
}


sub response_message {
    my $self = shift;
    
    return $self->response_code ? $self->response_message_hash->{ $self->response_code } : '';
}

sub sequence { shift->{'sequence'} }

sub length { shift->{'length'} }

sub data {
    my $self = shift;
    my $data = shift;

    if($data) {
        $self->{'data'} = ref $data eq 'ARRAY' ? $data : [ split '', $data ];
    }

    return $self->{'data'} || [];
}

sub checksum {
    my $self     = shift;
    my $checksum = shift;

    $self->{'checksum'} = $checksum if defined $checksum;

    return defined $self->{'checksum'} ? $self->{'checksum'} : -1;
}

sub validate_checksum {
    my $self = shift;

    my $sum;

    $sum += 1 * $_ for ( $self->response_code, $self->sequence, $self->length, @{ $self->data } );
    $sum = $sum % 256;
    $sum = ~$sum & 0xFF;

    return defined $sum && defined $self->checksum && $sum == $self->checksum;
}

sub header {
    my $self = shift;

    return ( $self->sop1, $self->sop2, $self->response_code, $self->sequence, $self->length );
}

sub body {
    my $self = shift;

    return ( @{ $self->data } );
}

sub packet {
    my $self = shift;

    return pack('C*', $self->header, $self->body, $self->checksum);
}

sub parse_header {
    my ($self, $header);

    if(scalar @_ > 1) {
       ($self, $header) = @_;
    } else {
        $header = shift;
    }

    my $header_size = Device::Sphero::Constants::RESPONSE_HEADER_SIZE;

    throw "Header is not a length of $header_size" unless CORE::length($header) == $header_size; 

    my @data;

    push @data, unpack('C',$_) for split '', $header;

    my $hash = {
        sop1          => $data[0],
        sop2          => $data[1],
        response_code => $data[2],
        sequence      => $data[3],
        length        => $data[4],
    };

    if($self) {
        $self->{ $_ } = $hash->{ $_ } for keys %$hash;
    }

    return $hash;
}

sub parse_body {
    my ($self, $body);

    if(scalar @_ > 1) {
       ($self, $body) = @_;
    } else {
        $body = shift;
    }

    my @data;

    push @data, unpack('C',$_) for split '', $body;

    my $checksum = pop @data;

    my $hash = {
        data     => \@data,
        checksum => $checksum,
    };

    if($self) {
        $self->{ $_ } = $hash->{ $_ } for keys %$hash;
    }

    return $hash;

}

1;

__END__

=pod

=cut
