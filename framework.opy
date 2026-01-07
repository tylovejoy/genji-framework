#!optimizeForSize
##!suppressWarnings w_ow2_communicate_bug
#!suppressWarnings w_tags
#!suppressWarnings w_lone_else
#!suppressWarnings w_enum_constant
################################################################################
#!define versionhere "1.10.4F"
#♨ Dev Build Icon
################################################################################
#!define editortoggle(x) __script__("test-maps/togglescript.js")
editortoggle(0) # 0 is editor, rest is numbers
################################################################################
#$$ TODO proper multi-hero support
#!define importHero(Hero) __script__('FwHero/fwHero.js')
importHero(["Genji", "Hanzo", "Hazard", "Kiriko", "Doomfist"][0])
################################################################################
macro lobbyTime = 260 # Default lobby duration: 260
macro fxLimit = 193 # Max orbs can be made
macro portalDistance = 1.3 # Portal distance: 1.3
macro cpCircleRadius = 1.4 # Sphere radius: 1.4
macro cpCirkleFx = 1 # Ring radius fx: 1
macro bounceOrbDistance = 1.4 # Orb range for player: 1.4
macro bounceOffset = 0.7 # Height added to player for orb detection: 0.7
macro usePerks = false # Enable perks: false (Requires some manual overriding)
macro teleCheat = false # Teleport cheats: false
macro antiCheat = true # Detect speed & gravity cheats
macro compModeToggle = false # Enable Tournament Mode: false
macro attemptCount = 5 # Allowed Restart(s) limit
macro compMarathon = false # Enforce Marathon: false
################################################################################
#!include "settings.opy"
################################################################################
##!excludeVariablesInCompilation
#!include "definitions.opy"
################################################################################
#!translations en zh ko
#!disableTranslationSourceLines
#!translateWithPlayerVar noDetectionRule
##!keepUnusedTranslations
macro overrideLanguage = Languages.Automatic
################################################################################
#!disableInspector
#!globalvarInitRuleName "OverPy | Global Init"
#!playervarInitRuleName "OverPy | Player Init"
################################################################################
Fw_Include_Hero
################################################################################
#!include "parkour.opy"
################################################################################
Fw_Mechanics_Hero()
################################################################################
#!include "editor.opy"
##!include "editor2.opy"
################################################################################
#!include "commands.opy"
################################################################################
#!include "huds.opy"
################################################################################
#!include "effects.opy"
################################################################################
#!include "addons-page1.opy"
################################################################################
rule "MAP DATA - 地图数据":
    @NewPage ("▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
    " Map Data & Addon Settings Are On Page 2 - 地图数据和附加组件的设置在第2页 "
    "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒")
################################################################################
testData
################################################################################
#!include "customize.opy"
################################################################################
#!include "addons-page2.opy"
################################################################################
# Enable/disable the include
##!include "test-scripts.opy"