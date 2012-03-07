#!/usr/bin/perl

#use strict;
#use warnings;
use WWW::Wikipedia;
use HTML::Entities;
use HTML::StripTags qw(strip_tags);

binmode(STDOUT, ":utf8");

my $lang = $ARGV[1];
if (!$lang) {
   $lang = "de";
}

my $wiki = WWW::Wikipedia->new( language => $lang);

my $result = $wiki->search( "$ARGV[0]" );
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
      if ($line && $line =~ m/^\*\s?/) {
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
      $line=~ s/.*}}//g;
      $line=~ s/^\s*//;
      $line=~ s/\s*$//;
      if ($line !~ m/^\s*$/) {
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
      print "For more see http://$lang.wikipedia.org/wiki/$ARGV[0]\n";
   }
} else {
   print "No matches with $ARGV[0]\n";
}
