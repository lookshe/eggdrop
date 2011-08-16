# slap by lookshe

bind pub - !name proc_name

proc proc_name {nick host hand chan arg} {
   #putserv "PRIVMSG $chan :[clock format [NetTime ntp.nasa.gov]]"
   set arg [string trim $arg]
   if {$arg == ""} {
      set output [split "[exec cat /home/eggdrop/eggdrop/scripts/names.txt]" "\n"]
      foreach out $output {
         putserv "PRIVMSG $nick :$out"
      }
   } else {
      exec echo $arg >> /home/eggdrop/eggdrop/scripts/names.txt
      exec echo $arg by $nick >> /home/eggdrop/eggdrop/scripts/names_nick.txt
      putserv "NOTICE $nick :$arg added to list"      
   }
}

putlog "name by lookshe loaded"
