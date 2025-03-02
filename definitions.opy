#!mainFile "genji.opy"

######################################## Settings ####################
#!define versionhere "v1.10.2♨J"
#♨ Dev Build Icon

#!define editortoggle(x) __script__("test-maps/togglescript.js")
editortoggle(0) # 0 is editor, rest is numbers
# Disable via double ## at include, not the define because the define needs to exist
#!define testToggle ##!include "test-scripts.opy"

# Debug force CN mode on
##!define checkCN if true else

# Enable Invis Command (Invis Command cant be pasted in CN client die to null and none translating to same symbol)
#!define enableInvisCommand true

# Limit on how many orbs can be made
#!define fxLimit 193

#!define portalDistance 1.3

# Default circle radius: 1.4
#!define cpcircleradius 1.4

# Default fx: 1
#!define cpCirkleFx 1

# distance range for player - orb 1.4
#!define bounceorbdistance 1.4

# height added to player for orb detection. inludes the +
#!define bounceoffset + Vector.UP * 0.7

#!define usePerks false

#!define cpCheat false

# defaults: off, attempt:5, 120 min, restart:false
#!define compModeToggle false
#!define attemptCount 5
#!define compTimeLimit 120
#!define compRestartLimit false

######################################## Macro Tools ##########################
##!define RestartTimer(timeInMinutes) "{0} Hours and {1} Minutes".format(floor(timeInMinutes / 60 / 60), "{0}{1}".format(floor(timeInMinutes % 60 / 10), floor(timeInMinutes % 60 - floor(timeInMinutes % 60 / 10) * 10)))
##!define prettyTime(timeInSeconds) "{0}:{1}".format(floor(timeInSeconds / 60), "{0}{1}.{2}".format(floor(timeInSeconds % 60 / 10), floor(timeInSeconds % 60 - floor(timeInSeconds % 60 / 10) * 10), "{0}{1}".format([] if floor((timeInSeconds % 1) * 100) >= 10 else "0", floor((timeInSeconds % 1) * 100))))
##!define prettyTime(timeInSeconds) "{0} sec".format(timeInSeconds)
##!define prettyTime(timeInSeconds) "{0} {1}".format(timeInSeconds,"秒"  checkCN "sec")
#!define prettyTime(timeInSeconds) "{0} sec".format(timeInSeconds)

#!define insert(insert_array, insert_index, insert_value)\
insert_array.append(insert_value)\
insert_array = [elementhere if i < insert_index else insert_array.last() if i == insert_index else insert_array[i - 1] for elementhere, i in insert_array]

#!define toggleCpInArray(baninput)\
if eventPlayer.checkpoint_current in baninput:\
    baninput = [i for i in baninput if i != eventPlayer.checkpoint_current]\
else:\
    baninput.append(eventPlayer.checkpoint_current)

#!define removeCPandLower(arrayname)\
arrayname = [i for i in arrayname if i != hostPlayer.checkpoint_current]\
arrayname = [x - (1 if x >= hostPlayer.checkpoint_current else 0) for x in arrayname]

#!define checkCN if l"Oof" == "噢" else

#!define FILLER "<tx0C000000000207B5><fgFFFF00FF> Map Data & Addon Settings Are on Page 2 - 地图数据和附加组件的设置在第2页"

#!define flyMovementDelta ((0.096 + 0.192 * eventPlayer.isHoldingButton(Button.JUMP) - 0.048 * eventPlayer.isHoldingButton(Button.CROUCH)) * \
    (eventPlayer.getFacingDirection() * eventPlayer.getThrottle().z * (vect(1, not eventPlayer.isHoldingButton(Button.ABILITY_1), 1))+ \
    worldVector(eventPlayer.getThrottle() * Vector.LEFT, eventPlayer, Transform.ROTATION) + \
    Vector.UP * (eventPlayer.isHoldingButton(Button.ABILITY_2) - eventPlayer.isHoldingButton(Button.ULTIMATE))))

###############################################################################
#!optimizeForSize
# Supress warning for emote
#!suppressWarnings w_ow2_communicate_bug
#disable overpy map detection (command removed by zezy after fix by blizzard)
# #!disableMapDetectionFix

#!include "settings.opy"

