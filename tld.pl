#!/usr/bin/perl

#use strict;
#use warnings;
use Web::Scraper;
use URI;
use HTML::Entities;
use Encode;
use URI::Escape;
use LWP::UserAgent;

my $type = $ARGV[0];
if ($type !~ /^\./)
{
   $type = ".$type";
}

binmode(STDOUT, ":utf8");

my $scrap = scraper {
      process '//table/tr/td', 'table[]' => 'TEXT';
   };
my $url = URI->new("http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains");
my $res = $scrap->scrape($url);
my $table = $res->{'table'};
for ($i = 0; $i < $#$table; $i++)
{
   if ($$table[$i] =~ /^\.[^ ]*$/ && $$table[$i+1] !~ /^No$/ && $$table[$i+1] !~ /^Yes$/ && $$table[$i+1] !~ /^Partial\[/ && $$table[$i+1] !~ /^$/)
   {
      #print "$$table[$i] is $$table[$i+1]\n";
      if ($$table[$i] =~ /^$type$/)
      {
         print "$type is $$table[$i+1]\n";
         break;
      }
      $i++;
      next;
   }
   if ($$table[$i] =~ /^xn--/)
   {
      #print "$$table[$i+1] is $$table[$i+2]\n";
      if ($$table[$i+1] =~ /^$type$/)
      {
         print "$type is $$table[$i+2]\n";
         break;
      }
      $i+=5;
      next;
   }
}
