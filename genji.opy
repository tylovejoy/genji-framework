#!define versionhere "1.8 beta"
# cheats ##############################
#!define editortoggle(x) __script__("test-maps/togglescript.js")
editortoggle(4) # 0 is editor, rest is numbers
#14 nepal 4 mini 6 busan 10 holly 18 rialto
#!define touchground false
#!define cpcheat false
#!define inspectoron false

# disable via double ## at include, not the define because the define needs to exist
#!define testaitoggle ##!include "test-scripts.opy"

#!define compmodetoggle false
#!define attemptcount 5
#!define comptimelimit 120
#!define comprestartlimit false
# defaults: off, atempt:5, 120 min, restart:false

# settings ##############################
# limit on how many orbs can be made
#!define fxlimit 193
#!define portaldistance 1.3

# 1.4 is the default cirkle radius, fx is default to 1
#!define cpcircleradius 1.4
#!define cpcirklefx 1

# distance range for player - orb 1.4
#!define bounceorbdistance 1.4
# eight added to player for orb detection. inludes the + 
#!define bounceoffset + vect(0,0.7,0)


#disable overpy map detection
#!disableMapDetectionFix 

#!include "settings.opy"
#!include "definitions.opy"

rule "fisho cp cheat for overpy toggle":
    @Event eachPlayer
    @Condition cpcheat
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.NotOnLastCp) or (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.CurrentCheckpoint != 0)
    @Condition not eventPlayer.EditorOn
    @Condition not eventPlayer.PracticeToggle   

    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint - 1])
        eventPlayer.CurrentCheckpoint -= 1
    else:
        eventPlayer.CurrentCheckpoint += 1
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint])


FILLER

rule "------------------------------------------------------------------------  General functions ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled

def RebuildBounceOrbs():
    @Name "SUB | Rebuild Bounce Orbs"
    destroyEffect(BounceEffects)
    BounceEffects = [] 
    for TempIterator1 in range(0, len(BouncePadCheckpoints)):
        createEffect(
            [x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)] and not evalOnce(BouncePositions[evalOnce(TempIterator1)]) in x.LockCollected], 
            Effect.ORB, 
            Color.ORANGE if BounceToggleLock[evalOnce(TempIterator1)] else Color.GREEN, 
            BouncePositions[evalOnce(TempIterator1)], 
            1, 
            EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
    BounceEffects.append(getLastCreatedEntity())
    wait()

