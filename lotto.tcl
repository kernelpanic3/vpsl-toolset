# Modified for VirginiaBot toolset.
# Changelog
# 1.2 - fully integrated with toolset.
# 1.1mod - reworked wording.

###############################################################################
#
#Lotto 6-49 1.1 Loaded
#
#The famouse lottery game Lotto 6-49 .
#
#Commands :
#
#!lotto on - enable Lotto 6-49
#!lotto off - disable Lotto 6-49
#!lotto - start the Lotto 6-49 game
#!lotto reset - reset the game if it freezes.
#!lotto version - version info
#!lotto help - help menu
#
#              ------------- Version 1.1 --------------
#New Commands :
#             
#!lotto <nick1> <nick2>.. - start a private game with who you desire
#!lotto <botnick> - start a game against your eggdrop. offCourse <botnick> can be added with other players on a private game.
#!lotto <nick1> <botnick> <nick2> start a private game with your friends and eggdrop
#
#Repaired some bugs :)
#                                             BLaCkShaDoW ProductionS
#                                                WwW.TCLScripts.Net
###############################################################################

bind pub -|- !lotto game:start
bind pub -|- !enter game:enter
bind pub -|- !number game:numbers

setudef flag lotto
set lottoversion "1.2"

proc game:start {nick host hand chan arg} {
global lotto lottoversion
set flag [lindex [split $arg] 0]
set choose_players [lrange [split $arg] 0 end]
set ::lotto_chan $chan
switch -exact -- [string tolower $flag] {
reset {
if {[matchattr $hand mn|o $chan]} {
putquick "PRIVMSG $chan :Lotto reset."
game:clear
return 0
}
}

on {
if {[matchattr $hand mn|o $chan]} {
channel set $chan +lotto
putquick "PRIVMSG $chan :Lotto  has been \002enabled\002 in $chan."
return 0
}
}

off {
if {[matchattr $hand mn|o $chan]} {
channel set $chan -lotto
putquick "PRIVMSG $chan :Lotto has been \002disabled\002 in $chan."
return 0
}
}

version {
    putquick "PRIVMSG $chan :Lotto $lottoversion by VASirens. Original 3Lotto 6-49 by 3BLaCkShaDoW."
return 0 version
}
 
}

if {[info exists lotto(start)]} {
putserv "PRIVMSG $chan :\002Oops!\002 A game is already in progress."
return 0
}
if {![channel get $chan lotto]} {
putserv "PRIVMSG $chan :Lotto is not enabled in this channel. If you are a chanop, you may enable it with !lotto on."
return 0 
} 

if {$choose_players != ""} {
lappend lotto(players:$chan) "[join $nick]"
foreach player $choose_players {
if {[onchan $player $chan] && ($player != $nick)} {
	lappend lotto(players:$chan) "[join $player]"
	set lotto(players:$chan) [lsort -unique $lotto(players:$chan)]
	}
}

if {[llength $lotto(players:$chan)] < 2} {
	puthelp "PRIVMSG $chan :No players! Lotto stopped."
	game:clear  
	return 0 
}
if {[info exists lotto(players:$chan)]} {
puthelp "PRIVMSG $chan :Lotto starts with a private game. Get ready!"
puthelp "NOTICE $nick :Players: $lotto(players:$chan)"
utimer 3 [list game:run $chan] 
set lotto(start) 1
}
return 0
}

puthelp "PRIVMSG $chan :Lotto started. 30 seconds on the clock for users to enter."
puthelp "PRIVMSG $chan :Use !enter to enter the game."
lappend lotto(players:$chan) $nick
utimer 30 [list game:run $chan] 
set lotto(start) 1

}


proc game:clear {} {
global lotto
set chan $::lotto_chan
if {[info exists lotto(players:$chan)]} {
foreach playa $lotto(players:$chan) {
if {[info exists lotto(numbers:$playa:$chan)]} {
unset lotto(numbers:$playa:$chan)
}
if {[info exists lotto(setnumber:$playa:$chan)]} {
unset lotto(setnumber:$playa:$chan)
}
if {[info exists lotto(Waitnumber:$playa:$chan)]} {
unset lotto(Waitnumber:$playa:$chan)
}
if {[info exists lotto(count:results:$playa:$chan)]} {
unset lotto(count:results:$playa:$chan)
}

if {[info exists lotto(show:numbers:$playa:$chan)]} {
unset lotto(show:numbers:$playa:$chan)
}

if {[info exists lotto(cpu:numbers:$chan)]} {
unset lotto(cpu:numbers:$chan)
}

if {[info exists lotto(results:$playa:$chan)]} {
unset lotto(results:$playa:$chan)
}
}
}
foreach tmr [utimers] {
if {[string match "*game:*" [join [lindex $tmr 1]]]} {
killutimer [lindex $tmr 2]
}
}
if {[info exists lotto(start)]} {
unset lotto(start)
}
if {[info exists lotto(players:$chan)]} {
unset lotto(players:$chan)
}
if {[info exists lotto(i:$chan)]} {
unset lotto(i:$chan)
}
if {[info exists lotto(number:start:$chan)]} {
unset lotto(number:start:$chan)
}
if {[info exists lotto(won:players:$chan)]} {
unset lotto(won:players:$chan)
}

if {[info exists lotto(is:player:$chan)]} {
unset lotto(is:player:$chan)
}
if {[info exists lotto(extragere:$chan)]} {
unset lotto(extragere:$chan)
}

if {[info exists lotto(count:extragere:$chan)]} {
unset lotto(count:extragere:$chan)
}


}

