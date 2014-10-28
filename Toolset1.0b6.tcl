######################## Aide Commands v1.0 ###########################
#
#  
# Author : MeS - MeS@EdenTech.Biz - http://www.EdenTech.Biz
#
#
# Support Channels : #EdenTech @Undernet.org
#                    #EdenTech @DalNet
#                    #EdenTech @EdenTech.Biz
#                    #EdenTech @Hells.ca
#
#
# *Description : Ce script vous permet de configurer vous meme, celon 
# vos besoin les pub commands "!exemple" que vous souhaitez. Ainsi que
# d'y afficher le resultat que vous desirez. Il affiche aussi une 
# notice à tous ceux qui rejoingnent le channel, les informants des
# commandes disponibles
#
#
# Exemple : !Exemple
# Resultat: -nick notice- Ce Si Est Le Texte Qui Va Avec le !Exemple.
#
#
# Se script est utilisez dans les channels d'aide pour des commandes 
# tel que !helper !aide !admin ...
#
#
# -Il peut né-an-moin etre adapter à divers fonctions. Vous pouvez y 
# programmez une !list qui informera les gens des commandes disponibles 
# -Il peut etre utiliser pour les channels ISP. pour un !menu ou       
# !Services. 
#
#
# *En Bref Ce Script Serv a tout. Besoin de crées des pub aide         
#  commandes vous etes à la bonne adresse.
#
#
#######################################################################
#               La Configuration du script commence ici               #
#######################################################################

# Vous n'avez aucun besoin de changer ceci. (Sauf pour frimer)
set Aide-Cmds(ver) "v1.0mod"

# la notice on join ou changreet que recevrons les user qui rejoignent
# votre channel. Ainsi que votre channel doivent etre preciser ici.

bind join - * join_tous
proc join_tous {nick host hand chan} {
  if {$chan == "#french"} {
putlog "$nick joined $chan! Yay!"
 }
}

# Ici vous devez apliquer les pub commandes désirées.
# bind pub - !Exemple pub_Exemple --> remplace ici exemple par le nom
# de la commande souhaiter et n'oublier pas de changer pub_"Exemple"
# Il doivent avoir le meme nom.

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
bind pub - #tf2.mix.nahl pub_not-join-badcmd
bind pub - #tf2.mix.euhl pub_not-join-badcmd
bind pub - #tf2.pug.nahl pub_not-join-badcmd
bind pub - #tf2.pug.na pub_not-join-badcmd
bind pub - #tf2scrim pub_not-join-badcmd
bind pub - #tf2.mix.eu pub_not-join-badcmd
bind pub - #tf2scrim.hl pub_not-join-badcmd
# Deprecation redirection; now in themselves deprecated
# bind pub - ?? pub_deprecated_??
# bind pub - timebomb pub_deprecated_timebomb
# Joke, should normally be commented out
bind pub - !downtime pub_downtime
# Anti-slap
bind ctcp - ACTION antislap:ctcp:action

# Il vous est possible de travailler en arborescence si vous le        
# souhaiter. Suffit de refléchir. taper !menu vous aurais !sousmenu1, 
# !sousmenu2, !sousmenu3 ... .Puis tapez !sousmenu2 vous accederais au 
# sousmenu3. Et avec sa vous pouvez crée un menu complé.
# Plus vous avez besoin d'aide commande plus vous adder de pour crée
# de nouvelle commande !.... .
# bind pub - !..... pub_.....

# bind pub - !Aide pub_Aide
# bind pub - !helpers pub_Helpers
# bind pub - !list pub_list
# bind pub - !Info pub_Info
# bind pub - !Menu pub_Menu
# bind pub - !SousMenu pub_SousMenu
# bind pub - !Services pub_Services
# bind pub - !Service1 pub_Service1

# ICI commance la configuration des textes resultats des diférentes 
# commandes !.....

#######################################################################                          #                         Procédure !Exemple                          # 
#######################################################################

