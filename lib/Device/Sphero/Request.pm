package Device::Sphero::Request;

use strict;
use warnings;

use Device::Sphero::Constants;
use Throw;

sub new {
    my $class = shift;
    my $args  = shift || {};

    $args = {} unless ref $args eq 'HASH';
    
    _validate_args($args);
    
    my $request_class_name = do {
        my $name = $args->{'command'} || '';
        
        $name = ucfirst(lc($name));
        $name =~ s/_(\w)/uc($1)/eg;
        $name =~ s/_//g;
        
        "Device::Sphero::Request::$name";
    };
    
    my $self = eval {
        my $request_class_location = $request_class_name;
        $request_class_location =~ s|::|/|g;
        require $request_class_location . '.pm';
        bless $args, $request_class_name; 
    } || undef;
    
    $self->_validate_args($args) if $self && $self->can('_validate_args');

    $self = bless $args, $class if ! $self;        

    return $self;
}

sub _validate_args {
    my $args = shift;
    
    throw "Command required" unless defined $args->{'command'};
}

sub command { shift->{'command'} }

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

sub data { [ ] } # Subclass Request in order to handle data

sub length {  length( shift->pack_body ) + 1  }; # Add one for checksum

sub checksum_pack_format { 'C' }

sub checksum {
    my $self = shift;
    my $sum;

    $sum += 1 * $_ for ( @{ $self->command_code }, $self->sequence, $self->length, @{ $self->data } );
    $sum = $sum % 256;
    $sum = ~$sum & 0xFF;

    return $sum;
}

sub pack_checksum {
    my $self = shift;
    
    return pack($self->checksum_pack_format, $self->checksum);
}

sub header_pack_format { 'C6' }

sub header {
    my $self = shift;

    return ( $self->sop1, $self->sop2, @{ $self->command_code }, $self->sequence, $self->length );
}

sub pack_header {
    my $self = shift;
    
    return pack($self->header_pack_format, $self->header);
}

sub body_pack_format { 'C*' }

sub body {
    my $self = shift;

    return ( @{ $self->data } );
}

sub pack_body {
    my $self = shift;
    
    return pack($self->body_pack_format, $self->body);
}

sub packet {
    my $self = shift;

    return $self->pack_header
           . $self->pack_body
           . $self->pack_checksum;
}

1;

__END__

=pod

=cut
