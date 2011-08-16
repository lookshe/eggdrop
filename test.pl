#!/usr/bin/perl

use Net::Domain::TLD qw(tlds tld_exists);

my @ccTLDs = tlds('cc');
print "TLD de OK\n" if tld_exists('de', 'cc');
print "TLD ac OK\n" if tld_exists('ac', 'cc');
