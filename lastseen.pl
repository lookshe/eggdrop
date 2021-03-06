#!/usr/bin/perl

use File::ReadBackwards;

if ($#ARGV ne 2){
   print "not enough arguments\n";
   exit 1;
}

my $chan=$ARGV[1];
my $folder=$ARGV[0];
my $nick=$ARGV[2];
my $snick=$nick;
$snick=~s/\\/\\\\/g;
$snick=~s/\|/\\\|/g;
$snick=~s/\^/\\\^/g;

my @files;

push @files, `ls $folder/$chan.* | sort -r`;

foreach $file (@files) {


my $date=0;
my $lastaction;
my $line;

$file=~s/\n$//;
my $log = File::ReadBackwards->new($file) || die $!;

while ($line=$log->readline()){
#   $line=$log->readline();
   if ($date eq 0){
      if ($line =~ m/^\[[0-9]{2}:[0-9]{2}(:[0-9]{2})?\]( Nick change:)? $snick /i && $line !~ m/joined #/ ) {
         $date=1;
         $lastaction=$line;
      }
   } else {
      if ($line =~ m/^\[00:00(:00)?\] --- /){
         ($date=$line)=~s/^\[00:00(:00)?\] --- (.*)\n/$2/;
         ($time=$lastaction)=~s/(.*)\[([0-9]{2}:[0-9]{2}(:[0-9]{2})?)\](.*)\n/$2/;
         $l=9+length($snick);
         $k=12+length($snick);
         if ($lastaction=~m/^.{$l}kicked/ || $lastaction=~m/.{$k}kicked/){
            ($by=$lastaction)=~s/^\[[0-9]{2}:[0-9]{2}(:[0-9]{2})?\] $snick kicked from #.* by //i;
            ($reason=$by)=~s/.*: (.*)\n/$1/;
            $by=~s/:.*\n//i;
            
            print "$nick was kicked by $by on $date at $time reason: $reason\n";
         } elsif ($lastaction=~m/$snick \(.*\) left irc: /i){
            ($message=$lastaction)=~s/^.* $snick \(.*\) left irc: (.*)\n/$1/i;
            print "$nick has quit on $date at $time saying: $message\n";
         } elsif ($lastaction=~m/Nick change: $nick /i) {
            ($newnick=$lastaction)=~s/^.*Nick change: $snick -> (.*)\n/$1/i;
            print "$nick changed his name to $newnick on $date at $time\n";
         } else {
            if ($lastaction=~m/\)\.$/) {
               ($message=$lastaction)=~s/^.* $snick \(.*\) left #[a-zA-Z0-9]* \((.*)\)\.\n/$1/i;
               print "$nick has left on $date at $time saying: $message\n";
            } else {
               print "$nick has left on $date at $time\n";
            }
         }
         exit 0;
      }
   }
}
}

print "I do not remember $nick\n";
