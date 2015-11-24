#!/usr/bin/perl -w
use strict;
use Time::Local;
use DBI;
my $date = `date`;
#$date =~ /\s([0-9][0-9]:[0-9][0-9]):/;
$date =~ /([0-9][0-9])/;
my $res;
print $1;
if ($1 eq "20")
{
#    print "$ARGV[0]\n";
    if ($ARGV[0] == 1){
#       print "1!\n";
        open UPS1_IN, "> UPS1";
    }
    if ($ARGV[0] == 2) {
#       print "2!\n";
        open UPS2_IN, "> UPS2";
    }
#    print "OK!\n";
    if ($ARGV[0] == 1){
        $res = `snmpget -v1 -c public 192.168.20.187 .1.3.6.1.4.1.318.1.1.1.4.3.6.0`;
    }
    if ($ARGV[0] == 2) {
        $res = `snmpget -v1 -c public 192.168.20.188 .1.3.6.1.4.1.318.1.1.1.4.3.6.0`;
    }
    chomp ($res);
    $res =~ /(\S*$)/;
    print $1;
    if ($ARGV[0] == 1){
        print UPS1_IN $1;
    }
    if ($ARGV[0] == 2) {
        print UPS2_IN $1;
    }
}
else
{
    if($ARGV[0] == 1){
        open UPS1_OUT, "< UPS1";
        print <UPS1_OUT>;
    }
    if ($ARGV[0] == 2) {
        open UPS2_OUT, "< UPS2";
        print <UPS2_OUT>;
    }
}