def RebuildKillOrbs():
    @Name "SUB | Rebuild Kill Orbs"
    destroyEffect(KillBallEffects)
    KillBallEffects = []  
    for TempIterator1 in range(0, len(KillballCheckpoints)):
        createEffect([x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == KillballCheckpoints[evalOnce(TempIterator1)]], Effect.SPHERE, Color.BLUE, KillBallPositions[evalOnce(TempIterator1)], KillBallRadii[evalOnce(TempIterator1)], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        KillBallEffects.append(getLastCreatedEntity())
        wait()

def BuildPortals():
    @Name "SUB | Rebuild Portals"
    # custom portals
    if CustomPortalStart:
        for TempIterator1 in range(len(CustomPortalStart)):
            createEffect(
                [i for i in getAllPlayers() if i.CurrentCheckpoint == CustomPortalCP[evalOnce(TempIterator1)] or CustomPortalCP[evalOnce(TempIterator1)] == 999],
                Effect.GOOD_AURA, Color.WHITE,
                CustomPortalStart[evalOnce(TempIterator1)], 
                0.6,
                EffectReeval.VISIBILITY
            )
            wait(0.16)
    # pre-set portals
    if PortalDest:
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

def UpdateCache():
    @Name "SUB | Update Effect Cache"
    eventPlayer.NotOnLastCp = (eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1 and len(CheckpointPositions)  > 1)
    
    eventPlayer.BouncePosition_Cache = [_ for _, i in BouncePositions if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceStrength_Cache = [_ for _, i in BounceStrength if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceUlt_Cache = [_ for _, i in BounceToggleUlt if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceDash_Cache = [_ for _, i in BounceToggleDash if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceLock_Cache = [_ for _, i in BounceToggleLock if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.KillPosition_Cache = [_ for _, i in KillBallPositions if KillballCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.KillRadii_Cache = [_ for _, i in KillBallRadii if KillballCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceLockMax_Cache = len([i for i in eventPlayer.BounceLock_Cache if i])    
    
    eventPlayer.banstring = ""
    wait()

    if createWorkshopSetting(bool, "Ban (applies to all levels) -  封禁(适用于所有级别)", "▲ ban Triple Jump - 三段跳", false, 0):
        eventPlayer.ban_triple = true
    elif eventPlayer.CurrentCheckpoint in BanTriple:
        eventPlayer.banstring = "▲ {}".format(eventPlayer.banstring)
        eventPlayer.ban_triple = true
    else:
        eventPlayer.ban_triple = false

    if createWorkshopSetting(bool, "Ban (applies to all levels) -  封禁(适用于所有级别)", "∞ ban Multiclim - 封禁蹭留", false, 1):
        eventPlayer.ban_multi = true
    elif eventPlayer.CurrentCheckpoint in BanMulti:
        eventPlayer.banstring = "∞ {}".format(eventPlayer.banstring)
        eventPlayer.ban_multi = true
    else:
        eventPlayer.ban_multi = false

    if createWorkshopSetting(bool, "Ban (applies to all levels) -  封禁(适用于所有级别)", "♂ ban Createbhop - 封禁卡小", false, 2):
        eventPlayer.ban_create = true
    elif eventPlayer.CurrentCheckpoint in BanCreate:
        eventPlayer.banstring = "♂ {}".format(eventPlayer.banstring)
        eventPlayer.ban_create = true
    else:
        eventPlayer.ban_create = false

    if createWorkshopSetting(bool, "Ban (applies to all levels) -  封禁(适用于所有级别)", "X ban Deathbhop - 封禁死小", false, 3):
        eventPlayer.ban_dedhop = true
    elif eventPlayer.CurrentCheckpoint in BanDead:
        eventPlayer.banstring = "X {}".format(eventPlayer.banstring)
        eventPlayer.ban_dedhop = true
    else:
        eventPlayer.ban_dedhop = false

    if createWorkshopSetting(bool, "Ban (applies to all levels) -  封禁(适用于所有级别)", "♥ ban Emote Savehop - 封禁表情爬", false, 4):
        eventPlayer.ban_emote = true
    elif eventPlayer.CurrentCheckpoint in BanEmote:
        eventPlayer.banstring = "♥ {}".format(eventPlayer.banstring)
        eventPlayer.ban_emote = true
    else:
        eventPlayer.ban_emote = false
    
    if createWorkshopSetting(bool, "Ban (applies to all levels) -  封禁(适用于所有级别)", "↑ ban Wallclimb - 封禁爬墙", false, 5):
        eventPlayer.ban_climb = true
    elif eventPlayer.CurrentCheckpoint in BanClimb:
        eventPlayer.banstring = "↑ {}".format(eventPlayer.banstring)
        eventPlayer.ban_climb = true
    else:
        eventPlayer.ban_climb = false

    if createWorkshopSetting(bool, "Ban (applies to all levels) -  封禁(适用于所有级别)","≥ require bhop available - 留小跳进点 ", false, 5):
        eventPlayer.ban_bhop = true
    elif eventPlayer.CurrentCheckpoint in BanBhop:
        eventPlayer.banstring = "≥ {}".format(eventPlayer.banstring) # ≥  √ ▼ ↓
        eventPlayer.ban_bhop = true
    else:
        eventPlayer.ban_bhop = false
 
    wait()
    async(CheckUlt(), AsyncBehavior.RESTART)
    async(CheckDash(), AsyncBehavior.RESTART)

    if not eventPlayer.EditorOn:
        return

    destroyEffect(eventPlayer.EffectSizeArray)
    eventPlayer.EffectSizeArray = []
    createEffect(eventPlayer if eventPlayer.EffectSizeToggle else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint], cpcircleradius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.EffectSizeArray.append(getLastCreatedEntity())
    createEffect(eventPlayer if eventPlayer.EffectSizeToggle and eventPlayer.NotOnLastCp else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], cpcircleradius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.EffectSizeArray.append(getLastCreatedEntity())

    eventPlayer.BounceIndex_Cache = [e for e in [(i if e2 == eventPlayer.CurrentCheckpoint else -1) for e2, i in BouncePadCheckpoints] if  e >=0]
    eventPlayer.KillIndex_Cache = [e for e in [(i if e2 == eventPlayer.CurrentCheckpoint else -1) for e2, i in KillballCheckpoints] if  e >=0]

    if eventPlayer.MovedCheckpoint and eventPlayer == hostPlayer:
        #SelectedCheckpoint_Editing = eventPlayer.CurrentCheckpoint
        SelectedKillball_Editing = 0 if eventPlayer.KillIndex_Cache else 99999
        KillBallChase = KillBallPositions[eventPlayer.KillIndex_Cache[SelectedKillball_Editing]] if len(eventPlayer.KillIndex_Cache) else vect(0,0,0)
        CurrentBounce_Editing = 0 if eventPlayer.BounceIndex_Cache else 99999
        CurrentBouncePosition_Editing = BouncePositions[eventPlayer.BounceIndex_Cache[CurrentBounce_Editing]] if len(eventPlayer.BounceIndex_Cache) else vect(0,0,0)
        eventPlayer.MovedCheckpoint = false

#!include "editor.opy"

rule "------------------------------------------------------------------------  General rules ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled


rule "Setup and Variables":
    if not inspectoron:
        disableInspector()

    disableGamemodeCompletion()
    disableScoring()
    disableMusic()
    disableAnnouncer()
    startForcingSpawn(Team.ALL,  0)
    startForcingSpawn(Team.ALL,  1)
    startForcingSpawn(Team.ALL,  2)
    wait(0.024) # wait for map data rule
    BladeEnabledCheckpoints = BladeEnabledCheckpoints if len([i for i in BladeEnabledCheckpoints if i != -1 and i != [] ]) and BladeEnabledCheckpoints != null else []
    DashEnabledCheckpoints =  DashEnabledCheckpoints if len([i for i in DashEnabledCheckpoints if i != -1 and i != [] ]) and DashEnabledCheckpoints != null  else  []
    BouncePadCheckpoints = BouncePadCheckpoints if len(BouncePadCheckpoints) else []
    CheckpointPositions = CheckpointPositions if len(CheckpointPositions) else []
    CheckpointPositions = CheckpointPositions if len(CheckpointPositions) else []
    KillballCheckpoints = KillballCheckpoints if len(KillballCheckpoints) else []
    KillBallPositions = KillBallPositions if len(KillBallPositions) else []
    KillBallRadii = KillBallRadii if len(KillBallRadii) else []
    KillBallEffects = KillBallEffects if len(KillBallEffects) else []
    SelectedKillball_Editing = 0
    BouncePositions = BouncePositions if len(BouncePositions) else []
    BounceEffects = BounceEffects if len(BounceEffects) else []
    BounceStrength = BounceStrength if len(BounceStrength) else []
    CurrentBounce_Editing = 0
    BounceToggleUlt = BounceToggleUlt if len(BounceToggleUlt) else []
    BounceToggleDash = BounceToggleDash if len(BounceToggleDash) else []
    BounceToggleLock = BounceToggleLock if len(BounceToggleLock) else []
    LeaderBoardFull = []

    TitleData = null
    PortalNames = []
    PortalLoc = []
    PortalDest  = []
    CustomPortalStart  = []
    CustomPortalEndpoint  = []
    CustomPortalCP  = []

    wait(1)
    DashExploitToggle = createWorkshopSetting(bool, "Ban (applies to all levels) -  封禁(适用于所有级别)", "ban Dash Start - 0关卡Shift", true, 2)
    PortalOn = createWorkshopSetting(bool, "map settings -  地图设置","enable portals (control maps) - 启用门户(控制映射)",true,0)
    #SelectedCheckpoint_Editing = len(CheckpointPositions) - 1 # This probably isn't necessary
    CompMode = createWorkshopSetting(bool, "Competitive mode - 竞赛模式","Turn on competitive mode - 开启比赛模式" , compmodetoggle , 100)
    if CompMode:
        # -! comp minutes !- 
        CompTime = createWorkshopSetting(int[1:240], "Competitive mode - 竞赛模式", "time limit - 时间限制", comptimelimit, 101) # 5-240
        # -! comp attempt count !- 
        CompAtmpNum = createWorkshopSetting(int[0:500], "Competitive mode - 竞赛模式", "attempt count - 尝试计数", attemptcount, 102) 
        # -! comp restartlimiter !-
        CompRestartLimit = createWorkshopSetting(bool, "Competitive mode - 竞赛模式","disable restart during run - 在运行过程中禁用重新启动" , comprestartlimit , 103)


    wait(5)
    KILLBALL()
    wait(2)
    pinball() #
    wait(2)
    BuildPortals()
    # Check for editor/host spawn to redo effect reeval
    waitUntil(hostPlayer.hasSpawned(), 99999)
    wait()
    if not hostPlayer.EditorOn:
        return
    
    RebuildKillOrbs()
    RebuildBounceOrbs()
    
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
                kill(getAllPlayers(), null)
                wait(0.032)
                async(CreateLeaderBoard(), AsyncBehavior.RESTART)            

    bigMessage(getAllPlayers(), "房间已达最大持续时间, 即将重启" checkCN "maximum lobby time expired, restarting")
    wait(5)
    if getCurrentGamemode() == Gamemode.FFA:
        declarePlayerVictory(hostPlayer)
    else:
        declareTeamVictory(hostPlayer.getTeam())


rule "Player Initialize":
    @Event eachPlayer
    eventPlayer.EditorOn = createWorkshopSetting(bool, "Editor - 作图模式","Editor mode - 作图模式" ,  editoron , 0) # Turn Editor On
    eventPlayer.GuideToggle = eventPlayer.EditorOn
    eventPlayer.disableGamemodeHud()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.preloadHero(Hero.GENJI)
    eventPlayer.setRespawnTime(1)
    eventPlayer.SpectateToggle = false
    eventPlayer.WallclimbUsed = false #Climbing the wall prompts the HUD
    eventPlayer.JumpCount = 0
    eventPlayer.bouncetouchedlast = -1
    #big waits first for about 1 second before loading, to make sure things like comp mode are fully loaded and configured, load fx in meanwhile
    wait(1) 
    createEffect(eventPlayer, Effect.RING, Color.SKY_BLUE, CheckpointPositions[eventPlayer.CurrentCheckpoint].last(), cpcirklefx, EffectReeval.POSITION_AND_RADIUS)
    createEffect(eventPlayer if eventPlayer.NotOnLastCp  else null, Effect.RING, Color.LIME_GREEN, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], cpcirklefx, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    wait(0.5)
    createEffect(eventPlayer if eventPlayer.NotOnLastCp  else null, Effect.LIGHT_SHAFT, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], cpcirklefx, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createIcon(eventPlayer if eventPlayer.NotOnLastCp  else null, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1] + Vector.UP, Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.SKY_BLUE, true)
    wait(0.5)
  
    createInWorldText(eventPlayer if eventPlayer.NotOnLastCp else null, 
        "{0} {1}".format(
            iconString(Icon.WARNING),    
            "先收集橙球" checkCN "collect orbs first"
        ) if eventPlayer.BounceLockMax_Cache and len(eventPlayer.LockCollected) < eventPlayer.BounceLockMax_Cache else
        "到这里来" checkCN "Come here",
        CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 
        1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT
    )
    wait(1)  

    if not eventPlayer.isDummy():
        eventPlayer.startForcingHero(Hero.GENJI)
    elif eventPlayer.getCurrentHero() != Hero.GENJI: # only do the things on genji test bots
        return

    waitUntil(eventPlayer.hasSpawned(), 9999)

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
            waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) or CompTime < 1,99999)
            eventPlayer.setMoveSpeed(100)
            eventPlayer.instructionhud = false
        else:
            eventPlayer.AttemptCount = CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))]
            #trans ? or was this a test hud
            #smallMessage(eventPlayer,"now {0}".format( eventPlayer.AttemptCount))
        if eventPlayer.AttemptCount == (-1) or CompTime < 1:
            eventPlayer.CompDone = true
    

    wait()
    StartGame_Sub()  # initialization of the game
   
def DeleteSave():
    @Name "delete save" 
    del SaveName[SaveEnt.index(eventPlayer)]
    del SaveCp[SaveEnt.index(eventPlayer)]
    del SaveTimer[SaveEnt.index(eventPlayer)]
    del SaveElapsed[SaveEnt.index(eventPlayer)]
    del SavePauseTime[SaveEnt.index(eventPlayer)]
    del SavePauseEnabled[SaveEnt.index(eventPlayer)]
    del SaveEnt[SaveEnt.index(eventPlayer)] # must always be last because its the index itself

def MakeSave():
    @Name "make save"
    SaveName.append("{}".format(eventPlayer))
    SaveCp.append(eventPlayer.CurrentCheckpoint)
    SaveTimer.append(eventPlayer.Timer)
    SaveEnt.append(eventPlayer)
    SaveElapsed.append(getTotalTimeElapsed())
    SavePauseTime.append(0)
    SavePauseEnabled.append(false)

def StartPauseTimer():
    @Name "start pause timer"
    chase(eventPlayer.PauseTimer, 999999, rate=1, ChaseReeval.NONE)
    SaveTimer[SaveEnt.index(eventPlayer)] = eventPlayer.Timer
    SaveElapsed[SaveEnt.index(eventPlayer)] = getTotalTimeElapsed()
    SavePauseEnabled[SaveEnt.index(eventPlayer)] = true

def StopPauseTimer():
    @Name "stop pause timer"
    stopChasingVariable(eventPlayer.PauseTimer)
    SavePauseTime[SaveEnt.index(eventPlayer)] = eventPlayer.PauseTimer
    eventPlayer.PauseTimer = 0
    SavePauseEnabled[SaveEnt.index(eventPlayer)] = false

def CreateLeaderBoard():
    @Name "leaderboard hud"
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
    eventPlayer.LockCollected = []
    eventPlayer.cancelPrimaryAction()
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)
    eventPlayer.teleport( CheckpointPositions[eventPlayer.CurrentCheckpoint].last() )
    if eventPlayer.ban_dedhop and eventPlayer.InvincibleToggle == false and eventPlayer.NotOnLastCp:
        # if eventPlayer.isOnWall():
        #smallMessage(eventPlayer, "Deathbhop is banned!")
        eventPlayer.disallowButton(Button.JUMP)
        wait(0.1)
        eventPlayer.allowButton(Button.JUMP)        
    if eventPlayer.CurrentCheckpoint == 0 and not eventPlayer.PracticeToggle:
        eventPlayer.Timer = 0
        eventPlayer.splittime = 0
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)
        wait()
   
    async(CheckUlt(), AsyncBehavior.RESTART)
    async(CheckDash(), AsyncBehavior.RESTART)

