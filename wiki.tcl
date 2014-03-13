# lastseen by xeno

bind pub - !wiki wiki
bind pub - !ewiki ewiki
#bind pub - !say say
bind pub - !mitsu mitsu
bind pub - !google say
bind pub - !pastebin pastebin
bind pub - !ezcrypt pastebin

proc say {nick host hand chan arg} {
#   putserv "PRIVMSG $chan :$arg";
#   putserv "PRIVMSG $chan :das hier ist [string trimleft $chan #]";
}

proc mitsu {nick host hand chan arg} {
  putserv "PRIVMSG $chan :www.mitsu-talk.de";
#   putserv "PRIVMSG $chan :das hier ist [string trimleft $chan #]";
}

proc pastebin {nick host hand chan arg} {
  putserv "PRIVMSG $chan :Längere Texte bitte nicht in den Chat kopieren! Benutze stattdessen https://ezcrypt.it/ : kopiere den Text in das große Textfeld, klicke auf \"Submit\" und teile uns die URL mit, auf die du automatisch weitergeleitet wurdest.";
}

proc wiki {nick host hand chan arg} {
   global do_wiki
   if {[info exists do_wiki($nick:$chan)]} {
      putserv "NOTICE $nick :no flooding!"
      return 0;
   }
   set do_wiki($nick:$chan) 1
   timer 1 "unset do_wiki($nick:$chan)"
   set arg [string trim $arg]
if {$arg == ""} {
   return 0
}

   set output [split "[exec perl /home/eggdrop/eggdrop/scripts/wiki2.pl $arg de]" "\n"]
   foreach out $output {
      putserv "PRIVMSG $chan :$out";
   }
}

proc ewiki {nick host hand chan arg} {
   global do_wiki
   if {[info exists do_wiki($nick:$chan)]} {
      return 0;
   }
   set do_wiki($nick:$chan) 1
   timer 1 "unset do_wiki($nick:$chan)"
   set arg [string trim $arg]
if {$arg == ""} {
   return 0
}

   set output [split "[exec perl /home/eggdrop/eggdrop/scripts/wiki2.pl $arg en]" "\n"]
   foreach out $output {
      putserv "PRIVMSG $chan :$out";
   }
}

putlog "wiki by lookshe loaded"
