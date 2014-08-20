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

    return $self->{'checksum'};
}

sub validate_checksum {
    my $self = shift;

    my $sum;

    $sum += 1 * $_ for ( $self->response_code, $self->sequence, $self->length, @{ $self->data } );
    $sum = $sum % 256;
    $sum = ~$sum & 0xFF;

    return $sum == $self->checksum;
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
