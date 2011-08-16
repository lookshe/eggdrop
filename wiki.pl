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

my $lang = $ARGV[1];
if (!$lang) {
   $lang = "de";
}
my $wikiurl = "http://$lang.wikipedia.org/wiki/Special:Search?search=$ARGV[0]&go=Go";

my $ua = new LWP::UserAgent;
my $req = HTTP::Request->new('GET', $wikiurl);
my $res = $ua->request($req);
my $url = $res->request->uri;
my $origurl = $url;
$url =~ s/.*\/wiki\///;

binmode(STDOUT, ":utf8");

if ($url !~ m/Special:Search/) {
#artikel

   $scrap = scraper {
      process '//div[@id="bodyContent"]/p', 'text[]' => 'TEXT';
      process '//img', 'img[]' => '@src';
      process '//div[@id="bodyContent"]/ul/li', 'list[]' => 'TEXT';
      process '//table/tr/td', 'table[]' => 'TEXT';
   };
   $url = URI->new($wikiurl);

   my $res = $scrap->scrape($url);
   my $text = $res->{'text'};
   my $img = $res->{'img'};
   my $list = $res->{'list'};
   my $table = $res->{'table'};
   my $isDis = 0;

   if ($$table[1] !~ m/$ARGV[0]/i && $#$table == 1) {
      foreach (@$img) {
#print "$_\n";
#         if ($_ =~ m/^http:\/\/upload\.wikimedia\.org\/wikipedia\/commons\/thumb\/.*\/.*\/Disambig/) {
         if ($_ =~ m/Disambig/) {
            $isDis = 1;
            last;
         }
      }
   }
   if (!$isDis) {
      $text = decode_entities($$text[0]);
      $text =~ s/\([^\(\)]*\)||\[[^\[\]]*\]//g;
      $text =~ s/\([^\(\)]*\)||\[[^\[\]]*\]//g;
      $text =~ s/\([^\(\)]*\)||\[[^\[\]]*\]//g;
      $text =~ s/\([^\(\)]*\)||\[[^\[\]]*\]//g;
      $text =~ s/\s+/ /g;
      $text =~ s/\s([,.\?!])/$1/g;

      if ($text =~ m/.{448}.*/) {
         $text =~ s/^(.{448}).*$/$1/;
         $text =~ s/^(.*[\.!\?])[^\.!\?]*$/$1 (...)/;
      }

      print $text, "\n";
   } else {
      for ($count = 0; $count < 3 && $count <= $#$list; $count++) {
         print "$$list[$count]\n";
      }
      print "For more see $origurl\n";
   }

} else {
#kein artikel

   $scrap = scraper {
      process '//div[@class="searchresult"]', 'text[]' => 'TEXT';
      process '//ul[@class="mw-search-results"]/li/div/a', 'href[]' => '@href';
   };
   $url = URI->new($wikiurl);

   my $res = $scrap->scrape($url);
   if (keys(%$res)) {
      my $text = $res->{'text'};
      my $href = $res->{'href'};
      my $result = "";
      for ($count = 0; $count < 5 && $count <= $#$text; $count++) {
         $result = ($result?"$result || ":"").$$href[$count], "\n";
      }
      print "$result\n";
   } else {
      print "No matches with $ARGV[0]\n";
   }
}