def StartGame_Sub():
    @Name "SUB | Start Game"
    if CompMode and (CompTime < 1 or eventPlayer.CompDone):
        eventPlayer.LeaderboardToggle = true
        eventPlayer.CompDone = true
        eventPlayer.disableRespawn()
        kill(eventPlayer,null)
        return
    
    if DashExploitToggle:
        eventPlayer.setAbility1Enabled(false)
        if eventPlayer.isUsingAbility1():
            waitUntil(not eventPlayer.isUsingAbility1(), 1.5)
            smallMessage(eventPlayer,"   0关卡Shift已禁用!" checkCN "   Dash Start is banned!")            

    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)
    if len(CheckpointPositions) != 0:
        destroyInWorldText(eventPlayer.TitleStore) # restarting reset t itle even if non on cp 0
        if "{0}".format(eventPlayer) in SaveName: # load saved progres
            SaveEnt[SaveName.index("{}".format(eventPlayer))] = eventPlayer
            eventPlayer.CurrentCheckpoint = SaveCp[SaveEnt.index(eventPlayer)]
            eventPlayer.Timer = SaveTimer[SaveEnt.index(eventPlayer)]
            SaveElapsed[SaveEnt.index(eventPlayer)] = getTotalTimeElapsed()
            SavePauseTime[SaveEnt.index(eventPlayer)] = 0
            SavePauseEnabled[SaveEnt.index(eventPlayer)] = false
            eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint] + Vector.UP)
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
            eventPlayer.teleport(CheckpointPositions[0] + Vector.UP)
            eventPlayer.CurrentCheckpoint = 0
            eventPlayer.Timer = 0
            stopChasingVariable(eventPlayer.PauseTimer)
            eventPlayer.PauseTimer = 0
            MakeSave()
            UpdateTitle()
    
    eventPlayer.splittime = 0
    chase(eventPlayer.Timer, 9999999, rate=1, ChaseReeval.NONE)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    eventPlayer.LockCollected = []
    eventPlayer.InvincibleToggle = false
    # eventPlayer.LockState = false
    UpdateCache()

