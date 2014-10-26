# Script that allows users to choose between Uno variants.
# Part of the VirginiaBot toolset.
# Changelog
# 0.02 - fixed variant retention.
# 0.01 - initial version.

bind pub - !unovar unovar

proc unovar {nick host hand chan args} {
global UnoVariant
    if {$args == "x2"} {
filemod x2
putquick "PRIVMSG $chan :\002\0033U\00312N\00313O\00308!\002\003 mode set to Double Uno."
rehash
set UnoVariant 1
return
    }
    if {$args == "attack"} {
filemod attack
putquick "PRIVMSG $chan :\002\0033U\00312N\00313O\00308!\002\003 mode set to Uno Attack."
rehash
set UnoVariant 2
return
    } elseif {![info exists UnoVariant]} {
putquick "PRIVMSG $chan :\002\0033U\00312N\00313O\00308!\002\003 mode currently \002not set\002."
return
    } elseif {$UnoVariant == 1} {
putquick "PRIVMSG $chan :\002\0033U\00312N\00313O\00308!\002\003 mode currently set to: \002Double Uno\002"
return
	} elseif {$UnoVariant == 2} {
putquick "PRIVMSG $chan :\002\0033U\00312N\00313O\00308!\002\003 mode currently set to: \002Uno Attack\002"
return
	} else {
putquick "PRIVMSG $chan :Oops: UnoVariant set but out of bounds (someone call my owner)"
putlog "Oops: UnoVariant set but out of bounds"
return
	}
}


proc filemod {var} {
set fname "~/eggdrop/geeksirc.conf"
set fp [open $fname "r"] 
set data [read -nonewline $fp] 
close $fp
set lines [split $data "\n"]
if {$var == "x2"} {
set line_to_delete 110
set lines [lreplace $lines $line_to_delete $line_to_delete "source scripts/uno.tcl"]
set line_to_delete 111
set lines [lreplace $lines $line_to_delete $line_to_delete "# source scripts/unoattack.tcl"]
set fname "~/eggdrop/geeksirc.conf"
set fp [open $fname "w"] 
puts $fp [join $lines "\n"] 
close $fp 
}
if {$var == "attack"} {
set line_to_delete 110
set lines [lreplace $lines $line_to_delete $line_to_delete "# source scripts/uno.tcl"]
set line_to_delete 111
set lines [lreplace $lines $line_to_delete $line_to_delete "source scripts/unoattack.tcl"]
set fname "~/eggdrop/geeksirc.conf"
set fp [open $fname "w"] 
puts $fp [join $lines "\n"] 
close $fp 
}
}

putlog "Uno Chooser 0.01 loaded. Part of the VirginiaBot toolset."

