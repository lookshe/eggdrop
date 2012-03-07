#!/usr/bin/perl

#use strict;
#use warnings;
use WWW::Wikipedia;
use HTML::Entities;
use HTML::StripTags qw(strip_tags);

binmode(STDOUT, ":utf8");

my $query = $ARGV[0];
my $lang = $ARGV[1];
if (!$lang) {
   $lang = "de";
}
my $found = 0;
my $up = 0;
my $result;

while ($found < 5) {
   $found++;
   my $wiki = WWW::Wikipedia->new( language => $lang);
   $result = $wiki->search( "$query" );
   if (defined $result) {
      my @tmplines = split('\n', $result->text_basic());
      if ($#tmplines == 0 && $tmplines[0] =~ m/^#/) {
         $query = $tmplines[0];
         $query =~ s/^#\w*\s(.*)$/$1/;
      } else {
         break;
      }
   } else {
      if ($up == 0) {
         $query = uc $query;
         $up = 1;
      } else {
         $query = lc $query;
      }
   }
}
if (defined $result) {
   my @lines = split('\n', $result->text_basic());
   my @newlines;
   my $newline = "";
   my $isDis = 0;
   my $ln = 0;
   my $comment = 0;
   foreach my $line (@lines) {
#print "$line\n";
      $line =~ s/<!--.*-->//g;
      #$line=~ s/^}}//g;
      $line=~ s/^\]\]//g;
      $line=~ s/^\s*//;
      $line=~ s/\s*$//;
      $comment = 1 if $line =~ m/^<!--$/;
      $comment = 0 if $line =~ m/^-->$/;
      if ($line && $line =~ m/^\*\s?/ && $ln < 4) {
         push(@newlines, $newline);
         push(@newlines, $line);
         $newline = "";
         $isDis = 1 if $ln < 4;
      } elsif ($line) {
         $newline = "$newline$line ";
         $ln++;
      } elsif ($comment) {
      } else {
         push(@newlines, $newline);
         $newline = "";
      }
   }
   push(@newlines, $newline);
   $ln = 0;
   my $lst = 0;
   foreach my $line (@newlines) {
      $line =~ s/<!--.*-->//g;
      $line=~ s/^.*}}//g;
      $line=~ s/^[^\[]*\]\]//g;
      $line=~ s/^\s*//;
      $line=~ s/\s*$//;
      if ($line !~ m/^\s*$/ && $line !~ m/^{{Infobox/) {
         $line = decode_entities($line);
         #$line =~ s/\([^\(\)]*\)||\[[^\[\]]*\]//g;
         $line =~ s/\[\[([^|\]]*\|)?([^\]]*)\]\]/$2/g;
         $line =~ s/\'([^\']*)\'/$1/g;
         $line =~ s/\[\s*\]//g;
         $line =~ s/\(\s*\)//g;
         $line =~ s/\[\s*\]//g;
         $line =~ s/\(\s*\)//g;
         #$line = strip_tags($line);
         $line =~ s/<ref[^>]*>[^<]*<\/ref>//g;
         $line =~ s/\s+/ /g;
         $line =~ s/\s([,.\?!])/$1/g;
         if ($isDis) {
            if ($line =~ m/^\*\s?/) {
               last if ($ln == 3) && ($lst = 1);
               print "$line\n";
               $ln++;
            }
         } else {
            if ($line =~ m/.{448}.*/) {
               $line =~ s/^(.{448}).*$/$1/;
               #$line =~ s/^(.*[\.!\?])[^\.!\?]*$/$1 (...)/;
               $line =~ s/^(.*[\.!\?]) [^\.!\?]*$/$1 (...)/;
            }
            print "$line\n";
            last;
         }
      }
   }
   if ($isDis && $lst) {
      print "For more see http://$lang.wikipedia.org/wiki/$query\n";
   }
} else {
   print "No matches with $query\n";
}