######################################## Global Variables #####################
# Warning do not change global variable indices.
# Will result in variable mismatch upon exporting mapdata to newer versions
# Current Unused Variables: 1,6,9,11,16,17,19,28,29,31,36,37,48,49,59,72,89,92+
#!define CheckpointPositions A
globalvar CheckpointPositions 0             # list[vect | list[vect]]   --- sometimes nested - 0 original end, 1 teleported
#!define SelectedCheckpoint_Editing B
#globalvar SelectedCheckpoint_Editing       # legacy      # int                       --- selected checkpoint
#!define CheckpointRings_Editing C
globalvar CheckpointRings_Editing 2         # list[effect]              --- Holds checkpoint effects in editing context
#!define MapChecker MsDestructo
globalvar MsDestructo 3                     # Player
globalvar TimeRemaining 4
globalvar PortalEffects 5                   # list[effect]              --- Array holding custom portal effects
#globalvar CurrentPortalEditing
#!define Portal1PlayerList F
#globalvar Portal1PlayerList                # list[player]              --- players who can see portal 1
#!define Portal2PlayerList G
#globalvar Portal2PlayerList                # list[player]              --- players who can see portal 2
#!define KillBallPositions H
globalvar KillBallPositions 7               # list[vect]                --- KillBall position
#!define KillBallRadii I
globalvar KillBallRadii 8                   # list[float]               --- KillBall radius, default 5
#!define SelectedKillball_Editing J
#globalvar SelectedKillball_Editing         # int                       --- Current killball in editing context
#!define KillBallEffects K
globalvar KillBallEffects 10                # list[effect]              --- Array holding killball effects
#!define KillBallChase L
#globalvar KillBallChase                    # vect                      --- Location of killball while editing, chased.
#!define BladeEnabledCheckpoints Dao
globalvar BladeEnabledCheckpoints 12        # int                       --- blade enabled, should be bool.
#!define DashEnabledCheckpoints SHIFT
globalvar DashEnabledCheckpoints 13         # int                       --- dash enabled, should be bool.
#!define ListPlayersAtCheckpoints P
#globalvar ListPlayersAtCheckpoints         # list[list[player]]        --- players at a specific checkpoint
#!define ActivePlayers Q
#globalvar ActivePlayers                    # list[player]              --- Active players, Non-saved, non-spectating active players
#globalvar EditorOn                         # bool                      --- editor rules enabled?
globalvar EditSelected 14
globalvar EditSelectIdArray 15

#globalvar EditorMoveItem                   # num                       --- used for moving a portal

#Bounce Pad editing stuff
#!define BouncePositions TQ
globalvar BouncePositions 18                # list[vect]                --- list of bouncepad positions
#!define CurrentBounce_Editing TQ1
#globalvar CurrentBounce_Editing            # int                       --- count of 0-indexed bouncepad pos currently
#!define BounceEffects TQ2
globalvar BounceEffects 20                  # list[effects]             --- list of bounce pad effect entities
#!define CurrentBouncePosition_Editing TQ3
#globalvar CurrentBouncePosition_Editing    # vect                      --- the position we just added to bouncepad positions
globalvar EditorMoveItem 21                 # num                       --- used for moving a portal
#!define BounceStrength EditMode
globalvar BounceStrength 22                 # list[float]               --- bouncepad strength
#!define BounceToggleUlt TQ5
globalvar BounceToggleUlt 23                # list[bool]                --- toggle ult on bounce
#!define BounceToggleDash TQ6
globalvar BounceToggleDash 24               # list[bool]                --- toggle dash on bounce
globalvar BounceToggleLock 25               # list[bool]                --- lock cp if not collected bounce
#!define KillballCheckpoints killballnumber
globalvar KillballCheckpoints 26            # list[list[int]]           --- 2d list of checkpoints that havea kill ball [[0], [3]]
#!define BouncePadCheckpoints pinballnumber
globalvar BouncePadCheckpoints 27           # list[list[int]]           --- 2d list like killballnumber

# old save progresion, removed but kept in here for legacy pasta purposes
#!define SavedProgress save
globalvar SavedProgress 30                  # list[Any]                 --- saves player data in array for rejoining, sequential data

# Leaderboard stuff
#globalvar toplistPlayers
#globalvar toplistTimes
#globalvar toplistSortedTimes
globalvar LeaderBoardFull 32                # [[name,second,prettytime]]--- sorted list of 0-19 leaderboard entries
globalvar LeaderBoardHuds 33
globalvar LeaderBoardRemake 34              # bool                      --- indicate board needs remaking
#!define BhopBanToggle kaxiaotiao
globalvar BhopBanToggle 35                  # bool                      --- Enabled if Bhop is banned

#!define TempIterator1 NANBA
globalvar TempIterator1 38                  # int                       --- temp iterator

globalvar DashExploitToggle 39


globalvar PortalNames 40                    # [str]                     --- display name of portals
globalvar PortalLoc 41                      # [vect]                    --- portal position
globalvar PortalDest 42                     # [vect]                    --- portal destination
globalvar PortalOn 43                       # bool                      --- portals enabled
globalvar Difficultyhud 44                  # number                    --- workshop toggle to display difficulty hud