def KILLBALL():
    @Name "SUB | Kill Orb Effects"
    if KillBallPositions == [] or hostPlayer.EditorOn:
        return
    for TempIterator1 in range(0, len(KillBallPositions)):
        createEffect([x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == KillballCheckpoints[evalOnce(TempIterator1)]], Effect.SPHERE, Color.BLUE, KillBallPositions[evalOnce(TempIterator1)], KillBallRadii[evalOnce(TempIterator1)], EffectReeval.VISIBILITY)
        KillBallEffects.append(getLastCreatedEntity())
        wait()

def pinball():
    @Name "SUB | Bounce Ball Effects"
    if BouncePositions == [] or hostPlayer.EditorOn:
        return
    for TempIterator1 in range(0, len(BouncePositions)):
        createEffect(
            [x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)] and not BouncePositions[evalOnce(TempIterator1)] in x.LockCollected], 
            Effect.ORB, 
            Color.ORANGE if BounceToggleLock[TempIterator1] else Color.GREEN, 
            BouncePositions[evalOnce(TempIterator1)], 
            1, 
            EffectReeval.VISIBILITY
        )
        BounceEffects.append(getLastCreatedEntity())
        wait()

rule "Arrive | Ground reset | traces":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isAlive()
    if eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1:
        
        if (eventPlayer.isMoving() and eventPlayer.PracticeToggle == false and eventPlayer.invis == false and eventPlayer.EditorOn == false and CompMode == false):
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
    elif eventPlayer.NotOnLastCp and eventPlayer.InvincibleToggle == false and (CompMode == false or CompTime > 0) and eventPlayer.LockState == false:
        if distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= cpcircleradius:
            # arrived ----------------------------------------------------------------------------------------------------
            eventPlayer.MovedCheckpoint = true
            if eventPlayer.BounceLockMax_Cache and len(eventPlayer.LockCollected) < eventPlayer.BounceLockMax_Cache: # kill player if not colleted the locks
                smallMessage(eventPlayer, "   ! 进点前需收集齐所有黄弹球 !" checkCN "   ! collect ALL orange orbs to unlock !")
                kill(eventPlayer, null)
                goto lbl_abc
            if eventPlayer.ban_climb and eventPlayer.WallclimbUsed:
                smallMessage(eventPlayer, "   爬墙 ↑ 已禁用!" checkCN "   Climb ↑ is banned!")
                checkpointFailReset()
                goto lbl_abc
            
            if eventPlayer.ban_bhop and not (eventPlayer.BhopUsed == 0 or eventPlayer.BhopHUDColor == Color.GREEN):
                smallMessage(eventPlayer, "   ≥ 留小跳进点!" checkCN "   ≥ You need to have a bhop to complete!")
                checkpointFailReset()
                goto lbl_abc

            eventPlayer.LockCollected = []
            eventPlayer.CurrentCheckpoint += 1
            UpdateCache()
            # remove ult feature disabled for speedruning purposes
            #if eventPlayer.isUsingUltimate() and not eventPlayer.CurrentCheckpoint in BladeEnabledCheckpoints:
            #    kill(eventPlayer, null)
            if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) > 1:# teleport cps
                eventPlayer.startForcingPosition( CheckpointPositions[eventPlayer.CurrentCheckpoint].last() ,false)
                wait(0.1)
                eventPlayer.flytoggle = null
                eventPlayer.stopForcingPosition()
            
            eventPlayer.splitdisplay =  (eventPlayer.practicetimer if eventPlayer.PracticeToggle else eventPlayer.Timer) - eventPlayer.splittime
            wait()
            playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
            playEffect(eventPlayer if CompMode or eventPlayer.invis else getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, CheckpointPositions[eventPlayer.CurrentCheckpoint] + vect(0, 1.5, 0), 4)
            #bigMessage(eventPlayer, "Arrived at {0} / {1}{2}".format(eventPlayer.CurrentCheckpoint, len(CheckpointPositions) - 1, " - Split {}".format(eventPlayer.splitdisplay) if eventPlayer.splitson else "")) 
            bigMessage(eventPlayer,  "{1} {0}".format(eventPlayer.CurrentCheckpoint, "抵达检查点" checkCN "Arrived at level")   )
            wait()
            UpdateTitle()
           
            if eventPlayer.PracticeToggle:
                eventPlayer.splittime = eventPlayer.practicetimer
                goto lbl_abc
            
            eventPlayer.splittime = eventPlayer.Timer
                
            if eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1 and (not eventPlayer.EditorOn) and (not eventPlayer.PracticeToggle): # complete lvl
                stopChasingVariable(eventPlayer.Timer)
                stopChasingVariable(eventPlayer.practicetimer) 
                wait()
                bigMessage(getAllPlayers(), "{0} {2} {1}".format(eventPlayer, prettyTime(eventPlayer.Timer),"已通关! 用时 " checkCN "Mission complete! Time"))
                   
                DeleteSave()
                Leaderboardupdate()
                if CompMode and CompAtmpNum > 0:
                    if eventPlayer.AttemptCount == CompAtmpNum: 
                        CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))] = -1 
                        eventPlayer.AttemptCount = -1                     
                        eventPlayer.CompDone = true
                        eventPlayer.LeaderboardToggle = true
                        eventPlayer.disableRespawn()
                        kill(eventPlayer,null)
                    else:
                        CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))] = eventPlayer.AttemptCount + 1
            else: # update save
                DeleteSave()
                MakeSave()
        elif distance(eventPlayer,CheckpointPositions[eventPlayer.CurrentCheckpoint].last()) > cpcircleradius and not touchground:
            # ground reset ----------------------------------------------------------------------------------------------------
            checkpointFailReset()

    lbl_abc:
    wait(0.048)

    if RULE_CONDITION:
        goto RULE_START               
   
   
