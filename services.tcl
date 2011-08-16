###########################################################################################
######                           NickServ & ChanServ Tools                            #####
########################################################################################### 
#
# Autor  : Holger Brähne (Holli)
# E-Mail : hbraehne@web.de
# Version: 1.0
#
# Beschreibung: Das Script Identifiziert den Bot automatisch bei NickServ und lässt den
#               Bot automatisch Op erhalten falls das gewünscht ist und er die benötigten
#               Channelrechte besitzt. Das Script wurde getestet und hat funktioniert.
#               Ich kann allerdings nicht garantieren das es das auf allen IRC Servern
#               tut!
#
###########################################################################################
######                                 KONFIGURATION                                 ######
###########################################################################################

# Der Name den NickServ auf dem IRC Server verwendet auf dem sich der Bot befindet
set nserv(name) "NickServ"

# Der Befehl mit dem man sich bei NickServ identifiziert (normalerweise: IDENTIFY)
set nserv(idnt) "IDENTIFY"

# Der Name den der Bot verwendet. Wichtig falls jemand den Namen geklaut hat und der Bot
# in den GHOST Modus gehen soll um ihn zurück zu erhalten.
set nserv(nick) "Marvin"

# Das Passwort mit dem der Bot bei NickServ registriert ist.
set nserv(pass) "ongbak"

# Die Zeit die der Bot zwischen dem erkennen von NickServ und der Identifizierung warten
# soll. Bei mir haben 10 Sekunden immer gereicht, aber es soll ja auch langsamere Server
# geben ;)
set nserv(time) 10

# Der Name den ChanServ auf dem IRC Server verwendet auf dem sich der Bot befindet
set cserv(name) "ChanServ"

# Soll der Bot sich automatisch Op im unten angegebenen Channel holen?
# 0 = nein / 1 = ja
set cserv(opme) 0

# Der Channel in dem sich der Bot Op holen soll.
set cserv(chan) ""

# Siehe nserv(time). Die Zeit hier sollte aber mindestens 5 Sekunden länger angegeben sein!
set cserv(time) 15


###########################################################################################
######  !!! AB HIER NICHTS MEHR ÄNDERN, AUSSER DU WEISST GENAU WAS DU DA MACHST !!!  ######
###########################################################################################

bind notc - "*msg*IDENTIFY*pass*" nick_ident
bind dcc o nservid nick_ident

proc nick_ident {nick uhost hand args} {

  global botnick nserv cserv
  
  if {$botnick == $nserv(nick)} {
  
    utimer $nserv(time) "putserv \"PRIVMSG $nserv(name) :$nserv(idnt) $nserv(pass)\""
    
    if {$cserv(opme) == 1} {
    
      utimer $cserv(time) "putserv \"PRIVMSG $cserv(name) :owner\""
    
    }
  
  } else {
  
    utimer $nserv(time) "putserv \"PRIVMSG $nserv(name) :GHOST $nserv(nick) $nserv(pass)\""
  
  }

}