proc pub_helpme {nick host hand chan input args} {
global serveraddress botnick
# Should we show GeeksIRC-specific commands?
    if {$serveraddress == "irc.geeksirc.net:6667"} {
set isgeeksirc 1
    } else { set isgeeksirc 0 }
# Should we show VirginiaBot-specific commands?
    if {$botnick == "VirginiaBot"} {
set isVABot 1
    } else { set isVABot 0 }
# Should we show JDNet-specific commands?
    if {$serveraddress == "irc.jasperswebsite.com:6667"} {
set isjdnet 1
    } else { set isjdnet 0 }
    if {$input == "helpme"} {
# helpme
putserv "NOTICE $nick :The \002!helpme\002 command returns a list of all commands the bot recognizes. It can also return help on a specific command if you give it one."
putserv "NOTICE $nick :Example: \"!helpme\""
putserv "NOTICE $nick :Example: \"!helpme schedule\""
# schedule
} elseif {$input == "schedule" && $chan == "french" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :The \002!schedule\002 command returns the current class schedule."
putserv "NOTICE $nick :Example: \"!schedule\""
# w
    } elseif {$input == "w"} {
putserv "NOTICE $nick :The \002!w\002 command returns the current weather conditions and forecast for a location."
putserv "NOTICE $nick :Example: \"!w 90210\""
putserv "NOTICE $nick :Example: \"!w Easton, PA\""
putserv "NOTICE $nick :Example: \"!w Paris, FR\""
putserv "NOTICE $nick :Example: \"!w KPHF\""
# assignments
    } elseif {$input == "assignments" && $chan == "#french" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :The \002!assignments\002 command returns any assignments that are due this week."
putserv "NOTICE $nick :Example: \"!assignments\""
# 8ball
    } elseif {$input == "8ball"} {
putserv "NOTICE $nick :The \002!8ball\002 command returns an answer from the Official Calvin-Approved Magic 8-Ball(TM)."
putserv "NOTICE $nick :Example: \"!8ball Will I master conjugating aller?\""
# uno
    } elseif {$input == "uno" && $chan == "#VASirens" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :The \002!uno\002 command begins a game of one of several variants of Uno. Bot play is not supported at this time."
putserv "NOTICE $nick :Game commands are beyond the scope of this help system. Use !unocmds for a listing."
putserv "NOTICE $nick :Example: \"!uno\""
# version
    } elseif {$input == "version"} {
putserv "NOTICE $nick :The \002!version\002 command returns the bot's version and other technical details."
putserv "NOTICE $nick :Example: \"!version\""
# botnews
    } elseif {$input == "botnews" && $isgeeksirc == 1} {
putserv "NOTICE $nick :The \002!botnews\002 command returns recent news items regarding the bot - essentially, a changelog."
putserv "NOTICE $nick :Example: \"!botnews\""
# define
    } elseif {$input == "define" && $isgeeksirc == 1} {
putserv "NOTICE $nick :The \002!define\002 command returns a definition for a term. \002This command is not a dictionary in the normal sense.\002 Rather, it is meant for interest-specific terminology that would normally not be found in a dictionary."
putserv "NOTICE $nick :Example: \"!define WPS-3016\""
# ping
    } elseif {$input == "ping"} {
putserv "NOTICE $nick :The \002!ping\002 command pings a user, then returns how many seconds it took for the reply to arrive."
putserv "NOTICE $nick :Example: \"!ping me\""
putserv "NOTICE $nick :Example: \"!ping YakBot\""
# uptime
    } elseif {$input == "uptime"} {
putserv "NOTICE $nick :The \002!uptime\002 command returns the bot\'s uptime - how long it has been running. Depending on the channel, it may also trigger other user\'s uptime scripts."
putserv "NOTICE $nick :Example: \"!uptime\""
# techadvice
    } elseif {$input == "techadvice"} {
putserv "NOTICE $nick :The \002!techadvice\002 command returns a random snippet of helpful tech advice."
putserv "NOTICE $nick :Example: \"!techadvice\""
# search
    } elseif {$input == "wikipedia" && $isgeeksirc == 1 || $input == "wikipedia" && $isjdnet == 1} {
putserv "NOTICE $nick :The \002!wikipedia\002 command returns the first paragraph of an English Wikipedia article. Only mainspace is supported at this time."
putserv "NOTICE $nick :Example: \"!wikipedia WSBT-TV\""
putserv "NOTICE $nick :Example: \"!wikipedia Egg drop soup\""
# lotto
    } elseif {$input == "lotto" && $isgeeksirc == 1 || $input == "lotto" && $isjdnet == 1} {
putserv "NOTICE $nick :The \002!lotto\002 command begins a game of Lotto 6-49. For a game command listing, use !helpme lotto cmds."
putserv "NOTICE $nick :Example: \"!lotto\""
# lotto cmds
    } elseif {$input == "lotto cmds" && $isgeeksirc == 1 || $input == "lotto cmds" && $isjdnet == 1} {
putserv "NOTICE $nick :The \002!lotto\002 command begins a game of Lotto 6-49. Here is a game command listing."
putserv "NOTICE $nick :!lotto             - starts a public game (anyone can join)"
putserv "NOTICE $nick :!enter             - enter a public game"
putserv "NOTICE $nick :!lotto nick1 nick2 - starts a private game between the specified nicks; the bot can be included"
putserv "NOTICE $nick :!number            - pick your 6 numbers"
putserv "NOTICE $nick :!lotto version     - displays script version"
# dice
    } elseif {$input == "dice" && $isjdnet == 1} {
putserv "NOTICE $nick :The \002!dice\002 command begins a game of Dice. For a game command listing, use !helpme dice cmds."
putserv "NOTICE $nick :Example: \"!dice\""
# dice cmds
    } elseif {$input == "dice cmds" && $isjdnet == 1} {
putserv "NOTICE $nick :The \002!dice\002 command begins a game of Dice. Here is a game command listing."
putserv "NOTICE $nick :!dice nick   - starts a game between you and the specified nick"
putserv "NOTICE $nick :!dice bot    - starts a game between you and the bot"
putserv "NOTICE $nick :!roll        - rolls the dice"
putserv "NOTICE $nick :!diceversion - displays script version"
# unovar
    } elseif {$input == "unovar" && $chan == "#VASirens" && $isgeeksirc == 1 && $isVABot == 1} {
putserv "NOTICE $nick :The \002!unovar\002 command returns the currently-selected Uno variant, and allows you to select which one to play. Here is a listing of the variants currently available."
putserv "NOTICE $nick :Double Uno (x2)        - doubled draw values for wild cards, among other differences"
putserv "NOTICE $nick :Uno Attack (attack)    - uses a mechanical card launcher in lieu of drawing (except for wild draw two cards)"
putserv "NOTICE $nick :Example: \"!unovar\""
putserv "NOTICE $nick :Example: \"!unovar x2\""
# no help for you
    } elseif {[llength $input] != 0} {
putserv "NOTICE $nick :Sorry, but there isn't any help available on that command."
# we only want people bugging me about the bot in #french
	if {$chan == "#french" && $isgeeksirc == 1 && $isVABot == 1} {
	    putserv "NOTICE $nick :Try asking Calvin."
	}
# command listing
    } elseif {$chan != "#IdleRPG"} {
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
putserv "NOTICE $nick :!x2uno\002*\002       - begins a game of Double Uno"
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
putserv "NOTICE $nick :!techadvice\002*\002  - returns helpful tech advice"
# GeeksIRC/JDNet-specific command
    if {$isgeeksirc == 1 || $isjdnet == 1} {
putserv "NOTICE $nick :!wikipedia\002*\002   - returns an article from the English Wikipedia"
}
    if {$isgeeksirc == 1 || $isjdnet == 1} {
putserv "NOTICE $nick :!lotto\002*\002       - begins a game of Lotto 6-49"
}
    if {$isjdnet == 1} {
putserv "NOTICE $nick :!dice\002*\002        - begins a game of Dice"
}
putserv "NOTICE $nick :!helpme       - prints out this help listing"
putserv "NOTICE $nick :!version      - prints out the bot's version, among other things"
putserv "NOTICE $nick :For more help on a specific command, type \"!helpme <command>\". (Example: \"!helpme helpme\")"
putserv "NOTICE $nick :Have fun!"
  }
}