globalvar CustomPortalStart 45              # [vect]                    --- custom portal start
globalvar CustomPortalEndpoint 46           # [vect]                    --- custom portal end points
globalvar CustomPortalCP 47                 # [int]                     --- custom portal checkpoints

globalvar CompMode 50                       # bool                      --- competitive mode toggle
globalvar CompTime 51                       # int                       --- compt mode time limit
globalvar CompAtmpNum 52                    # int                       --- compt mode attempt limit
globalvar CompAtmpSaveNames 53              # [strings]                 --- comp name list
globalvar CompAtmpSaveCount 54              # [int]                      --- compt attempt list
globalvar CompRestartLimit 55               # bool                      --- resest limiter
#!define InstructionText instructiontext
globalvar InstructionText 56                # [text]                    --- array of instructions
globalvar TitleData 57                      # [[cp ,[title],[color]]    --- title addon
globalvar HudStoreEdit 58                   # [textid]                  --- list of huds to delete if editormode is on

globalvar SaveName 60
globalvar SaveCp 61
globalvar SaveEnt 62
globalvar SaveTimer 63
globalvar SaveElapsed 64
globalvar SavePauseTime 65
globalvar SavePauseEnabled 66

globalvar HintCp 67
globalvar HintText 68

globalvar ColorConfig 69                    # [colors]                  --- configured colors

globalvar Name 70
globalvar Code 71
globalvar Cachedcredits 73

# per cp iwt or hud
globalvar CpHudText 74
globalvar CpHudCp 75
globalvar CpIwtText 76
globalvar CpIwtCp 77
globalvar CpIwtPos 78
globalvar CpIwtColor 79

globalvar BanTriple 80                      # legacy
globalvar BanMulti 81
globalvar BanCreate 82
#!define deathjump BanDead
globalvar BanDead 83
globalvar BanEmote 84
globalvar BanClimb 85
globalvar BanBhop 86
globalvar BanStand 87                       # bans on second hop
globalvar BanDjump 88
globalvar BanSaveDouble 89
#!define MapCheckerIter DestructoIter
globalvar DestructoIter 90
globalvar MapVectorArray 91

######################################## Player Variables #####################
#PlayerEffects data
#0 - Current ring,
#1 - Next ring,
#2 - Next lightshaft,
#3 - Next arrow icon,
#4 - Next "Come here" text
#playervar PlayerEffects                    # list[effect]              --- Player effect data array
#playervar ArrayIterator                    # MsDestructo Iterator
#playervar PortalText                       # In-World Text             --- Portal String inworld text
#playervar MapVectorArray                   # MsDestructo Vectors
#playervar TracesOff                        # bool                      --- turn traces (ring explosion fx) off
playervar checkpoint_current                # int                       --- Current Checkpoint
playervar checkpoint_practice               # int                       --- Saved practice checkpoint
playervar checkpoint_moved
playervar checkpoint_notLast                       # bool                      --- false if you are noton the last cp or level below 2 cps
playervar lockState                         # bool                      --- locked means you are curently runing arrive checkpoint rule

playervar timer_normal                             # float                     --- Timer, chased.
playervar timer_pause                        # float                     --- time in spectate/invincible, chased
playervar timer_practice
playervar timer_split                         # int                       --- stored time that the split compares to
playervar timer_splitDisplay                      # int                       --- displayed split value
#playervar timer_splitsOn                         # bool                      --- turning splits on/off is now done via seting splittime to -Math.INFINITY

playervar toggle_invincible                  # bool                       --- invincible/normal mode toggle now a bool
playervar toggle_spectate                    # bool                       --- turned into bool
playervar toggle_practice                    # int                       --- turned into bool
playervar toggle_quickRestart                # bool                      -- enable reload to restart cp
playervar toggle_guide                       # bool                       --- turned into bool, shows/hides editor hud
playervar toggle_leaderboard                 # bool                      --- show/hide leaderboard
playervar toggle_invisible                             # bool                      --- invis toggle added by fisho
playervar toggle_hints

playervar editor_on                          # bool                      --- on all players, but only gets checked from host player
playervar editor_modeSelect                 # int                       --- EditMode - 1 checkpoint | 2 Killing sphere | 3 Bouncing ball
playervar editor_fly                         # vector/null               --- null if not flying, else vector position, added by fisho
playervar editor_saveHud                        # array                     --- array of save map hud ids
playervar editor_undo
playervar editor_lock                        # bool                      --- ensure only 1 editor command can go of at the time
playervar editor_hitboxEffect
playervar editor_hitboxToggle

