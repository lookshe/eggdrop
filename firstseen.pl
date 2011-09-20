#!/usr/bin/perl


if ($#ARGV ne 2){
   print "not enough arguments\n";
   exit 1;
}

my $chan=$ARGV[1];
my $folder=$ARGV[0];
my $nick=$ARGV[2];
$nick=~s/\|/\\\|/g;
$nick=~s/\\/\\\\/g;

my @files;

push @files, `ls $folder/$chan.* | sort`;

foreach $file (@files) {

my $date="irgendwas";
my $line;

open(file, $file) or die("Could not open file $file");
foreach $line (<file>) {
      if ($line =~ m/^\[[0-9]{2}:[0-9]{2}(:[0-]{2})?\] (Action: )?<?$nick>? /i) {
         if ($date =~ /^irgendwas$/) {
            print "$nick belongs to inventory\n";
            exit 0;
         } else {
            ($time=$line)=~s/(.*)([0-9]{2}:[0-9]{2}(:[0-9]{2})?)(.*)\n/$3/;
            print "$nick was first seen on $date at $time\n";
            exit 0;
         }
      }
      if ($line =~ m/^\[00:00(:00)?\] --- /){
         ($date=$line)=~s/^\[00:00(:00)?\] --- (.*)\n/$2/;
      }
      if ($line =~ m/^\[[0-9]{2}:[0-9]{2}(:[0-]{2})?\] Nick change: .* -> $nick/i) {
         ($newnick=$line)=~s/.* Nick change: (.*) -> $nick\n/$1/i;
         print "$nick was $newnick\n";
         exec($^X, $0, $folder, $chan, $newnick);
         exit 0
      }
}
}

print "I do not remember $nick\n";
