NAME
    Device::Sphero - A perl library for communication with Sphero robots via
    their Bluetooth API. <http://www.gosphero.com/>

VERSION
    0.0.1

SYNOPSIS
    use Device::Sphero;

    my $sphero_by_name = Device::Sphero->new({ name => 'NameOfSphero' });

    # Or if the address is already known...

    my $sphero_by_addr = Device::Sphero->new({ addr => 'TheAddress' });

DESCRIPTION
    A library to create an accessible means of communication with Sphero
    Robots via their Bluetooth API. See more details about the specifics of
    Sphero's Bluetooth API at <https://developer.gosphero.com/> and
    <https://github.com/orbotix/DeveloperResources>

METHODS
  remote_devices
    calls Net::Bluetooth::get_remote_devices

  find_addr_by_name
    return address based on name passed. A partial name is possible as a
    regex search is done if an exact match isn't found.

  sdp_records
    returns call from Net::Bluetooth::sdp_search with the address stored in
    this object.

  name
    returns the name, if known.

  addr
    returns the address. This is required to communicate with the Sphero.
    There are ways to find the address if note known as described in the
    SYNOPSIS.

REQUIREMENTS
  Net::Bluetooth
    As of this writing, Net::Bluetooth only supports BlueZ (on Linux) or
    Windows' Bluetooth drivers.

  IO::Socket
    So we can use send and recv

  List::Util
    For first

  Throw
    Exception handling

AUTHOR
    Travis Chase, "gaudeon at cpan dot org"

LICENSE
    This program is free software. You can redistribute it and/or modify it
    under the same terms as Perl itself.

