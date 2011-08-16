# lastseen by xeno

bind pub - !lastseen lastseen
bind pub - !lastspoke lastspoke
bind pub - !seen lastseen
bind pub - !spoke lastspoke

proc lastspoke {nick host hand chan arg} {
   set arg [string trim $arg]
if {$arg == ""} {
   return 0
}
   if {[onchan $arg $chan] != 1} {
      set output [split "[exec perl /home/eggdrop/eggdrop/scripts/lastspoke.pl /home/eggdrop/eggdrop/logs [string trimleft $chan #] $arg 1]" "\n"]
   } else {
      set output [split "[exec perl /home/eggdrop/eggdrop/scripts/lastspoke.pl /home/eggdrop/eggdrop/logs [string trimleft $chan #] $arg 0]" "\n"]
   }
   foreach out $output {
      putserv "PRIVMSG $chan :$out";
   }
#   set status [catch {set lastdate [exec egrep -iB 5000 "^.{9}$arg" logs/hackerboard.log.2008 | grep "00:00.*---" | tail -n 1 | cut -c13-]}]
#   if {$status == 0} {
#      set lastaction [exec egrep -i "^.{9}$arg" logs/hackerboard.log.2008 | tail -n 1]
#      if {[onchan $arg $chan] != 1} {
#         putserv "PRIVMSG $chan :$arg spoke last time on $lastdate"
#      }
#      putserv "PRIVMSG $chan :$arg's last action: $lastaction"
#   } else {
#      putserv "PRIVMSG $chan :I didn't remember $arg"
#   }
}

proc lastseen {nick host hand chan arg} {
   set arg [string trim $arg]
if {$arg == ""} {
   return 0
}

   if {[onchan $arg $chan] == 1} {
      global botnick
      if {$botnick == $arg} {
         putserv "PRIVMSG $chan :Yes, I am here!"
      } elseif {$nick == $arg} {
         putserv "PRIVMSG $chan :Where is uhm $arg? Ah, there he is!"
      } else {
         putserv "PRIVMSG $chan :$arg is already here you fool..."
      }
   } else {
      putserv "PRIVMSG $chan :[exec perl /home/eggdrop/eggdrop/scripts/lastseen.pl /home/eggdrop/eggdrop/logs [string trimleft $chan #] $arg]"
#      set status [catch {set lastdate [exec egrep -iB 5000 "^.{8}$arg " logs/hackerboard.log.2008 | grep "00:00.*---" | tail -n 1 | cut -c13-]}]
#      if {$status == 0} {
#         set lastaction [exec egrep -i "^.{8}$arg " logs/hackerboard.log.2008 | grep -v "joined #" | tail -n 1]
#         set lasttime [string range $lastaction 1 5]
#         set kicked [string range $lastaction [expr 9 + [string length $arg]] [expr 14 + [string length $arg]]]
#         set lastlist [split $lastaction]
#         set lastlength [string length $lastaction]
#         if {$kicked == "kicked"} {
#            putserv "PRIVMSG $chan :$arg kicked by [string trimright [lindex $lastlist 6] ":"] on $lastdate at $lasttime reason: [string range $lastaction [expr [string first : $lastaction 5] + 2] $lastlength]"
#         } else {
#            if {[lindex $lastlist 4] == "irc:"} {
#               putserv "PRIVMSG $chan :$arg quits on $lastdate at $lasttime saying: [string range $lastaction [expr 2 + [string first : $lastaction 5]] $lastlength]"
#            } else {
#               if {[string range $lastaction [expr $lastlength - 2] [expr $lastlength - 2]] == ")"} {
#                  putserv "PRIVMSG $chan :$arg parts on $lastdate at $lasttime saying: [string trimright [string range $lastaction [expr 1 + [string first ( $lastaction [expr 1 + [string first ( $lastaction]]]] $lastlength] ).]"
#               } else {
#                  putserv "PRIVMSG $chan :$arg parts on $lastdate at $lasttime"
#               }
#            }
#         }
#      } else {
#         putserv "PRIVMSG $chan :I didn't remember $arg"
#      }
   }
}

putlog "lastseen by xeno (pimped by lookshe) loaded"
