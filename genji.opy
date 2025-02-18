#!define versionhere "1.10.2♨C"
#♨ Dev Build Icon

#!define editortoggle(x) __script__("test-maps/togglescript.js")
editortoggle(0) # 0 is editor, rest is numbers
# Disable via double ## at include, not the define because the define needs to exist
#!define testToggle ##!include "test-scripts.opy"

# Supress warning for emote
#!suppressWarnings w_ow2_communicate_bug
#disable overpy map detection (command removed by zezy after fix by blizzard)
# #!disableMapDetectionFix

################################################################################

#!include "settings.opy"

#!include "definitions.opy"

################################################################################

rule FILLER:
    @Delimiter

rule "<tx0C00000000001344> General Functions <tx0C00000000001344>":
    @Delimiter

def UpdateCache():
    @Name "SUB | Update Effect Cache"
    # note: if adding cp pos to cache, make sure to also adjust editor things like move and teleport
    eventPlayer.BouncePosition_Cache = [_ for _, i in BouncePositions if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceStrength_Cache = [_ for _, i in BounceStrength if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceUlt_Cache = [_ for _, i in BounceToggleUlt if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceDash_Cache = [_ for _, i in BounceToggleDash if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceLock_Cache = [_ for _, i in BounceToggleLock if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceLockMax_Cache = len([i for i in eventPlayer.BounceLock_Cache if i])    
    eventPlayer.KillPosition_Cache = [_ for _, i in KillBallPositions if KillballCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.KillRadii_Cache = [_ for _, i in KillBallRadii if KillballCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.PortalStart_Cache = [_ for _, i in CustomPortalStart if CustomPortalCP[i] == eventPlayer.CurrentCheckpoint or CustomPortalCP[i] == Math.INFINITY]
    eventPlayer.PortalEnd_cache = [_ for _, i in CustomPortalEndpoint if CustomPortalCP[i] == eventPlayer.CurrentCheckpoint or CustomPortalCP[i] == Math.INFINITY]
    eventPlayer.NotOnLastCp = (eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1 and len(CheckpointPositions) > 1)
    eventPlayer.HintsOn = false
    eventPlayer.banstring = []
    wait()
    if not eventPlayer.NotOnLastCp:
        eventPlayer.ban_multi = true if createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Multiclimb - 封禁蹭留", false, 1) else eventPlayer.CurrentCheckpoint in BanMulti
        if eventPlayer.ban_multi:
            eventPlayer.banstring = "∞ {}".format(eventPlayer.banstring)

        eventPlayer.ban_create = true if createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Createbhop - 封禁卡小", false, 2) else eventPlayer.CurrentCheckpoint in BanCreate
        if eventPlayer.ban_create:
            eventPlayer.banstring = "♂ {}".format(eventPlayer.banstring)

        eventPlayer.ban_standcreate = true if createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)","ban standcreate - 封禁站卡", false, 3) else eventPlayer.CurrentCheckpoint in BanStand
        if eventPlayer.ban_standcreate:
            eventPlayer.banstring = "♠ {}".format(eventPlayer.banstring) # ≥  √ ▼ ↓

        eventPlayer.ban_dedhop = true if createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Deathbhop - 封禁死小", false, 4) else eventPlayer.CurrentCheckpoint in BanDead
        if eventPlayer.ban_dedhop:
            eventPlayer.banstring = "X {}".format(eventPlayer.banstring)

        eventPlayer.ban_emote = true if createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Emote Savehop - 封禁表情留小", false, 5) else eventPlayer.CurrentCheckpoint in BanEmote
        if eventPlayer.ban_emote:
            eventPlayer.banstring = "♥ {}".format(eventPlayer.banstring)

        eventPlayer.ban_climb = true if createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Wallclimb - 封禁爬墙", false, 6) else eventPlayer.CurrentCheckpoint in BanClimb
        if eventPlayer.ban_climb:
            eventPlayer.banstring = "↑ {}".format(eventPlayer.banstring)

        eventPlayer.ban_savedouble = true if createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban save double - 封禁延二段跳", false, 7) else eventPlayer.CurrentCheckpoint in BanSaveDouble
        if eventPlayer.ban_savedouble:
            eventPlayer.banstring = "△ {}".format(eventPlayer.banstring)

        eventPlayer.ban_bhop = true if createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)","require bhop available - 留小跳进点 ", false, 8) else eventPlayer.CurrentCheckpoint in BanBhop
        if eventPlayer.ban_bhop:
            eventPlayer.banstring = "≥ {}".format(eventPlayer.banstring) # ≥  √ ▼ ↓

        eventPlayer.ban_djump = true if createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)","require djump available - 留二段跳 ", false, 9) else eventPlayer.CurrentCheckpoint in BanDjump
        if eventPlayer.ban_djump:
            eventPlayer.banstring = "» {}".format(eventPlayer.banstring) # ≥  √ ▼ ↓ ︽
    else:
        eventPlayer.ban_multi = false
        eventPlayer.ban_create = false
        eventPlayer.ban_standcreate = false
        eventPlayer.ban_dedhop = false
        eventPlayer.ban_emote = false
        eventPlayer.ban_climb = false
        eventPlayer.ban_savedouble = false
        eventPlayer.ban_bhop = false
        eventPlayer.ban_djump = false
    wait()
    async(CheckUlt(), AsyncBehavior.RESTART)
    async(CheckDash(), AsyncBehavior.RESTART)    

    if not eventPlayer.EditorOn: return

    editupdateselectedids()

    destroyEffect(eventPlayer.EffectSizeArray)
    eventPlayer.EffectSizeArray = []
    createEffect(eventPlayer if eventPlayer.EffectSizeToggle else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint], cpcircleradius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.EffectSizeArray.append(getLastCreatedEntity())
    createEffect(eventPlayer if eventPlayer.EffectSizeToggle and eventPlayer.NotOnLastCp else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], cpcircleradius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.EffectSizeArray.append(getLastCreatedEntity())

    eventPlayer.BounceIndex_Cache = [e for e in [(i if e2 == eventPlayer.CurrentCheckpoint else -1) for e2, i in BouncePadCheckpoints] if  e >=0]
    eventPlayer.KillIndex_Cache = [e for e in [(i if e2 == eventPlayer.CurrentCheckpoint else -1) for e2, i in KillballCheckpoints] if  e >=0]

    if eventPlayer.MovedCheckpoint and eventPlayer == hostPlayer:
        EditorSelectLast()
        eventPlayer.MovedCheckpoint = false     

def DeleteSave():
    @Name "SUB | Delete Save" 
    del SaveName[SaveEnt.index(eventPlayer)]
    del SaveCp[SaveEnt.index(eventPlayer)]
    del SaveTimer[SaveEnt.index(eventPlayer)]
    del SaveElapsed[SaveEnt.index(eventPlayer)]
    del SavePauseTime[SaveEnt.index(eventPlayer)]
    del SavePauseEnabled[SaveEnt.index(eventPlayer)]
    del SaveEnt[SaveEnt.index(eventPlayer)] # must always be last because its the index itself

def MakeSave():
    @Name "SUB | Make Save"
    SaveName.append("{}".format(eventPlayer))
    SaveCp.append(eventPlayer.CurrentCheckpoint)
    SaveTimer.append(eventPlayer.Timer)
    SaveEnt.append(eventPlayer)
    SaveElapsed.append(getTotalTimeElapsed())
    SavePauseTime.append(0)
    SavePauseEnabled.append(false)

def StartPauseTimer():
    @Name "SUB | Start Pause Timer"
    chase(eventPlayer.PauseTimer, Math.INFINITY, rate=1, ChaseReeval.NONE)
    SaveTimer[SaveEnt.index(eventPlayer)] = eventPlayer.Timer
    SaveElapsed[SaveEnt.index(eventPlayer)] = getTotalTimeElapsed()
    SavePauseEnabled[SaveEnt.index(eventPlayer)] = true

def StopPauseTimer():
    @Name "SUB | Stop Pause Timer"
    stopChasingVariable(eventPlayer.PauseTimer)
    SavePauseTime[SaveEnt.index(eventPlayer)] = eventPlayer.PauseTimer
    eventPlayer.PauseTimer = 0
    SavePauseEnabled[SaveEnt.index(eventPlayer)] = false

def CreateLeaderBoard():
    @Name "SUB | Leaderboard HUD"
    # turns into global rule so it doesnt delete when player leaves
    LeaderBoardRemake = false
    wait()
    LeaderBoardRemake = true
 
def Leaderboardupdate():
    @Name "SUB | Leaderboard Update"
    # [i[0] for i in var1]   list of first element of each in var 1
    # [ [name, seconds, prettytime] ]
    if "{0}".format(eventPlayer) in [i[0] for i in LeaderBoardFull]: # you already have a time
        if eventPlayer.Timer > [i for i in LeaderBoardFull if i[0] == "{0}".format(eventPlayer)][0][1]: # new time worse
            goto lbl_a
        else: # new time better
            LeaderBoardFull.remove( [i for i in LeaderBoardFull if i[0] == "{0}".format(eventPlayer)])
            LeaderBoardFull.append( [["{0}".format(eventPlayer),eventPlayer.Timer, prettyTime(eventPlayer.Timer)]] )
            CreateLeaderBoard()
    else: # you are not in list yet
        if len(LeaderBoardFull) < 20: # board has room for more
            LeaderBoardFull.append( [["{0}".format(eventPlayer),eventPlayer.Timer, prettyTime(eventPlayer.Timer)] ])
            CreateLeaderBoard()
        else: # 20 entries already
            if LeaderBoardFull[19][1] < eventPlayer.Timer:  # your time lower then last entry
                goto lbl_a
            else: # you beat the last entry, thus replacing it
                del LeaderBoardFull[19]
                LeaderBoardFull.append( [["{0}".format(eventPlayer),eventPlayer.Timer, prettyTime(eventPlayer.Timer)]] )
                CreateLeaderBoard()
    lbl_a:

def checkpointFailReset():
    @Name "SUB | Checkpoint Fail"
    eventPlayer.splittime = eventPlayer.practicetimer if eventPlayer.PracticeToggle else eventPlayer.Timer
    eventPlayer.LockCollected = []
    eventPlayer.cancelPrimaryAction()
    eventPlayer.DoubleUsed = null
    
    if eventPlayer.CurrentCheckpoint == 0 and not eventPlayer.PracticeToggle:
        eventPlayer.Timer = 0
        eventPlayer.splittime = 0
    
    if len(CheckpointPositions) > 0:
        eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)  
        if eventPlayer.isUsingAbility1() and DashExploitToggle:
            #smallMessage(eventPlayer,"   0关卡Shift已禁用!" checkCN "   Dash Start is banned!")
            eventPlayer.startForcingPosition(eventPlayer, false)
            waitUntil(not eventPlayer.isUsingAbility1(), DashExploitToggle)
            eventPlayer.stopForcingPosition()
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint].last())
        #After teleport incase stopForcingPosition launches the player
        eventPlayer.applyImpulse( -1 * eventPlayer.getVelocity(), 0.0001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

    /*
    if eventPlayer.ban_dedhop:
    # old: disallow jump > 0.1 sec wait > allow jump, this method bugs with ult check disabling ultimate for some reason
        wait(0.1) # finish teleport first     
        if eventPlayer.isHoldingButton(Button.JUMP):
            eventPlayer.forceButtonPress(Button.JUMP)
            eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed() + 0.1, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    # end new */

    if eventPlayer.isUsingUltimate():
        eventPlayer.setDamageReceived(100)
        kill(eventPlayer, null)
        eventPlayer.setDamageReceived(0)
        wait()

    async(CheckUlt(), AsyncBehavior.RESTART)
    async(CheckDash(), AsyncBehavior.RESTART)
    TriggerOnFailSuccesReset()

def StartGame():
    @Name "SUB | Start Game"
    if CompMode and (CompTime < 1 or eventPlayer.CompDone):
        eventPlayer.LeaderboardToggle = true
        eventPlayer.CompDone = true
        eventPlayer.disableRespawn()
        eventPlayer.setDamageReceived(100)
        kill(eventPlayer,null)
        eventPlayer.setDamageReceived(0)
        return
    
    /*if DashExploitToggle and len(CheckpointPositions)>0:
        eventPlayer.setAbility1Enabled(false)
        wait()
        if eventPlayer.isUsingAbility1():
            waitUntil(not eventPlayer.isUsingAbility1(), 1.5)
            smallMessage(eventPlayer,"   0关卡Shift已禁用!" checkCN "   Dash Start is banned!")            

    if eventPlayer.isUsingUltimate():
        eventPlayer.setDamageReceived(100)
        kill(eventPlayer, null)
        eventPlayer.setDamageReceived(0)*/
       
    if len(CheckpointPositions) != 0:
        destroyInWorldText(eventPlayer.TitleStore) # restarting reset title even if non on cp 0
        if "{0}".format(eventPlayer) in SaveName: # load saved progres
            SaveEnt[SaveName.index("{}".format(eventPlayer))] = eventPlayer
            eventPlayer.CurrentCheckpoint = SaveCp[SaveEnt.index(eventPlayer)]
            eventPlayer.Timer = SaveTimer[SaveEnt.index(eventPlayer)]
            SaveElapsed[SaveEnt.index(eventPlayer)] = getTotalTimeElapsed()
            SavePauseTime[SaveEnt.index(eventPlayer)] = 0
            SavePauseEnabled[SaveEnt.index(eventPlayer)] = false
            if TitleData != null and  any([i for i in TitleData[0] if i <= eventPlayer.CurrentCheckpoint]) and (not eventPlayer.EditorOn ): # if any title data, find last cp
                createInWorldText(
                    getAllPlayers() if not eventPlayer.invis else null,
                    TitleData[1][TitleData[0].index(
                    sorted([i for i in TitleData[0] if i <= eventPlayer.CurrentCheckpoint], lambda i:i*-1)[0])], 
                    eventPlayer,1.1,Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, 
                    TitleData[2][TitleData[0].index(sorted([i for i in TitleData[0] if i <= eventPlayer.CurrentCheckpoint], lambda i:i*-1)[0])], 
                    SpecVisibility.DEFAULT
                )
                eventPlayer.TitleStore = getLastCreatedText()
        else:
            eventPlayer.CurrentCheckpoint = 0
            eventPlayer.Timer = 0
            stopChasingVariable(eventPlayer.PauseTimer)
            eventPlayer.PauseTimer = 0
            MakeSave()
            UpdateTitle()
    
    chase(eventPlayer.Timer, Math.INFINITY, rate=1, ChaseReeval.NONE)
    UpdateCache()
    checkpointFailReset()
    eventPlayer.enableRespawn()
    eventPlayer.InvincibleToggle = false
    eventPlayer.SpectateToggle = false
    eventPlayer.MovedCheckpoint = true
    # eventPlayer.LockState = false

################################################################################

#!include "editor.opy"

#!include "commands.opy"

################################################################################

rule "<tx0C00000000001344> General Rules <tx0C00000000001344>":
    @Delimiter

rule "Setup and Variables":
    disableInspector()
    disableGamemodeCompletion()
    disableScoring()
    disableMusic()
    disableAnnouncer()
    startForcingSpawn(Team.ALL,  0)
    startForcingSpawn(Team.ALL,  1)
    startForcingSpawn(Team.ALL,  2)
    wait(0.024) # wait for map data rule
    
    # fix team because of naming
    if ColorConfig[customize.orb_lock] == Color.TEAM_1: 
        ColorConfig[customize.orb_lock] = Color.BLUE 
    elif ColorConfig[customize.orb_lock] == Color.TEAM_2:
        ColorConfig[customize.orb_lock] = Color.RED

    # prevent same color lock orbs
    if ColorConfig[customize.orb_normal] == ColorConfig[customize.orb_lock]:
        ColorConfig[customize.orb_lock] = Color.GREEN  if ColorConfig[customize.orb_normal] == Color.ORANGE else Color.ORANGE

    # prevent same color bhop/climb used/unused
    if ColorConfig[customize.bhopclimb_available] == ColorConfig[customize.bhopclimb_used]:
        ColorConfig[customize.bhopclimb_used] = Color.ORANGE if ColorConfig[customize.bhopclimb_available] == Color.RED else Color.RED

    SaveName = []
    SaveCp = []
    SaveTimer = []
    SaveEnt = []
    SavePauseTime = []
    SavePauseEnabled = []
    SaveElapsed = []

    if BladeEnabledCheckpoints == null and len(BladeEnabledCheckpoints) == 1:
        BladeEnabledCheckpoints = [0]
    else:
        BladeEnabledCheckpoints = BladeEnabledCheckpoints if len([i for i in BladeEnabledCheckpoints if i != -1 and i != [] ]) and BladeEnabledCheckpoints != null else []
    
    if DashEnabledCheckpoints == null and len(DashEnabledCheckpoints) == 1:
        DashEnabledCheckpoints = [0]
    else:
        DashEnabledCheckpoints =  DashEnabledCheckpoints if len([i for i in DashEnabledCheckpoints if i != -1 and i != [] ]) and DashEnabledCheckpoints != null  else  []

    BouncePadCheckpoints = BouncePadCheckpoints if len(BouncePadCheckpoints) else []
    CheckpointPositions = CheckpointPositions if len(CheckpointPositions) else []
    CheckpointPositions = CheckpointPositions if len(CheckpointPositions) else []
    KillballCheckpoints = KillballCheckpoints if len(KillballCheckpoints) else []
    KillBallPositions = KillBallPositions if len(KillBallPositions) else []
    KillBallRadii = KillBallRadii if len(KillBallRadii) else []
    KillBallEffects = KillBallEffects if len(KillBallEffects) else []
    BouncePositions = BouncePositions if len(BouncePositions) else []
    BounceEffects = BounceEffects if len(BounceEffects) else []
    BounceStrength = BounceStrength if len(BounceStrength) else []
    BounceToggleUlt = BounceToggleUlt if len(BounceToggleUlt) else []
    BounceToggleDash = BounceToggleDash if len(BounceToggleDash) else []
    BounceToggleLock = BounceToggleLock if len(BounceToggleLock) else []

    CustomPortalStart = CustomPortalStart if len(CustomPortalStart) > 0 else [] 
    CustomPortalEndpoint = CustomPortalEndpoint if len(CustomPortalEndpoint) > 0 else [] 
    CustomPortalCP = CustomPortalCP if len(CustomPortalCP) > 0 else [] 

    LeaderBoardFull = []
    TitleData = null
    PortalNames = []
    PortalLoc = []
    PortalDest  = []
    
    HintCp = []
    HintText = []

    wait(1)

    # clean out -1's after the ban has loaded
    BanBhop = [i for i in BanBhop if i != -1] if len(BanBhop) else []
    BanClimb = [i for i in BanClimb if i != -1] if len(BanClimb) else []
    BanEmote = [i for i in BanEmote if i != -1] if len(BanEmote) else []
    BanDead = [i for i in BanDead if i != -1] if len(BanDead) else []
    BanCreate = [i for i in BanCreate if i != -1] if len(BanCreate) else []
    BanMulti = [i for i in BanMulti if i != -1] if len(BanMulti) else []
    BanTriple = null #[i for i in BanTriple if i != -1] if len(BanTriple) > 0 else [] # legacy code, now auto sets it to null to save space
    BanStand = [i for i in BanStand if i != -1] if len(BanStand) else []
    BanSaveDouble = BanSaveDouble if len(BanSaveDouble) else []
    BanDjump = BanDjump if len(BanDjump) else []

    DashExploitToggle = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Dash Start - 0关卡Shift", true, 2)
    if createWorkshopSetting(bool,"map settings \n地图设置","Basic Map Validator - 验证地图", true, 3):
        async(CheckMap, AsyncBehavior.NOOP)
    PortalOn = createWorkshopSetting(bool, "map settings \n地图设置","enable portals (control maps) - 启用传送门 (占点地图)", true, 4)
    CompMode = createWorkshopSetting(bool, "Competitive mode\n竞赛模式","Turn on competitive mode - 开启竞赛模式" , compModeToggle , 100)
    if CompMode:
        # -! comp minutes !- 
        CompTime = createWorkshopSetting(int[1:240], "Competitive mode\n竞赛模式", "time limit (global) - 时间限制", compTimeLimit, 101) # 5-240
        # -! comp attempt count !- 
        CompAtmpNum = createWorkshopSetting(int[0:500], "Competitive mode\n竞赛模式", "attempt count - 尝试次数", attemptCount, 102) 
        # -! comp restartlimiter !-
        CompRestartLimit = createWorkshopSetting(bool, "Competitive mode\n竞赛模式","disable restart during run - 竞赛中禁用重新开始" , compRestartLimit , 103)
    else:
        instructiontext = null

    wait(1) # add back to below wait if removed

    if len(PortalDest) > 0: # pre set control map portals. not in portal rule because shared I variable
        for TempIterator1 in range(len(PortalLoc)):
            createEffect(
                [i for i in getAllPlayers() if i.InvincibleToggle or not i.NotOnLastCp],
                Effect.BAD_AURA, 
                Color.AQUA if evalOnce(TempIterator1) % 2 == 1 else Color.ORANGE,
                PortalLoc[evalOnce(TempIterator1)], 
                0.6,
                EffectReeval.VISIBILITY
            )
            createInWorldText(
                [i for i in getAllPlayers() if i.InvincibleToggle or not i.NotOnLastCp], 
                "{0}".format(PortalNames[evalOnce(TempIterator1)]), 
                PortalLoc[evalOnce(TempIterator1)] + vect(0,1,0), 
                1, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT
            )
    waitUntil(entityExists([i for i in getAllPlayers() if not i.isDummy()]),Math.INFINITY)
    wait(1)
    if not [i for i in getAllPlayers() if not i.isDummy()][0].EditorOn:
        EffectsCreate()
        return

    RebuildKillOrbs()
    RebuildBounceOrbs()
    RebuildPortals()

rule "Match time":
    if getCurrentGamemode() != Gamemode.SKIRMISH:
        wait(0.25)
        setMatchTime(1)
        wait(1.1)
        setMatchTime(1)
        wait(1.1)
        wait(10)
    
    setMatchTime(69)
    pauseMatchTime()
    wait(5)
    TimeRemaining = 265

    while TimeRemaining > 0:
        wait(60)
        TimeRemaining --
        if CompMode:
            CompTime --
            if CompTime == 0:
                bigMessage(getAllPlayers(),"时间到了" checkCN "time's up")
                getAllPlayers().CompDone = true
                stopChasingVariable(getAllPlayers().Timer)
                getAllPlayers().disableRespawn()
                getAllPlayers().setDamageReceived(100)
                kill(getAllPlayers(), null)
                wait(0.032)
                async(CreateLeaderBoard(), AsyncBehavior.RESTART)            

    bigMessage(localPlayer, "房间已达最大持续时间, 即将重启" checkCN "maximum lobby time expired, restarting")
    wait(5)
    if getCurrentGamemode() == Gamemode.FFA:
        declarePlayerVictory(hostPlayer)
    else:
        declareTeamVictory(hostPlayer.getTeam())

rule "Player Initialize":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    eventPlayer.setDamageReceived(0)
    eventPlayer.EditorOn = createWorkshopSetting(bool, "map settings \n地图设置","Editor mode - 作图模式" ,  editoron , -1) # Turn Editor On
    eventPlayer.LockEditor = true
    eventPlayer.preloadHero(Hero.GENJI)
    eventPlayer.GuideToggle = true
    eventPlayer.disableGamemodeHud()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.disablePlayerCollision()
    eventPlayer.WallclimbUsed = false #Climbing the wall prompts the HUD
    eventPlayer.JumpCount = 0
    eventPlayer.bouncetouchedlast = -1
    eventPlayer.bouncetouched = -1
    eventPlayer.PreviewsI = null
    #big waits first for about 1 second before loading, to make sure things like comp mode are fully loaded and configured, load fx in meanwhile
    wait(1) 
    eventPlayer.setRespawnTime(1)
    createEffect(eventPlayer, Effect.RING, ColorConfig[customize.ring_current], CheckpointPositions[eventPlayer.CurrentCheckpoint].last(), cpCirkleFx, EffectReeval.POSITION_AND_RADIUS)
    createEffect(eventPlayer if eventPlayer.NotOnLastCp  else null, Effect.RING, ColorConfig[customize.ring_next] , CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], cpCirkleFx, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(eventPlayer if eventPlayer.NotOnLastCp  else null, Effect.LIGHT_SHAFT, ColorConfig[customize.shaft], CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], cpCirkleFx, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createIcon(eventPlayer if eventPlayer.NotOnLastCp  else null, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1] + Vector.UP, Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, ColorConfig[customize.nexticon_color], true)

    waitUntil(eventPlayer.hasSpawned(), Math.INFINITY)
    eventPlayer.LockEditor = false

    if CompMode:
        eventPlayer.setInvisibility(Invis.ALL)
        if not "{0}".format(eventPlayer) in CompAtmpSaveNames: # instructions and settings for comp start
            eventPlayer.instructionhud = true
            CompAtmpSaveNames.append("{0}".format(eventPlayer))
            CompAtmpSaveCount.append(1)
            eventPlayer.AttemptCount = 1
            eventPlayer.setMoveSpeed(0)
            eventPlayer.setAbility1Enabled(false)
            eventPlayer.setUltEnabled(false)
            waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT),1)
            waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) or CompTime < 1, Math.INFINITY)
            eventPlayer.setMoveSpeed(100)
            eventPlayer.instructionhud = false
        else:
            eventPlayer.AttemptCount = CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))]
            #smallMessage(eventPlayer,"now {0}".format( eventPlayer.AttemptCount))
        if eventPlayer.AttemptCount == (-1) or CompTime < 1:
            eventPlayer.CompDone = true
    

    wait()
    StartGame()  # initialization of the game

