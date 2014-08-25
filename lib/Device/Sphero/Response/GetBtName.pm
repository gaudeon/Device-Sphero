package Device::Sphero::Response::GetBtName;

use strict;
use warnings;

use base qw(Device::Sphero::Response);

use constant NAME_INDEX   => 0;
use constant NAME_LENGTH  => 16;
use constant ADDR_INDEX   => 16;
use constant ADDR_LENGTH  => 12;
use constant COLOR_INDEX  => 29;
use constant COLOR_LENGTH => 3;

sub bt_name {
    my $self = shift;
    
    return $self->{'bt_name'} ||= do {
        my @bytes = @{ $self->data }[ NAME_INDEX ..  (NAME_INDEX + NAME_LENGTH - 1) ];
        join( '', map { chr } @bytes );
    };
}

sub bt_addr {
    my $self = shift;
    
    return $self->{'bt_addr'} ||= do {
        my @bytes = @{ $self->data }[ ADDR_INDEX ..  (ADDR_INDEX + ADDR_LENGTH - 1) ];
        join( '', map { chr } @bytes );
    };
}

sub bt_id_colors {
    my $self = shift;
 
    return $self->{'bt_id_colors'} ||= do {
        my @bytes = @{ $self->data }[ COLOR_INDEX ..  (COLOR_INDEX + COLOR_LENGTH - 1) ];
        [ map { chr } @bytes ];
    };   
}

1;

__END__

=pod

=cut
