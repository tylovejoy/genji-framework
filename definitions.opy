#!mainFile "genji.opy"

##!define RestartTimer(timeInMinutes) "{0} Hours and {1} Minutes".format(floor(timeInMinutes / 60 / 60), "{0}{1}".format(floor(timeInMinutes % 60 / 10), floor(timeInMinutes % 60 - floor(timeInMinutes % 60 / 10) * 10)))

##!define prettyTime(timeInSeconds) "{0}:{1}".format(floor(timeInSeconds / 60), "{0}{1}.{2}".format(floor(timeInSeconds % 60 / 10), floor(timeInSeconds % 60 - floor(timeInSeconds % 60 / 10) * 10), "{0}{1}".format("" if floor((timeInSeconds % 1) * 100) >= 10 else "0", floor((timeInSeconds % 1) * 100))))
##!define prettyTime(timeInSeconds) "{0} sec".format(timeInSeconds)
#!define prettyTime(timeInSeconds) "{0} {1}".format(timeInSeconds,"秒"  checkCN "sec")

#!define insert(insert_array, insert_index, insert_value)  insert_array.append(insert_value) \
        insert_array = [elementhere if i < insert_index else insert_array.last() if i == insert_index else insert_array[i - 1] for elementhere, i in insert_array]

# check if cn client
/*
#!define checkCN if any([ \
        "{0}".format(Color.ROSE) == "玫红", \
        l"No" == "不行",  \
        l"Capture" ==  "夺取",    # 捕捉cn \
        l"Capture" == "捕捉"  # 捕捉 tw  check \
    ]) else
*/

#!define checkCN if l"Capture" == "捕捉" or l"Capture" == "捕捉" or "{0}".format(Color.ROSE) == "玫红" else

##!define FILLER rule "Addon settings are on next page! Click the next page button!":\

##!define FILLER rule "Map data and addon settings are on page 2 !!!!!!!!!!!!!!!!!!!":\
#!define FILLER rule "Map data and addon settings are on page 2 - 地图数据和附加组件的设置在第2页":\
    @Delimiter\
    #@Disabled

# ----------------GLOBAL------------------
#!define CheckpointPositions A
#!define SelectedCheckpoint_Editing B
#!define CheckpointRings_Editing C 
#3 MsDestructo
#4 TimeRemaining
#!define Portal1PlayerList F
#!define Portal2PlayerList G
#!define KillBallPositions H
#!define KillBallRadii I
#!define SelectedKillball_Editing J
#!define KillBallEffects K
#!define KillBallChase L
#!define BladeEnabledCheckpoints Dao
#!define DashEnabledCheckpoints SHIFT
#14 O
#!define ListPlayersAtCheckpoints P
#!define ActivePlayers Q
#17 R
#Bounce Pad editing stuff
#!define BouncePositions TQ
#!define CurrentBounce_Editing TQ1
#!define BounceEffects TQ2
#!define CurrentBouncePosition_Editing TQ3
#!define BounceStrength EditMode
#!define BounceToggleUlt TQ5
#!define BounceToggleDash TQ6

#!define KillballCheckpoints killballnumber
#!define BouncePadCheckpoints pinballnumber
#!define DeathBhopBan deathjump
#29
#!define SavedProgress save
##!define toplistPlayers toplistPlayers
##!define toplistTimes toplistTimes
##!define toplistSortedTimes toplistSortedTimes
#!define BhopBanToggle kaxiaotiao
#36
#37
#!define TempIterator1 NANBA


# ----------------PLAYER------------------
#!define CurrentCheckpoint A
##!define PlayerEffects B
#!define InvincibleToggle C
#!define Timer D
#!define EditModeSelection E
#!define SpectateToggle F
#6 ArrayIterator
#!define PortalText H
#8 MapVectorArray
#!define WallclimbUsed J
#!define GuideToggle K
#11 L
#!define PauseTimer ztjs
#13
#!define BhopUsed O
#15
#16 PracticeCheckpoint
#17 PracticeToggle
#18
#!define LeaderboardTimerCapture T
#20
#21
#22
#23
#24
#25
#!define JumpCount TY
#27
#!define MultiClimbCountHUD paqiang   
#29
#30
#!define QuickRestartToggle quick_restart     
#!define MultiClimbCount climbNum        
           
