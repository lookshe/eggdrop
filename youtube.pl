#!/usr/bin/perl

use LWP::Simple;

if ($#ARGV != 0)
{
   exit;
}

my ($url, $content, $title);
$url = $ARGV[0];

$content = get($url);

if (!defined $content)
{
   exit;
}

if ($content =~ m/<title>(.*?)<\/title>/s)
{
   $title = $1;
   $title =~ s/^\s+//;
   $title =~ s/\s+- YouTube\s+$//;
   print "$title";
}
