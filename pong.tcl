# description: little funny ping-pong script, everyone knows this joke from irc, bot can kick you or just answer you

# Author: Tomekk
# e-mail:  tomekk/@/oswiecim/./eu/./org
# home page: http://tomekk.oswiecim.eu.org/
#
# Version 0.1
#
# This file is Copyrighted under the GNU Public License.
# http://www.gnu.org/copyleft/gpl.html

bind pub - !ping ping_fct

# 0 - answer 'pong', 1 - kick with 'pong' ;-)
set fun "0"

proc ping_fct { nick uhost hand chan arg } {
   global fun

   set txt [split $arg]

        set pongle [join [lrange $txt 0 end]]
   
   if {$pongle == ""} {
   
      if {$fun == "0"} {
         putquick "PRIVMSG $chan :ping? pong!"
      } {
         putkick $chan Pong!
      }
   }
}

putlog "tkpingpong.tcl ver 0.1 by Tomekk loaded"
