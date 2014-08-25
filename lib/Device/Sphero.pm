package Device::Sphero;

use strict;
use warnings;

our $VERSION = '0.0.1';
$VERSION = eval $VERSION;

use Device::Sphero::Constants;
use Device::Sphero::Response;
use Device::Sphero::Response::Null;

use List::Util qw(first);
use Net::Bluetooth;
use Throw;

use Data::Dumper;
use Data::HexDump;

sub new {
    my $class = shift;
    my $args  = shift || {};

    $args = {} unless ref $args eq 'HASH';

    return bless $args, $class;
}

sub remote_devices { get_remote_devices() }

sub find_addr_by_name {
    my $self = shift;
    my $name = shift || throw "Name required";

    my $devices = $self->remote_devices();

    my %name_to_key = map { $devices->{ $_ } => $_ } keys %$devices;

    return $name_to_key{ $name } if exists $name_to_key{ $name };

    my $device_name = first { $_ =~ /$name/ } keys %name_to_key;

    return $device_name ? $name_to_key{ $device_name } : undef;
}

sub sdp_records {
    my $self = shift;

    return $self->{'sdp_records'} ||= do {
        my $hash = sdp_search($self->addr,'1101','');
        throw "Missing RFCOMM service record" unless exists $hash->{'RFCOMM'};
        $hash;
    };
}

sub rfcomm_port { shift->sdp_records->{'RFCOMM'} };

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

sub nbt_socket { 
    my $self = shift;

    $self->{'__nbt_socket'} ||= Net::Bluetooth->newsocket('RFCOMM');

    throw "Socket error: $!\n" unless $self->{'__nbt_socket'};

    return $self->{'__nbt_socket'};
}

sub nbt_socket_fh {
    my $self = shift;
    return $self->{'__nbt_socket_fh'} ||= do {
        throw "Connection error: $!\n" unless $self->nbt_socket->connect( $self->addr, $self->rfcomm_port ) == 0;
        $self->nbt_socket->perlfh();
    };
}

sub send_request {
    my $self    = shift;
    my $request = shift;

    ref $request eq 'Device::Sphero::Request' || throw 'Invalid request';
   
    my $fh = $self->nbt_socket_fh;

    syswrite $fh, $request->packet;

    my $response;

    if($request->sop2_answer) {
        my $buffer;

        sysread $fh, $buffer, Device::Sphero::Constants::RESPONSE_HEADER_SIZE;

        my $response_class_name = 'Device::Sphero::Response::' . $self->response_class_name($request->command);
        
        $response = eval {
            my $response_class_location = $response_class_name;
            $response_class_location =~ s|::|/|g;
            require $response_class_location . '.pm';
            $response_class_name->new($buffer);
        } || undef;
        
        $response = Device::Sphero::Response->new($buffer) if ! $response;
        
        sysread $fh, $buffer, $response->length;

        $response->parse_body($buffer);
    }
    else {
        $response = Device::Sphero::Response::Null->new();
    }

    return $response;
}

sub response_class_name {
    my ($self, $request_name) = @_;
    
    $request_name = ucfirst(lc($request_name));
    $request_name =~ s/_(\w)/uc($1)/eg;
    $request_name =~ s/_//g;
    
    return $request_name;
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

=head2 L<List::Util>

For first

=head2 L<Throw>

Exception handling

=head1 AUTHOR

Travis Chase, C<< gaudeon at cpan dot org >>

=head1 LICENSE

This program is free software. You can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
