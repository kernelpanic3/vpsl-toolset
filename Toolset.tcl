# The VPSL toolset, a neatly-packaged assortment of random junk that might be partially useful to someone somewhere sometime.
# Setup:
# Run toolsetup.sh (or toolsetup.bat for Windrop).
# Changelog:
# See changelog.txt.
# Notes:
# Tested with Eggdrop 1.6.21.
# Some functions are adapted from other scripts - these are credited in prominent locations nearby.
# Comments, questions, or suggestions? Visit #VASirens on GeeksIRC (http://geeksirc.net/).

# END RANDOM PRATTLING

# BEGIN INITIALIZATION ROUTINES

bind pub - !helpme pub_helpme
bind pub - !schedule pub_schedule
bind pub - !assignments pub_assignments
bind pub - !version pub_version
# TF2 redirection
bind pub - !add pub_not-tf2
bind pub - !remove pub_not-tf2
bind pub - !cvote pub_not-tf2
bind pub - !whatis pub_not-tf2
bind pub - !rank pub_not-tf2
bind pub - !place pub_not-tf2
bind pub - !top10 pub_not-tf2
bind pub - !sub pub_not-tf2
bind pub - !mumble pub_not-tf2
bind pub - !server pub_not-tf2
bind pub - !map pub_not-tf2
bind pub - !list pub_not-tf2
bind pub - !stats pub_not-tf2
bind pub - !last pub_not-tf2
bind pub - !reward pub_not-tf2
bind pub - !format pub_not-tf2
bind pub - !0games pub_not-tf2
bind pub - !pick pub_not-tf2
bind pub - !pickwho pub_not-tf2
bind pub - !captain pub_not-tf2
bind pub - !accept pub_not-tf2
bind pub - !status pub_not-tf2
bind pub - !fadd pub_not-tf2
bind pub - !fremove pub_not-tf2
bind pub - !restrictions pub_not-tf2
bind pub - !stats-all pub_not-tf2
bind pub - !stats-class pub_not-tf2
bind pub - !crestrict pub_not-tf2
bind pub - !endgame pub_not-tf2
bind pub - !auto pub_not-tf2
bind pub - !fgame pub_not-tf2
bind pub - !famp pub_not-tf2
bind pub - !authorize pub_not-tf2
bind pub - !restrict pub_not-tf2
bind pub - !syncvoiced pub_not-tf2
bind pub - !lockdown pub_not-tf2
bind pub - !unlock pub_not-tf2
bind pub - !restart pub_not-tf2
bind pub - !tf2server pub_not-tf2
# Bad join redirection
bind pub - !join pub_not-join
bind pub - ?join pub_not-join
bind pub - .join pub_not-join
bind pub - #tf2.mix.nahl pub_not-join-badcmd-mixnahl
bind pub - #tf2.mix.euhl pub_not-join-badcmd-mixeuhl
bind pub - #tf2.pug.nahl pub_not-join-badcmd-pugnahl
bind pub - #tf2.pug.na pub_not-join-badcmd-pugna
bind pub - #tf2scrim pub_not-join-badcmd-scrim
bind pub - #tf2.mix.eu pub_not-join-badcmd-mixeu
bind pub - #tf2scrim.hl pub_not-join-badcmd-scrimhl
# Deprecation redirection; now in themselves deprecated
# bind pub - ?? pub_deprecated_??
# bind pub - timebomb pub_deprecated_timebomb
# Joke, should normally be commented out
bind pub - !downtime pub_downtime
# Anti-slap
bind ctcp - ACTION antislap:ctcp:action
# Merlion
bind ctcp - VERSION merlioncheck
proc merlioncheck {nick uhost hand chan keyword arg} {
global botnick
if {$botnick == "MerlionBot"} {
bind pub - !support pub_support
putlog "toolset: botnick is $botnick, binding !support"
} else {putlog "toolset: botnick is $botnick, not binding !support"}
}
# Topic engine cleanup (bind disabled)
# bind time - * topiccheck
proc topiccheck {minute hour day month year} {
global topicEngineOnline
if {!$topicEngineOnline} {
set topicEngineOnline 0
putlog "topicEngineOnline does not exist, setting it to 0"
} else {return}
}
# Topic change at midnight local time or on demand (with updating as needed)
bind time - "00 00 * * *" pub_topic_change
bind pub - !updatetopic pub_topic_change_now
bind time - "* * * * *" pub_topic_update
# Roulette
bind pub - !roulette roulette_challenge

# Set up udefs
setudef flag antislap
setudef flag tf2redirect
setudef flag redirect-notjoin
setudef flag redirect-notjoin-badcmd

bind evnt - init-server init_netfind
bind evnt - rehash init_netfind
# Initialize network-finding variables
proc init_netfind {type} {
global network networkid serveraddress
if {$serveraddress == "irc.freenode.net:6667"} {
set network "freenode"
set networkid 0
} elseif {$serveraddress == "chat.freenode.net:6667"} {
set network "freenode"
set networkid 0
} elseif {$serveraddress == "irc.jasperswebsite.com:6667"} {
set network "JDNet"
set networkid 1
} elseif {$serveraddress == "irc.geeksirc.net:6665"} {
set network "GeeksIRC"
set networkid 2
} elseif {$serveraddress == "unreal.nsrt.it:6667"} {
set network "FIRCd Testnet"
set networkid 3
} elseif {$serveraddress == "127.0.0.1:34254"} {
set network "TestIRC"
set networkid 4
} elseif {$serveraddress == "irc.rizon.net:6665"} {
set network "Rizon"
set networkid 5
} elseif {$serveraddress == "irc.gamesurge.net:6667"} {
set network "GameSurge"
set networkid 6
} else {
set network "Unknown"
set networkid 65536
}
putlog "netfind: network $network, networkid $networkid"
}

# Initialize other variables
set roulette_player1 ""
set roulette_player2 "" 
set roulette_curplayer ""
set roulette_notcurplayer ""
set roulette_timeout_timer 0
set roulette_started 0
set roulette_turns 0
set roulette_bullet [rand 5]
set roulette_scorefile "roulette.txt"
set roulette_kill_count 0
set roulette_last_warn ""
set roulette_pull {
"quickly pulls the trigger..."
"shakes as they slowly raise the gun to pull the trigger..."
"calmly smiles as they pull the trigger..."
"puts the gun in their mouth..."
"places the gun between their eyes and starts to pray..."
"slowly raises the gun and puts it against their temple..."
"slowly but surely inches the gun toward their head..."
"cautiously fingers the trigger..."
"reconsiders playing, but accidentally pulls the trigger..."
"aims the gun between their eyes and hopes for the best..."
}
set roulette_lucky_msg {
"Click...did I remember to load that gun?"
"Click...your luck won't last long...\002hahahahaha!!!!!\002"
"Click...next turn, you've got a date with a bullet...\002hahahahaha!!!!!\002"
"Click...well, well, well, if it isn't Mr. Lucky Charms."
"Click...you're lucky that bullet didn't work...here, have a fresh one."
"Click...I bet you wish you were this lucky at the lottery."
"Click...spin or shoot, I don't care. If you win I'll just shoot you myself."
"Click...so you think you're good, eh? I dare you to play me next."
"Click...if I had a head like yours I'd've been playing this game until I lost!"
"Click...funny, I didn't think that round was spent."
}

# END INITIALIZATION ROUTINES

# BEGIN HELP SYSTEM CODE