proc game:enter {nick host hand chan arg} {
global lotto count
if {[channel get $chan lotto]} {
if {![info exists lotto(start)]} {
return 0
}
foreach ply $lotto(players:$chan) {
if {[string equal -nocase $ply $nick]} {
puthelp "NOTICE $nick :\002Oops!\002 You're already a player in this game."
return 0 
}
}
if {[info exists lotto(number:start:$chan)]} {
puthelp "NOTICE $nick :Are you really trying to enter a game that's already in progress? Tsk, tsk, tsk."
return 0 
}
lappend lotto(players:$chan) "[join $nick]"
puthelp "PRIVMSG $chan :$nick has joined the game of Lotto."
}
} 

proc game:run {chan} {
global lotto
if {[llength $lotto(players:$chan)] == "1"} {
puthelp "PRIVMSG $chan :Nobody joined the game. Lotto stopped."
game:clear 
return 0 
}
puthelp "PRIVMSG $chan :Starting Lotto."
puthelp "PRiVMSG $chan :Players: $lotto(players:$chan)"
puthelp "PRIVMSG $chan :Now, the numbers."
game:player $chan
} 

proc cpu:number:chose {chan} {
global lotto botnick
set maxnumber "48"
set randnumber [expr [rand $maxnumber] +1]
if {![info exists lotto(numbers:$botnick:$chan)]} {
lappend lotto(numbers:$botnick:$chan) "[join $randnumber]"
}
while {[lsearch -integer -exact $lotto(numbers:$botnick:$chan) $randnumber] < 0} {
lappend lotto(numbers:$botnick:$chan) "[join $randnumber]"
}
cpu:number:chose:again $chan
}

proc cpu:number:chose:again {chan} {
global lotto botnick
if {[llength $lotto(numbers:$botnick:$chan)] < 6} {
cpu:number:chose $chan
}
}


proc game:player {chan} {
global lotto botnick
if {![info exists lotto(i:$chan)]} {
set lotto(i:$chan) 0
}
set player [lindex $lotto(players:$chan) $lotto(i:$chan)]
incr lotto(i:$chan) +1
set lotto(Waitnumber:$player:$chan) 1
if {$player != $botnick} {
puthelp "PRIVMSG $chan :It's your turn $player! Please type !number <number1> <number2> <number3> <number4> <number5> <number6> to choose your numbers (from 1 to 49). You have \0022\002 minutes."
}
if {[onchan $player $chan] && (![isbotnick $player])} { puthelp "NOTICE $player :ALERT: Please set your numbers for Lotto in $chan!" }
if {[string equal -nocase $player $botnick]} { 
cpu:number:chose $chan   
set lotto(setnumber:$player:$chan) 1
utimer 3 [list puthelp "PRIVMSG $chan :Bot's numbers are: $lotto(numbers:$player:$chan)"]
utimer 5 [list game:player:start $chan $player]
return 0
}
set lotto(number:start:$chan) 1
utimer 120 [list game:player:start $chan $player]
}

proc game:player:start {chan player} {
global lotto
if {![info exists lotto(setnumber:$player:$chan)]} {
puthelp "PRIVMSG $chan :$player didn't choose their numbers - skipping..."
if {[info exists lotto(Waitnumber:$player:$chan)]} {
unset lotto(Waitnumber:$player:$chan) 
}
}
if {[llength $lotto(players:$chan)] != $lotto(i:$chan)} {
game:player $chan
} else {
if {[info exists lotto(players:$chan)]} {
foreach playa $lotto(players:$chan) {
if {[info exists lotto(numbers:$playa:$chan)]} {
lappend lotto(is:player:$chan) $playa
}
}
}
game:extragere $chan
puthelp "PRIVMSG $chan :The numbers have been chosen. Starting the lottery..."
utimer 10 [list game:output $chan]
}
}


