#!/usr/bin/perl

use File::ReadBackwards;

if ($#ARGV ne 2){
   print "not enough arguments\n";
   exit 1;
}

my $folder=$ARGV[0];
my $chan=$ARGV[1];
my $nick=$ARGV[2];
$nick=~s/\\/\\\\/g;
$nick=~s/\|/\\\|/g;
$nick=~s/\^/\\\^/g;

my @files;

push @files, `ls $folder/$chan.* | sort -r`;

foreach $file (@files) {


my $date=0;
my $lastaction;
my $line;
my $datecount=0;

$file=~s/\n$//;
my $log = File::ReadBackwards->new($file) || die $!;

while ($line=$log->readline()){
#   $line=$log->readline();
   if ($date eq 0){
      if ($line =~ m/^\[[0-9]{2}:[0-9]{2}(:[0-9]{2})?\] <$nick> /i && $line !~ m/joined #/ ) {
         $date=1;
         ($lastaction=$line)=~s/\n//;
      } elsif ($line =~ m/^\[00:00(:00)?\] --- /) {
         ++$datecount
      }
   } else {
      if ($datecount eq 0){
         print "$nick\'s last action: $lastaction\n";
         exit 0;
      } else {
         if ($line=~m/^\[00:00(:00)?\] --- /){
            ($date=$line)=~s/^\[00:00(:00)?\] --- (.*)\n/$2/;
            print "$nick spoke last time on $date\n";
            print "$nick\'s last action: $lastaction\n";
            exit 0;
         }
      }
   }
}
}

print "I do not remember $nick\n";