# Aussi si vous changer l'intitule !Exemple de la commande ainsi que 
# le pub_Exemple. Vous dever le changer dans ces ligne de procedure
# au dessu : "proc pub_Exemple"
# pour adder des ligne de notice adder une ligne de script
# putserv "NOTICE $nick :la notice souhaité"
# Vous pouvez adder autant de notice que vous souhaiter, mais il est 
# deconseiller de dépasser la mesure. Cela peut causer le flood de  
# votre Egg.

#######################################################################                          #                         Procédure !Aide                             # 
#######################################################################
proc pub_Aide {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Les Commandes d'aide sont :"
putserv "NOTICE $nick :!Aide-Commandes"
putserv "NOTICE $nick :!Aide-EggDrop"
putserv "NOTICE $nick :!Aide-PsyBNC"
putserv "NOTICE $nick :!Aide-Linux"
putserv "NOTICE $nick :!Aide-....."
putserv "NOTICE $nick :!Aide-....."
  }
}


#######################################################################                          #                         Procédure !Helpers                          # 
#######################################################################
proc pub_Helpers {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Nos Helpers Officiel sont :"
putserv "NOTICE $nick :MeS"
putserv "NOTICE $nick :Statique"
putserv "NOTICE $nick :Xeres"
putserv "NOTICE $nick :VorBis"
putserv "NOTICE $nick :`DarK`"
putserv "NOTICE $nick :`}F{F}F{`"
putserv "NOTICE $nick :Nick-du-helper"
  }
}


