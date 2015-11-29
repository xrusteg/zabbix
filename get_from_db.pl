#!/usr/bin/perl -w
use strict;
use DBI;
use Time::Local;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $itemid;

$year += 1900;
if ($ARGV[0] eq "192.168.20.188") {
	$itemid = 23734;
}
if ($ARGV[0] eq "192.168.20.187") {
        $itemid = 23733;
}

my $date = timelocal(0,0,0,$mday,$mon,$year);
#$date = 10000000000000000;
my $dbh = DBI->connect("DBI:mysql:database=zabbix;host=localhost", "root", "", {'RaiseError' => 1});
my $sth = $dbh->prepare("select * from history where clock=(select min(clock) from history where clock > $date and itemid=$itemid) 
														and itemid=$itemid;");
$sth->execute();
my $ref = $sth->fetchrow_hashref();
my $first = $ref -> {'value'};

$sth = $dbh->prepare("select * from history where clock=(select max(clock) from history where itemid=$itemid) and itemid=$itemid");
$sth->execute();
$ref = $sth->fetchrow_hashref();
my $last = $ref -> {'value'};
unless ($first) { $first = $last; }

my $res = $last - $first;
printf ("%.4f", $res);

$sth->finish();
$dbh->disconnect();