proc game:output {chan} {
global lotto botnick
if {![info exists lotto(is:player:$chan)]} {
puthelp "PRIVMSG $chan :Nobody chose their numbers! Lotto stopped."
game:clear 
return 0
}
puthelp "PRIVMSG $chan :The lottery numbers have been chosen..."
puthelp "PRIVMSG $chan :4AND NOW, THE RESULTS!"
puthelp "PRIVMSG $chan :The lottery numbers are..."
puthelp "PRIVMSG $chan :$lotto(extragere:$chan)"
foreach player $lotto(players:$chan) {
game:results:show $chan $player
if {[info exists lotto(show:numbers:$player:$chan)]} {
array set totalnum [list]
set num [llength $lotto(show:numbers:$player:$chan)]
lappend totalnum($num) $player
puthelp "PRIVMSG $chan : $player has guessed \002[llength $lotto(show:numbers:$player:$chan)]\002 of \0026\002 numbers. The numbers are: \002$lotto(show:numbers:$player:$chan)\002"
if {[llength $lotto(show:numbers:$player:$chan)] > 2} {
if {[onchan $player $chan] && (![isvoice $player $chan]) && (![isop $player $chan]) && [isop $botnick $chan]} {
puthelp "PRIVMSG $chan :$player gets voice because they guessed \002[llength $lotto(show:numbers:$player:$chan)]\002 of \0026\002 numbers. \002Congratulations!\002"
putnow "MODE $chan +v $player"
}
}

} else { puthelp "PRIVMSG $chan :$player didn't guess any numbers!"}

}
foreach car [lsort -integer -increasing [array names totalnum]] {
set max "$car"
}
if {[info exists num]} {
lappend winners "The winners are: \002[join $totalnum($max) ", "]\002 with \002$max\002 numbers guessed."
} else { set winners "\002Nobody won.\002" }
game:clear
if {![info exists lotto(start:$chan)]} {
if {[info exists winners]} {
puthelp "PRIVMSG $chan :[join $winners]"
}
puthelp "PRIVMSG $chan :And that, ladies and gentlemen, concludes our game."
}
}

proc game:results:show {chan player} {
global lotto
if {[info exists lotto(numbers:$player:$chan)]} {
foreach ex $lotto(extragere:$chan) {
if {[lsearch -exact [join $lotto(numbers:$player:$chan)] $ex] > -1} {
lappend lotto(show:numbers:$player:$chan) "[join $ex]"
}
}
}
}


proc game:extragere {chan} {
global lotto
set lotto_numbers "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49"
set randnumber [lindex $lotto_numbers [expr {int(rand()*[llength $lotto_numbers])}]]
if {![info exists lotto(extragere:$chan)]} {
lappend lotto(extragere:$chan) "[join $randnumber]"
}
while {[lsearch -integer -exact $lotto(extragere:$chan) $randnumber] < 0} {
lappend lotto(extragere:$chan) "[join $randnumber]"
}
game:extragere:again $chan
}

proc game:extragere:again {chan} {
global lotto
if {[llength $lotto(extragere:$chan)] < 6} {
game:extragere $chan
}
}



proc game:numbers {nick host hand chan arg} {
global lotto count
set numbers [lrange [split $arg] 0 5]
if {![info exists lotto(start)]} {
return 0
}
if {![info exists lotto(Waitnumber:$nick:$chan)]} {
return 0
}
if {[info exists lotto(setnumber:$nick:$chan)]} {
puthelp "Ti-ai setat deja numerele..."
return 0
}

foreach player $lotto(players:$chan) {
if {[string match -nocase $nick $player]} {
set numbers [lsort -unique $numbers]
if {([llength $numbers] < 6)} {
puthelp "NOTICE $nick :Use !number <number1> <number2> <number3> <number4> <number5> <number6>"
return 0 
}
foreach number $numbers {
if {![regexp {^[0-9]} $number]} {
puthelp "NOTICE $nick :Use !number <number1> <number2> <number3> <number4> <number5> <number6>"
return 0
}
if {($number < 1) || ($number > 49)} {
puthelp "NOTICE $nick :Use unique numbers from 1 to 49."
return 0
}


}
set lotto(setnumber:$player:$chan) 1
lappend lotto(numbers:$player:$chan) "$numbers"

}
}
puthelp "NOTICE $nick :Your numbers are: [join $lotto(numbers:$nick:$chan)]"
foreach tmr [utimers] {
if {[string match "*game:player:start*" [join [lindex $tmr 1]]]} {
killutimer [lindex $tmr 2]
game:player:start $chan $nick
}
}

}


putlog "Lotto $lottoversion loaded. Part of the VirginiaBot toolset."
putlog "Original 3Lotto 6-49 by 3BLaCkShaDoW."