rule "Arrive | Ground reset | traces":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isAlive()
    if not eventPlayer.NotOnLastCp:
        if (eventPlayer.isMoving() and not (eventPlayer.PracticeToggle or eventPlayer.invis or eventPlayer.EditorOn or CompMode)):
            # traces ----------------------------------------------------------------------------------------------------
            eventPlayer.finishfxcache = [Color.RED, Color.ORANGE, Color.YELLOW, Color.LIME_GREEN, Color.GREEN, Color.TURQUOISE, Color.BLUE, Color.PURPLE, Color.VIOLET, Color.ROSE][(floor(getTotalTimeElapsed()*2))%10]
            #eventPlayer.finishfxcache =  rgb((cosDeg(getTotalTimeElapsed()/2 * 360 - 0) + 0.5) * 255, (cosDeg(getTotalTimeElapsed/2 * 360 - 120) + 0.5) * 255, (cosDeg(getTotalTimeElapsed/2 * 360 - 240) + 0.5) * 255)
            wait(0.16)
            # 1.6 - 0.2 in 0.2 steps
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 1.4)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 1.2)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 1)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 0.8)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 0.6)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 0.4)
            wait(0.128)
    elif eventPlayer.InvincibleToggle or (CompMode and CompTime == 0) or eventPlayer.LockState:
        # Do nothing
    elif distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= cpcircleradius:
        # arrived ----------------------------------------------------------------------------------------------------
        eventPlayer.MovedCheckpoint = true
        if eventPlayer.BounceLockMax_Cache and len(eventPlayer.LockCollected) < eventPlayer.BounceLockMax_Cache: # kill player if not colleted the locks
            if eventPlayer.isUsingAbility1():
                waitUntil(not eventPlayer.isUsingAbility1(), 1)    
            smallMessage(eventPlayer, "   ! 进点前需集齐所有收集球 !" checkCN "   ! collect ALL {} orbs to unlock !".format(ColorConfig[customize.orb_lock]))
            #kill(eventPlayer, null)
            checkpointFailReset()
            goto lbl_abc
        if eventPlayer.ban_climb and eventPlayer.WallclimbUsed:
            smallMessage(eventPlayer, "   爬墙 ↑ 已禁用!" checkCN "   Climb ↑ is banned!")
            checkpointFailReset()
            goto lbl_abc
        
        if eventPlayer.ban_bhop and not (eventPlayer.BhopUsed == 0 or eventPlayer.BhopHUDColor == Color.GREEN):
            smallMessage(eventPlayer, "   ≥ 留小跳进点!" checkCN "   ≥ Must have a bhop to complete!")
            checkpointFailReset()
            goto lbl_abc

        if eventPlayer.ban_djump and not (eventPlayer.DoubleUsed == 0):
            smallMessage(eventPlayer, "   » 留二段跳!" checkCN "   » Must have a double jump to complete!")
            checkpointFailReset()
            goto lbl_abc

        #eventPlayer.LockCollected = []
        eventPlayer.CurrentCheckpoint += 1
        UpdateCache()
        # remove ult feature disabled for speedruning purposes
        #if eventPlayer.isUsingUltimate() and not eventPlayer.CurrentCheckpoint in BladeEnabledCheckpoints:
        #    kill(eventPlayer, null)
        if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) > 1:# teleport cps
            checkpointFailReset()/*
            eventPlayer.startForcingPosition( CheckpointPositions[eventPlayer.CurrentCheckpoint].last() ,false)
            eventPlayer.flytoggle = null
            wait(0.1)
            eventPlayer.stopForcingPosition()
            # position wasnt ready when check cache ran
            async(CheckUlt(), AsyncBehavior.RESTART)
            async(CheckDash(), AsyncBehavior.RESTART)*/

        
        if eventPlayer.splitdisplay != -Math.INFINITY:
            eventPlayer.splitdisplay =  (eventPlayer.practicetimer if eventPlayer.PracticeToggle else eventPlayer.Timer) - eventPlayer.splittime
        wait()
        playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
        playEffect(eventPlayer if CompMode or eventPlayer.invis else getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, CheckpointPositions[eventPlayer.CurrentCheckpoint] + vect(0, 1.5, 0), 4)
        # msg disabled due to annoying new sound
        #bigMessage(eventPlayer,  "{1} {0}".format(eventPlayer.CurrentCheckpoint, "抵达检查点" checkCN "Arrived at level")   )
        wait()
        UpdateTitle()
        TriggerOnFailSuccesReset()
        
        if eventPlayer.PracticeToggle:
            eventPlayer.splittime = eventPlayer.practicetimer
            goto lbl_abc
        
        eventPlayer.splittime = eventPlayer.Timer
        if eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1 and (not eventPlayer.EditorOn) and (not eventPlayer.PracticeToggle): # complete lvl
            stopChasingVariable(eventPlayer.Timer)
            stopChasingVariable(eventPlayer.practicetimer) 
            wait()
            bigMessage(getAllPlayers(), "{0} {2} {1}".format(eventPlayer, prettyTime(eventPlayer.Timer),"已通关! 用时" checkCN "Mission complete! Time"))
                
            DeleteSave()
            Leaderboardupdate()
            if CompMode and CompAtmpNum > 0:
                if eventPlayer.AttemptCount == CompAtmpNum: 
                    CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))] = -1 
                    eventPlayer.AttemptCount = -1                     
                    eventPlayer.CompDone = true
                    eventPlayer.LeaderboardToggle = true
                    eventPlayer.disableRespawn()
                    eventPlayer.setDamageReceived(100)
                    kill(eventPlayer,null)
                    eventPlayer.setDamageReceived(0)
                else:
                    CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))] = eventPlayer.AttemptCount + 1
        else: # update save
            DeleteSave()
            MakeSave()
    elif distance(eventPlayer,CheckpointPositions[eventPlayer.CurrentCheckpoint].last()) > cpcircleradius:
        checkpointFailReset()

    lbl_abc:
    eventPlayer.LockCollected = []
    wait(0.048)

    if RULE_CONDITION:
        goto RULE_START               
   
