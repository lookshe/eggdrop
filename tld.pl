#!/usr/bin/perl

#use strict;
#use warnings;
use Web::Scraper;
use URI;
use HTML::Entities;
use Encode;
use URI::Escape;
use LWP::UserAgent;
use utf8;

my $type = $ARGV[0];
if ($type !~ /^\./)
{
   $type = ".$type";
}


my $scrap = scraper {
      process '//table/tr/td', 'table[]' => 'TEXT';
   };
my $url = URI->new("http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains");
my $res = $scrap->scrape($url);
my $table = $res->{'table'};
my $found = 0;
for ($i = 0; $i < $#$table && found != 1; $i++)
{
   if ($$table[$i] =~ /^\.[^ ]*$/ && $$table[$i+1] !~ /^No$/ && $$table[$i+1] !~ /^Yes$/ && $$table[$i+1] !~ /^Partial\[/ && $$table[$i+1] !~ /^$/)
   {
      #print "$$table[$i] is $$table[$i+1]\n";
      if ($$table[$i] =~ /^$type$/)
      {
         ($result = $$table[$i+1]) =~ s/^ //;
         print "$type is ";
         binmode(STDOUT, ":utf8");
         print "$result\n";
         $found = 1;
         break;
      }
      $i++;
      next;
   }
   if ($$table[$i] =~ /^xn--/)
   {
      $tabletype_enc = encode("utf8", $$table[$i+1]);
      #print "$$table[$i+1] is $$table[$i+2]\n";
      if ($tabletype_enc =~ /$type/)
      {
         ($result = $$table[$i+2]) =~ s/^ //;
         print "$type is ";
         binmode(STDOUT, ":utf8");
         print "$result\n";
         $found = 1;
         break;
      }
      $i+=5;
      next;
   }
}
if ($found == 0)
{
   print "$type is unknown\n";
}