proc pub_helpme {nick host hand chan input args} {
global networkid botnick
global isgeeksirc isVABot isjdnet
# Should we show GeeksIRC-specific commands?
    if {$networkid == 2} {
set isgeeksirc 1
    } else { set isgeeksirc 0 }
# Should we show VirginiaBot-specific commands?
    if {$botnick == "VirginiaBot"} {
set isVABot 1
    } else { set isVABot 0 }
# Should we show MerlionBot-specific commands?
    if {$botnick == "MerlionBot"} {
set isMerlionBot 1
    } else { set isMerlionBot 0 }
# Should we show JDNet-specific commands?
    if {$networkid == 1} {
set isjdnet 1
    } else { set isjdnet 0 }
# Should we show TestIRC-specific commands?
    if {$networkid == 4} {
set istestirc 1
    } else { set istestirc 0 }
# Should we show Rizon-specific commands?
    if {$networkid == 5} {
set isrizon 1
    } else { set isrizon 0 }

    if {$input == "helpme"} {
# helpme
putserv "NOTICE $nick :The \002!helpme\002 command returns a list of all commands the bot recognizes. It can also return help on a specific command if you give it one."
putserv "NOTICE $nick :Example: \"!helpme\""
putserv "NOTICE $nick :Example: \"!helpme schedule\""
putlog "info: $nick used !helpme $input in $chan"
# schedule
} elseif {$input == "schedule" && $chan == "french" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :The \002!schedule\002 command returns the current class schedule."
putserv "NOTICE $nick :Example: \"!schedule\""
putlog "info: $nick used !helpme $input in $chan"
# w
    } elseif {$input == "w"} {
putserv "NOTICE $nick :The \002!w\002 command returns the current weather conditions and forecast for a location."
putserv "NOTICE $nick :Example: \"!w 90210\""
putserv "NOTICE $nick :Example: \"!w Easton, PA\""
putserv "NOTICE $nick :Example: \"!w Paris, FR\""
putserv "NOTICE $nick :Example: \"!w KPHF\""
putlog "info: $nick used !helpme $input in $chan"
# assignments
    } elseif {$input == "assignments" && $chan == "#french" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :The \002!assignments\002 command returns any assignments that are due this week."
putserv "NOTICE $nick :Example: \"!assignments\""
putlog "info: $nick used !helpme $input in $chan"
# 8ball
    } elseif {$input == "8ball" && $isMerlionBot == 0} {
putserv "NOTICE $nick :The \002!8ball\002 command returns an answer from the Official Calvin-Approved Magic 8-Ball(TM)."
putserv "NOTICE $nick :Example: \"!8ball Will I master conjugating aller?\""
putlog "info: $nick used !helpme $input in $chan"
# uno
    } elseif {$input == "uno" && $chan == "#VASirens" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :The \002!uno\002 command begins a game of one of several variants of Uno. Bot play is not supported at this time."
putserv "NOTICE $nick :Game commands are beyond the scope of this help system. Use !unocmds for a listing."
putserv "NOTICE $nick :Example: \"!uno\""
putlog "info: $nick used !helpme $input in $chan"
# version
    } elseif {$input == "version"} {
putserv "NOTICE $nick :The \002!version\002 command returns the bot's version and other technical details."
putserv "NOTICE $nick :Example: \"!version\""
putlog "info: $nick used !helpme $input in $chan"
# botnews
    } elseif {$input == "botnews" && $isgeeksirc == 1} {
putserv "NOTICE $nick :The \002!botnews\002 command returns recent news items regarding the bot - essentially, a changelog."
putserv "NOTICE $nick :Example: \"!botnews\""
putlog "info: $nick used !helpme $input in $chan"
# define
    } elseif {$input == "define" && $isgeeksirc == 1} {
putserv "NOTICE $nick :The \002!define\002 command returns a definition for a term. \002This command is not a dictionary in the normal sense.\002 Rather, it is meant for interest-specific terminology that would normally not be found in a dictionary."
putserv "NOTICE $nick :Example: \"!define WPS-3016\""
putlog "info: $nick used !helpme $input in $chan"
# ping
    } elseif {$input == "ping"} {
putserv "NOTICE $nick :The \002!ping\002 command pings a user, then returns how many seconds it took for the reply to arrive."
putserv "NOTICE $nick :Example: \"!ping me\""
putserv "NOTICE $nick :Example: \"!ping YakBot\""
putlog "info: $nick used !helpme $input in $chan"
# uptime
    } elseif {$input == "uptime"} {
putserv "NOTICE $nick :The \002!uptime\002 command returns the bot\'s uptime - how long it has been running. Depending on the channel, it may also trigger other user\'s uptime scripts."
putserv "NOTICE $nick :Example: \"!uptime\""
putlog "info: $nick used !helpme $input in $chan"
# techadvice
    } elseif {$input == "techadvice" && $isMerlionBot == 0} {
putserv "NOTICE $nick :The \002!techadvice\002 command returns a random snippet of helpful tech advice."
putserv "NOTICE $nick :Example: \"!techadvice\""
putlog "info: $nick used !helpme $input in $chan"
# search
    } elseif {$input == "wikipedia"} {
	if {$isgeeksirc == 1 || $isjdnet == 1} {
putserv "NOTICE $nick :The \002!wikipedia\002 command returns the first paragraph of an English Wikipedia article. Only mainspace is supported at this time."
putserv "NOTICE $nick :Example: \"!wikipedia WSBT-TV\""
putserv "NOTICE $nick :Example: \"!wikipedia Egg drop soup\""
putlog "info: $nick used !helpme $input in $chan"
	} else {nohelp $nick $chan $input}
# lotto
    } elseif {$input == "lotto"} {
	if {$isgeeksirc == 1 || $isjdnet == 1 || $isrizon == 1 || $isgs == 1} {
	    if {$isMerlionBot == 0} {
putserv "NOTICE $nick :The \002!lotto\002 command begins a game of Lotto 6-49. For a game command listing, use !helpme lotto cmds."
putserv "NOTICE $nick :Example: \"!lotto\""
putlog "info: $nick used !helpme $input in $chan"
	    } else {nohelp $nick $chan $input}
	} else {nohelp $nick $chan $input}
# lotto cmds
    } elseif {$input == "lotto cmds"} {
	if {$isgeeksirc == 1 || $isjdnet == 1 || $isrizon == 1 || $isgs == 1} {
	    if {$isMerlionBot == 0} {
putserv "NOTICE $nick :The \002!lotto\002 command begins a game of Lotto 6-49. Here is a game command listing."
putserv "NOTICE $nick :!lotto             - starts a public game (anyone can join)"
putserv "NOTICE $nick :!enter             - enter a public game"
putserv "NOTICE $nick :!lotto nick1 nick2 - starts a private game between the specified nicks; the bot can be included"
putserv "NOTICE $nick :!number            - pick your 6 numbers"
putserv "NOTICE $nick :!lotto version     - displays script version"
putlog "info: $nick used !helpme $input in $chan"
	    } else {nohelp $nick $chan $input}
	} else {nohelp $nick $chan $input}
# dice
    } elseif {$input == "dice"} {
	if {$isgeeksirc == 1 || $isjdnet == 1 || $istestirc == 1 || $isrizon == 1 || $isgs == 1} {
	    if {$isMerlionBot == 0} {
putserv "NOTICE $nick :The \002!dice\002 command begins a game of Dice. For a game command listing, use !helpme dice cmds."
putserv "NOTICE $nick :Example: \"!dice\""
putlog "info: $nick used !helpme $input in $chan"
	    } else {nohelp $nick $chan $input}
	} else {nohelp $nick $chan $input}
# dice cmds
    } elseif {$input == "dice cmds"} {
	if {$isgeeksirc == 1 || $isjdnet == 1 || $istestirc == 1 || $isrizon == 1 || $isgs == 1} {
	    if {$isMerlionBot == 0} {
putserv "NOTICE $nick :The \002!dice\002 command begins a game of Dice. Here is a game command listing."
putserv "NOTICE $nick :!dice nick   - starts a game between you and the specified nick"
putserv "NOTICE $nick :!dice bot    - starts a game between you and the bot"
putserv "NOTICE $nick :!roll        - rolls the dice"
putserv "NOTICE $nick :!diceversion - displays script version"
putlog "info: $nick used !helpme $input in $chan"
	    } else {nohelp $nick $chan $input}
	} else {nohelp $nick $chan $input}
# unovar
    } elseif {$input == "unovar" && $chan == "#VASirens" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :The \002!unovar\002 command returns the currently-selected Uno variant, and allows you to select which one to play. Here is a listing of the variants currently available."
putserv "NOTICE $nick :Double Uno (x2)        - doubled draw values for wild cards, among other differences"
putserv "NOTICE $nick :Uno Attack (attack)    - uses a mechanical card launcher in lieu of drawing (except for wild draw two cards)"
putserv "NOTICE $nick :Example: \"!unovar\""
putserv "NOTICE $nick :Example: \"!unovar x2\""
putlog "info: $nick used !helpme $input in $chan"
# roulette
    } elseif {$input == "roulette"} {
putserv "NOTICE $nick :The \002!roulette\002 command begins a game of the famously lethal game of chance, Russian Roulette. Unlike the original, however, this version is by its very nature harmless."
putserv "NOTICE $nick :For a game command listing, use !helpme roulette cmds."
putserv "NOTICE $nick :Example: !roulette $botnick"
putlog "info: $nick used !helpme $input in $chan"
# roulette cmds
    } elseif {$input == "roulette cmds"} {
putserv "NOTICE $nick :The \002!roulette\002 command begins a game of Russian Roulette. Here is a game command listing."
putserv "NOTICE $nick :!roulette nick        - challenges the specified nick to a game; the bot can also be challenged"
putserv "NOTICE $nick :!roulette scores all  - sends you a private message containing a cross-network score list"
putserv "NOTICE $nick :!roulette scores nick - displays the scores for the specified nick"
putlog "info: $nick used !helpme $input in $chan"
# easter egg
    } elseif {$input == "supercalifragilisticexpialidocious"} {
pub_easteregg $nick $chan
# no help for you
    } elseif {[llength $input] != 0} {
nohelp $nick $chan $input
# command listing
    } else {
putserv "NOTICE $nick :You used !helpme."
putserv "NOTICE $nick :Here is a list of commands the bot recognizes. Commands with an asterisk \002*\002 next to them will send output to everyone."
# #french-specific command on GeeksIRC as VirginiaBot
	if {$chan == "#french" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :!schedule     - displays the current class schedule"
	}
putserv "NOTICE $nick :!w\002*\002           - prints out the weather conditions and forecast for a location"
# #french-specific command on GeeksIRC as VirginiaBot
	if {$chan == "#french" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :!assignments  - prints out the assignments due this week"
	}
putserv "NOTICE $nick :!8ball\002*\002       - asks the Magic 8 Ball a question"
# #VASirens-specific command on GeeksIRC as VirginiaBot
	if {$chan == "#VASirens" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :!uno\002*\002         - begins a game of Uno"
	}
# #VASirens-specific command on GeeksIRC as VirginiaBot
	if {$chan == "#VASirens" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :!unovar\002*\002      - returns or changes the current Uno variant"
	}
# On GeeksIRC
	if {$isgeeksirc == 1} {
putserv "NOTICE $nick :!botnews      - prints out the latest updates regarding the bot"
    }
    if {$isgeeksirc == 1} {
putserv "NOTICE $nick :!define       - returns the definition of a term"
}
putserv "NOTICE $nick :!ping         - pings a user"
putserv "NOTICE $nick :!uptime\002*\002      - returns the bot\'s uptime"
# Not used on MerlionBot
	if {$isMerlionBot == 0} {
putserv "NOTICE $nick :!techadvice\002*\002  - returns helpful tech advice"
	}
# GeeksIRC/JDNet-specific command
    if {$isgeeksirc == 1 || $isjdnet == 1} {
putserv "NOTICE $nick :!wikipedia\002*\002   - returns an article from the English Wikipedia"
}
# GeeksIRC/JDNet/Rizon-specific command on VirginiaBot/PuppyBot/MutterBot
    if {$isgeeksirc == 1 || $isjdnet == 1 || $isrizon == 1 || $isgs == 1} {
if {$isMerlionBot == 0} {
putserv "NOTICE $nick :!lotto\002*\002       - begins a game of Lotto 6-49"
}
}
# GeeksIRC/JDNet/TestIRC/Rizon-specific command on VirginiaBot/PuppyBot/BlahBot/MutterBot
    if {$isgeeksirc == 1 || $isjdnet == 1 || $istestirc == 1 || $isrizon == 1 || $isgs == 1} {
	if {$isMerlionBot == 0} {
putserv "NOTICE $nick :!dice\002*\002        - begins a game of Dice"
}
    }
putserv "NOTICE $nick :!roulette\002*\002    - begins a (harmless) game of Russian Roulette"
putserv "NOTICE $nick :!helpme       - prints out this help listing"
putserv "NOTICE $nick :!version      - prints out the bot's version, among other things"
putserv "NOTICE $nick :For more help on a specific command, type \"!helpme <command>\". (Example: \"!helpme helpme\")"
putserv "NOTICE $nick :Have fun!"
putlog "info: $nick used !helpme in $chan"
  }
}

