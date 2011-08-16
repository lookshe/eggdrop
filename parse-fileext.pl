#!/usr/bin/perl

#use strict;
#use warnings;
use Web::Scraper;
use URI;
use HTML::Entities;
use Encode;
use URI::Escape;
use LWP::UserAgent;

my $scrap;

my $wikiurl = "http://filext.com/file-extension/$ARGV[0]";

my $scrapp = scraper {
   process '//table/tr/td', 'chars[]' => 'TEXT';
};
my $url = URI->new($wikiurl);
my $blubb = $scrapp->scrape($url);
my $list = $blubb->{'chars'};

binmode(STDOUT, ":utf8");

for($i = 0; $i <= $#$list;$i++) {
   if ($$list[$i] =~ /^Extension: $ARGV[0]$/i)
   {
      print "$$list[$i+4]\n";
   }
}
