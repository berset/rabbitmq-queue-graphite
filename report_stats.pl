#!/usr/bin/perl -w

# avoid zombie apocalypse
$SIG{CHLD} = 'IGNORE';

my $host = 'graphite';
my $port = 2003;
my $report_interval = 10;
my $prefix = "rabbitmq";


while (1) {
    my $ts = `date +%s`;
    chomp $ts;
    my @rows = split(/\n/, get_queues());

    my $data = "";

    for my $row (@rows) {
        my @f = split(/\t/, $row, 4);
        if (scalar @f == 4) {
            $data .= sprintf("%s.%s.%s %d %s\n", $prefix, $f[0], 'messages'
                , $f[1], $ts);
            $data .= sprintf("%s.%s.%s %d %s\n", $prefix, $f[0], 'messages_ready'
                , $f[2], $ts);
            $data .= sprintf("%s.%s.%s %d %s\n", $prefix, $f[0], 'messages_unacknowledged'
                , $f[3], $ts);
        }
    }

    if ($data ne '') {
        open(my $nc, "| nc $host $port");
        print $nc $data;
        close($nc);
    }

    printf("reported: %s - %d\n", $ts, scalar @rows);
    sleep $report_interval;
}



sub get_queues {
    return `rabbitmqctl list_queues name messages messages_ready messages_unacknowledged`
}