playervar skill_countBhops                         # int                       --- counts bhops used for stand create ban
playervar skill_countJumps                         # int                       --- jump tracking count, 0, 1, 2
playervar skill_countCreates
playervar skill_countMulti                   # int                       --- climb count # for HUD
playervar WallclimbUsed                     # bool                      --- turned into bool
playervar BhopUsed                          # bool                      --- turned into bool
playervar DoubleUsed                        # bool

playervar banString                         # str                       --- displayed bans
#playervar ban_triple
#playervar ban_dashStart
playervar ban_multi
playervar ban_create
playervar ban_dead
playervar ban_emote
playervar ban_climb
playervar ban_bhop
playervar ban_standcreate                   # bans on second hop
playervar ban_djump
playervar ban_savedouble

playervar Temp
playervar LockCollected                     # number                    --- amount collected lock this cp
playervar bounceTouched                     # int                       --- cache of the bouncepad id you are currently touching
playervar bounceLastTouched
#playervar PortalLoop                       # int                       --- loop to select portal
playervar PortalStart_Cache
playervar PortalEnd_cache
playervar BounceLockMax_Cache
playervar KillPosition_Cache
playervar KillRadii_Cache
playervar BouncePosition_Cache
playervar BounceStrength_Cache
playervar BounceUlt_Cache
playervar BounceDash_Cache
playervar BounceLock_Cache
playervar BounceIndex_Cache
playervar KillIndex_Cache

playervar CompDone                          # bool                      --- out of atemps or time?
playervar AttemptCount                      # int                       --- amound of attemps remaining
playervar instructionhud

playervar ult_cd_global                     # int                       --- tracks cd for ult even if rule restarts the waits
playervar BhopHUDColor                      # Color                     --- Color for Bhop HUD
playervar HUDInputs
playervar finishfxcache                     # color                     --- color of fx after finish the map

playervar PreviewsArray2
playervar PreviewsArray                     # array                     --- store preview positions
playervar PreviewsI                         # int                       --- preview itterator

playervar TitleStore                        # textid                    --- store curent  title textid
playervar LedgeDash
######################################## Subroutines ##########################
subroutine StartGame
#subroutine KILLBALL
#subroutine pinball
#subroutine PortalCreate
subroutine EffectsCreate
subroutine Leaderboardupdate # fishos
subroutine CreateLeaderBoard
subroutine UpdateTitle
subroutine DashUltGive
subroutine CheckUlt
subroutine CheckDash
subroutine DeleteSave
subroutine MakeSave
subroutine StartPauseTimer
subroutine StopPauseTimer
subroutine editupdateselectedids
subroutine EditorSelectLast
subroutine TriggerOnFailSuccesReset
subroutine CheckMap

######################################## Enums ################################
enum HO:
    # Left #####################
    data_name = -200,
    data_code,
    data_dsc,
    edit_savemap,

    game_timer,
    game_split_display,
    game_bhop,
    game_climb,
    game_input,

    edit_orblimit,
    edit_selecteddata,
    edit_orb_ult,
    edit_orb_dash,
    edit_orb_lock,

    leftend,
    # Top #####################
    edit_clearec1,
    edit_clearec2,
    edit_clearec3,

    comp_info,
    comp_instructtop,
    comp_instruct1,
    comp_instruct2,
    comp_instruct3,
    comp_instruct4,
    comp_instructbottom,

    edit_changemode,
    edit_host_mode,
    data_dif,
    game_level_orb,
    com_previewsub,

    filler_custommsg,
    add_custommsg1,
    add_custommsg2,
    add_custommsg3,

    board_header,
    board_display1,
    board_display2,
    board_display3,
    board_display4,

    fillermain, # push skirmish etc down
    topend,
    # Right #####################
    data_remaingtime,

    com_restart_n_board,
    com_invincible,
    com_quickres,
    com_spec,
    com_invis,
    com_displaytoggle,
    com_splits,

    com_preview,
    #com_previewsub,
    com_practice,
    com_practicesub,
    com_hints,

    edit_instructions_general,
    edit_instructions_general1,
    edit_instructions_edit,
    edit_instructions_edit1,
    edit_instructions_edit2,
    edit_instructions_edit3,
    edit_instructions_edit4,
    edit_instructions_edit5,

    wr,
    board_top5,

    rightend,
    # End #####################

enum customize: # always add new options on end so previously configured colors dont mess up
    credit_name,
    credit_code,
    servertime,
    time,
    level,
    command_normal,
    command_highlight,
    bhopclimb_available,
    bhopclimb_used,

    ring_current,
    ring_next,
    shaft,
    nexticon_color,
    cometext,
    killorb,
    orb_normal,
    orb_lock,
    portal,
    dsc,