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
# notice � tous ceux qui rejoingnent le channel, les informants des
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
# -Il peut n�-an-moin etre adapter � divers fonctions. Vous pouvez y 
# programmez une !list qui informera les gens des commandes disponibles 
# -Il peut etre utiliser pour les channels ISP. pour un !menu ou       
# !Services. 
#
#
# *En Bref Ce Script Serv a tout. Besoin de cr�es des pub aide         
#  commandes vous etes � la bonne adresse.
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

# Ici vous devez apliquer les pub commandes d�sir�es.
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
# Deprecation redirection
bind pub - ?? pub_deprecated_??
bind pub - timebomb pub_deprecated_timebomb

# Il vous est possible de travailler en arborescence si vous le        
# souhaiter. Suffit de refl�chir. taper !menu vous aurais !sousmenu1, 
# !sousmenu2, !sousmenu3 ... .Puis tapez !sousmenu2 vous accederais au 
# sousmenu3. Et avec sa vous pouvez cr�e un menu compl�.
# Plus vous avez besoin d'aide commande plus vous adder de pour cr�e
# de nouvelle commande !.... .
# bind pub - !..... pub_.....

bind pub - !Aide pub_Aide
bind pub - !helpers pub_Helpers
bind pub - !list pub_list
bind pub - !Info pub_Info
bind pub - !Menu pub_Menu
bind pub - !SousMenu pub_SousMenu
bind pub - !Services pub_Services
bind pub - !Service1 pub_Service1

# ICI commance la configuration des textes resultats des dif�rentes 
# commandes !.....

#######################################################################                          #                         Proc�dure !Exemple                          # 
#######################################################################

proc pub_helpme {nick host hand chan input args} {
global serveraddress
# Should we show GeeksIRC-specific commands?
    if {$serveraddress == "irc.geeksirc.net:6667"} {
set isgeeksirc 1
    } else { set isgeeksirc 0 }
    if {$input == "helpme"} {
# helpme
putserv "NOTICE $nick :The \002!helpme\002 command returns a list of all commands the bot recognizes. It can also return help on a specific command if you give it one."
putserv "NOTICE $nick :Example: \"!helpme\""
putserv "NOTICE $nick :Example: \"!helpme schedule\""
# schedule
} elseif {$input == "schedule" && $chan == "french" && $isgeeksirc == 1} {
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
    } elseif {$input == "assignments" && $chan == "#french" && $isgeeksirc == 1} {
putserv "NOTICE $nick :The \002!assignments\002 command returns any assignments that are due this week."
putserv "NOTICE $nick :Example: \"!assignments\""
# 8ball
    } elseif {$input == "8ball"} {
putserv "NOTICE $nick :The \002!8ball\002 command returns an answer from the Official Calvin-Approved Magic 8-Ball(TM)."
putserv "NOTICE $nick :Example: \"!8ball Will I master conjugating aller?\""
# x2uno
    } elseif {$input == "x2uno" && $chan == "#VASirens" && $isgeeksirc == 1} {
putserv "NOTICE $nick :The \002!x2uno\002 command begins a game of Double Uno, a customized variant with doubled draw values for wild cards, among other differences. Bot play is not supported at this time."
putserv "NOTICE $nick :Game commands are beyond the scope of this help system. Use !unocmds for a listing."
putserv "NOTICE $nick :Example: \"!x2uno\""
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
# no help for you
    } elseif {[llength $input] != 0} {
putserv "NOTICE $nick :Sorry, but there isn't any help available on that command."
# we only want people bugging me about the bot in #french
	if {$chan == "#french" && $isgeeksirc == 1} {
	    putserv "NOTICE $nick :Try asking Calvin."
	}
# command listing
    } elseif {$chan != "#IdleRPG"} {
putserv "NOTICE $nick :You used !helpme."
putserv "NOTICE $nick :Here is a list of commands the bot recognizes. Commands with an asterisk \002*\002 next to them will send output to everyone."
# #french-specific command on GeeksIRC
	if {$chan == "#french" && $isgeeksirc == 1} {
putserv "NOTICE $nick :!schedule     - displays the current class schedule"
	}
putserv "NOTICE $nick :!w\002*\002           - prints out the weather conditions and forecast for a location"
# #french-specific command on GeeksIRC
	if {$chan == "#french" && $isgeeksirc == 1} {
putserv "NOTICE $nick :!assignments  - prints out the assignments due this week"
	}
putserv "NOTICE $nick :!8ball\002*\002       - asks the Magic 8 Ball a question"
# #VASirens-specific command on GeeksIRC
	if {$chan == "#VASirens" && $isgeeksirc == 1} {
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
# putserv "NOTICE $nick :la notice souhait�"
# Vous pouvez adder autant de notice que vous souhaiter, mais il est 
# deconseiller de d�passer la mesure. Cela peut causer le flood de  
# votre Egg.

#######################################################################                          #                         Proc�dure !Aide                             # 
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


#######################################################################                          #                         Proc�dure !Helpers                          # 
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


#######################################################################                          #                         Proc�dure !list                             # 
#######################################################################
proc pub_list {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Nos Publics commands sont : !seen, !Info, !dns host; !ping nick, !aide,..."
  }
}

#######################################################################                          #                         Proc�dure !Info                             # 
#######################################################################
proc pub_Info {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Channel D'Aide en tout genre"
putserv "NOTICE $nick :Notre Site Web : http://www......net"
putserv "NOTICE $nick :Nos Statistique: http://www......net"
  }
}

#######################################################################                          #                         Proc�dure !Menu                             # 
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

#######################################################################                          #                         Proc�dure !SousMenu                         # 
#######################################################################
proc pub_SousMenu {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Offre 1"
putserv "NOTICE $nick :Qualit�"
putserv "NOTICE $nick :nombre de"
putserv "NOTICE $nick :......"
  }
}


