#!mainFile "genji.opy"

#Global variables

globalvar CheckpointPositions 0 # Checkpoint Positions
globalvar B__ 1 # Current checkpoint in Editing context, maybe just a TempIterator count
globalvar CheckpointRings_Editing 2 # Holds checkpoint effects in editing context (shows all ?)
globalvar DVA 3
globalvar dva 4
globalvar Portal1PlayerList 5 # portal1 player list (visiblility)
globalvar Portal2PlayerList 6 # portal2 player list (visiblility)
globalvar KillBallPositions 7 # KillBall position
globalvar KillBallRadii 8 # KillBall radius
globalvar J__ 9 #  Current checkpoint in editing context? whats difference between B and J
globalvar KillBallEffects 10 # Array holding killball effects
globalvar KillBallChase 11 # Kill sphere temp chase lpcation?
globalvar Dao__ 12 # Dash Enabled for Checkpoint what difference?
globalvar SHIFT__ 13 # If Dash is enabled for the checkpoint whats difference?
globalvar SUPERJUMP_unused 14 # UNUSED
globalvar ListPlayersAtCheckpoints 15  # 2d array checkpoints for index with a list of players at each checkpoint
globalvar ActivePlayers 16 # I think this is just arr of active players. Non-saved, non-spectating active players
globalvar R_unused 17 # UNUSED

# Killball/Bounce Pad editing stuff
globalvar TQ__ 18
globalvar TQ1__ 19
globalvar TQ2__ 20
globalvar TQ3__ 21
globalvar EditMode__ 22
globalvar TQ5__ 23
globalvar TQ6__ 24

 
globalvar TimeLimitSettingToggle_ 25 # level time limit ? ws setting
globalvar KillballCheckpoints 26 # 2d list of checkpoints that havea kill ball [[0], [3]]
globalvar BouncePadCheckpoints 27 # 2d list like killballnumber
globalvar BhopBanFromReset 28 # Ban bhop from reset
globalvar SavedProgress 30 # saves player data in array for rejoining, sequential data.... should probably be 2d list

# Leaderboard stuff
globalvar toplistPlayers 32
globalvar toplistTimes 33
globalvar toplistSortedTimes 34


globalvar BhopBanToggle 35 # Enabled if Bhop is banned
globalvar TempIterator1 38 # This seems like a tru TempIterator rather than B


#Player variables

playervar A__ 0  # Current Checkpoint ??
playervar PlayerEffects 1  # Player effect data array 0 - Cur Checkpoint Ring, 1 - Next CP ring, 2 - Lightshaft at next CP, 3 - Arrow icon, 4 - "Come here" text 
playervar InvincibleToggle 2  # i thikn this is invincible/normal mode toggle
playervar D__ 3  # Timer
playervar EditModeSelection 4  # EditMode 2 Killing sphere | 3 Bouncing ball | 1 checkpoint
playervar SpectateToggle 5  # SpectateToggle
playervar G_unused 6  # unused?
playervar PortalText 7  # Portal String inworld text
playervar I_unused 8  # Unused ? Comment says tutorial HUD set to 2
playervar J__ 9  # "Climbing the wall prompt" HUD set to 2, multiclimb hud start ?
playervar GuideToggle 10  # Guide Enabled (1) /Disabled (2)
playervar L__ 11  # Time trial-like checkpoint?
playervar TimelimitTimer__ 12 # Timer (countdown?) for time limit
playervar BhopUsed 14 # Bhop has been used 1, 0 if not
playervar LeaderboardTimerCapture 19 # Leaderboard Timer capture
playervar TY__ 26 # some kind of tracking for bhop/multi jumps
playervar MultiClimbCountHUD 28 # climb counter . HUD entity
playervar QuickRestartToggle 31 # If quick restart is enabled or not
playervar MultiClimbCount 32  # climb counter # for HUD
playervar BhopHUDColor 85 # Color for Bhop HUD
playervar HUB_DOTS_INDEX 117 # never true? never init. shows "wall climb" text. debug text most likely


#Subroutine names

subroutine CheckpointEffect_Sub 0
subroutine StartGame_Sub 1
subroutine KILLBALL 3
subroutine pinball 4

