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

my $wikiurl = "http://de.wikipedia.org/wiki/Liste_der_Dateiendungen";

my $scrapp = scraper {
   process '//div[@id="bodyContent"]/table/tr/td/a', 'chars[]' => 'TEXT';
};
my $url = URI->new($wikiurl);
my $blubb = $scrapp->scrape($url);
my $list = $blubb->{'chars'};

binmode(STDOUT, ":utf8");

foreach(@$list) {
   $scrap = scraper {
      process '//div[@id="bodyContent"]/table[@class="prettytable"]/tr/td', 'table[]' => 'TEXT';
   };
   $url = URI->new("$wikiurl/$_");

   my $res = $scrap->scrape($url);
   my $table = $res->{'table'};

   for ($i=0; $i<=$#$table; $i+=3) {
      if ($$table[$i] !~ /\..*(\..*)+/ && $$table[$i+1] !~ /^.?$/ ) {
         print "$$table[$i] $$table[$i+1]\n";
      }
      if ($$table[$i+2] =~ /^\./) {
         $i--;
      }
   }
}
