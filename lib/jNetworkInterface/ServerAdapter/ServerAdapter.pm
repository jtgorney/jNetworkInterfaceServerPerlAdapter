#! /bin/env/ perl

# The MIT License (MIT)
# Copyright (c) 2015 Jacob Gorney
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

package jNetworkInterface::ServerAdapter;

use strict;
use warnings;
use IO::Socket::INET;
use Carp qw(croak);

sub new {
    my $class = shift;
    my $self = {};
    # Make sure arguments are correct
    croak "Illegal number of parameters. ServerAdapter->new('hostname' => HOSTNAME, 'port' => PORT)"
        if @_ % 2;
    # Store arguments
    my %params = @_;
    if (not defined $params{"hostname"} or not defined $params{"port"}) {
        croak "Illegal params passed.";
    }
    # Set data
    $self->{HOSTNAME} = $params{"hostname"};
    $self->{PORT} = $params{"port"};
    # Connection status
    $self->{IS_CONNECTED} = 0;
    # Client socket connection
    $self->{CLIENT_SOCKET} = undef;
    # Become part of the object
    bless $self, $class;
}

sub is_connected {
    my $self = shift;
    return $self->{IS_CONNECTED};
}

sub send_command {
    my $self = shift;
    $self->connect;
    # data to send
    my %params = @_;
    if ($self->{IS_CONNECTED}) {
        # Send data on socket
        $self->{CLIENT_SOCKET}->send($params{"command"}."\n");
        # Iterate and build data
        if (defined $params{"data"}) {
            # Send the command data to server
            foreach (@{$params{"data"}}) {
                $self->{CLIENT_SOCKET}->send($_."\n");
            }
        }
        # Finally, end command directive
        $self->{CLIENT_SOCKET}->send("END COMMAND\n");
        # Response data
        $self->{CLIENT_SOCKET}->recv(my $response, 1024);
        $self->close_connection;
        return $response;
    } else {
        return "";
    }
}

sub connect {
    my $self = shift;
    my $result = 1;
    if (not $self->{IS_CONNECTED}) {
        $self->{CLIENT_SOCKET} = IO::Socket::INET->new(
            PeerAddr => $self->{HOSTNAME},
            PeerPort => $self->{PORT},
            Proto => 'tcp'
        ) or $result = 0;
        # Set connection flag
        $self->{IS_CONNECTED} = $result;
        return $result;
    }
}

sub close_connection {
    my $self = shift;
    # Close the connection
    if ($self->{IS_CONNECTED}) {
        $self->{CLIENT_SOCKET}->close();
        $self->{IS_CONNECTED} = 0;
    }
}

sub test {
    my $self = shift;
    # Start out by testing connection status
    if (not $self->{IS_CONNECTED}) {
        print "Error: Connection not established.\n";
        return 0;
    }
    # Test the simple version command. All servers have this directly embedded unless modified.
    # In that case you probably know to change the below code.
    if (not defined $self->send_command(command => "version")) {
        print "Error: Could not execute command 'version' on remote server.\n";
        return 0;
    }
    # Passed test
    return 1;
}
