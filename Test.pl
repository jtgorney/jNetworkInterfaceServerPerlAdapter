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