#######################################################################                          #                         Procédure !list                             # 
#######################################################################
proc pub_list {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Nos Publics commands sont : !seen, !Info, !dns host; !ping nick, !aide,..."
  }
}

#######################################################################                          #                         Procédure !Info                             # 
#######################################################################
proc pub_Info {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Channel D'Aide en tout genre"
putserv "NOTICE $nick :Notre Site Web : http://www......net"
putserv "NOTICE $nick :Nos Statistique: http://www......net"
  }
}

#######################################################################                          #                         Procédure !Menu                             # 
#######################################################################
proc pub_Menu {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Les composant du menu d'aide sont :"
putserv "NOTICE $nick :!SousMenu"
putserv "NOTICE $nick :!SousMenu1"
putserv "NOTICE $nick :!SousMenu2"
putserv "NOTICE $nick :!SousMenu3"
putserv "NOTICE $nick :!SousMenu4"
  }
}

#######################################################################                          #                         Procédure !SousMenu                         # 
#######################################################################
proc pub_SousMenu {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Offre 1"
putserv "NOTICE $nick :Qualité"
putserv "NOTICE $nick :nombre de"
putserv "NOTICE $nick :......"
  }
}


#######################################################################                          #                         Procédure !Services                         # 
#######################################################################
proc pub_Services {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Nos services sont:"
putserv "NOTICE $nick :Service1"
putserv "NOTICE $nick :Shell-A"
putserv "NOTICE $nick :Shell-B"
putserv "NOTICE $nick :WebHosting"
putserv "NOTICE $nick :WebDesign"
putserv "NOTICE $nick :...."
  }
}

#######################################################################                      
#                         Procédure !Service1                         # 
#######################################################################
proc pub_Service1 {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Le Compte Service1 Est :"
putserv "NOTICE $nick :1 shell"
putserv "NOTICE $nick :2 backgrounds"
putserv "NOTICE $nick :1 email"
putserv "NOTICE $nick :Accés a tout nos vhost"
putserv "NOTICE $nick :........"
putserv "NOTICE $nick :........"
putserv "NOTICE $nick :10$/month"
  }
}

############### CopyRight 2003 : EdenTech Communication ###############

# END ORIGINAL CODE
# BEGIN BASE VIRGINIABOT TOOLS CODE