rule "Kill Orb | Activate":
    @Event eachPlayer
    @Condition eventPlayer.KillPosition_Cache != []
    @Condition eventPlayer.InvincibleToggle == false
    @Condition eventPlayer.NotOnLastCp
    @Condition (any([distance(i, eventPlayer) <= eventPlayer.KillRadii_Cache[eventPlayer.KillPosition_Cache.index(i)] for i in eventPlayer.KillPosition_Cache]))
    checkpointFailReset()

rule "Bounce Ball / Orb | Activate":
    @Event eachPlayer
    @Condition eventPlayer.BouncePosition_Cache != []
    #@Condition eventPlayer.NotOnLastCp # disabled coz editor
    @Condition (any([distance(i, eventPlayer.getPosition() bounceoffset) < bounceorbdistance for i in eventPlayer.BouncePosition_Cache]))
    
    eventPlayer.bouncetouched = eventPlayer.BouncePosition_Cache.index( # cashe the touched bouncepad number
        sorted(
            [i for i in eventPlayer.BouncePosition_Cache if distance(eventPlayer bounceoffset, i ) < bounceorbdistance and not (i in eventPlayer.LockCollected) ],
            lambda x: distance(eventPlayer, x)
            )[0]
        )

    if eventPlayer.bouncetouched == eventPlayer.bouncetouchedlast: # prevent same one trigering twice in a row
        wait(0.24)
        eventPlayer.bouncetouchedlast = -1 # -1 because null becomes 0 and thats a legit index
        if RULE_CONDITION:
            goto RULE_START
        return #only return if no others in radius

    eventPlayer.bouncetouchedlast = eventPlayer.bouncetouched 

    if eventPlayer.BounceStrength_Cache[eventPlayer.bouncetouched] > 0:
        eventPlayer.applyImpulse(Vector.UP, eventPlayer.BounceStrength_Cache[eventPlayer.bouncetouched], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    elif eventPlayer.BounceStrength_Cache[eventPlayer.bouncetouched] < 0:
        eventPlayer.cancelPrimaryAction()
        eventPlayer.DoubleUsed = null
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    if eventPlayer.BounceUlt_Cache[eventPlayer.bouncetouched]:
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        smallMessage(eventPlayer, "   {0} {1} ".format(abilityIconString(Hero.GENJI, Button.ULTIMATE),"#终极技能已就绪" checkCN "Ultimate is ready")) 
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    if eventPlayer.BounceLock_Cache[eventPlayer.bouncetouched]:
        eventPlayer.LockCollected.append(eventPlayer.BouncePosition_Cache[eventPlayer.bouncetouched])
        smallMessage(eventPlayer, "   弹球已收集" checkCN "   orb has been collected")
        
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    if eventPlayer.BounceDash_Cache[eventPlayer.bouncetouched]:
        if eventPlayer.isUsingAbility1():
            waitUntil(not eventPlayer.isUsingAbility1(), 1)
            wait(0.032) # wait til set false by check
        eventPlayer.setAbility1Enabled(true)
        smallMessage(eventPlayer, "   {0} {1} ".format(abilityIconString(Hero.GENJI, Button.ABILITY_1),"技能1影已就绪" checkCN "Dash is ready")) 
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    wait()
    eventPlayer.bouncetouched = -1
    wait(0.24)
    if RULE_CONDITION: goto RULE_START

    eventPlayer.bouncetouchedlast = -1

/*
death rule notes ( not death note)
without wait it can crash server
with wait it feels bad
this waituntil contrusction gives higher delay without relying on a variable count
*/
rule "Death Reset":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.SpectateToggle == false
    @Condition eventPlayer.CompDone == false
    if len(CheckpointPositions) > 0:
        eventPlayer.resurrect()
    else:
        eventPlayer.respawn()
    checkpointFailReset()
    # rest is to prevent dead spaming from crashign server
    # but doing waits only when needed
    waitUntil(eventPlayer.isAlive(), 1)
    waitUntil(eventPlayer.isDead(), 1)
    if eventPlayer.isDead() and (not eventPlayer.SpectateToggle) and (not eventPlayer.CompDone):
        wait(0.16)
        eventPlayer.resurrect()
        checkpointFailReset()
        waitUntil(eventPlayer.isAlive(), 1)
        waitUntil(eventPlayer.isDead(), 1)
        if eventPlayer.isDead() and (not eventPlayer.SpectateToggle) and (not eventPlayer.CompDone):
            wait(0.44)
            eventPlayer.resurrect()
            checkpointFailReset()
            waitUntil(eventPlayer.isAlive(), 1)
            waitUntil(eventPlayer.isDead(), 1)
            if eventPlayer.isDead() and (not eventPlayer.SpectateToggle) and (not eventPlayer.CompDone):
                wait(0.64)
                eventPlayer.resurrect()
                checkpointFailReset()

rule "Player Leaves":
    @Event playerLeft
    if SaveCp[SaveEnt.index(eventPlayer)] == 0: # delete if player didnt do first cp
       DeleteSave()
    else:
        if SaveCp[SaveEnt.index(eventPlayer)] >= len(CheckpointPositions) - 1 or SavePauseEnabled[SaveEnt.index(eventPlayer)]: # level complete or ?
            goto lbl_a
        SaveTimer[SaveEnt.index(eventPlayer)]  = (
            getTotalTimeElapsed() - 
            SaveElapsed[SaveEnt.index(eventPlayer)]  - 
            SavePauseTime[SaveEnt.index(eventPlayer)]  + 
            SaveTimer[SaveEnt.index(eventPlayer)] 
        )        
        lbl_a:
        SavePauseTime[SaveEnt.index(eventPlayer)] = 0
        SavePauseEnabled[SaveEnt.index(eventPlayer)] = false

rule "AFK timer":
    @Event eachPlayer
    @Condition eventPlayer.isMoving() == false
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isCommunicatingEmote() == false
    @Condition eventPlayer.EditorOn == false
    wait(300, Wait.ABORT_WHEN_FALSE)

    eventPlayer.setStatusEffect(null, Status.ASLEEP, Math.INFINITY)
      # raycast to prevent camera stuck on low wall
    eventPlayer.startCamera(
        eventPlayer.getPosition() + 
        Vector.UP * 
        (
        distance(
            eventPlayer.getPosition(),
            raycast(eventPlayer.getPosition(),eventPlayer.getPosition()+vect(0,4,0), null, null,false).getHitPosition()
        ) - 1
        ) ,
        eventPlayer.getPosition(), 
        10
    )
    # cancel it after jumping or not sleep, reset cures sleep
    wait(1)
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.hasStatusEffect(Status.ASLEEP) == false, Math.INFINITY)
    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.stopCamera()
    waitUntil(eventPlayer.isOnWall(), 2)
    if eventPlayer.isOnWall(): # prevent save bhop climb
        eventPlayer.cancelPrimaryAction() 
        eventPlayer.DoubleUsed = null

    if RULE_CONDITION:
        goto RULE_START