proc nohelp {nick chan input} {
global isgeeksirc isVABot
putlog "info: no help for $nick on $chan asking about $input"
putserv "NOTICE $nick :Sorry, but there isn't any help available on that command."
# we only want people bugging me about the bot in #french
	if {$chan == "#french" && $isgeeksirc == 1 && $isVABot == 1} {
	    putserv "NOTICE $nick :Try asking Calvin."
	}
}

# END HELP SYSTEM CODE

# BEGIN BASE VIRGINIABOT TOOLS CODE

# Log and load
putlog "Base bot tools loaded"
putlog "Anti trouting functionality enabled"
putlog "This code is based from: Aide Cmds TCL by MeS http://www.EdenTech.Biz"
putlog "Portions adapted from \002\00301,00WikipediA\002\003 \002by Ford_Lawnmower irc.GeekShed.net #Script-Help"
putlog "Other bot scripts:"
putlog "uno.tcl"
putlog "lilyweather4.6.tcl"
putlog "news.tcl"
putlog "dlearn.tcl"
putlog "8ball.tcl"
putlog "setmodeB.tcl"
putlog "timebomb.tcl"

# !schedule
proc pub_schedule {nick host hand chan args} {
    if {$chan == "#french"} {
# begin read from file
set schedfile "french-schedule.cur"
set fs [open $schedfile r] 
while {![eof $fs]} { 
  gets $fs line 
  set sched_line1 $line
  gets $fs line 
  set sched_line2 $line
} 
close $fs
# end read from file
# now we print things out
putserv "NOTICE $nick :The current class schedule for \002French 1\002 is:"
# if the first line is 0, we assume the schedule is temporarily unavailable and die
# first line is primary schedule
# second line is secondary info (speaking classes, etc.)
if {$sched_line1 == "0"} {
putserv "NOTICE $nick :\002Temporarily Unavailable\002"
} else  {putserv "NOTICE $nick :\002$sched_line1\002"}
if {$sched_line2 =="0"} {} else {putserv "NOTICE $nick :$sched_line2"}
    }
}

# !assignments
proc pub_assignments {nick host hand chan args} {
    if {$chan == "#french"} {
# begin read from file
set assignfile "french-assignments.due"
set fs [open $assignfile r] 
while {![eof $fs]} { 
  gets $fs line 
  set assignments_main $line
  gets $fs line 
  set assignments_bonus $line
} 
close $fs
# end read from file
# now we print things out
putserv "NOTICE $nick :The assignments due this week are:"
# if the first line is 0, we assume everyone has the week off
if {$assignments_main == "0"} {putserv "NOTICE $nick :Nothing!" } else { putserv "NOTICE $nick :\002$assignments_main\002" }
# if the second line is 0, we assume there is no extra credit available
if {$assignments_bonus == "0"} { putserv "NOTICE $nick :No extra credit this week." } else { putserv "NOTICE $nick :Extra credit: \002$assignments_bonus\002" }
}
}