#######################################################################                          #                         Proc�dure !Services                         # 
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
#                         Proc�dure !Service1                         # 
#######################################################################
proc pub_Service1 {nick host hand chan args} {
if {$chan == "#VASirens"} {
putserv "NOTICE $nick :Le Compte Service1 Est :"
putserv "NOTICE $nick :1 shell"
putserv "NOTICE $nick :2 backgrounds"
putserv "NOTICE $nick :1 email"
putserv "NOTICE $nick :Acc�s a tout nos vhost"
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
} else {
set network "Unknown"
set networkurl "Unknown"
}
# Next we set some variables
# *** REMEMBER TO UPDATE VERSIONS AS NEEDED ***
set toolsetver "1.0b4"
set toolsetdate "4/15/14"
set eggdropversion "1.6.21"
set eggdropdate "10/25/11"
set botcreatedate "1/29/14"
set tclver "8.5.13"
set tcldate "11/12/12"
set tclpkgver "8.5.0-2ubuntu5"
set tclpkgdate "4/22/13"
# Now we actually say something
putserv "NOTICE $nick :This is $botnick, a fully automated IRC bot."
putserv "NOTICE $nick :$botnick is an Eggdrop running on the $network network."
putserv "NOTICE $nick :Website: http://cca.net78.net/ch/IRC/"
putserv "NOTICE $nick :Technical details:"
putserv "NOTICE $nick :$botnick version: \002$toolsetver\002 ($toolsetdate)"
putserv "NOTICE $nick :Eggdrop version: \002$eggdropversion\002 ($eggdropdate)"
putserv "NOTICE $nick :Tcl version: \002$tclver\002 ($tcldate)"
putserv "NOTICE $nick :Network: \002$network\002 (URL: $networkurl)"
putserv "NOTICE $nick :Created: \002$botcreatedate\002"
}

# Anti trout from here http://forums.wireplay.co.uk/archive/index.php/t-245120.html (currently broken, needs fixing)

bind ctcp - ACTION antitrout:ctcp:action

proc antitrout:ctcp:action {nick uhost hand chan keyword arg} {
global botnick
set troutkickreason "Take your trout and go jump in a lake."
if {$chan == "#VASirens" && ([string tolower [lindex $arg 0]] == "slaps" || [string tolower [lindex $arg 0]] == "slap") && [lsearch [string tolower $arg] trout] >= 2 && [string tolower $nick] != [string tolower $botnick] } {
if { [botisop $chan] == 1 } {
puthelp "kick $chan $nick :$troutkickreason"
putlog "Kicked $nick from $chan for trouting"
}
if { [botisop $chan]== 0 } {
puthelp "PRIVMSG $chan :\001ACTION aims a blowtorch at $nick's trout, and incinerates it.\001"
putlog "Incinerated $nick's trout in $chan"
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

# BEGIN MISC CODE

proc pub_deprecated_?? {nick uhost hand chan args} {
putlog "Warning $nick - command ?? is deprecated"
putserv "NOTICE $nick :\002\00304ALERT:\002\003 That command is deprecated."
putserv "NOTICE $nick :Try \"!define <word>\"."
}

proc pub_deprecated_timebomb {nick uhost hand chan args} {
putlog "Warning $nick - command timebomb is deprecated"
putserv "NOTICE $nick :\002\00304ALERT:\002\003 That command is deprecated."
putserv "NOTICE $nick :Try \"!timebomb <user>\"."
}

# END MISC CODE

# EOF
