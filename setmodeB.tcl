# Sets mode +B on connect. For use on GeeksIRC.
# Based off of eggdrop.conf.
# Part of the VirginiaBot setup.

bind evnt - init-server evnt:init_server 

proc evnt:init_server {type} { 
global botnick 
putquick "MODE $botnick +B" 
}

putlog "Mode to be set +B."

