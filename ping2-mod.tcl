################################################################
# Ping TCL                                                     #
# Author:                                                      #
#    kazuya                                                    # 
#                                                              #
# Edited and add some enhancement by:                          #
#    kazuya                                                    #
#                                                              #
# I hate ripper, so please included the copyright stuff        #
# when you modified it. at least give credit to real author    #
#                                                              #
################################################################

# Modified for VirginiaBot/PuppyBot.
# Changelog:
# 0.02 - converted reply message to use NOTICE.
# 0.01 - initial revision.

bind pub - !ping ping_me
bind ctcr - PING ping_me_reply

proc ping_me {nick uhost hand chan arg} {
     global pingchan pingwho pinger pingee
     set pingee $arg
     set arg [string toupper $arg]
     if {$arg == "" || [string match "#*" $arg]} {
          puthelp "NOTICE $nick :Hmm? You failed to specify the recipient!"
          puthelp "NOTICE $nick :Use \002!ping me\002 to have the bot ping you, or \002!ping <nick>\002 to have the bot ping someone else."
          return 0
     } elseif {$arg == "ME"} {
          putserv "PRIVMSG $nick :\001PING [unixtime]\001"
          set pingwho 0
          set pingchan $chan
          set pinger $nick
          return 1
     } else { 
          putserv "PRIVMSG $arg :\001PING [unixtime]\001"
          set pingwho 1
          set pingchan $chan
          set pinger $nick
          return 1
     }
}

proc ping_me_reply {nick uhost hand dest key arg} {
     global pingchan pingwho pinger pingee
     if {$pingwho == 0} {
          puthelp "NOTICE $pinger :Ping reply from \002$nick\002: [expr [unixtime] - $arg] seconds."
          return 0
     } elseif {$pingwho == 1} {
          puthelp "NOTICE $pinger :Ping reply from \002$pingee\002: [expr [unixtime] - $arg] seconds."
          return 0
     }
}

############
#End of TCL#
############

putlog "Ping function 0.02 loaded. Part of the VirginiaBot/PuppyBot toolset."
putlog "Code based on ping2.tcl by kazuya."