#!define BhopHUDColor CH           


# ----------------SUBS------------------
#!define StartGame_Sub Sub1
##!define KILLBALL KILLBALL
##!define pinball pinball





#Global variables
globalvar CheckpointPositions 0             # list[vect | list[vect]]   --- sometimes nested - 0 original end, 1 teleported
globalvar SelectedCheckpoint_Editing 1 # legacy      # int                       --- selected checkpoint
globalvar CheckpointRings_Editing 2         # list[effect]              --- Holds checkpoint effects in editing context
globalvar MsDestructo 3                     # MsDestructo Player
globalvar TimeRemaining 4
#globalvar Portal1PlayerList 5               # list[player]              --- players who can see portal 1
#globalvar Portal2PlayerList 6               # list[player]              --- players who can see portal 2
globalvar KillBallPositions 7               # list[vect]                --- KillBall position
globalvar KillBallRadii 8                   # list[float]               --- KillBall radius, default 5
globalvar SelectedKillball_Editing 9        # int                       --- Current killball in editing context
globalvar KillBallEffects 10                # list[effect]              --- Array holding killball effects
globalvar KillBallChase 11                  # vect                      --- Location of killball while editing, chased.
globalvar BladeEnabledCheckpoints 12        # int                       --- blade enabled, should be bool.
globalvar DashEnabledCheckpoints 13         # int                       --- dash enabled, should be bool.
globalvar ListPlayersAtCheckpoints 15       # list[list[player]]        --- players at a specific checkpoint
#globalvar ActivePlayers 16                  # list[player]              --- Active players, Non-saved, non-spectating active players
#globalvar EditorOn 17                       # bool                      --- editor rules enabled?

#Bounce Pad editing stuff
globalvar BouncePositions 18                # list[vect]                --- list of bouncepad positions
globalvar CurrentBounce_Editing 19          # int                       --- count of 0-indexed bouncepad pos currently
globalvar BounceEffects 20                  # list[effects]             --- list of bounce pad effect entities
globalvar CurrentBouncePosition_Editing 21  # vect                      --- the position we just added to bouncepad positions
globalvar BounceStrength 22                 # list[float]               --- bouncepad strength
globalvar BounceToggleUlt 23                # list[bool]                --- toggle ult on bounce
globalvar BounceToggleDash 24               # list[bool]                --- toggle dash on bounce
globalvar BounceToggleLock 25               # list[bool]                --- lock cp if not collected bounce

globalvar KillballCheckpoints 26            # list[list[int]]           --- 2d list of checkpoints that havea kill ball [[0], [3]]
globalvar BouncePadCheckpoints 27           # list[list[int]]           --- 2d list like killballnumber

# old save progresion, removed but kept in here for legacy pasta purposes
globalvar SavedProgress 30                  # list[Any]                 --- saves player data in array for rejoining, sequential data

# Leaderboard stuff
#globalvar toplistPlayers 32
#globalvar toplistTimes 33
#globalvar toplistSortedTimes 34
globalvar LeaderBoardFull 32                # [[name,second,prettytime]]--- sorted list of 0-19 leaderboard entries
globalvar LeaderBoardHuds 33
globalvar LeaderBoardRemake 34              # bool                      --- indicate board needs remaking
globalvar BhopBanToggle 35                  # bool                      --- Enabled if Bhop is banned
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
globalvar instructiontext 56                # [text]                    --- array of instructions
globalvar TitleData 57                      # [[cp ,[title],[color]]    --- title addon 
globalvar HudStoreEdit 58                   # [textid]                  --- list of huds to delete if editormode is on

globalvar SaveName 60
globalvar SaveCp 61
globalvar SaveEnt 62
globalvar SaveTimer 63
globalvar SaveElapsed 64
globalvar SavePauseTime 65
globalvar SavePauseEnabled 66

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

globalvar BanTriple 80
globalvar BanMulti 81
globalvar BanCreate 82
globalvar BanDead 83
globalvar BanEmote 84
globalvar BanClimb 85
globalvar BanBhop 86

globalvar DestructoIter 90
globalvar MapVectorArray 91

#Player variables
playervar CurrentCheckpoint 0               # int                       --- Current Checkpoint

