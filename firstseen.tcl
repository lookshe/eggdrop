# lastseen by xeno

bind pub - !firstseen firstseen

proc firstseen {nick host hand chan arg} {
   set arg [string trim $arg]
if {$arg == ""} {
   return 0
}

      set output [split "[exec perl /home/eggdrop/eggdrop/scripts/firstseen.pl logs [string trimleft $chan #] $arg]" "\n"]
   foreach out $output {
      putserv "PRIVMSG $chan :$out";
   }
}

putlog "firstseen by lookshe loaded"