rule "reset collected locks when landing back on cp":
    @Event eachPlayer
    @Condition eventPlayer.LockCollected != []
    @Condition eventPlayer.isOnGround()
    @Condition distance(eventPlayer,CheckpointPositions[eventPlayer.CurrentCheckpoint].last()) <= cpcircleradius

    eventPlayer.LockCollected = []

rule "Kill Orb | Activate":
    @Event eachPlayer
    @Condition eventPlayer.KillPosition_Cache != []
    @Condition not eventPlayer.InvincibleToggle
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

    if eventPlayer.BounceStrength_Cache[eventPlayer.bouncetouched] != 0:
        eventPlayer.applyImpulse(Vector.UP, eventPlayer.BounceStrength_Cache[eventPlayer.bouncetouched], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

    if eventPlayer.BounceUlt_Cache[eventPlayer.bouncetouched]:
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        smallMessage(eventPlayer, "   {0} {1} ".format(abilityIconString(Hero.GENJI, Button.ULTIMATE),"#终极技能已就绪" checkCN "Ultimate is ready")) 
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    if eventPlayer.BounceLock_Cache[eventPlayer.bouncetouched]:
        eventPlayer.LockCollected.append(eventPlayer.BouncePosition_Cache[eventPlayer.bouncetouched])
        smallMessage(eventPlayer, "   黄球已收集" checkCN "   orb has been collected")
        
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    if eventPlayer.BounceDash_Cache[eventPlayer.bouncetouched]:
        if eventPlayer.isUsingAbility1():
            waitUntil(not eventPlayer.isUsingAbility1(), 1)
            wait(0.032) # wait til set false by check
        eventPlayer.setAbility1Enabled(true)
        smallMessage(eventPlayer, "   {0} {1} ".format(abilityIconString(Hero.GENJI, Button.ABILITY_1),"技能1影已就绪" checkCN "Dash is ready")) 
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    wait(0.24)
    if RULE_CONDITION:
        goto RULE_START

    eventPlayer.bouncetouchedlast = -1

rule "Death Reset":
    @Event playerDied
    @Condition not eventPlayer.SpectateToggle
    @Condition not eventPlayer.CompDone
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.resurrect()
    checkpointFailReset()
    # rest is to prevent dead spaming from crashign server
    # but doing waits only when needed
    waitUntil(eventPlayer.isAlive(), 1)
    waitUntil(eventPlayer.isDead(), 1)
    if eventPlayer.isDead() and (not eventPlayer.SpectateToggle) and (not eventPlayer.CompDone):
        wait(0.16)
        eventPlayer.clearStatusEffect(Status.PHASED_OUT)
        eventPlayer.resurrect()
        checkpointFailReset()
        waitUntil(eventPlayer.isAlive(), 1)
        waitUntil(eventPlayer.isDead(), 1)
        if eventPlayer.isDead() and (not eventPlayer.SpectateToggle) and (not eventPlayer.CompDone):
            wait(0.44)
            eventPlayer.clearStatusEffect(Status.PHASED_OUT)
            eventPlayer.resurrect()
            checkpointFailReset()
            waitUntil(eventPlayer.isAlive(), 1)
            waitUntil(eventPlayer.isDead(), 1)
            if eventPlayer.isDead() and (not eventPlayer.SpectateToggle) and (not eventPlayer.CompDone):
                wait(0.64)
                eventPlayer.clearStatusEffect(Status.PHASED_OUT)
                eventPlayer.resurrect()
                checkpointFailReset()

rule "Player Phase":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.PHASED_OUT) == false
    @Condition eventPlayer.isAlive()
    if eventPlayer.hasStatusEffect(Status.INVINCIBLE): # delay if its for afk sleep
        wait(0.16)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)

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
    @Condition not eventPlayer.EditorOn
    wait(90, Wait.ABORT_WHEN_FALSE)
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
    # clear status to apply sleep, auto re-aply via normal aply rule
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    wait()
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    wait()
    eventPlayer.setStatusEffect(null, Status.ASLEEP, 9999)
    # cancel it after jumping or not sleep, reset cures sleep
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.hasStatusEffect(Status.ASLEEP) == false, 99999)
    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.stopCamera()
    waitUntil(eventPlayer.isOnWall(), 2)
    if eventPlayer.isOnWall(): # prevent save bhop climb
        eventPlayer.cancelPrimaryAction() 

    if RULE_CONDITION:
        goto RULE_START


