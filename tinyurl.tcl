# -----------------------------------------------------------------------------
# tiny_url.tcl v0.1 [2004-10-19]
#
# This script will listen on channels and convert long URLs into shorter
# URLs using the TinyURL.com website.
#
# Written by: FAIN on QuakeNet <fain@flamingfist.org>
# -----------------------------------------------------------------------------

# ----- Settings --------------------------------------------------------------

# Set this to the minimum length of URLs to convert
set url_length 80

# -----------------------------------------------------------------------------

package require http 2.3

bind pubm - "*" scan_text
bind act - "*" scan_text

# -----------------------------------------------------------------------------
# Name    : scan_text
# Purpose : Scans for URLs and converts to TinyURLs
# -----------------------------------------------------------------------------

proc scan_text {nick uhost hand chan arg} {
   global botnick url_length

   if {($arg == "boeser bot") ||
         ($arg == "dummer bot") ||
         ($arg == "böser bot")} {
      putserv "PRIVMSG $chan :Tut mir ja leid $nick! Wirklich!!!"
      return 0
   }

   if {($arg == "guter bot") ||
         ($arg == "braver bot")} {
      putserv "PRIVMSG $chan :Ich weiss, ich weiss :-)"
      return 0
   }

   set arg [split $arg]

foreach act_arg $arg {
   if {(([string match "http://*" $act_arg] == 1) ||
         ([string match "https://*" $act_arg] == 1) ||
         ([string match "ftp://*" $act_arg] == 1) ||
         ([string match "www.*" $act_arg] == 1))} {
      # Make sure it wasn't the bot who said it
      set url $act_arg
      if {$nick == $botnick} {
         return 0 
      }
     
      # Check length of URL 
      set length [string length $url]

      if {$length >= $url_length} {

         #set tinyurl [make_tinyurl $url]      
         set tinyurl [exec perl -e "use WWW::Shorten::TinyURL;binmode(STDOUT, \":utf8\");print makeashorterlink(\"$url\");"]

         if {$tinyurl != "0"} {
            set title [exec perl -e "use URI::Title;binmode(STDOUT, \":utf8\");print URI::Title::title(\"$url\");"]
            putserv "PRIVMSG $chan :\002Tiny URL\002: $tinyurl \[$title\] (URL by \002$nick\002)"
            return 0
         }
      }

      if {([string match "*youtube*watch*" $url] == 1) || ([string match "*youtu.be*" $url] ==1)} {
            set title [exec perl -e "use URI::Title;binmode(STDOUT, \":utf8\");print URI::Title::title(\"$url\");"]
            if {([string match "* - YouTube" $title] == 1)} {
               set title [string range $title 0 end-10]
               putserv "PRIVMSG $chan :\002Youtube\002: $title (URL by \002$nick\002)"
            }
      }
   }
}
   return 0   
}

# -----------------------------------------------------------------------------
# Name    : make_tinyurl
# Purpose : Does the actual conversion
# -----------------------------------------------------------------------------

proc make_tinyurl { arg } {
   set page [::http::geturl http://tinyurl.com/create.php?url=${arg}]
   set lines [split [::http::data $page] \n]
   set numLines [llength $lines]

   for {set i 0} {$i < $numLines} {incr i 1} {
      set line [lindex $lines $i]
 
      if {[string match "<input type=hidden name=tinyurl value=\"*\">" $line] == 1} {
         set tinyurl_line [string trim $line]
         regsub -all -nocase "<input type=hidden name=tinyurl value=\"" $tinyurl_line "" tinyurl_line
         regsub -all -nocase "\">" $tinyurl_line "" tinyurl_line

         return $tinyurl_line
      }
   }
   
   return "0"
}

putlog "---> tiny_url.tcl v0.1 by FAIN @ QuakeNet <fain@flamingfist.org> loaded"

