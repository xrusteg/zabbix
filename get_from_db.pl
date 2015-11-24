#!/usr/bin/perl -w
use strict;
use DBI;
use Time::Local;
#my $date = `date -I`;
#$date =~ /(\d*)-(\d*)/;
#my $year = $1;
#my $month = $2-1;

#open OUT, "> UPS1";
#print OUT "ARGV[0]\n";
#print OUT "QWEADS\n";
#close OUT;
#my $count = @ARGV;
#print $ARGV[0];
#exit 1;


my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
#$mon += 1;
$year += 1900;

my $itemid;
if ($ARGV[0] eq "192.168.20.188") {
        $sec = 34;
        $itemid = 23734;
}
if ($ARGV[0] eq "192.168.20.187") {
        $sec = 33;
        $itemid = 23733;
}

my $date = timelocal($sec,00,$hour,$mday,$mon,$year);
#print "$sec\n$min\n$hour\n$mday\n$mon\n$year\n$wday\n$yday\n$isdst\n";
#print "$date\n";
my $dbh = DBI->connect("DBI:mysql:database=zabbix;host=localhost",
                         "root", "",
                         {'RaiseError' => 1});
my $sth = $dbh->prepare("SELECT * FROM history where clock = $date and itemid = $itemid");
$sth->execute();
my $ref = $sth->fetchrow_hashref();
my $first = $ref -> {'value'};
#print "$first\n";
$sth = $dbh->prepare("select * from history where clock=(select max(clock) from history where itemid=$itemid) and itemid=$itemid");
$sth->execute();
$ref = $sth->fetchrow_hashref();
my $last = $ref -> {'value'};

if (($min == 0) && ($sec < 34)) {
        $first = $last;
}
my $res = $last - $first;
printf ("%.4f", $res);

$sth->finish();
$dbh->disconnect();
