# Roulette - adapted from roulette.tcl by dopeydwerg

###Custom made Russian Roulette Script
#this is the first script I written myself so ther's probably couple of things I could have done different
#and I'm open for suggestions. If you got any ideas for me please contact me at dopeydwerg@hotmail.com


#list lucky comments
set pull {
    "quickly pulls the trigger..."
    "shakes as they slowly raise the gun to pull the trigger..."
    "calmly smiles as they pull the trigger..."
    "puts the gun in their mouth..."
    "places the gun between their eyes and starts to pray..."
    "slowly raises the gun and puts it against their temple..."
}

set lucky_msg {
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

#set vars
set player1 ""
set player2 "" 
set curplayer ""
set notcurplayer ""
set timeout_timer 0
set started 0
set turns 0
set bullit [rand 5]
#file you want scores to be written
set scorefile "roulette.txt"
set kill_count 0
set last_warn "" 

#binds
bind pub - !spin spin:gun
bind pub - !shoot shoot:gun
bind pub - !roulette challenge:player
bind pub - !reply reply:player
bind pub - !accept accept
bind pub - !chicken chicken
bind pub - !roulette show_player_score
bind pub - !roulette showall


proc accept {nick host handle chan arg} {
    global rrstarttimer
            if {[utimerexists started]!=""} {killutimer $rrstarttimer}
    reply:player $nick $host $handle $chan "accept" 
}

proc chicken {nick host handle chan arg} {
    reply:player $nick $host $handle $chan "chicken" 
}

#proc to get somebody ro play with you
proc challenge:player {nick host handle chan arg} {
    global botnick player1 player2 started timeout_timer kill_count last_warn notcurplayer
    global rrstarttimer rrchannel
        if {$player1 != ""} {
            puthelp "NOTICE $nick :\002Oops!\002 $player1 already challenged $player2."
            return 0
        }
        if {![onchan $arg $chan]} {
            if {$nick == $last_warn} {
                puthelp "NOTICE $nick :OK, now you're starting to annoy me...so I have to shoot you!"
                kill $nick $chan
                return 0
            }
            puthelp "NOTICE $nick :Sorry, but I can't find $arg in this channel. Are you sure you have the nick right?"
            puthelp "NOTICE $nick :If you do it again I'm going to shoot you."
            set last_warn $nick
            return 0
        }        
        if {$arg == ""} {
            puthelp "NOTICE $nick :\002Oops!\002 You didn't specify a nick to challenge."
            puthelp "NOTICE $nick :Use !roulette <nick to challenge someone."
            return 0
        }
        if {$started == 1} {
            puthelp "NOTICE $nick :\002Oops!\002 The game is already running."
            return 0
        }
        if {$arg == $botnick} {
            puthelp "PRIVMSG $chan :Challenge accepted."
            puthelp "PRIVMSG $chan :Rrrrrrrrrrrrrrrr..."
            kill $nick $chan
            return 0
        }            
        set player1 $nick
        set player2 $arg
        set rrchannel $chan
        set timeout_timer 1
        utimer 20 [list timeout $chan ]
        set rrstarttimer [utimer 50 started]
        putquick "NOTICE $player2 :$nick challenges you to play roulette with them in $chan."
        putquick "NOTICE $player1 :Challenge sent to $player2."
        putquick "NOTICE $player2 :Use !accept to play or !chicken to chicken out."
        return 0
}

proc reply:player {nick host handle chan arg} {
    global botnick player1 player2 turns started curplayer timeout_timer notcurplayer
    global rrstarttimer rrchan
        if {$player1 == ""} {
            puthelp "NOTICE $nick :\002Oops!\002 Nobody has challenged you."
            puthelp "NOTICE $nick :To challenge someone, use !roulette <nick>."
            return 0
        }
        if {$nick != $player2} {
            puthelp "NOTICE $nick :\002Oops!\002 That isn't your call."
            puthelp "NOTICE $nick :$player2 was challenged by $player1."
            return 0
        }
        if {$arg == ""} {
            puthelp "NOTICE $nick :Use !accept to play or !chicken to decline."
            return 0
        }
        if {$started == 1} {
            puthelp "NOTICE $nick :\002Oops!\002 The game is already running."
            return 0
        }         
        if {$arg == "chicken"} {
            puthelp "PRIVMSG $chan :$nick chickened out. $player2 is a little pussycat...\002hahahahaha!!!!!\002"
            set player1 ""
            set player2 "" 
            return 0
        }
        if {$arg == "accept"} {
            set curplayer $player1
            set notcurplayer $player2
            set rrchan $chan
            putserv "notice $player1 :$nick accepted your challenge."
            putserv "notice $player1 :$curplayer goes first. Use !shoot to shoot the gun, or !spin to spin it first."
            putserv "notice $player2 :$curplayer goes first. Use !shoot to shoot the gun, or !spin to spin it first."
            incr_stats $curplayer "" "" "" "" ""
            incr_stats $notcurplayer "" "" "" "" ""
            set started 1
            set timeout_timer 0
            return 0
        }
}

proc spin:gun {nick host handle chan arg} {
    global botnick player1 player2 turns started bullit curplayer
    if {$nick != $curplayer} {
        puthelp "NOTICE $nick :\002Hey, no cheating!\002 It's not your turn."
        return 0
    }
    if {$started == 0} {
        puthelp "NOTICE $nick :\002Oops!\002 The game is not running!"
        puthelp "NOTICE $nick :Use !roulette <nick> to play."
        return 0
    }
    set bullit [rand 5]
    puthelp "PRIVMSG $chan :$curplayer spins the gun...rrrrrrrrrrrrrrrr..."
    incr_stats $curplayer "" "" "" "+ 1" ""
    shoot:gun $nick $host $handle $chan $started
    return 0
}

proc shoot:gun {nick host handle chan arg} {
    global botnick player1 player2 turns curplayer started bullit lucky_msg pull notcurplayer playerstat
    if {$started == 0} {
        puthelp "NOTICE $nick :\002Oops!\002 The game is not running!"
        puthelp "NOTICE $nick :Use !roulette <nick> to play."
        return 0
    }
    if {$nick != $curplayer} {
        puthelp "NOTICE $nick :\002Hey, no cheating!\002 It's not your turn."
        return 0
    }
    set checknr1 [rand [llength $pull]]
    set temp_pull $pull
    set temp_pull [lindex $temp_pull $checknr1]
    puthelp "PRIVMSG $chan :$nick $temp_pull"
    incr_stats $curplayer "" "" "+ 1" "" ""
    #check if bullit is on position 0 if it is then your dead
    if {$bullit != 0} {
        #if not then set bullit - 1 like in a real fun
        set bullit [expr $bullit - 1]
        #increase turns taken for stats
        set turns [expr $turns + 1]
        #insert random msg
            set checknr [rand [llength $lucky_msg]]
            set temp_lol $lucky_msg
            set temp_lol [lindex $temp_lol $checknr]
            puthelp "PRIVMSG $chan :$temp_lol"
         #switch playsers so nobody can before there turn
        if {$curplayer == $player1} {
            set curplayer $player2
            set notcurplayer $player1
            } else {
                set curplayer $player1
                set notcurplayer $player2
                }
                puthelp "notice $curplayer :Your turn - use !shoot or !spin."
                puthelp "notice $notcurplayer :$curplayer's turn..." 
        return 0
    #if bullit was on position 0 kick loser from chan and reset all used variables
    } else {
        incr_stats $curplayer "" "+ 1" "" "" "+ 1"
        incr_stats $notcurplayer "+ 1" "" "" "" "+ 1"
        show_score $notcurplayer
        putlog "$playerstat"
        puthelp "KICK $chan $curplayer :\002\00304BANG!\002\00304 \002You're dead!\002"
        puthelp "PRIVMSG $chan :$notcurplayer is the last person standing!"
        set player1 ""
        set player2 ""
        set curplayer ""
        set bullit [rand 5]
        set started 0
        return 0
    }
}

proc kill {nick chan} {
    global botnick
    set bullit [rand 5]
    for {set x 1} {$x < $bullit} {incr x} {
        puthelp "PRIVMSG $chan :Click..."
    }
    puthelp "KICK $chan $nick :\002\00304BANG!\002\003 \002You're dead!\002"
    return 0
}

proc timeout { chan } {
    global botnick player1 player2 turns curplayer started bullit lucky_msg pull timeout_timer
    if {$timeout_timer == 1} {
        puthelp "NOTICE $nick :$player2 is probably too chicken to play."
        set player1 ""
        set player2 ""
        set curplayer ""
        set bullit [rand 5]
        set timeout_timer 0
        set started 0
        return 0
    }
}

proc get_scores {} {
 global botnick scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
 if {[file exists $scorefile]&&[file size $scorefile]>2} {
  set _sfile [open $scorefile r]
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
proc incr_stats {who win loss shots spins played} {
    global botnick scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
    set who [lindex [split $who "|"] 0]
    set who [lindex [split $who "_"] 0]
    get_scores
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
    set _sfile [open $scorefile w]
    puts $_sfile "$_newscores"  
    close $_sfile
    return 0
}

proc show_score {text} {
    global rrscoresbyname rrscores playerstat
    get_scores
    set idx [lsearch -glob $rrscores "*,*,*,*,*,$text"]
    putlog "[lindex $rrscores $idx]"
    set _item [lindex $rrscores $idx]
    set _nick [lindex [split $_item ,] 5]
    set _win [lindex [split $_item ,] 0]
    set _lost [lindex [split $_item ,] 1]
    set _shots [lindex [split $_item ,] 2]
    set _played [lindex [split $_item ,] 4]
    set playerstat "$_nick has played $_played games of roulette. They won $_win, lost $_lost, and took $_shots shots in the process."
    return 
}

proc showall {nick uhost handle chan arg} {
    global botnick scorefile rrscoresbyname rrscorestotal rrscores rrranksbyname rrranksbynum
    get_scores
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
    return 0
}


proc show_player_score {nick host handle chan arg} {
    global rrscoresbyname rrscores playerstat
     if {$arg == ""} { set arg $nick } else { set arg [lindex [split $arg " "] 0] }
     show_score $arg
     puthelp "PRIVMSG $chan :$playerstat"
     return 1     
}

proc started {} {
    putlog "roulette: starttimer ended"
}


proc tggamemsg {what} {global rrchannel;putquick "PRIVMSG $rrchannel :[tgbold]$what"}