# !version
proc pub_version {nick host hand chan args} {
global botnick version network networkid config tcl_version
global toolsetver eggdropversion topicEngineOnline serveraddress
putlog "info: $nick used !version in $chan"
# First we determine what network we're on
    if {$networkid == 0} {set networkurl "http://freenode.net/"}
    if {$networkid == 1} {set networkurl "http://jd.orain.org/wiki/JDNet"}
    if {$networkid == 2} {set networkurl "http://geeksirc.net/"}
    if {$networkid == 3} {set networkurl "http://fircd.org/"}
    if {$networkid == 4} {set networkurl "http://74.99.75.127/testirc/"}
    if {$networkid == 5} {set networkurl "http://rizon.net/"}
    if {$networkid == 6} {set networkurl "https://gamesurge.net/"}
    if {$networkid == 65536} {set networkurl "Unknown"}
# Next we set some variables
# *** REMEMBER TO UPDATE VERSIONS AS NEEDED ***
set toolsetver "1.0b10.2"
set toolsetdate "9/15/14"
set eggdropversion "1.6.21"
set eggdropdate "10/25/11"
if {$botnick == "VirginiaBot"} {
set botcreatedate "1/29/14"
}
if {$botnick == "PuppyBot"} {
set botcreatedate "2/26/14"
}
if {$botnick == "SmokeBot"} {
set botcreatedate "6/17/14"
}
if {$botnick == "BlahBot"} {
set botcreatedate "6/28/14"
}
if {$botnick == "MerlionBot"} {
set botcreatedate "7/17/14"
}
if {$botnick == "MutterBot"} {
set botcreatedate "8/09/14"
}
set tclver "8.6.1"
set tcldate "9/19/13"
set tclpkgver "8.6.1-4ubuntu1"
set tclpkgdate "1/02/14"
if {$botnick == "LEDBot"} {
set isLEDBot 1
} else { set isLEDBot 0 }
if {$botnick == "MerlionBot"} {
set isMerlionBot 1
} else { set isMerlionBot 0 }
# Now we actually say something
putquick "NOTICE $nick :This is $botnick, a fully automated IRC bot."
putquick "NOTICE $nick :$botnick is an Eggdrop running on the $network network."
putquick "NOTICE $nick :$botnick is part of the VPSL botnet, a cross-network group of Eggdrops sharing common code."
putquick "NOTICE $nick :Website: http://74.99.75.127/vpsl"
# We only want to credit mrboojay if we're LEDBot
if {$isLEDBot == 1} {
putquick "NOTICE $nick :Special thanks to mrboojay for making this bot possible."
}
# As above, we only want to credit ACJZA is we're MerlionBot
if {$isMerlionBot == 1} {
putquick "NOTICE $nick :Special thanks to Chris Leung (MIA0233) for making this bot possible."
}
putserv "NOTICE $nick :Technical details:"
putserv "NOTICE $nick :$botnick version: \002$toolsetver\002 ($toolsetdate)"
putserv "NOTICE $nick :Eggdrop version: \002$eggdropversion\002 ($eggdropdate)"
putserv "NOTICE $nick :Tcl version: \002$tclver\002 ($tcldate)"
putserv "NOTICE $nick :Network: \002$network\002 (URL: $networkurl)"
putserv "NOTICE $nick :Created: \002$botcreatedate\002"
}

# Anti-slap adapted from here http://forums.wireplay.co.uk/archive/index.php/t-245120.html

proc antislap:ctcp:action {nick uhost hand chan keyword arg} {
global botnick
if {([string tolower [lindex $arg 0]] == "slaps" || [string tolower [lindex $arg 0]] == "slap")} {
if {[lsearch [string tolower $arg] trout] >= 2 || [lsearch [string tolower $arg] trout.] >= 2} {
if { [botisop $chan] == 1 } {
puthelp "kick $chan $nick :$troutkickreason"
putlog "info: Kicked $nick from $chan for trouting"
}
if { [botisop $chan]== 0 } {
puthelp "PRIVMSG $chan :\001ACTION incinerates $nick's trout with a blowtorch.\001"
putlog "info: Incinerated $nick's trout in $chan"
}
} else {
if {$nick != "TalkBot"} {
set objectfile "scripts/objects.txt"
set fd [open $objectfile r]
set lines [split [read -nonewline $fd] "\n"]
set num [rand [llength $lines]]
set randline [lindex $lines $num]
set object [lindex [split $randline *] 0]
close $fd
puthelp "PRIVMSG $chan :\001ACTION slaps $nick with $object.\001"
putlog "Slapped $nick in $chan with $object"
} else {
putlog "info: TalkBot slapped someone; not engaging in mutual slapping session"
}
}
}
return 0
}

# END BASE VIRGINIABOT TOOLS CODE

# BEGIN TF2 CODE

proc pub_not-tf2 {nick uhost hand chan args} {
if {[lsearch -exact [channel info $chan] +tf2redirect] != -1} {
putlog "info: Kicking and warning $nick - $chan is not a TF2 channel"
putserv "PRIVMSG ChanServ :kick $chan $nick You are not in a TF2 channel"
putserv "NOTICE $nick :\002\00304ALERT:\002\003 You are speaking in $chan. $chan is not a TF2 channel."
putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a channel operator for help. Thanks!"
putlog "PRIVMSG ChanServ :kick $chan $nick You are not in a TF2 channel"
} else {
putlog "info: $nick: $chan is not a TF2 channel, but udef not set - ignoring"
return 1
}
}

# END TF2 CODE

# BEGIN JOIN REDIRECTION CODE

proc pub_not-join {nick uhost hand chan input args} {
if {[lsearch -exact [channel info $chan] +redirect-notjoin] != -1} {
    putlog "info: Redirecting $nick - bad attempt to join $input from $chan (wrong join command)"
    if {$input == "#tf2.mix.euhl" || $input == "#tf2.pug.nahl" || $input == "#tf2.pug.na" || $input == "#tf2.mix.nahl" || $input == "#tf2scrim.hl" || $input == "#tf2scrim"} {
putserv "NOTICE $nick :\002\00304ALERT:\002\003 You are using the wrong command to join that TF2 channel."
putserv "NOTICE $nick :Try \"/join $input\" (without quotes)."
putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
# If they aren't trying to join a TF2 channel, we don't mention TF2
    } else {
putserv "NOTICE $nick :\002\00304ALERT:\002\003 You are using the wrong command to join that channel."
putserv "NOTICE $nick :Try \"/join $input\" (without quotes)."
    }
} else {
putlog "info: $nick made bad attempt to join $input from $chan (wrong join command), but udef not set - ignoring"
return 1
}
}

proc pub_not-join-badcmd-mixnahl {nick uhost hand chan input args} {
    if {[lsearch -exact [channel info $chan] +redirect-notjoin-badcmd] != -1} {
    putlog "info: Redirecting $nick - bad attempt to join #tf2.mix.nahl from $chan (no join command)"
    putserv "NOTICE $nick :\002\00304ALERT:\002\003 Are you trying to join a TF2 channel?"
    putserv "NOTICE $nick :Try \"/join \#tf2.mix.nahl\" (without quotes)."
    putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
    } else {
    putlog "info: $nick made bad attempt to join #tf2.mix.nahl from $chan (no join command), but udef not set - ignoring"
return 1
    }
    }
proc pub_not-join-badcmd-mixeuhl {nick uhost hand chan input args} {
    if {[lsearch -exact [channel info $chan] +redirect-notjoin-badcmd] != -1} {
    putlog "info: Redirecting $nick - bad attempt to join #tf2.mix.euhl from $chan (no join command)"
    putserv "NOTICE $nick :\002\00304ALERT:\002\003 Are you trying to join a TF2 channel?"
    putserv "NOTICE $nick :Try \"/join \#tf2.mix.euhl\" (without quotes)."
    putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
    } else {
    putlog "info: $nick made bad attempt to join #tf2.mix.euhl from $chan (no join command), but udef not set - ignoring"
return 1
    }
    }
proc pub_not-join-badcmd-pugnahl {nick uhost hand chan input args} {
    if {[lsearch -exact [channel info $chan] +redirect-notjoin-badcmd] != -1} {
    putlog "info: Redirecting $nick - bad attempt to join #tf2.pug.nahl from $chan (no join command)"
    putserv "NOTICE $nick :\002\00304ALERT:\002\003 Are you trying to join a TF2 channel?"
    putserv "NOTICE $nick :Try \"/join \#tf2.pug.nahl\" (without quotes)."
    putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
    } else {
    putlog "info: $nick made bad attempt to join #tf2.pug.nahl from $chan (no join command), but udef not set - ignoring"
return 1
    }
    }
proc pub_not-join-badcmd-pugna {nick uhost hand chan input args} {
    if {[lsearch -exact [channel info $chan] +redirect-notjoin-badcmd] != -1} {
    putlog "info: Redirecting $nick - bad attempt to join #tf2.pug.na from $chan (no join command)"
    putserv "NOTICE $nick :\002\00304ALERT:\002\003 Are you trying to join a TF2 channel?"
    putserv "NOTICE $nick :Try \"/join \#tf2.pug.na\" (without quotes)."
    putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
    } else {
    putlog "info: $nick made bad attempt to join #tf2.pug.na from $chan (no join command), but udef not set - ignoring"
return 1
    }
    }
proc pub_not-join-badcmd-scrim {nick uhost hand chan input args} {
    if {[lsearch -exact [channel info $chan] +redirect-notjoin-badcmd] != -1} {
    putlog "info: Redirecting $nick - bad attempt to join #tf2scrim from $chan (no join command)"
    putserv "NOTICE $nick :\002\00304ALERT:\002\003 Are you trying to join a TF2 channel?"
    putserv "NOTICE $nick :Try \"/join \#tf2scrim\" (without quotes)."
    putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
    } else {
    putlog "info: $nick made bad attempt to join #tf2scrim from $chan (no join command), but udef not set - ignoring"
return 1
    }
    }
