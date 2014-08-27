package Device::Sphero::Request::SetRgbLed;

use strict;
use warnings;

use base qw(Device::Sphero::Request);

use Throw;

sub _validate_args {
    my $self = shift;
    my $args = shift;

    throw "red required" unless defined $args->{'red'};
    
    throw "red must be a value between 0 and 255"
        unless  $args->{'red'} =~ m/^\d+$/
                && $args->{'red'} >= 0
                && $args->{'red'} <= 255;
                
    throw "green required" unless defined $args->{'green'};
    
    throw "green must be a value between 0 and 255"
        unless  $args->{'green'} =~ m/^\d+$/
                && $args->{'green'} >= 0
                && $args->{'green'} <= 255;
                
    throw "blue required" unless defined $args->{'blue'};
    
    throw "blue must be a value between 0 and 255"
        unless  $args->{'blue'} =~ m/^\d+$/
                && $args->{'blue'} >= 0
                && $args->{'blue'} <= 255;
}

sub red { shift->{'red'} }

sub green { shift->{'green'} }

sub blue { shift->{'blue'} }

sub flag_color_persists { shift->{'flag_color_persists'} ? 1 : 0 }

sub data {
    my $self = shift;
    
    return [ $self->red, $self->green, $self->blue, $self->flag_color_persists ];
}

sub body_pack_format { 'C4' }

1;

__END__

=pod

=head1 NAME

=cut

