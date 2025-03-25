#!optimizeForSize
# Supress warning for emote
#!suppressWarnings w_ow2_communicate_bug
###############################################################################
#!define versionhere "v1.10.3♨B"
#♨ Dev Build Icon
#!define editortoggle(x) __script__("test-maps/togglescript.js")
editortoggle(0) # 0 is editor, rest is numbers
# Disable via double ## at include, not the define because the define needs to exist
#!define testToggle ##!include "test-scripts.opy"
###############################################################################
# Debug force CN mode on
##!define checkCN if true else

# Enable Invis Command (Invis Command cant be pasted in CN client die to null and none translating to same symbol)
#!define enableInvisCommand true
# Limit on how many orbs can be made
#!define fxLimit 193
#
#!define portalDistance 1.3
# Default circle radius: 1.4
#!define cpcircleradius 1.4
# Default fx: 1
#!define cpCirkleFx 1
# distance range for player - orb 1.4
#!define bounceorbdistance 1.4
# height added to player for orb detection.
#!define bounceoffset 0.7
#
#!define usePerks false
#
#!define cpCheat false
# defaults: off, attempt:5, 120 min, restart:false
#!define compModeToggle false
#!define attemptCount 5
#!define compTimeLimit 120
#!define compRestartLimit false
###############################################################################
#!include "settings.opy"
###############################################################################
#!include "definitions.opy"
###############################################################################
rule versionhere:
    @Delimiter
    #◀ The Official Genji Parkour Editor ▶
    #Discord: dsc.gg/genjiparkour
    #Code: 54CRY
    #Adapted by: LulledLion, FishoFire, Nebula
    return
rule FILLER:
    @Delimiter
###############################################################################
#!include "editor.opy"
###############################################################################
#!include "commands.opy"
###############################################################################
#$$ Rename file
#!include "genji.opy"
###############################################################################
#!include "huds.opy"
###############################################################################
#!include "mechanics.opy"
###############################################################################
#!include "addons-page1.opy"
###############################################################################
rule "MAP DATA - 地图数据":
    @NewPage FILLER # padding to make rest of rules go on page 2

editorordata
###############################################################################
#!include "customize.opy"
###############################################################################
#!include "addons-page2.opy"
###############################################################################
# enable/disable the include via defines
testToggle