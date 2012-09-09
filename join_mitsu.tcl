bind join - "#mitsu_chat_runde" join_help

proc join_help {nick host hand chan} {
   global botnick
   if {$botnick == $nick} {
      return 0
   }
   putserv "PRIVMSG $chan :Willkommen im MFF-Chat $nick, stelle einfach deine Frage oder sag einfach nur Hallo. Warte bitte eine Weile auf Antwort, da die User auch ein Privatleben haben ;-) (PS: Ich bin nur ein Bot)"
}

putlog "join_mitsu by lookshe loaded"
