bind pub - !tld proc_tld

proc proc_tld {nick host hand chan arg} {
   set arg [string trim $arg]
   if {$arg == ""} {
      return 0
   }

   set output [split "[exec perl /home/eggdrop/eggdrop/scripts/tld.pl $arg]" "\n"]
   foreach out $output {
      putserv "PRIVMSG $chan :$out"
   }
}

putlog "tld by lookshe loaded"
