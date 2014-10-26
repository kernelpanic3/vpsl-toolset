# Wikimedia search function for PuppyBot.
# Adapted from: http://hawkee.com/snippet/9492/

# Changelog:
# 0.02 - changed syntax and formatting to align with toolset.
# 0.01 - initial revision.

##############################################################################################
##  ##     wikipedia.tcl for eggdrop by Ford_Lawnmower irc.geekshed.net #Script-Help    ##  ##
##############################################################################################
## To use this script you must set channel flag +wikipedia (ie .chanset #chan +wikipedia)   ##
##############################################################################################
##############################################################################################
##  ##                             Start Setup.                                         ##  ##
##############################################################################################
## Change wikipedia_cmdchar to the character you want to use.                               ##
set wikipedia_cmdchar "!"
## Change wikipedia_lang to the 2 digit language code you want to use                       ##
set wikipedia_lang "en"
proc wikipedia {nick host hand chan wikipediasite wikipediaurl} {
  if {[lsearch -exact [channel info $chan] +wikipedia] != -1} {
## Change the characters between the "" below to change the logo shown with each result.    ##
    set wikipedialogo ""
## Change the format codes between the "" below to change the color/state of the text.      ##
    set textf ""
##############################################################################################
##  ##                           End Setup.                                              ## ##
##############################################################################################	
    if {[catch {set wikipediaSock [socket -async $wikipediasite 80]} sockerr]} {
      putserv "PRIVMSG $chan :$wikipediasite $wikipediaurl $sockerr error"
      return 0
      } else {
      puts $wikipediaSock "GET $wikipediaurl HTTP/1.0"
      puts $wikipediaSock "Host: $wikipediasite"
      puts $wikipediaSock ""
      flush $wikipediaSock
      while {![eof $wikipediaSock]} {
        set wikipediavar " [gets $wikipediaSock] "
        if {[regexp {may refer to:} $wikipediavar] || [regexp {HTTP\/1\.0 403} $wikipediavar]} {
           putserv "PRIVMSG $chan :\002Oops!\002 Your search returned no results."
           putserv "PRIVMSG $chan :Please refine your search and check your spelling."
           putserv "PRIVMSG $chan :Note that the bot only fully supports mainspace at this time."
           putlog "$nick used !search $search, but there were no results (wikipedia proc)"
           close $wikipediaSock
	   return 0
        }
        if {[regexp {<b>(.*)</p>} $wikipediavar] || [regexp {<p>(.*)</p>} $wikipediavar]} {
          regexp {<p>(.*)</p>} $wikipediavar match wikipediaresult
          set wikipediaresult [concat [wikipediadehex [wikipediastrip $wikipediaresult]] \003\037\002http://${wikipediasite}${wikipediaurl}]
	  set wikipediaresult [wikitextsplit $wikipediaresult 50]
          set counter 0
          while {$counter <= [llength $wikipediaresult]} {
	    if {[lindex $wikipediaresult $counter] != ""} {
		putserv "PRIVMSG $chan :[lindex $wikipediaresult $counter]"
	    }
	    incr counter
	  }
	  close $wikipediaSock
	  return 0
        }
      }
      close $wikipediaSock
      return 0 
    }
  }
}
proc googlewikisearch {nick host hand chan search} {
  global wikipedia_lang
  if {[lsearch -exact [channel info $chan] +wikipedia] != -1} {
    set googlewikisite "www.google.com"
    set googlewikisearch [string map {{ } \%20} "${search}"]
    set googlewikiurl "/search?q=${googlewikisearch}+site:${wikipedia_lang}.wikipedia.org&rls=${wikipedia_lang}&hl=${wikipedia_lang}"
    if {[catch {set googlewikiSock [socket -async $googlewikisite 80]} sockerr]} {
      putserv "PRIVMSG $chan :$googlewikisite $googlewikiurl $sockerr error"
      return 0
    } else {
      puts $googlewikiSock "GET $googlewikiurl HTTP/1.0"
      puts $googlewikiSock "Host: $googlewikisite"
      puts $googlewikiSock ""
      flush $googlewikiSock
      while {![eof $googlewikiSock]} {
        set googlewikivar " [gets $googlewikiSock] "
	if {[regexp {<cite>(.*?)<\/cite>} $googlewikivar match googlewikiresult]} {
          if {[regexp {wikipedia\.org} $googlewikiresult]} {
            set googlewikiresult [wikipediastrip $googlewikiresult]
            regexp {(.*?)\/} $googlewikiresult match wikisite
            regexp {\.org(.*)} $googlewikiresult match wikiurl
            wikipedia $nick $host $hand $chan $wikisite $wikiurl
            close $googlewikiSock
	    return 0
          }
	}
      }
           putserv "PRIVMSG $chan :\002Oops!\002 Your search returned no results."
           putserv "PRIVMSG $chan :Please refine your search and check your spelling."
           putserv "PRIVMSG $chan :Note that the bot only fully supports mainspace at this time."
           putlog "$nick used !search $search, but there were no results (google proc)"
      close $googlewikiSock
      return 0 
    }
  }
}
proc wikitextsplit {text limit} {
  set text [split $text " "]
  set tokens [llength $text]
  set start 0
  set return ""
  while {[llength [lrange $text $start $tokens]] > $limit} {
    incr tokens -1
    if {[llength [lrange $text $start $tokens]] <= $limit} {
      lappend return [join [lrange $text $start $tokens]]
      set start [expr $tokens + 1]
      set tokens [llength $text]
    }
  }
  lappend return [join [lrange $text $start $tokens]]
  return $return
}
proc wikipediadehex {string} {
  regsub -all {[\[\]]} $string "" string
  set string [subst [regsub -nocase -all {\&#([0-9]{3});} $string {[format %c \1]}]]
  return [string map {&quo\te; \"} $string]
}
proc wikipediastrip {string} {
  regsub -all {<[^<>]+>} $string "" string
  regsub -all {\[\d+\]} $string "" string
  return $string
}
bind pub - [string trimleft $wikipedia_cmdchar]wikipedia googlewikisearch
setudef flag wikipedia
putlog "Wikimedia 0.02 loaded. Part of the VirginiaBot/PuppyBot toolset."
putlog "Based on \00301,00WikipediA\002\003 \002by Ford_Lawnmower irc.GeekShed.net #Script-Help"