#!include "huds.opy"

#!include "commands.opy"     

#!include "mechanics.opy"

#!include "addons.opy"

rule "------------------------------------------------------------------------ MAP DATA - 地图数据 ------------------------------------------------------------------------":
    @Delimiter
    @Disabled

rule "Map Data - 数据录入 <---- INSERT HERE / 在这输入":
    @Delimiter

editorordata

rule "Credits here - 作者名字 <---- INSERT HERE / 在这输入 ": 
    # Filling this in adds it to the inspector pasta after next restart.
    # You can fill in again to overwrite.
    # 填充此字段 将其添加到 检查器数据 面中
    # 您可以再次 填写以覆盖 之前的条目
    Name = "name here - 作者"
    Code = "code here - 代码"


rule "Ban per CP - 封禁(每级) <---- INSERT HERE / 在这输入":
    # Enter the checkpoint/level numbers in the lists below to apply the ban on them
    # Remember the workshop toggle overwrites this list
    # 在下面的列 表中输入检 查点 / 级别编号，封禁 掉对其应用
    # 记住，工作坊切换 将覆盖 此列表
    wait(1)
    # ======================
    # ban  triple - 三段跳
    BanTriple = [-1,-1,-1,-1,-1,-1,-1,-1,-1]
    # ban  multi - 蹭留 
    BanMulti = [-1,-1,-1,-1,-1,-1,-1,-1,-1]
    # ban create - 卡小
    BanCreate = [-1,-1,-1,-1,-1,-1,-1,-1,-1]
    # ban dedhop - 死小
    BanDead = [-1,-1,-1,-1,-1,-1,-1,-1,-1]
    # ban emote - 表情爬
    BanEmote = [-1,-1,-1,-1,-1,-1,-1,-1,-1]
    # ban climb - 爬墙
    BanClimb = [-1,-1,-1,-1,-1,-1,-1,-1,-1]
    # require bhop available - 留小跳进点
    BanBhop = [-1,-1,-1,-1,-1,-1,-1,-1,-1]

