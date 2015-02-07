#! /usr/bin/perl

package ServerAdapter;

use strict;
use warnings;
use Socket;
use Carp qw(croak);

sub new {
    my $class = shift;
    my $self = {};
    # Make sure arguments are correct
    croak "Illegal number of parameters. ServerAdapter->new(HOSTNAME, PORT)"
        if @_ % 2;
    # Store arguments
    my ($self->{HOSTNAME}, $self->{PORT}) = @_;
    # Connection status
    $self->{IS_CONNECTED} = 0;
    # Client socket connection
    $self->{CLIENT_SOCKET} = undef;
    # Become part of the object
    bless $self;
    # Return the new self
    return $self;
}

sub is_connected {
    my $self = shift;
    return $this->{IS_CONNECTED};
}

sub send_command {
    my $self = shift;
    $self->connect;
    # data to send
    my ($command, @data) = @_;
    # Send data on socket
    $self->{CLIENT_SOCKET}->send($command."\n");
    # Iterate and build data
    if (@data) {
        # Send the command data to server
        foreach (@data) {
            $self->{CLIENT_SOCKET}->send($_."\n");
        }
    }
    # Finally, end command directive
    $self->{CLIENT_SOCKET}->send("END COMMAND\n");
    # Response data
    my $response = <$self->{CLIENT_SOCKET}>;
    return $response;
}

sub connect {
    my $self = shift;
    if (not $self->{IS_CONNECTED}) {
        $self->{CLIENT_SOCKET} = new IO::Socket::INET (
            LocalHost => $self->{HOSTNAME},
            LocalPort => $self->{PORT},
            Proto => 'tcp',
            Listen => 1,
            Reuse => 1    
        ) or die("Error establishing connection to server.");
        # Set connection flag
        $self->{CONNECTED} = 1;
    }
}

sub close_connection {
    my $self = shift;
    # Close the connection
    if ($self->{IS_CONNECTED}) {
        $self->{CLIENT_SOCKET}->close();
    }
}