proc pub_not-join-badcmd-mixeu {nick uhost hand chan input args} {
    if {[lsearch -exact [channel info $chan] +redirect-notjoin-badcmd] != -1} {
    putlog "info: Redirecting $nick - bad attempt to join #tf2.mix.eu from $chan (no join command)"
    putserv "NOTICE $nick :\002\00304ALERT:\002\003 Are you trying to join a TF2 channel?"
    putserv "NOTICE $nick :Try \"/join \#tf2.mix.eu\" (without quotes)."
    putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
    } else {
    putlog "info: $nick made bad attempt to join #tf2.mix.eu from $chan (no join command), but udef not set - ignoring"
return 1
    }
    }
proc pub_not-join-badcmd-scrimhl {nick uhost hand chan input args} {
    if {[lsearch -exact [channel info $chan] +redirect-notjoin-badcmd] != -1} {
    putlog "info: Redirecting $nick - bad attempt to join #tf2scrim.hl from $chan (no join command)"
    putserv "NOTICE $nick :\002\00304ALERT:\002\003 Are you trying to join a TF2 channel?"
    putserv "NOTICE $nick :Try \"/join \#tf2scrim.hl\" (without quotes)."
    putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
    } else {
    putlog "info: $nick made bad attempt to join #tf2scrim.hl from $chan (no join command), but udef not set - ignoring"
return 1
    }
    }

# END JOIN REDIRECTION CODE

# BEGIN LEDBOT-SPECIFIC CODE

# None at present; placeholder

# END LEDBOT-SPECIFIC CODE

# BEGIN PUPPYBOT-SPECIFIC CODE

# None at present; placeholder

# END PUPPYBOT-SPECIFIC CODE

# BEGIN MERLIONBOT-SPECIFIC CODE

proc pub_support {nick uhost hand chan input args} {
set file "scripts/supportlines.txt"
set fln 0
set fs [open $file r]
while {![eof $fs]} {
gets $fs line
incr fln
if {$fln == $input} {
set found 1
set sline $line
putlog "info: $nick used !support $input in $chan"
pub_supportformat $sline $chan
return
} else {set found 0}
}
if {$found == 0 && [eof $fs]} {
putquick "NOTICE $nick :\002Oops!\002 Line not found."
putlog "warning: $nick used !support $input in $chan, but line not found"
}
close $fs
}

proc pub_supportformat {sline chan} {
  set sline [split $sline " "]
  set tokens [llength $sline]
  set start 0
  set return ""
  set limit 50
  while {[llength [lrange $sline $start $tokens]] > $limit} {
    incr tokens -1
    if {[llength [lrange $sline $start $tokens]] <= $limit} {
      lappend return [join [lrange $sline $start $tokens]]
      set start [expr $tokens + 1]
      set tokens [llength $sline]
    }
  }
  lappend return [join [lrange $sline $start $tokens]]
  pub_supportoutput $sline $chan
}
proc pub_supportoutput {sline chan} {
putquick "PRIVMSG $chan :$sline"
}

# END MERLIONBOT-SPECIFIC CODE

# BEGIN TOPIC MANAGEMENT CODE

proc pub_topic_change {minute hour day month year} {
global serveraddress networkid topicchan
global misc_cur miscjdnet_cur miscgeeksirc_cur miscrizon_cur wordofday_cur
# What network are we on? What channel should we change the topic in?
    if {$networkid == 1} {set topicchan "#WikiPuppies"}
    if {$networkid == 2} {set topicchan "#VASirens"}
    if {$networkid == 4} {set topicchan "#test"}
    if {$networkid == 5} {set topicchan "#Metacity"}
    if {$networkid == 6} {set topicchan "#blindsight"}
putlog "info: clock says midnight, changing topic in $topicchan"
# Is there any miscellaneous stuff to append to the end of the topic? What's the word of the day?
set miscfile "/home/calvin/IRC/eggdrop/scripts/misc.txt"
set fs [open $miscfile r] 
while {![eof $fs]} { 
  gets $fs line
  putlog "$line"
  set misc $line
  putlog "$misc"
  set misc_cur $misc
} 
close $fs
# If there's misc stuff, flag it
if {$misc == ""} {set ismisc 0} else {set ismisc 1}
# Network-specific stuff
if {$networkid == 1} {
set miscjdnetfile "/home/calvin/IRC/eggdrop/scripts/misc-jdnet.txt"
set fs [open $miscjdnetfile r] 
while {![eof $fs]} { 
  gets $fs line 
  putlog "$line"
  set miscjdnet $line
  putlog "$miscjdnet"
  set miscjdnet_cur $miscjdnet
} 
close $fs
}
if {$networkid == 2} {
set miscgeeksircfile "/home/calvin/IRC/eggdrop/scripts/misc-geeksirc.txt"
set fs [open $miscgeeksircfile r] 
while {![eof $fs]} { 
  gets $fs line
  set miscgeeksirc $line
  set miscgeeksirc_cur $miscgeeksirc
} 
close $fs
}
if {$networkid == 5} {
set miscrizonfile "/home/calvin/IRC/eggdrop/scripts/misc-rizon.txt"
set fs [open $miscrizonfile r] 
while {![eof $fs]} { 
  gets $fs line 
  set miscrizon $line
  set miscrizon_cur $miscrizon
} 
close $fs
}
# If there's network-specific misc stuff, flag it
if {$networkid == 1} {if {$miscjdnet != ""} {set ismiscjdnet 1} else {set ismiscjdnet 0}}
if {$networkid == 2} {if {$miscgeeksirc != ""} {set ismiscgeeksirc 1} else {set ismiscgeeksirc 0}}
if {$networkid == 5} {if {$miscrizon != ""} {set ismiscrizon 1} else {set ismiscrizon 0}}
# Now for the word of the day
set wodfile "scripts/wordofday.txt"
set fd [open $wodfile r]
set lines [split [read -nonewline $fd] "\n"]
set num [rand [llength $lines]]
set randline [lindex $lines $num]
set wordofday [lindex [split $randline *] 0]
close $fd
# Copy word of day so it isn't blown away if the topic needs to be updated later
set wordofday_cur $wordofday
# Find network, send command
        if {$networkid == 1} {
        putlog "$networkid - putting topic"
        putlog "$ismisc $ismiscjdnet $misc $miscjdnet"
	    if {$ismisc == 1 && $ismiscjdnet == 1} {
		putquick "TOPIC $topicchan :My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday\002 | Be warned - there is frequent bot insanity in this channel. | $miscjdnet | $misc"
	    } elseif {$ismisc == 1 && $ismiscjdnet == 0} {
		putquick "TOPIC $topicchan :My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday\002 | Be warned - there is frequent bot insanity in this channel. | $misc"
	    } else {
		putquick "TOPIC $topicchan :My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday\002 | Be warned - there is frequent bot insanity in this channel."}
	} elseif {$networkid == 2} {
        putlog "$networkid - putting topic"
	    if {$ismisc == 1 && $ismiscgeeksirc == 1} {
		putquick "TOPIC $topicchan :My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday\002 | Be warned: *anything* can happen here! | $miscgeeksirc | $misc"
	    } elseif {$ismisc == 1 && $ismiscgeeksirc == 0} {
		putquick "TOPIC $topicchan :My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday\002 | Be warned: *anything* can happen here! | $misc"
	    } else {
		putquick "TOPIC $topicchan :My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday\002 | Be warned: *anything* can happen here!"}
        } elseif {$networkid == 4} {
        putlog "$networkid - putting topic"
        putquick "TOPIC $topicchan :General testing channel. All users opped. For +a and up, make your own channel."
        } elseif {$networkid == 5} {
        putlog "$networkid - putting topic"
	    if {$ismisc == 1 && $ismiscrizon == 1} {
		putquick "TOPIC $topicchan :My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday\002 | $miscrizon | $misc"
	    } elseif {$ismisc == 1 && $ismiscrizon == 0} {
		putquick "TOPIC $topicchan :My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday\002 | $misc"
	    } else {
		putquick "TOPIC $topicchan :My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday\002"}
        } else {putlog "error: topic change called, but no topic to change - \$networkid = $networkid"
	}
}

# Update the topic if misc files change