rule "Custom difficulty hud  - 自定义难度hud <---- INSERT HERE / 在这输入":
    @Disabled
    @Delimiter
    #1) workshop settings > difficulty > set to "dont display"
    #2) enable this rule
    #3) type your difficulty in the hud below
    printLog("--------")
    #1) 设置正常 难度hud为“不显示”
    #2) 启用此规则
    #3) 在下面的hud中输入难度
    hudSubheader(getAllPlayers(), "enter custom difficulty here", HudPosition.TOP, HO.data_dif,Color.GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    HudStoreEdit.append(getLastCreatedText())

rule "Comp Mode instruction message - 竞赛模式指引消息 <---- INSERT HERE / 在这输入":
    # Instructions that show when you start comp mode.
    # Due to the hud text limit, you there is 4 huds available.
    # If you dont need a field just empty the textfield.
    printLog("--------")
    # 竞赛模式 指引消息
    # 指引消息将 会在竞赛模 式开始时 显示
    # 由于 hud 文本限制，你有 4 个hud可用
    # 如果你不需 要一个字段 只是空文 本字段
    instructiontext[0] = "Change in Comp Mode instruction message hud 1"
    instructiontext[1] = "Change in Comp Mode instruction message hud 2"
    instructiontext[2] = "Change in Comp Mode instruction message hud 2"
    instructiontext[3] = "Change in Comp Mode instruction message hud 2"

# enable/disable the include via defines
testaitoggle 
