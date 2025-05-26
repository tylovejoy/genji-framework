#!optimizeForSize
##!suppressWarnings w_ow2_communicate_bug
##!suppressWarnings w_tags
#!suppressWarnings w_lone_else
#!suppressWarnings w_enum_constant
###############################################################################
#!define versionhere "v1.10.3F"
#♨ Dev Build Icon
###############################################################################
#!define editortoggle(x) __script__("test-maps/togglescript.js")
editortoggle(0) # 0 is editor, rest is numbers
###############################################################################

###############################################################################
macro COMPILE_FOR_CHINESE = false
# Enable Invis Command (Invis Command cant be pasted in CN client die to null and none translating to same symbol)
# Debug force CN mode on
##!define checkCN if true else
###############################################################################
# Max orbs can be made
macro fxLimit = 193
# Portal distance: 1.3
macro portalDistance = 1.3
# Circle radius: 1.4
macro cpcircleradius = 1.4
# Default fx: 1
macro cpCirkleFx = 1
# Orb range for player: 1.4
macro bounceorbdistance = 1.4
# Height added to player for orb detection: 0.7
macro bounceoffset = 0.7
# Enable perks: false
macro usePerks = false
# non-practice cheat mode: false
macro cpCheat = false
# defaults: off, attempt:5, 120 min, restart:false
macro compModeToggle = false
macro attemptCount = 5
macro compTimeLimit = 120
macro compRestartLimit = false
###############################################################################
#!include "settings.opy"
###############################################################################
#!include "definitions.opy"
###############################################################################
##!include "language.opy"
###############################################################################
rule FILLER "    </fg>" versionhere:
    @Delimiter
    #◀ The Official Genji Parkour Editor ▶
    #Discord: dsc.gg/genjiparkour
    #Code: 54CRY
    #Adapted by: LulledLion, FishoFire, Nebula
    return
###############################################################################
#!include "editor.opy"
###############################################################################
#!include "commands.opy"
###############################################################################
#$$ Rename file to parkour.opy
#!include "genji.opy"
###############################################################################
#!include "huds.opy"
###############################################################################
#!include "effects.opy"
###############################################################################
#!include "mechanics.opy"
###############################################################################
#$$ TODO hero support
##!include "genji.opy"

##!include "hanzo.opy"

##!include "kiriko.opy"

##!include "hazard.opy"
###############################################################################
#!include "addons-page1.opy"
###############################################################################
rule "MAP DATA - 地图数据":
    @NewPage FILLER # padding to make rest of rules go on page 2
###############################################################################
testData
###############################################################################
#!include "customize.opy"
###############################################################################
#!include "addons-page2.opy"
###############################################################################
# Enable/disable the include
##!include "test-scripts.opy"