proc pub_topic_update {minute hour day month year} {
global serveraddress networkid topicchan
global misc_cur miscjdnet_cur miscgeeksirc_cur miscrizon_cur wordofday_cur
# Set topic channel
    if {$networkid == 1} {set topicchan "#WikiPuppies"}
    if {$networkid == 2} {set topicchan "#VASirens"}
    if {$networkid == 4} {set topicchan "#test"}
    if {$networkid == 5} {set topicchan "#Metacity"}
    if {$networkid == 6} {set topicchan "#blindsight"}
# Grab misc files
set miscfile "/home/calvin/IRC/eggdrop/scripts/misc.txt"
set fs [open $miscfile r] 
while {![eof $fs]} { 
  gets $fs line 
  set misc_cur $line
} 
close $fs
# If there's misc stuff, flag it
if {$misc_cur == ""} {set ismisc 0} else {set ismisc 1}
# Network-specific stuff
if {$networkid == 1} {
set miscjdnetfile "/home/calvin/IRC/eggdrop/scripts/misc-jdnet.txt"
set fs [open $miscjdnetfile r] 
while {![eof $fs]} { 
  gets $fs line 
  set miscjdnet_cur $line
} 
close $fs
}
if {$networkid == 2} {
set miscgeeksircfile "/home/calvin/IRC/eggdrop/scripts/misc-geeksirc.txt"
set fs [open $miscgeeksircfile r] 
while {![eof $fs]} { 
  gets $fs line 
  set miscgeeksirc_cur $line
} 
close $fs
}
if {$networkid == 5} {
set miscrizonfile "/home/calvin/IRC/eggdrop/scripts/misc-rizon.txt"
set fs [open $miscrizonfile r] 
while {![eof $fs]} { 
  gets $fs line 
  set miscrizon_cur $line
} 
close $fs
}
# If there's network-specific misc stuff, flag it
if {$networkid == 1} {if {$miscjdnet_cur == ""} {set ismiscjdnet 0} else {set ismiscjdnet 1}}
if {$networkid == 2} {if {$miscgeeksirc_cur == ""} {set ismiscgeeksirc 0} else {set ismiscgeeksirc 1}}
if {$networkid == 5} {if {$miscrizon_cur == ""} {set ismiscrizon 0} else {set ismiscrizon 1}}
# Generate new topic to compare
        if {$networkid == 1} {
	    if {$ismisc == 1 && $ismiscjdnet == 1} {
		set newtopic "My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday_cur\002 | Be warned - there is frequent bot insanity in this channel. | $miscjdnet_cur | $misc_cur"
	    } elseif {$ismisc == 1 && $ismiscjdnet == 0} {
		set newtopic "My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday_cur\002 | Be warned - there is frequent bot insanity in this channel. | $misc_cur"
	    } else {
		set $newtopic "My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday_cur\002 | Be warned - there is frequent bot insanity in this channel."}
	} elseif {$networkid == 2} {
	    if {$ismisc == 1 && $ismiscgeeksirc == 1} {
		set newtopic "My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday_cur\002 | Be warned: *anything* can happen here! | $miscgeeksirc_cur | $misc_cur"
	    } elseif {$ismisc == 1 && $ismiscgeeksirc == 0} {
		set newtopic "My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday_cur\002 | Be warned: *anything* can happen here! | $misc_cur"
	    } else {
		set newtopic "My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday_cur\002 | Be warned: *anything* can happen here!"}
        } elseif {$networkid == 5} {
	    if {$ismisc == 1 && $ismiscrizon == 1} {
		set newtopic "My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday_cur\002 | $miscrizon_cur | $misc_cur"
	    } elseif {$ismisc == 1 && $ismiscrizon == 0} {
		set newtopic "My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday_cur\002 | $misc_cur"
	    } else {
		set newtopic "My personal channel. All idlers welcome! | Today's word of the day: \002$wordofday_cur\002"}
	} else {

# Compare with current topic
set oldtopic [topic $topicchan]
if {$newtopic == $oldtopic} {
putlog "info: topic for $topicchan unchanged"
} else {
putquick "TOPIC $topicchan :$newtopic"
putlog "info: topic for $topicchan updated"
}
}

# Manually force full topic change

proc pub_topic_change_now {nick uhost hand chan args} {
pub_topic_change blah blah blah blah blah
putlog "info: topic change forced by $nick from $chan"
}

# END TOPIC MANAGEMENT CODE

# BEGIN MISC CODE

# Deprecated

# proc pub_deprecated_?? {nick uhost hand chan args} {
# putlog "Warning $nick - command ?? is deprecated"
# putserv "NOTICE $nick :\002\00304ALERT:\002\003 That command is deprecated."
# putserv "NOTICE $nick :Try \"!define <word>\"."
# }

# Deprecated

# proc pub_deprecated_timebomb {nick uhost hand chan args} {
# putlog "Warning $nick - command timebomb is deprecated"
# putserv "NOTICE $nick :\002\00304ALERT:\002\003 That command is deprecated."
# putserv "NOTICE $nick :Try \"!timebomb <user>\"."
# }

# Joke command

proc pub_downtime {nick uhost hand chan args} {
putlog "panic: Type 6 error (dsOvflowErr)"
putlog "panic: Channel: $chan Nick: $nick"
putlog "panic: Automatically restarting..."
putquick "PRIVMSG $chan :panic: Type 6 error (dsOvflowErr)"
putquick "PRIVMSG $chan :panic: Channel: $chan Nick: $nick"
putquick "PRIVMSG $chan :panic: Automatically restarting..."
restart
}

# Easter egg

proc pub_easteregg {nick chan} {
global botnick toolsetver eggdropversion
putlog "info: $nick FOUND THE EASTER EGG IN $chan! :D"
puthelp "PRIVMSG $nick :$botnick $toolsetver on Eggdrop $eggdropversion."
puthelp "PRIVMSG $nick :Special thanks to..."
puthelp "PRIVMSG $nick :Oldiesmann - inspiration for VirginiaBot, programming assistance, ideas, testing"
puthelp "PRIVMSG $nick :Jasper_Deng - founding JDNet, ideas, testing"
puthelp "PRIVMSG $nick :blindsight - running GeeksIRC, ideas, testing"
puthelp "PRIVMSG $nick :mrboojay - ideas and testing"
puthelp "PRIVMSG $nick :siren_face2000 - testing"
puthelp "PRIVMSG $nick :csssuf - inspiration for YakBot/SmokeBot"
puthelp "PRIVMSG $nick :JB555 - testing"
puthelp "PRIVMSG $nick :ACJZA - inspiration for MerlionBot"
puthelp "PRIVMSG $nick :...and everyone at GeeksIRC, JDNet, and beyond, without whom this project would not have been possible."
puthelp "PRIVMSG $nick :Thanks for using $botnick."
}

# Roulette - adapted from roulette.tcl by dopeydwerg

proc roulette_accept {nick host handle chan arg} {
    global rrstarttimer roulette_player2 roulette_justaccepted
    if {$nick == $roulette_player2} {
    if {[utimerexists roulette_started]!=""} {killutimer $rrstarttimer}
    if {[utimerexists roulette_timeout]!=""} {killutimer $rrtimeout}
    roulette_player_reply $nick $host $handle $chan "accept"
    set roulette_justaccepted 1
    }
}

proc roulette_chicken {nick host handle chan arg} {
    global roulette_player2 roulette_justchickened
    if {$nick == $roulette_player2} {
    if {[utimerexists roulette_timeout]!=""} {killutimer $rrtimeout}
    roulette_player_reply $nick $host $handle $chan "chicken"
    set roulette_justchickened 1
    }
}

# get somebody to play with you
proc roulette_challenge {nick host handle chan arg} {
    global botnick roulette_player1 roulette_player2 roulette_started roulette_timeout_timer roulette_kill_count roulette_last_warn roulette_notcurplayer
    global rrstarttimer rrchannel
    # putquick "PRIVMSG $chan :$nick $host $handle $chan $arg"
set argcheck [lindex [split $arg] 0]
set argall [lindex [split $arg] 1]
if {$argcheck == "scores" && $argall != "all"} {
    set scorenick $argall      
    roulette_show_player_score $nick $host $handle $chan $scorenick
} elseif {$argcheck == "scores" && $argall == "all"} {
    roulette_showall $nick $host $handle $chan $arg
} else {
        if {$roulette_player1 != ""} {
            putquick "NOTICE $nick :\002Oops!\002 $roulette_player1 already challenged $roulette_player2."
            putlog "roulette: $nick tried to challenge $arg in $chan, but $roulette_player1 already challenged $roulette_player2"
            
        } elseif {$arg == ""} {
            putquick "NOTICE $nick :\002Oops!\002 You didn't specify a nick to challenge."
            putquick "NOTICE $nick :Use !roulette <nick> to challenge someone."
            putlog "roulette: $nick forgot to challenge someone in $chan"
            
        }
        if {![onchan $arg $chan]} {
            if {$nick == $roulette_last_warn} {
                putquick "NOTICE $nick :OK, now you're starting to annoy me...so I have to shoot you!"
                putlog "roulette: $nick is annoying me in $chan, time to shoot them"
                kill $nick $chan
                
            }
            putquick "NOTICE $nick :Sorry, but I can't find $arg in this channel. Are you sure you have the nick right?"
            putquick "NOTICE $nick :If you do it again I'm going to shoot you!"
            putlog "roulette: $nick tried to challenge non-existent nick $arg in $chan...last warning"
            set roulette_last_warn $nick
            
        } elseif {$roulette_started == 1} {
            putquick "NOTICE $nick :\002Oops!\002 The game is already running."
            putlog "roulette: $nick tried to challenge $arg in $chan, but game is already running"
            
        } elseif {$arg == $botnick} {
            putquick "PRIVMSG $chan :Challenge accepted."
            putquick "PRIVMSG $chan :Rrrrrrrrrrrrrrrr..."
            putlog "roulette: $nick challenged bot in $chan, time to shoot them"
            kill $nick $chan
            
        } else {        
        set roulette_player1 $nick
        set roulette_player2 $arg
        set rrchannel $chan
        set roulette_timeout_timer 1
	set rrtimeout [utimer 20 [list roulette_timeout $chan $nick]]
        set rrstarttimer [utimer 50 roulette_started]
        putquick "NOTICE $roulette_player2 :$nick challenges you to play roulette with them in $chan."
        putquick "NOTICE $roulette_player1 :Challenge sent to $roulette_player2."
        putquick "NOTICE $roulette_player2 :Use !accept to play or !chicken to chicken out."
        putlog "roulette: $roulette_player1 challenged $roulette_player2 in $chan"
        bind pub - !accept roulette_accept
        bind pub - !chicken roulette_chicken
        bind pub - !reply roulette_player_reply
        }
  }
}

proc roulette_player_reply {nick host handle chan arg} {
    global botnick roulette_player1 roulette_player2 roulette_turns roulette_started roulette_curplayer roulette_timeout_timer roulette_notcurplayer
    global rrstarttimer rrchan
        if {$roulette_player1 == ""} {
            putquick "NOTICE $nick :\002Oops!\002 Nobody has challenged you."
            putquick "NOTICE $nick :To challenge someone, use !roulette <nick>."
            putlog "roulette: $nick tried to accept/chicken out of non-existent challenge in $chan"
        } elseif {$nick != $roulette_player2} {
            putquick "NOTICE $nick :\002Oops!\002 That isn't your call."
            putquick "NOTICE $nick :$roulette_player2 was challenged by $roulette_player1."
            putlog "roulette: $nick tried to accept/chicken $roulette_player2's challenge for them in $chan"
        } elseif {$arg == ""} {
            putquick "NOTICE $nick :Use !accept to play or !chicken to decline."
            putlog "roulette: $nick forgot to accept or chicken out in $chan"
            
        } elseif {$roulette_started == 1} {
            putquick "NOTICE $nick :\002Oops!\002 The game is already running."
            putlog "roulette: $nick tried to accept/chicken out in $chan, but game is already running"      
        } elseif {$arg == "chicken"} {
            putquick "PRIVMSG $chan :$nick chickened out. $roulette_player2 is a little pussycat...\002hahahahaha!!!!!\002"
            putlog "roulette: $roulette_player2 chickened out from $roulette_player1's challenge in $chan"
            set roulette_player1 ""
            set roulette_player2 ""
            set roulette_timeout_timer 0
        } elseif {$arg == "accept"} {
            set roulette_curplayer $roulette_player1
            set roulette_notcurplayer $roulette_player2
            set rrchan $chan
            putquick "notice $roulette_player1 :$nick accepted your challenge."
            putquick "notice $roulette_player1 :$roulette_curplayer goes first. Use !shoot to shoot the gun, or !spin to spin it first."
            putquick "notice $roulette_player2 :$roulette_curplayer goes first. Use !shoot to shoot the gun, or !spin to spin it first."
            putlog "roulette: $roulette_player2 accepted $roulette_player1's challenge in $chan"
            roulette_incr_stats $roulette_curplayer "" "" "" "" ""
            roulette_incr_stats $roulette_notcurplayer "" "" "" "" ""
            set roulette_started 1
            set roulette_timeout_timer 0
            bind pub - !spin roulette_spin
            bind pub - !shoot roulette_shoot
            unbind pub - !accept roulette_accept
            unbind pub - !chicken roulette_chicken
            unbind pub - !reply roulette_player_reply
	}
}

proc roulette_spin {nick host handle chan arg} {
    global botnick roulette_player1 roulette_player2 roulette_turns roulette_started roulette_bullet roulette_curplayer
    if {$nick != $roulette_curplayer} {
        putquick "NOTICE $nick :\002Hey, no cheating!\002 It's not your turn."
        putlog "roulette: $nick tried to spin gun in $chan, but current player is $roulette_curplayer"
    } elseif {$roulette_started == 0} {
        putquick "NOTICE $nick :\002Oops!\002 The game is not running!"
        putquick "NOTICE $nick :Use !roulette <nick> to play."
        putlog "roulette: $nick tried to spin non-existent gun in $chan"
        
    } else {
    set roulette_bullet [rand 5]
    putquick "PRIVMSG $chan :$roulette_curplayer spins the gun...rrrrrrrrrrrrrrrr..."
    roulette_incr_stats $roulette_curplayer "" "" "" "+ 1" ""
    roulette_shoot $nick $host $handle $chan $roulette_started
    }
}

proc roulette_shoot {nick host handle chan arg} {
    global botnick roulette_player1 roulette_player2 roulette_turns roulette_curplayer roulette_started roulette_bullet roulette_lucky_msg roulette_pull roulette_notcurplayer playerstat
    if {$roulette_started == 0} {
        putquick "NOTICE $nick :\002Oops!\002 The game is not running!"
        putquick "NOTICE $nick :Use !roulette <nick> to play."
        putlog "roulette: $nick tried to shoot non-existent gun in $chan"
    } elseif {$nick != $roulette_curplayer} {
        putquick "NOTICE $nick :\002Hey, no cheating!\002 It's not your turn."
        putlog "roulette: $nick tried to shoot gun in $chan, but current player is $roulette_curplayer"
        
    } else {
    set checknr1 [rand [llength $roulette_pull]]
    set temp_roulette_pull $roulette_pull
    set temp_roulette_pull [lindex $temp_roulette_pull $checknr1]
    putquick "PRIVMSG $chan :$nick $temp_roulette_pull"
    roulette_incr_stats $roulette_curplayer "" "" "+ 1" "" ""
    #check if roulette_bullet is on position 0 if it is then your dead
    if {$roulette_bullet != 0} {
        #if not then set roulette_bullet - 1 like in a real fun
        set roulette_bullet [expr $roulette_bullet - 1]
        #increase roulette_turns taken for stats
        set roulette_turns [expr $roulette_turns + 1]
        #insert random msg
            set checknr [rand [llength $roulette_lucky_msg]]
            set temp_lol $roulette_lucky_msg
            set temp_lol [lindex $temp_lol $checknr]
            putquick "PRIVMSG $chan :$temp_lol"
            putlog "roulette: click in $chan ($roulette_player1 vs $roulette_player2, $roulette_curplayer lucky)"
         #switch players so nobody can before there turn
        if {$roulette_curplayer == $roulette_player1} {
            set roulette_curplayer $roulette_player2
            set roulette_notcurplayer $roulette_player1
            } else {
                set roulette_curplayer $roulette_player1
                set roulette_notcurplayer $roulette_player2
                }
                putquick "notice $roulette_curplayer :Your turn - use !shoot or !spin."
                putquick "notice $roulette_notcurplayer :$roulette_curplayer's turn..." 
        
    #if roulette_bullet was on position 0 kick loser from chan and reset all used variables
    } else {
        roulette_incr_stats $roulette_curplayer "" "+ 1" "" "" "+ 1"
        roulette_incr_stats $roulette_notcurplayer "+ 1" "" "" "" "+ 1"
        putlog "roulette: $roulette_curplayer died in $chan; $roulette_notcurplayer is last person standing"
        putquick "KICK $chan $roulette_curplayer :\002\00304BANG!\002\00304 \002You're dead!\002"
        putquick "PRIVMSG $chan :$roulette_notcurplayer is the last person standing!"
        unbind pub - !spin roulette_spin
        unbind pub - !shoot roulette_shoot
        set roulette_player1 ""
        set roulette_player2 ""
        set roulette_curplayer ""
        set roulette_bullet [rand 5]
        set roulette_started 0
        
    }
}
}

proc kill {nick chan} {
    global botnick
    set roulette_bullet [rand 5]
    for {set x 1} {$x < $roulette_bullet} {incr x} {
        putquick "PRIVMSG $chan :Click..."
        putlog "roulette: click in $chan ($botnick vs $nick)"
    }
    putquick "KICK $chan $nick :\002\00304BANG!\002\003 \002You're dead!\002"
    putquick "PRIVMSG $chan :Yep, I'm still the king!"
    putlog "roulette: $nick died in $chan; $botnick is last person standing"
    
}

proc roulette_timeout {chan nick} {
    global botnick roulette_player1 roulette_player2 roulette_turns roulette_curplayer roulette_started roulette_bullet roulette_lucky_msg roulette_pull roulette_timeout_timer roulette_justchickened roulette_justaccepted
    if {$roulette_justchickened == 0 && $roulette_justaccepted == 0} {
        putquick "NOTICE $nick :$roulette_player2 is probably too chicken to play."
        putlog "roulette: $roulette_player2 is too chicken to play $nick in $chan"
        set roulette_player1 ""
        set roulette_player2 ""
        set roulette_curplayer ""
        set roulette_bullet [rand 5]
        set roulette_timeout_timer 0
        set roulette_started 0
    } else {
set roulette_justchickened 0
set roulette_justaccepted 0
}
}

proc roulette_get_scores {} {
 global botnick roulette_scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
 if {[file exists $roulette_scorefile]&&[file size $roulette_scorefile]>2} {
  set _sfile [open $roulette_scorefile r]
  set rrscores [lsort -dict -decreasing [split [gets $_sfile] " "]]
  close $_sfile
  set rrscorestotal [llength $rrscores]
 } else {
  set rrscores ""
  set rrscorestotal 0
 }
    if {[info exists rrscoresbyname]} {unset rrscoresbyname}
        if {[info exists rrranksbyname]} {unset rrranksbyname}
            if {[info exists rrranksbynum]} {unset rrranksbynum}       
 set i 0
 while {$i<[llength $rrscores]} {
  set _item [lindex $rrscores $i]
            set _nick [lindex [split $_item ,] 5]
            set _win [lindex [split $_item ,] 0]
            set _lost [lindex [split $_item ,] 1]
            set _shots [lindex [split $_item ,] 2]
            set _spins [lindex [split $_item ,] 3]
            set _played [lindex [split $_item ,] 4]
  set rrscoresbyname($_nick) $_win
  set rrranksbyname($_nick) [expr $i+1],$_win
  set rrranksbynum([expr $i+1]) $_nick,$_win
  incr i
 }
 return
}
proc roulette_incr_stats {who win loss shots spins played} {
    global botnick roulette_scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
    set who [lindex [split $who "|"] 0]
    set who [lindex [split $who "_"] 0]
    roulette_get_scores
    if {$rrscorestotal>0} {
        set i 0
        if {[lsearch $rrscores "*,*,*,*,*,$who"]==-1} {
            append _newscores "0,0,0,0,0,$who "
        }
        while {$i<[expr [llength $rrscores] - 1]} {
            set _item [lindex $rrscores $i]
            set _nick [lindex [split $_item ,] 5]
            set _win [lindex [split $_item ,] 0]
            set _lost [lindex [split $_item ,] 1]
            set _shots [lindex [split $_item ,] 2]
            set _spins [lindex [split $_item ,] 3]
            set _played [lindex [split $_item ,] 4]
            if {[strlwr $who]==[strlwr $_nick]} {
                append _newscores "[expr $_win $win],[expr $_lost $loss],[expr $_shots $shots],[expr $_spins $spins],[expr $_played $played],$_nick "
            } else {
                append _newscores "$_win,$_lost,$_shots,$_spins,$_played,$_nick "
            }
            incr i
        }
    } else {
        append _newscores "0,0,0,0,0,$who "
    }
    set _sfile [open $roulette_scorefile w]
    puts $_sfile "$_newscores"  
    close $_sfile
    
}

proc roulette_showscore {text} {
    global rrscoresbyname rrscores playerstat
    roulette_get_scores
    set idx [lsearch -glob $rrscores "*,*,*,*,*,$text"]
    putlog "[lindex $rrscores $idx]"
    set _item [lindex $rrscores $idx]
    set _nick [lindex [split $_item ,] 5]
    set _win [lindex [split $_item ,] 0]
    set _lost [lindex [split $_item ,] 1]
    set _shots [lindex [split $_item ,] 2]
    set _played [lindex [split $_item ,] 4]
    if {$_nick == "" && $_played == ""} {
    set playerstat "That nick has never played roulette."
    } else {
    set playerstat "$_nick has played $_played games of roulette. They won $_win, lost $_lost, and took $_shots shots in the process."
    }
    return 
}

proc roulette_showall {nick uhost handle chan arg} {
    global botnick roulette_scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
    roulette_get_scores
    putlog "roulette: $nick requested all scores"
    set totallength 16
    if {$rrscorestotal>0} {
        putquick "PRIVMSG $nick :\00304=========== VPSL Roulette Scores (all networks) ============"
        putquick "PRIVMSG $nick :\00304**| Nick            | Total |  Won  | Lost | Shots \00304|**"
        putquick "PRIVMSG $nick :\00304**|-----------------|-------|-------|------|-------|**"
        set i 0
        while {$i<[expr [llength $rrscores] - 1]} {
            set checked 0
            set _item [lindex $rrscores $i]
            set _nick [lindex [split $_item ,] 5]
            set _win [lindex [split $_item ,] 0]
            if {$_win < 10} {
                set _win "   $_win   "
                } elseif {$_win < 100} {
                    set _win "   $_win  "
                    }
            set _lost [lindex [split $_item ,] 1]
            if {$_lost < 10} {
                set _lost "   $_lost  "
                } elseif {$_lost < 100} {
                    set _lost "  $_lost  "
                    }
            set _shots [lindex [split $_item ,] 2]
            if {$_shots < 10} {
                set _shots "   $_shots   "
                } elseif {$_shots < 100} {
                    set _shots "   $_shots  "
                    }
            set _played [lindex [split $_item ,] 4]
            if {$_played < 10} {
                set _played "   $_played   "
                } elseif {$_played < 100} {
                    set _played "   $_played  "
                    }
            set checknick [split $_nick ""]
            set who [lindex [split $nick "|"] 0]
            set who [lindex [split $who "_"] 0]
            if {[string tolower $who] == [string tolower $_nick]} {set checked 1}
            set long [llength $checknick]
            set spaces ""
            for {set i2 $long} {$i2 < $totallength} {incr i2} {
                append spaces " "
            }
            if {$checked == 1} {
                putquick "PRIVMSG $nick :\00304**| \00312$_nick$spaces\00304|\00312$_played\00304|\00312$_win\00304|\00312$_lost\00304|\00312$_shots\00304|**"
            } else {
                putquick "PRIVMSG $nick :\00304**| \00310$_nick$spaces\00304|\00310$_played\00304|\00310$_win\00304|\00310$_lost\00304|\00310$_shots\00304|**"
            }
            incr i
        }
        putquick "PRIVMSG $nick :\00304============================================================"
    }
    
}


proc roulette_show_player_score {nick host handle chan arg} {
    global rrscoresbyname rrscores playerstat
     if {$arg == ""} { set arg $nick } else { set arg [lindex [split $arg " "] 0] }
     roulette_showscore $arg
     putlog "roulette: $nick requested scores for $arg"
     putquick "PRIVMSG $chan :$nick: $playerstat"
     }
     return 1     
}

proc roulette_started {} {
    putlog "roulette: starttimer ended"
}

proc tggamemsg {what} {global rrchannel;putquick "PRIVMSG $rrchannel :[tgbold]$what"}

# END MISC CODE

# EOF
