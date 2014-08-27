package Device::Sphero::Request::SetCal;

use strict;
use warnings;

use base qw(Device::Sphero::Request);

use Throw;

sub _validate_args {
    my $self = shift;
    my $args = shift;

    throw "heading required" unless defined $args->{'heading'};
    
    throw "heading must be a value between 0 and 359"
        unless  $args->{'heading'} =~ m/^\d+$/
                && $args->{'heading'} >= 0
                && $args->{'heading'} <= 359;
}

sub heading { shift->{'heading'} }

sub data {
    my $self = shift;
    
    return [ $self->{'heading'} ];
}

sub body_pack_format { 'n' }

1;

__END__

=pod

=head1 NAME

=cut

