# Tech advice for VirginiaBot/PuppyBot.
# Code based from riddle.tcl by Leg.
# Changelog
# 0.01 - initial revision.

# Bindings

bind pub - "!techadvice" giveadvice
proc giveadvice {nick uhost hand chan rest} {
global botnick
 set advicefile "scripts/techadvice.txt"
 set fd [open $advicefile r]
 set lines [split [read -nonewline $fd] "\n"]
 set num [rand [llength $lines]]
 set randline [lindex $lines $num]
 set advicetxt [lindex [split $randline *] 0]
 set answertemp [lindex [split $randline *] 1]
 set answer [string tolower $answertemp]
 close $fd
 puthelp "PRIVMSG $chan :$botnick\'s tech advice of the moment..."
 puthelp "PRIVMSG $chan :\002$advicetxt\002"
}

putlog "Tech advice 0.01 loaded. Part of the VirginiaBot/PuppyBot toolset."
putlog "Code based from riddle.tcl by Leg."