################################################################################

#!include "huds.opy"     

#!include "mechanics.opy"

#!include "addons-page1.opy"

################################################################################

# padding to make rest of rules go on page 2
rule "MAP DATA - 地图数据":
    @NewPage FILLER

rule "<tx0C0000000000D297><fg00FFFFFF> Map Data - 数据录入 <---- INSERT HERE / 在这输入":
    @Delimiter

editorordata

# note: Don't change defaults only here.
# If you change this, also change it in the name/credit construciton in the huds
# The old default should always be included to make old data valid
rule "<tx0C00000000044B55><fg0FFFFFFF> Credits and Colors here - 作者代码HUD颜色 <---- INSERT HERE / 在这输入 ": 
    #Filling this in adds it to the inspector pasta after next restart.
    #You can fill in again to overwrite.
    #修改的内容 在重新开始 比赛后生效
    #您可以反复 修改字符串 中的内容
    Name = "Name Here - 作者"
    Code = "Code Here - 代码"
    #
    #+++++  +++++  +++++  +++++  +++++  +++++  
    #color customization below / 自定义 颜色(实体、HUD)
    #+++++  +++++  +++++  +++++  +++++  +++++  
    # 
    #credit hud name   -   作者HUD
    ColorConfig[customize.credit_name] = Color.VIOLET
    #credit hud code   -   代码HUD
    ColorConfig[customize.credit_code] = Color.SKY_BLUE
    #dsc.gg/genjiparkour
    ColorConfig[customize.dsc] = Color.AQUA
    #server time hud   -   房间倒计时
    ColorConfig[customize.servertime] = Color.RED
    #time  hud   -   单关用时HUD
    ColorConfig[customize.time] = Color.WHITE
    #level hud   -   关卡HUD
    ColorConfig[customize.level] = Color.WHITE
    #command hud   -   指令HUD
    ColorConfig[customize.command_normal] = Color.WHITE
    #command hud highlight   -   指令HUD高亮
    ColorConfig[customize.command_highlight] = Color.GREEN
    #bhop/climb available   -   小跳/爬墙未用HUD
    ColorConfig[customize.bhopclimb_available] = Color.GREEN
    #bhop/climb used (cant be same as available)   -   小跳/爬墙已用HUD
    ColorConfig[customize.bhopclimb_used] = Color.RED
        
    #current checkpoint ring   -   当前检查点光圈
    ColorConfig[customize.ring_current] =  Color.SKY_BLUE
    #next checkpoint ring   -   下一关检查点光圈
    ColorConfig[customize.ring_next] = Color.LIME_GREEN
    #next checkpoint light shaft   -   下一关检查点光柱
    ColorConfig[customize.shaft] = Color.WHITE
    #next checkpoint icon   -   下一关检查点图标
    ColorConfig[customize.nexticon_color] = Color.SKY_BLUE
    #"come here" text   -   到这里来" 文本
    ColorConfig[customize.cometext] = Color.WHITE
    #kill orbs   -   击杀球
    ColorConfig[customize.killorb] = Color.BLUE
    #normal orbs   -   弹球
    ColorConfig[customize.orb_normal] = Color.GREEN
    #lock orbs (overwritten if its same as normal)   
    #收集球 (与普通弹 球相同时将 自动覆写)
    ColorConfig[customize.orb_lock] = Color.ORANGE
    #portals   -   自定义 传送门
    ColorConfig[customize.portal] = Color.WHITE

