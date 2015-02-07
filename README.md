# jNetworkInterfaceServerPerlAdapter

jNetworkInterfaceServer Perl Adapter

Class written in Perl to connect to jNetworkInterfaceServer.

Use the following:

my $connection = ServerAdapter->new(hostname => "127.0.0.1", port => 8080);
my $response = $connection->send_command(command => "yourcommand", data => ["data1", "data2", "data2"]);
