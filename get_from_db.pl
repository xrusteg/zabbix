#!/usr/bin/perl -w
use strict;
use DBI;
use Time::Local;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $itemid;

$year += 1900;
$hour = 0;
if ($ARGV[0] eq "192.168.20.188") {
	$sec = 34;
	$itemid = 23734;
}
if ($ARGV[0] eq "192.168.20.187") {
        $sec = 33;
        $itemid = 23733;
}

my $date = timelocal($sec,00,$hour,$mday,$mon,$year);

my $dbh = DBI->connect("DBI:mysql:database=zabbix;host=localhost", "root", "", {'RaiseError' => 1});
my $sth = $dbh->prepare("SELECT * FROM history where clock = $date and itemid = $itemid");
$sth->execute();
my $ref = $sth->fetchrow_hashref();
my $first = $ref -> {'value'};

$sth = $dbh->prepare("select * from history where clock=(select max(clock) from history where itemid=$itemid) and itemid=$itemid");
$sth->execute();
$ref = $sth->fetchrow_hashref();
my $last = $ref -> {'value'};

#print "$min\n$hour\n";
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
if (($min == 0) && ($hour == 0)) {
	$first = $last;
}
my $res = $last - $first;
printf ("%.4f", $res);

$sth->finish();
$dbh->disconnect();
