#!mainFile "genji.opy"

##!define RestartTimer(timeInMinutes) "{0} Hours and {1} Minutes".format(floor(timeInMinutes / 60 / 60), "{0}{1}".format(floor(timeInMinutes % 60 / 10), floor(timeInMinutes % 60 - floor(timeInMinutes % 60 / 10) * 10)))

##!define prettyTime(timeInSeconds) "{0}:{1}".format(floor(timeInSeconds / 60), "{0}{1}.{2}".format(floor(timeInSeconds % 60 / 10), floor(timeInSeconds % 60 - floor(timeInSeconds % 60 / 10) * 10), "{0}{1}".format("" if floor((timeInSeconds % 1) * 100) >= 10 else "0", floor((timeInSeconds % 1) * 100))))
#!define prettyTime(timeInSeconds) "{0}".format(eventPlayer.Timer)

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
#!define PlayerEffects B
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
#17
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
#!define CheckpointEffect_Sub Sub0
#!define StartGame_Sub Sub1
##!define KILLBALL KILLBALL
##!define pinball pinball





#Global variables
globalvar CheckpointPositions 0             # list[vect | list[vect]]   --- sometimes nested - 0 original end, 1 teleported
globalvar SelectedCheckpoint_Editing 1      # int                       --- selected checkpoint
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

globalvar KillballCheckpoints 26            # list[list[int]]           --- 2d list of checkpoints that havea kill ball [[0], [3]]
globalvar BouncePadCheckpoints 27           # list[list[int]]           --- 2d list like killballnumber
globalvar DeathBhopBan 28               # bool                      --- Ban bhop from reset

# sequential data
#0 eventPlayer, 
#1 current checkpoint, 
#2 timer gets stored here, 
#3 eventPlayer stored, 
#4 totalElapsedTime , 
#5 PausedTimer amount, 
#6 bool timer paused
globalvar SavedProgress 30                  # list[Any]                 --- saves player data in array for rejoining, sequential data

# Leaderboard stuff
#globalvar toplistPlayers 32
#globalvar toplistTimes 33
#globalvar toplistSortedTimes 34
globalvar LeaderBoardFull 32                # [[name,second,prettytime]]--- sorted list of 0-19 leaderboard entries

globalvar BhopBanToggle 35                  # bool                      --- Enabled if Bhop is banned
globalvar TempIterator1 38                  # int                       --- temp iterator

globalvar DashExploitToggle 39


globalvar PortalNames 40                    # [str]                     --- display name of portals
globalvar PortalLoc 41                      # [vect]                    --- portal position
globalvar PortalDest 42                     # [vect]                    --- portal destination
globalvar PortalOn 43                       # bool                      --- portals enabled
#Player variables

playervar CurrentCheckpoint 0               # int                       --- Current Checkpoint

#PlayerEffects data
#0 - Current ring, 
#1 - Next ring, 
#2 - Next lightshaft, 
#3 - Next arrow icon, 
#4 - Next "Come here" text
playervar PlayerEffects 1                   # list[effect]              --- Player effect data array  
playervar InvincibleToggle 2                # int                       --- invincible/normal mode toggle, should be bool
playervar Timer 3                           # float                     --- Timer, chased.
playervar EditModeSelection 4               # int                       --- EditMode - 1 checkpoint | 2 Killing sphere | 3 Bouncing ball
playervar SpectateToggle 5                  # int                       --- Spectate Toggle, should be bool
playervar ArrayIterator 6                   # MsDestructo Iterator
playervar PortalText 7                      # In-World Text             --- Portal String inworld text
playervar MapVectorArray 8                  # MsDestructo Vectors
playervar WallclimbUsed 9                   # int                       --- 1 if wall climb has been used 2 if not, should be bool
playervar GuideToggle 10                    # int                       --- Guide Enabled (1) /Disabled (2), should be bool

playervar PauseTimer 12                     # float                     --- time in spectate/invincible, chased
playervar BhopUsed 14                       # int                       --- Bhop has been used 1, 0 if not, should be bool
playervar PracticeCheckpoint 16             # int                       --- Saved practice checkpoint
#playervar LeaderboardTimerCapture 19        # float                     --- Saves players time for leaderboard
playervar LeaderboardToggle 19              # bool                      --- show/hide leaderboard
playervar JumpCount 26                      # int                       --- jump tracking count, 0, 1, 2
playervar MultiClimbCountHUD 28             # HUD                       --- climb counter
playervar QuickRestartToggle 31             # int                       --- If quick restart is enabled or not, should be bool
playervar MultiClimbCount 32                # int                       --- climb count # for HUD
playervar invis 40                          # bool                      --- invis toggle added by fisho
playervar flytoggle 41                      # vector/null               --- null if not flying, else vector position, added by fisho
playervar savemaphud 42                     # array                     --- array of save map hud ids
playervar TracesOff 43                      # bool                      --- turn traces (ring explosion fx) off
playervar EditorOn 45                       # bool                      --- on all players, but only gets checked from host player
playervar BhopHUDColor 85                   # Color                     --- Color for Bhop HUD


#Subroutine names

subroutine CheckpointEffect_Sub 0
subroutine StartGame_Sub 1
subroutine KILLBALL 3
subroutine pinball 4
subroutine Leaderboardupdate # fishos
