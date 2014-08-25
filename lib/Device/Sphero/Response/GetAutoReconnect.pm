package Device::Sphero::Response::GetAutoReconnect;

use strict;
use warnings;

use base qw(Device::Sphero::Response);

sub flag { shift->data->[0] }

sub time { shift->data->[1] }

1;

__END__

=pod

=cut
