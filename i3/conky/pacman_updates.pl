#!/usr/bin/perl
## script by Xyne
## http://bbs.archlinux.org/viewtopic.php?id=57291
## most useful in combination with a root crontab script to update package database
## see root_crontab, taken from archwiki
use strict;
use warnings;
my $n = (`pacman -Qu | wc -l`);
chomp ($n);
if ($n == 0)
{
     print "No new packages"
}
elsif($n == 1)
{
     print "1 new package"
}
else
{
print "$n new packages "
}