rule "Instructions for Depricated Rules (ban / portal / dash /ult) - 旧版编辑器中已弃用规则指引 (单关封禁 / 传送门 / 给刀给S)":
    @Delimiter
    printLog("■■■■■■■■■■■■■■■■■■■■■■■■")
    # The following rules should now be handled with the ingame editor
    #- Ban per checkpoint
    #- Dash/Ult per checkpoint
    #- Custom portals
    printLog("■■■■■■■■■■■■■■■■■■■■■■■■")
    # When updating old maps, these things should be added to your map data.
    # This is done with the instructions below
    printLog("■■■■■■■■■■■■■■■■■■■■■■■■")
    #step 1) Open the old rule
    #step 2) Select the variables and press copy
    #      (do not select waits or workshop toggles, only select variables)
    #step 3) Go to map data rule and paste this the variables
    printLog("■■■■■■■■■■■■■■■■■■■■■■■■")
    #以下规则现在 要用游戏内置 编辑器编辑
	#	- 单关 封禁(卡小、蹭留等)
	#	- 检查点给 刀给S
	#	- 自定义 传送门
    printLog("■■■■■■■■■■■■■■■■■■■■■■■■")
	#	当更新旧 图数据 时，以上 这些东西 应该放 到地图 数据里
    #	以下是一 些更新旧 图数据 指引: 
    printLog("■■■■■■■■■■■■■■■■■■■■■■■■")
	#	步骤 1) 找到旧图 数据的 规则
	#	步骤 2) 选中旧图 数据的 全局变 量并复制
	#		  (不要复制含 等待 地图工坊设置 的指令, 只要 全局变量 的数据)
	#	步骤 3) 将全局变 量数据粘 贴到新版 编辑器的 地图数 据规则
    printLog("■■■■■■■■■■■■■■■■■■■■■■■■")

################################################################################

#!include "addons-page2.opy"

# enable/disable the include via defines
testToggle 