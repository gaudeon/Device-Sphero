package Device::Sphero;

use strict;
use warnings;

our $VERSION = '0.0.1';
$VERSION = eval $VERSION;

use IO::Socket;
use List::Util qw(first);
use Net::Bluetooth;
use Throw;

sub new {
    my $class = shift;
    my $args  = shift || {};

    $args = {} unless ref $args eq 'HASH';

    return bless $args, $class;
}

sub remote_devices { get_remote_devices() }

sub find_addr_by_name {
    my $self = shift;
    my $name = shift;

    my $devices = $self->remote_devices();

    my %name_to_key = map { $devices->{ $_ } => $_ } keys %$devices;

    return $name_to_key{ $name } if exists $name_to_key{ $name };

    my $device_name = first { $_ =~ /$name/ } keys %name_to_key;

    return $device_name ? $name_to_key{ $device_name } : undef;
}

sub sdp_records {
    my $self = shift;

    return $self->{'sdp_records'} ||= sdp_search($self->addr,'','');
}

sub name { shift->{'name'} }

sub addr { 
    my $self = shift;
    
    $self->{'addr'} = shift if @_;

    return $self->{'addr'} ||= do {
        my $addr = $self->find_addr_by_name( $self->name );

        throw "Address could not be found by name." unless $addr;

        $addr;
    };
}

sub _nbt_socket { 
    my $self = shift;

    $self->{'__nbt_socket'} ||= Net::Bluetooth->newsocket('RFCOMM');

    throw "Socket error: $!\n" unless $self->{'__nbt_socket'};

    return $self->{'__nbt_socket'};
}

sub io_socket {
    my $self = shift;

    return $self->{'__io_socket'} ||= do {
        throw "Connection error: $!\n" unless $self->_nbt_socket->connect( $self->addr, $self->sdp_records->{'RFCOMM'} ) == 0;
        
        IO::Socket->new_from_fd(
            $self->_nbt_socket->perlfh(),
            'r+'
        ) || throw "Failed to create IO::Socket";
    };
}

1;

__END__

=pod

=head1 NAME

Device::Sphero - A perl library for communication with Sphero robots via their Bluetooth API. L<http://www.gosphero.com/>

=head1 VERSION

0.01

=head1 SYNOPSIS

use Device::Sphero;

my $sphero_by_name = Device::Sphero->new({ name => 'NameOfSphero' });

# Or if the address is already known...

my $sphero_by_addr = Device::Sphero->new({ addr => 'TheAddress' });

=head1 DESCRIPTION

A library to create an accessible means of communication with Sphero Robots via their Bluetooth API. See more details about the specifics of Sphero's Bluetooth API at L<https://developer.gosphero.com/> and L<https://github.com/orbotix/DeveloperResources>

=head1 METHODS

=head2 remote_devices

calls Net::Bluetooth::get_remote_devices

=head2 find_addr_by_name

return address based on name passed. A partial name is possible as a regex search is done if an exact match isn't found.

=head2 sdp_records

returns call from Net::Bluetooth::sdp_search with the address stored in this object.

=head2 name

returns the name, if known.

=head2 addr

returns the address. This is required to communicate with the Sphero. There are ways to find the address if note known as described in the SYNOPSIS.

=head1 REQUIREMENTS

=head2 L<Net::Bluetooth>

As of this writing, Net::Bluetooth only supports BlueZ (on Linux) or Windows' Bluetooth drivers.

=head2 L<IO::Socket>

So we can use send and recv

=head2 L<List::Util>

For first

=head2 L<Throw>

Exception handling

=head1 AUTHOR

Travis Chase, C<< <gaudeon at cpan dot org> >>

=head1 LICENSE

This program is free software. You can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