# Log and load
putlog "Base bot tools loaded"
# Broken at the moment: putlog "Anti trouting functionality enabled in: #VASirens"
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
global botnick version server serveraddress config tcl_version
# First we determine what server we're on
if {$serveraddress == "irc.freenode.net:6667"} {
set network "freenode"
set networkurl "http://freenode.net/"
} elseif {$serveraddress == "chat.freenode.net:6667"} {
set network "freenode"
set networkurl "http://freenode.net/"
} elseif {$serveraddress == "irc.jasperswebsite.com:6667"} {
set network "JDNet"
set networkurl "http://jd.orain.org/wiki/JDNet"
} elseif {$serveraddress == "irc.geeksirc.net:6667"} {
set network "GeeksIRC"
set networkurl "http://geeksirc.net/"
} elseif {$serveraddress == "unreal.nsrt.it:6667"} {
set network "FIRCd Testnet"
set networkurl "http://inertianetworks.com/"
} elseif {$serveraddress == "127.0.0.1:6669"} {
set network "TestIRC"
set networkurl "http://cca.net78.net/ch/IRC/TestIRC/"
} else {
set network "Unknown"
set networkurl "Unknown"
}
# Next we set some variables
# *** REMEMBER TO UPDATE VERSIONS AS NEEDED ***
set toolsetver "1.0b6"
set toolsetdate "6/26/14"
set eggdropversion "1.6.21"
set eggdropdate "10/25/11"
set botcreatedate "1/29/14"
set tclver "8.6.0"
set tcldate "12/20/12"
set tclpkgver "8.6.0+6ubuntu3"
set tclpkgdate "3/06/14"
if {$botnick == "LEDBot"} {
set isLEDBot 1
} else { set isLEDBot 0 }
# Now we actually say something
putquick "NOTICE $nick :This is $botnick, a fully automated IRC bot."
putquick "NOTICE $nick :$botnick is an Eggdrop running on the $network network."
putquick "NOTICE $nick :Website: http://cca.net78.net/ch/IRC/"
# We only want to credit mrboojay if we're LEDBot
if {$isLEDBot == 1} {
putquick "NOTICE $nick :Special thanks to mrboojay for making this bot possible."
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
putlog "Kicked $nick from $chan for trouting"
}
if { [botisop $chan]== 0 } {
puthelp "PRIVMSG $chan :\001ACTION incinerates $nick's trout with a blowtorch.\001"
putlog "Incinerated $nick's trout in $chan"
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
putlog "TalkBot slapped someone; not engaging in mutual slapping session"
}
}
}
return 0
}

# END BASE VIRGINIABOT TOOLS CODE

# BEGIN TF2 CODE

proc pub_not-tf2 {nick uhost hand chan args} {
putlog "Warning $nick - $chan is not a TF2 channel"
putserv "NOTICE $nick :\002\00304ALERT:\002\003 You are speaking in $chan. $chan is not a TF2 channel."
putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
}

# END TF2 CODE

# BEGIN JOIN REDIRECTION CODE

proc pub_not-join {nick uhost hand chan input args} {
    putlog "Redirecting $nick - bad attempt to join $input from $chan (wrong join command)"
    if {$input == "#tf2.mix.euhl" || $input == "#tf2.pug.nahl" || $input == "#tf2.pug.na" || $input == "#tf2.mix.nahl" || $input == "#tf2scrim.hl" || $input == "#tf2scrim"} {
putserv "NOTICE $nick :\002\00304ALERT:\002\003 You are using the wrong command to join that TF2 channel."
putserv "NOTICE $nick :Try \"/join \#\<channel\>\" (without quotes)."
putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
# If they aren't trying to join a TF2 channel, we don't mention TF2
    } else {
putserv "NOTICE $nick :\002\00304ALERT:\002\003 You are using the wrong command to join that channel."
putserv "NOTICE $nick :Try \"/join \#\<channel\>\" (without quotes)."
}
}

proc pub_not-join-badcmd {nick uhost hand chan input args} {
    putlog "Redirecting $nick - bad attempt to join $input from $chan (no join command)"
    if {$input == "#tf2.mix.euhl" || $input == "#tf2.pug.nahl" || $input == "#tf2.pug.na" || $input == "#tf2.mix.nahl" || $input == "#tf2scrim.hl" || $input == "#tf2scrim"} {
putserv "NOTICE $nick :\002\00304ALERT:\002\003 Are you trying to join a TF2 channel?"
putserv "NOTICE $nick :Try \"/join \#\<channel\>\" (without quotes)."
putserv "NOTICE $nick :If you need assistance joining a TF2 channel, please ask a chanop for help. Thanks!"
# If they aren't trying to join a TF2 channel, we don't mention TF2
    } else {
putserv "NOTICE $nick :\002\00304ALERT:\002\003 Are you trying to join a channel?"
putserv "NOTICE $nick :Try \"/join \#\<channel\>\" (without quotes)."
}
}

# END JOIN REDIRECTION CODE

# BEGIN LEDBOT-SPECIFIC CODE

# None at present; placeholder

# END LEDBOT-SPECIFIC CODE

# BEGIN PUPPYBOT-SPECIFIC CODE

# None at present; placeholder

# END PUPPYBOT-SPECIFIC CODE

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

# END MISC CODE

# EOF
