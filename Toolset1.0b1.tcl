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

# Il vous est possible de travailler en arborescence si vous le        
# souhaiter. Suffit de refléchir. taper !menu vous aurais !sousmenu1, 
# !sousmenu2, !sousmenu3 ... .Puis tapez !sousmenu2 vous accederais au 
# sousmenu3. Et avec sa vous pouvez crée un menu complé.
# Plus vous avez besoin d'aide commande plus vous adder de pour crée
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

# ICI commance la configuration des textes resultats des diférentes 
# commandes !.....

#######################################################################                          #                         Procédure !Exemple                          # 
#######################################################################

proc pub_helpme {nick host hand chan input args} {
    if {$input == "helpme"} {
# helpme
putserv "NOTICE $nick :The \002!helpme\002 command returns a list of all commands the bot recognizes. It can also return help on a specific command if you give it one."
putserv "NOTICE $nick :Example: \"!helpme\""
putserv "NOTICE $nick :Example: \"!helpme schedule\""
# schedule
} elseif {$input == "schedule" && $chan == "french"} {
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
    } elseif {$input == "assignments" && $chan == "#french"} {
putserv "NOTICE $nick :The \002!assignments\002 command returns any assignments that are due this week."
putserv "NOTICE $nick :Example: \"!assignments\""
# 8ball
    } elseif {$input == "8ball"} {
putserv "NOTICE $nick :The \002!8ball\002 command returns an answer from the Official Calvin-Approved Magic 8-Ball(TM)."
putserv "NOTICE $nick :Example: \"!8ball Will I master conjugating aller?\""
# x2uno
    } elseif {$input == "x2uno" && $chan == "#VASirens"} {
putserv "NOTICE $nick :The \002!x2uno\002 command begins a game of Double Uno, a customized variant with doubled draw values for wild cards, among other differences. Bot play is not supported at this time."
putserv "NOTICE $nick :Game commands are beyond the scope of this help system. Use !unocmds for a listing."
putserv "NOTICE $nick :Example: \"!x2uno\""
# version
    } elseif {$input == "version"} {
putserv "NOTICE $nick :The \002!version\002 command returns the bot's version and other technical details."
putserv "NOTICE $nick :Example: \"!version\""
# no help for you
    } elseif {[llength $input] != 0} {
putserv "NOTICE $nick :Sorry, but there isn't any help available on that command."
# we only want people bugging me about the bot in #french
	if {$chan == "#french"} {
	    putserv "NOTICE $nick :Try asking Calvin."
	}
# command listing
    } elseif {$chan != "#IdleRPG"} {
putserv "NOTICE $nick :You used !helpme."
putserv "NOTICE $nick :Here is a list of commands the bot recognizes. Commands with an asterisk \002*\002 next to them will send output to everyone."
# #french-specific command
	if {$chan == "#french"} {
putserv "NOTICE $nick :!schedule     - displays the current class schedule"
	}
putserv "NOTICE $nick :!w\002*\002           - prints out the weather conditions and forecast for a location"
# #french-specific command
	if {$chan == "#french"} {
putserv "NOTICE $nick :!assignments  - prints out the assignments due this week"
	}
putserv "NOTICE $nick :!8ball\002*\002       - asks the Magic 8 Ball a question"
# #VASirens-specific command
	if {$chan == "#VASirens"} {
putserv "NOTICE $nick :!x2uno\002*\002       - begins a game of Double Uno"
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
putlog "Base VirginiaBot tools loaded"
# Broken at the moment: putlog "Anti trouting functionality enabled in: #VASirens"
putlog "This code is based from: Aide Cmds TCL by MeS http://www.EdenTech.Biz"

# !schedule
proc pub_schedule {nick host hand chan args} {
    if {$chan == "#french"} {
putserv "NOTICE $nick :The current class schedule for \002French 1\002 is:"
putserv "NOTICE $nick :\002Wednesdays at 2:45 PM Eastern (11:45 AM Pacific)\002"
putserv "NOTICE $nick :Speaking classes every other Thursday at 11:15 AM Eastern (8:15 AM Pacific) - 6 student limit, RSVP in advance"
    }
}

# !assignments
proc pub_assignments {nick host hand chan args} {
    if {$chan == "#french"} {
putserv "NOTICE $nick :The assignments due this week are:"
putserv "NOTICE $nick :\002Temporarily Unavailable\002"
    }
}

# !version
proc pub_version {nick host hand chan args} {
putserv "NOTICE $nick :This is VirginiaBot, a fully automated IRC bot."
putserv "NOTICE $nick :VirginiaBot is an Eggdrop running on the GeeksIRC network."
putserv "NOTICE $nick :Website: http://cca.net78.net/ch/IRC/"
putserv "NOTICE $nick :Technical details:"
# REMEMBER TO UPDATE VERSIONS AS NEEDED
putserv "NOTICE $nick :VirginiaBot version: \0021.0b1\002 (3/26/14)"
putserv "NOTICE $nick :Eggdrop version: \0021.6.21\002 (10/25/11)"
putserv "NOTICE $nick :Tcl version: \0028.5.0-2ubuntu5\002 (4/22/13)"
putserv "NOTICE $nick :Network: \002GeeksIRC\002 (URL: http://geeksirc.net/)"
putserv "NOTICE $nick :Created: \0021/29/14\002"
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
# EOF