#PlayerEffects data
#0 - Current ring, 
#1 - Next ring, 
#2 - Next lightshaft, 
#3 - Next arrow icon, 
#4 - Next "Come here" text
#playervar PlayerEffects 1                   # list[effect]              --- Player effect data array  
playervar InvincibleToggle 2                # bool                       --- invincible/normal mode toggle now a bool
playervar Timer 3                           # float                     --- Timer, chased.
playervar EditModeSelection 4               # int                       --- EditMode - 1 checkpoint | 2 Killing sphere | 3 Bouncing ball
playervar SpectateToggle 5                  # bool                       --- turned into bool
#playervar ArrayIterator 6                   # MsDestructo Iterator
#playervar PortalText 7                      # In-World Text             --- Portal String inworld text
#playervar MapVectorArray 8                  # MsDestructo Vectors
playervar isCN 6                            # bool                      --- is the player on chinese client

playervar WallclimbUsed 9                   # bool                      --- turned into bool
playervar GuideToggle 10                    # bool                       --- turned into bool, shows/hides editor hud
playervar LockState 11                      # bool                      --- locked means you are curently runing arrive checkpoint rule
playervar PauseTimer 12                     # float                     --- time in spectate/invincible, chased
playervar Temp 13
playervar BhopUsed 14                       # bool                      --- turned into bool
playervar MovedCheckpoint 15
playervar PracticeCheckpoint 16             # int                       --- Saved practice checkpoint
playervar PracticeToggle 17                 # int                       --- turned into bool
playervar LeaderboardToggle 19              # bool                      --- show/hide leaderboard
playervar NotOnLastCp 20                    # bool                      --- false if you are noton the last cp or level below 2 cps
playervar JumpCount 26                      # int                       --- jump tracking count, 0, 1, 2
playervar MultiClimbCountHUD 28             # HUD                       --- climb counter
playervar QuickRestartToggle 31             # bool                      -- enable reload to restart cp
playervar MultiClimbCount 32                # int                       --- climb count # for HUD

playervar finishfxcache  33                   # color                     --- color of fx after finish the map
playervar PreviewsArray 38                  # array                     --- store preview positions
playervar PreviewsI 39                      # int                       --- preview itterator
playervar invis 40                          # bool                      --- invis toggle added by fisho
playervar flytoggle 41                      # vector/null               --- null if not flying, else vector position, added by fisho
playervar savemaphud 42                     # array                     --- array of save map hud ids
#playervar TracesOff 43                      # bool                      --- turn traces (ring explosion fx) off
playervar EditorOn 45                       # bool                      --- on all players, but only gets checked from host player
playervar LockCollected 46                  # number                    --- amount collected lock this cp
playervar bouncetouched 47                  # int                       --- cache of the bouncepad id you are currently touching
playervar PortalLoop 48                     # int                       --- loop to select portal

playervar BounceLockMax_Cache 49
playervar KillPosition_Cache 50
playervar KillRadii_Cache 51
playervar BouncePosition_Cache 52
playervar BounceStrength_Cache 53
playervar BounceUlt_Cache 54
playervar BounceDash_Cache 55
playervar BounceLock_Cache 56
playervar BounceIndex_Cache 57
playervar KillIndex_Cache 58
playervar bouncetouchedlast 59 

playervar EffectSizeArray 60
playervar EffectSizeToggle 61
playervar CompDone 65                       # bool                      --- out of atemps or time?
playervar AttemptCount 66                   # int                       --- amound of attemps remaining
playervar instructionhud 67
playervar TitleStore 68                     # textid                    --- store curent  title textid

playervar banstring 70                      # str                       --- displayed bans
playervar ban_triple 71
playervar ban_multi 72
playervar ban_create 73
playervar ban_dedhop 74
playervar ban_dashstart 75
playervar ban_emote 76
playervar ban_climb 77
playervar ban_bhop 78

playervar splittime 79 
playervar splitdisplay 80
playervar splitson 81
playervar practicetimer 82

playervar BhopHUDColor 85                   # Color                     --- Color for Bhop HUD


#Subroutine names
subroutine StartGame_Sub 1
subroutine KILLBALL 3
subroutine pinball 4
subroutine BuildPortals 5
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
    com_splits,

    com_preview,
    com_previewsub,
    com_practice,
    com_practicesub,

    edit_instructions_general,
    edit_instructions_edit,

    wr,
    board_top5,

    rightend,
    # End #####################