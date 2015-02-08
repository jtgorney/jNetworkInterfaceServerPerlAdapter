#! /bin/env/ perl

use strict;
use warnings;
use jNetworkInterface::ServerAdapter;

# Perform a quick connection test
my $adapter = ServerAdapter->new(hostname => 'localhost', port => 8080);
# Call a few built in commands
my $statsresponse = $adapter->send_command(command => 'stats');
my $verResponse = $adapter->send_command(command => 'version');
# Parse stats
my @stats = split /,/, $statsresponse;
# Print the output
print "Server Version: ".$verResponse."\n";
print "Server Started At: ".$stats[0]."\n";
print "Commands Executed: ".$stats[1]."\n";