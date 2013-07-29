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
my $file = $ARGV[1];
my $skipFile = $ARGV[2];

if ($length !~ /.{0,6}/) {
   exit 0;
}

binmode(STDOUT, ":utf8");

if ($type !~ /^\./) {
   $type =~ s/^/./;
}

my $found = 0;

if ($skipFile !~ /X/i)
{
   open (in,"<$file")||die $!;
   while (<in>) {
      ($ext = $_) =~ s/ .*\n//;
      ($des = $_) =~ s/^$ext (.*)\n/$1/;
      if ($type =~ /^$ext$/) {
         print "$ext is \"$des\"\n";
         $found = 1;
      }
   }
   close in;
}
$type =~ s/^\.//;
if ($found == 0) {
   $found = 0;
   #my $wikiurl = "http://filext.com/file-extension/$ARGV[0]";
   #my $scrapp = scraper {
   #   process '//table/tr/td', 'chars[]' => 'TEXT';
   #};
   my $wikiurl = "http://www.file-extensions.org/search/?searchstring=$ARGV[0]";
   my $scrapp = scraper {
      process '//table/tr/td', 'chars[]' => 'TEXT';
      process '//div//p', 'results[]' => 'TEXT';
      process '//div[@id="heading"]/h2', 'text[]' => 'TEXT';
   };
   my $url = URI->new($wikiurl);
   my $blubb = $scrapp->scrape($url);
   my $list = $blubb->{'chars'};
   my $res = $blubb->{'results'};
   my $text = $blubb->{'text'};
   my $morethanone = 0;
   for ($i=0; $i <= $#$res; $i++) {
      if ($$res[$i] =~ /Database contains .* records./i) {
         $morethanone = 1;
      }
   }
   if ($morethanone =~/1/) {
      for ($i = 2; $i <= $#$list; $i++) {
#print "$$list[$i]\n";
         if ($$list[$i] =~ /^.file extension $type$/i) {
            if ($found == 3) {
               print "for more see $wikiurl\n";
               last;
            }
            $i++;
            print ".$type is $$list[$i]\n";
            $found++;
         }
      }
   } else {
      print ".$type is $$text[0]\n";
      $found = 1;
   }
   #for ($i = 0; $i <= $#$list; $i++) {
   #   if ($$list[$i] =~ /^Extension: $type$/i) {
   #      print ".$type is $$list[$i+4]\n";
   #      $found = 1;
   #   }
   #}
   if ($found == 0) {
      print ".$type not in database\n";
   }
}


