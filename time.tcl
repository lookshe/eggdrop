# slap by lookshe
#package require time

bind pub - !zeit proc_time
bind pub - !time proc_time

proc proc_time {nick host hand chan opfer} {
   #putserv "PRIVMSG $chan :[clock format [NetTime ntp.nasa.gov]]"
   putserv "PRIVMSG $chan :[exec date]"
}

proc NetTime {server} {
   set tok [time::getsntp $server] ;# or gettime to use the TIME protocol
    time::wait $tok
    if {[time::status $tok] eq "ok"} {
       set result [time::unixtime $tok]
       set code ok
    } else {
       set result [time::error $tok]
       set code error
    }
    time::cleanup $tok
    return -code $code $result
}

putlog "time by lookshe loaded"
