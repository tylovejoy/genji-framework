#!mainFile "framework.opy"

rule "<tx0C00000000001344> General <tx0C00000000001344>":
    @Delimiter

def UpdateCache():
    @Name "General | SUB Update Effect Cache"
    # note: if adding cp pos to cache, make sure to also adjust editor things like move and teleport
    eventPlayer.cache_bouncePosition = [_ for _, i in BouncePositions if BouncePadCheckpoints[i] == eventPlayer.checkpoint_current]
    #eventPlayer.cache_bounceStrength = [_ for _, i in BounceStrength if BouncePadCheckpoints[i] == eventPlayer.checkpoint_current]
    #eventPlayer.cache_bounceUlt = [_ for _, i in BounceToggleUlt if BouncePadCheckpoints[i] == eventPlayer.checkpoint_current]
    #eventPlayer.cache_bounceDash = [_ for _, i in BounceToggleDash if BouncePadCheckpoints[i] == eventPlayer.checkpoint_current]
    #eventPlayer.cache_bounceLocks = [_ for _, i in BounceToggleLock if BouncePadCheckpoints[i] == eventPlayer.checkpoint_current and _]
    #eventPlayer.cache_bounceMaxLocks = len([_ for _ in eventPlayer.cache_bounceLocks if _])
    eventPlayer.cache_bounceMaxLocks = len([_ for _, i in BounceToggleLock if BouncePadCheckpoints[i] == eventPlayer.checkpoint_current and _])
    eventPlayer.cache_killPosition = [_ for _, i in KillBallPositions if KillballCheckpoints[i] == eventPlayer.checkpoint_current]
    eventPlayer.cache_killRadii = [_ for _, i in KillBallRadii if KillballCheckpoints[i] == eventPlayer.checkpoint_current]
    eventPlayer.cache_portalStart = [_ for _, i in CustomPortalStart if CustomPortalCP[i] == eventPlayer.checkpoint_current or CustomPortalCP[i] < 0]
    eventPlayer.cache_portalEnd = [_ for _, i in CustomPortalEndpoint if CustomPortalCP[i] == eventPlayer.checkpoint_current or CustomPortalCP[i] < 0]
    eventPlayer.checkpoint_notLast = (eventPlayer.checkpoint_current < len(CheckpointPositions) - 1 and len(CheckpointPositions) > 1)
    eventPlayer.toggle_hints = false
    eventPlayer.banString = []
    wait()
    if eventPlayer.checkpoint_notLast:
        eventPlayer.ban_multi = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Multiclimb - 封禁蹭留", false, 1) or eventPlayer.checkpoint_current in BanMulti
        if eventPlayer.ban_multi:
            eventPlayer.banString = "∞ {}".format(eventPlayer.banString)
        eventPlayer.ban_create = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Createbhop - 封禁卡小", false, 2) or eventPlayer.checkpoint_current in BanCreate
        if eventPlayer.ban_create:
            eventPlayer.banString = "♂ {}".format(eventPlayer.banString)
        eventPlayer.ban_standcreate = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)","ban standcreate - 封禁站卡", false, 3) or eventPlayer.checkpoint_current in BanStand
        if eventPlayer.ban_standcreate:
            eventPlayer.banString = "♠ {}".format(eventPlayer.banString) # ≥  √ ▼ ↓
        eventPlayer.ban_dead = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Deathbhop - 封禁死小", false, 4) or eventPlayer.checkpoint_current in BanDead
        if eventPlayer.ban_dead:
            eventPlayer.banString = "X {}".format(eventPlayer.banString)
        eventPlayer.ban_emote = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Emote Savehop - 封禁表情留小", false, 5) or eventPlayer.checkpoint_current in BanEmote
        if eventPlayer.ban_emote:
            eventPlayer.banString = "♥ {}".format(eventPlayer.banString)
        eventPlayer.ban_climb = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Wallclimb - 封禁爬墙", false, 6) or eventPlayer.checkpoint_current in BanClimb
        if eventPlayer.ban_climb:
            eventPlayer.banString = "↑ {}".format(eventPlayer.banString)
        eventPlayer.ban_savedouble = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban save double - 封禁延二段跳", false, 7) or eventPlayer.checkpoint_current in BanSaveDouble
        if eventPlayer.ban_savedouble:
            eventPlayer.banString = "△ {}".format(eventPlayer.banString)
        eventPlayer.ban_bhop = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)","require bhop available - 留小跳进点 ", false, 8) or eventPlayer.checkpoint_current in BanBhop
        if eventPlayer.ban_bhop:
            eventPlayer.banString = "≥ {}".format(eventPlayer.banString) # ≥  √ ▼ ↓
        eventPlayer.ban_djump = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)","require djump available - 留二段跳 ", false, 9) or eventPlayer.checkpoint_current in BanDjump
        if eventPlayer.ban_djump:
            eventPlayer.banString = "» {}".format(eventPlayer.banString) # ≥  √ ▼ ↓ ︽
    else:
        eventPlayer.ban_multi = false
        eventPlayer.ban_create = false
        eventPlayer.ban_standcreate = false
        eventPlayer.ban_dead = false
        eventPlayer.ban_emote = false
        eventPlayer.ban_climb = false
        eventPlayer.ban_savedouble = false
        eventPlayer.ban_bhop = false
        eventPlayer.ban_djump = false
    wait()
    async(CheckUlt(), AsyncBehavior.RESTART)
    async(CheckAbility1(), AsyncBehavior.RESTART)

    if eventPlayer != hostPlayer or not eventPlayer.editor_on: return
    EditUpdateSelectedIds()
    destroyEffect(hostPlayer.editor_hitboxEffect)
    createEffect(hostPlayer if hostPlayer.editor_hitboxToggle else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[hostPlayer.checkpoint_current], cpcircleradius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    hostPlayer.editor_hitboxEffect = getLastCreatedEntity()
    createEffect(hostPlayer if hostPlayer.editor_hitboxToggle and hostPlayer.checkpoint_notLast else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[hostPlayer.checkpoint_current + 1], cpcircleradius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    hostPlayer.editor_hitboxEffect.append(getLastCreatedEntity())
    hostPlayer.editor_bounceIndex = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in BouncePadCheckpoints] if e >=0]
    hostPlayer.editor_killIndex = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in KillballCheckpoints] if e >=0]
    if hostPlayer.checkpoint_moved:
        EditorSelectLast()
        hostPlayer.checkpoint_moved = false

def DeleteSave():
    @Name "General | SUB Delete Save"
    del SaveName[SaveEnt.index(eventPlayer)]
    del SaveCp[SaveEnt.index(eventPlayer)]
    del SaveTimer[SaveEnt.index(eventPlayer)]
    del SaveElapsed[SaveEnt.index(eventPlayer)]
    del SaveEnt[SaveEnt.index(eventPlayer)] # must always be last because its the index itself

def MakeSave():
    @Name "General | SUB Make Save"
    SaveEnt.append(eventPlayer)
    SaveName.append(eventPlayer[0].split([]))
    SaveCp.append(eventPlayer.checkpoint_current)
    SaveTimer.append(eventPlayer.timer_normal)
    SaveElapsed.append(getTotalTimeElapsed())

def TimerPause():
    @Name "General | SUB Timer Pause"
    stopChasingVariable(eventPlayer.timer_normal)
    if not eventPlayer in SaveEnt: return
    SaveTimer[SaveEnt.index(eventPlayer)] = eventPlayer.timer_normal
    SaveElapsed[SaveEnt.index(eventPlayer)] = null

def TimerResume():
    @Name "General | SUB Timer Resume"
    chase(eventPlayer.timer_normal, Math.INFINITY, rate=1, ChaseReeval.NONE)
    SaveElapsed[SaveEnt.index(eventPlayer)] = getTotalTimeElapsed()

def LeaderboardUpdate():
    @Name "General | SUB Leaderboard Update"
    # [[name, seconds, prettytime]]
    if eventPlayer[0].split([]) in [e[0] for e in LeaderBoardFull]: # you already have a time
        if eventPlayer.timer_normal >= [e for e in LeaderBoardFull if e[0] == eventPlayer[0].split([])][0][1]:
            return #Time too slow
        LeaderBoardFull = [e for e in LeaderBoardFull if e[0] != eventPlayer[0].split([])]
    elif len(LeaderBoardFull) < 25 or eventPlayer.timer_normal < LeaderBoardFull[19].last():
        # you are not in list yet
        # board has room for more
        # your time lower then last entry
        del LeaderBoardFull[24]
    else:
        return #Full and time too slow
    LeaderBoardFull.append([[eventPlayer[0].split([]), eventPlayer.timer_normal, prettyTime(eventPlayer.timer_normal)]])
    LeaderBoardRemake = true #CreateLeaderboard()

def CheckpointFailReset():
    @Name "General | SUB Checkpoint Fail"
    eventPlayer.timer_split = eventPlayer.timer_practice if eventPlayer.toggle_practice else eventPlayer.timer_normal
    eventPlayer.cache_collectedLocks = []
    eventPlayer.cancelPrimaryAction()
    eventPlayer.skill_usedDouble = null

    if not (eventPlayer.checkpoint_current or eventPlayer.toggle_practice):
        eventPlayer.timer_normal = 0
        eventPlayer.timer_split = 0

    if len(CheckpointPositions):
        if eventPlayer.isUsingAbility1() and DashExploitToggle:
            #smallMessage(eventPlayer,"   0关卡Shift已禁用!" checkCN "   Dash Start is banned!")
            eventPlayer.startForcingPosition(eventPlayer, false)
            waitUntil(not eventPlayer.isUsingAbility1(), DashExploitToggle)
            eventPlayer.stopForcingPosition()
        eventPlayer.teleport(CheckpointPositions[eventPlayer.checkpoint_current].last())
        #After teleport incase stopForcingPosition launches the player
        eventPlayer.applyImpulse(-1 * eventPlayer.getVelocity(), Math.EPSILON, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

        # old: disallow jump > 0.1 sec wait > allow jump, this method bugs with ult check disabling ultimate for some reason
        #if eventPlayer.ban_dead or eventPlayer.ban_emote and eventPlayer.isHoldingButton(Button.JUMP):
        if eventPlayer.ban_dead:
            if eventPlayer.isHoldingButton(Button.JUMP):
                eventPlayer.forceButtonPress(Button.JUMP)
        else:
            #Reset Hop
            eventPlayer.setStatusEffect(null, Status.ROOTED, 0.096)

        if eventPlayer.isUsingUltimate():
            eventPlayer.setDamageReceived(100)
            kill(eventPlayer, null)
            eventPlayer.setDamageReceived(0)
            wait()

    async(CheckUlt(), AsyncBehavior.RESTART)
    async(CheckAbility1(), AsyncBehavior.RESTART)
    AddonCustomLoadAndReset()

def StartGame():
    @Name "General | SUB Start Game"
    if CompMode and (CompTime < 1 or eventPlayer.comp_done):
        eventPlayer.toggle_leaderboard = true
        eventPlayer.comp_done = true
        #eventPlayer.disableRespawn()
        eventPlayer.setDamageReceived(100)
        kill(eventPlayer,null)
        eventPlayer.setDamageReceived(0)
        return

    if len(CheckpointPositions):
        if eventPlayer[0].split([]) in SaveName: # load saved progres
            SaveEnt[SaveName.index(eventPlayer[0].split([]))] = eventPlayer
            eventPlayer.checkpoint_current = SaveCp[SaveEnt.index(eventPlayer)]
            eventPlayer.timer_normal = SaveTimer[SaveEnt.index(eventPlayer)]
        else:
            eventPlayer.checkpoint_current = 0
            eventPlayer.timer_normal = 0
            MakeSave()
        UpdateTitle()
        UpdateCache()
        CheckpointFailReset()
        waitUntil(isGameInProgress(), Math.INFINITY) # FFA
        TimerResume()
    #eventPlayer.enableRespawn()
    eventPlayer.toggle_invincible = false
    eventPlayer.toggle_spectate = false
    eventPlayer.checkpoint_moved = true
    # eventPlayer.lockState = false

rule "General | Setup & Variables":
    disableInspector()
    disableGamemodeCompletion()
    disableScoring()
    disableMusic()
    disableAnnouncer()
    startForcingSpawn(Team.ALL,  0)
    startForcingSpawn(Team.ALL,  1)
    startForcingSpawn(Team.ALL,  2)
    wait(LoadOrder.setup) # wait for map data rule

    # fix team because of naming
    if ColorConfig[Customize.orb_lock] == Color.TEAM_1:
        ColorConfig[Customize.orb_lock] = Color.BLUE
    elif ColorConfig[Customize.orb_lock] == Color.TEAM_2:
        ColorConfig[Customize.orb_lock] = Color.RED

    # prevent same color lock orbs
    if ColorConfig[Customize.orb_normal] == ColorConfig[Customize.orb_lock]:
        ColorConfig[Customize.orb_lock] = Color.GREEN if ColorConfig[Customize.orb_normal] == Color.ORANGE else Color.ORANGE

    # prevent same color bhop/climb used/unused
    if ColorConfig[Customize.bhopclimb_available] == ColorConfig[Customize.bhopclimb_used]:
        ColorConfig[Customize.bhopclimb_used] = Color.ORANGE if ColorConfig[Customize.bhopclimb_available] == Color.RED else Color.RED

    SaveName = []
    SaveCp = []
    SaveTimer = []
    SaveEnt = []
    #SavePauseTime = []
    #SavePauseEnabled = []
    SaveElapsed = []

    BladeEnabledCheckpoints = [i for i in BladeEnabledCheckpoints if i + false >= 0] if len(BladeEnabledCheckpoints) else []
    DashEnabledCheckpoints = [i for i in DashEnabledCheckpoints if i + false >= 0] if len(DashEnabledCheckpoints) else []

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

    CustomPortalStart = CustomPortalStart if len(CustomPortalStart) else []
    CustomPortalEndpoint = CustomPortalEndpoint if len(CustomPortalEndpoint) else []
    CustomPortalCP = CustomPortalCP if len(CustomPortalCP) else []

    LeaderBoardFull = []
    TitleData = null
    HintCp = []
    HintText = []

    # clean out -1's after the ban has loaded
    BanBhop = [i for i in BanBhop if i + false >= 0] if len(BanBhop) else []
    BanClimb = [i for i in BanClimb if i + false >= 0] if len(BanClimb) else []
    BanEmote = [i for i in BanEmote if i + false >= 0] if len(BanEmote) else []
    BanDead = [i for i in BanDead if i + false >= 0] if len(BanDead) else []
    BanCreate = [i for i in BanCreate if i + false >= 0] if len(BanCreate) else []
    BanMulti = [i for i in BanMulti if i + false >= 0] if len(BanMulti) else []
    #BanTriple = [i for i in BanTriple if i + false >= 0] if len(BanTriple) else [] # legacy code, now auto sets it to null to save space
    BanStand = [i for i in BanStand if i + false >= 0] if len(BanStand) else []
    BanSaveDouble = BanSaveDouble if len(BanSaveDouble) else []
    BanDjump = BanDjump if len(BanDjump) else []

    #Check if old map forces ban off
    if len(DashExploitToggle):
        #DashExploitToggle = createWorkshopSetting(bool, "Ban (applies to all levels)\n封禁(应用于所有关卡)", "ban Dash Start - 0关卡Shift", true, 2)
        DashExploitToggle = null

    if createWorkshopSetting(bool,"map settings \n地图设置","Basic Map Validator - 验证地图", true, 3):
        async(AddonCheckMap, AsyncBehavior.NOOP)
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
        InstructionText = null

rule "General | Match time":
    if getCurrentGamemode() != Gamemode.SKIRMISH:
        wait()#0.25
        setMatchTime(false)#1
        wait()#1.1
        setMatchTime(false)#1
        wait()#1.1
        #wait(10)#10

    setMatchTime(70)
    pauseMatchTime()
    wait()
    TimeRemaining = 265
    while TimeRemaining or hostPlayer.editor_on:
        wait(60)
        TimeRemaining--
        if CompMode:
            CompTime--
            if not CompTime:
                bigMessage(true[0],"时间到了" checkCN "time's up")
                getAllPlayers().comp_done = true
                stopChasingVariable(getAllPlayers().timer_normal)
                #getAllPlayers().disableRespawn()
                getAllPlayers().setDamageReceived(100)
                kill(getAllPlayers(), null)
                #wait(0.032)
                #LeaderBoardRemake = true #async(CreateLeaderboard(), AsyncBehavior.RESTART)

    bigMessage(true[0], "房间已达最大持续时间, 即将重启" checkCN "maximum lobby time elapsed, restarting")
    wait(5)
    #Prevent crash during POTG and closing lobby
    getAllPlayers().lockState = true
    declarePlayerVictory(hostPlayer)
    declareTeamVictory(hostPlayer.getTeam())

rule "General | Player Initialize":
    @Event playerJoined
    eventPlayer.editor_on = createWorkshopSetting(bool, "map settings \n地图设置","Editor mode - 作图模式" ,  editoron , -1) # Turn Editor On
    eventPlayer.disableGamemodeHud()
    eventPlayer.disablePlayerCollision()
    eventPlayer.setDamageReceived(0)
    eventPlayer.lockState = true
    if eventPlayer.isDummy(): return

    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.disableRespawn()
    eventPlayer.preloadHero(Hero.GENJI)
    eventPlayer.editor_lock = true
    eventPlayer.toggle_guide = true
    eventPlayer.cache_bounceTouched = -1
    wait(1) #big waits first for about 1 second before loading, to make sure things like comp mode are fully loaded and configured, load fx in meanwhile
    createEffect(eventPlayer, Effect.RING, ColorConfig[Customize.ring_current], CheckpointPositions[eventPlayer.checkpoint_current].last(), cpCirkleFx, EffectReeval.POSITION_AND_RADIUS)
    createEffect(eventPlayer if eventPlayer.checkpoint_notLast else null, Effect.RING, ColorConfig[Customize.ring_next], CheckpointPositions[eventPlayer.checkpoint_current + 1], cpCirkleFx, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(eventPlayer if eventPlayer.checkpoint_notLast else null, Effect.LIGHT_SHAFT, ColorConfig[Customize.shaft], CheckpointPositions[eventPlayer.checkpoint_current + 1], cpCirkleFx, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createIcon(eventPlayer if eventPlayer.checkpoint_notLast else null, CheckpointPositions[eventPlayer.checkpoint_current + 1] + Vector.UP, Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, ColorConfig[Customize.nexticon_color], true)
    waitUntil(eventPlayer.hasSpawned(), Math.INFINITY)
    eventPlayer.editor_lock = false

    if CompMode:
        eventPlayer.setInvisibility(Invis.ALL)
        if eventPlayer[0].split([]) in CompAtmpSaveNames: 
            eventPlayer.comp_countAttempts = CompAtmpSaveCount[CompAtmpSaveNames.index(eventPlayer[0].split([]))]
            #smallMessage(eventPlayer,"now {0}".format(eventPlayer.comp_countAttempts))
        else: # instructions and settings for comp start
            eventPlayer.comp_instructionHud = true
            CompAtmpSaveNames.append(eventPlayer[0].split([]))
            CompAtmpSaveCount.append(1)
            eventPlayer.comp_countAttempts = 1
            eventPlayer.setMoveSpeed(0)
            eventPlayer.setAbility1Enabled(false)
            eventPlayer.setUltEnabled(false)
            waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), true)
            waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) or CompTime < 1, Math.INFINITY)
            eventPlayer.setMoveSpeed(100)
            eventPlayer.comp_instructionHud = false
        if eventPlayer.comp_countAttempts < 0 or CompTime < 1:
            eventPlayer.comp_done = true

    wait()
    StartGame()  # initialization of the game
    eventPlayer.lockState = false

rule "General | Player Leaves":
    @Event playerLeft
    if SaveCp[SaveEnt.index(eventPlayer)]:
        if SaveCp[SaveEnt.index(eventPlayer)] < len(CheckpointPositions) - 1 and SaveElapsed[SaveEnt.index(eventPlayer)]:
            SaveTimer[SaveEnt.index(eventPlayer)] = (getTotalTimeElapsed() - SaveElapsed[SaveEnt.index(eventPlayer)]) + SaveTimer[SaveEnt.index(eventPlayer)]
    else: # delete if player didnt do first cp
        DeleteSave()

rule "General | Ground: Traces, Arrive, & Reset":
    @Event eachPlayer
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isAlive()
    if not eventPlayer.checkpoint_notLast:
        if (eventPlayer.isMoving() and not (eventPlayer.toggle_practice or eventPlayer.toggle_invisible or eventPlayer.editor_on or CompMode)):
            # traces ----------------------------------------------------------------------------------------------------
            eventPlayer.cache_rainbow = [Color.RED, Color.ORANGE, Color.YELLOW, Color.LIME_GREEN, Color.GREEN, Color.TURQUOISE, Color.BLUE, Color.PURPLE, Color.VIOLET, Color.ROSE][(floor(getTotalTimeElapsed()*2))%10]
            #eventPlayer.cache_rainbow =  rgb((cosDeg(getTotalTimeElapsed()/2 * 360 - 0) + 0.5) * 255, (cosDeg(getTotalTimeElapsed/2 * 360 - 120) + 0.5) * 255, (cosDeg(getTotalTimeElapsed/2 * 360 - 240) + 0.5) * 255)
            # 1.6 - 0.2 in 0.2 steps
            playEffect(true[0], DynamicEffect.RING_EXPLOSION, eventPlayer.cache_rainbow, eventPlayer.getPosition(), 0.4)
            wait(0.048)
            playEffect(true[0], DynamicEffect.RING_EXPLOSION, eventPlayer.cache_rainbow, eventPlayer.getPosition(), 0.6)
            wait(0.048)
            playEffect(true[0], DynamicEffect.RING_EXPLOSION, eventPlayer.cache_rainbow, eventPlayer.getPosition(), 0.8)
            wait(0.048)
            playEffect(true[0], DynamicEffect.RING_EXPLOSION, eventPlayer.cache_rainbow, eventPlayer.getPosition(), 1)
            wait(0.048)
            playEffect(true[0], DynamicEffect.RING_EXPLOSION, eventPlayer.cache_rainbow, eventPlayer.getPosition(), 1.2)
            wait(0.048)
            playEffect(true[0], DynamicEffect.RING_EXPLOSION, eventPlayer.cache_rainbow, eventPlayer.getPosition(), 1.4)
            wait(0.048)
    elif eventPlayer.toggle_invincible or (CompMode and not CompTime):# or eventPlayer.lockState:
        # Do nothing
    elif distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current + 1]) <= cpcircleradius:
        # arrived ----------------------------------------------------------------------------------------------------
        if len(eventPlayer.cache_collectedLocks) < eventPlayer.cache_bounceMaxLocks: # kill player if not colleted the locks
            smallMessage(eventPlayer, "   ! 进点前需集齐所有收集球 !" checkCN "   ! collect ALL {} orbs to unlock !".format(ColorConfig[Customize.orb_lock]))
            #kill(eventPlayer, null)
            CheckpointFailReset()
        elif eventPlayer.ban_climb and eventPlayer.skill_usedClimb:
            smallMessage(eventPlayer, "   爬墙 ↑ 已禁用!" checkCN "   Climb ↑ is banned!")
            CheckpointFailReset()
        elif eventPlayer.ban_bhop and eventPlayer.skill_usedBhop:
            smallMessage(eventPlayer, "   ≥ 留小跳进点!" checkCN "   ≥ Must have a bhop to complete!")
            CheckpointFailReset()
        elif eventPlayer.ban_djump and eventPlayer.skill_usedDouble:
            smallMessage(eventPlayer, "   » 留二段跳!" checkCN "   » Must have a double jump to complete!")
            CheckpointFailReset()
        else:
            eventPlayer.checkpoint_moved = true
            eventPlayer.checkpoint_current += 1
            UpdateCache()
            # remove ult feature disabled for speedruning purposes
            #if eventPlayer.isUsingUltimate() and not eventPlayer.checkpoint_current in BladeEnabledCheckpoints:
            #    CheckpointFailReset()
            if len(CheckpointPositions[eventPlayer.checkpoint_current]) > 1:# teleport cps
                CheckpointFailReset()

            if eventPlayer.timer_splitDisplay > -Math.INFINITY:
                eventPlayer.timer_splitDisplay = (eventPlayer.timer_practice if eventPlayer.toggle_practice else eventPlayer.timer_normal) - eventPlayer.timer_split
            wait()
            playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
            playEffect(eventPlayer if CompMode or eventPlayer.toggle_invisible else true, DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, CheckpointPositions[eventPlayer.checkpoint_current] + vect(0, 1.5, 0), 4)
            # msg disabled due to annoying new sound
            #bigMessage(eventPlayer,  "{1} {0}".format(eventPlayer.checkpoint_current, "抵达检查点" checkCN "Arrived at level")   )
            wait()
            AddonCustomLoadAndReset()

            if eventPlayer.toggle_practice:
                eventPlayer.timer_split = eventPlayer.timer_practice
            else:
                UpdateTitle()
                eventPlayer.timer_split = eventPlayer.timer_normal
                DeleteSave()
                if eventPlayer.checkpoint_current == len(CheckpointPositions) - 1 and not eventPlayer.editor_on: # complete lvl
                    stopChasingVariable(eventPlayer.timer_normal)
                    wait()
                    bigMessage(true[0], "{0} {2} {1}".format(eventPlayer, prettyTime(eventPlayer.timer_normal), "已通关! 用时" checkCN "Mission complete! Time"))
                    LeaderboardUpdate()
                    if CompMode and CompAtmpNum:
                        if eventPlayer.comp_countAttempts == CompAtmpNum:
                            CompAtmpSaveCount[CompAtmpSaveNames.index(eventPlayer[0].split([]))] = -1
                            eventPlayer.comp_countAttempts = -1
                            eventPlayer.comp_done = true
                            eventPlayer.toggle_leaderboard = true
                            #eventPlayer.disableRespawn()
                            eventPlayer.setDamageReceived(100)
                            kill(eventPlayer,null)
                            eventPlayer.setDamageReceived(0)
                        else:
                            CompAtmpSaveCount[CompAtmpSaveNames.index(eventPlayer[0].split([]))] = eventPlayer.comp_countAttempts + 1
                else: # update save
                    MakeSave()
    elif distance(eventPlayer,CheckpointPositions[eventPlayer.checkpoint_current].last()) > cpcircleradius:
        CheckpointFailReset()

    eventPlayer.cache_collectedLocks = []
    wait(0.048)
    if RULE_CONDITION: goto RULE_START

rule "General | Boundary Sphere":
    @Event eachPlayer
    @Condition eventPlayer.cache_killPosition != []
    @Condition eventPlayer.toggle_invincible == false
    @Condition eventPlayer.checkpoint_notLast
    @Condition (any([normalize(rad) * distance(eventPlayer.cache_killPosition[i], eventPlayer) < rad for rad, i in eventPlayer.cache_killRadii]))
    CheckpointFailReset()

rule "General | Bounce Ball / Orb":
    @Event eachPlayer
    @Condition eventPlayer.cache_bouncePosition != []
    #@Condition eventPlayer.checkpoint_notLast # disabled coz editor
    @Condition (any([distance(pos, eventPlayer.getPosition() + Vector.UP * bounceoffset) < bounceorbdistance for pos in eventPlayer.cache_bouncePosition]))

    eventPlayer.cache_bounceTouched = BouncePositions.index([pos for pos, i in BouncePositions if
        BouncePadCheckpoints[i] == eventPlayer.checkpoint_current and
        i != eventPlayer.cache_bounceTouched and
        not (i in eventPlayer.cache_collectedLocks) and
        distance(eventPlayer + Vector.UP * bounceoffset, pos) < bounceorbdistance])

    if eventPlayer.cache_bounceTouched >= 0: # prevent same one trigering twice in a row
        if BounceToggleLock[eventPlayer.cache_bounceTouched]:
            #eventPlayer.cache_collectedLocks.append(eventPlayer.cache_bouncePosition[eventPlayer.cache_bounceTouched])
            eventPlayer.cache_collectedLocks.append(eventPlayer.cache_bounceTouched)
            smallMessage(eventPlayer, "   弹球已收集" checkCN "   orb has been collected")

        if BounceStrength[eventPlayer.cache_bounceTouched] > 0:
            eventPlayer.applyImpulse(Vector.UP, BounceStrength[eventPlayer.cache_bounceTouched], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        elif BounceStrength[eventPlayer.cache_bounceTouched] < 0:
            eventPlayer.cancelPrimaryAction()
            eventPlayer.skill_usedDouble = null
            smallMessage(eventPlayer, "   二段跳已就绪" checkCN "   Double Jump is ready")

        if BounceToggleUlt[eventPlayer.cache_bounceTouched]:
            eventPlayer.setUltEnabled(true)
            eventPlayer.setUltCharge(100)
            smallMessage(eventPlayer, "   {0} {1} ".format(abilityIconString(Hero.GENJI, Button.ULTIMATE),"终极技能已就绪" checkCN "Ultimate is ready"))

        if BounceToggleDash[eventPlayer.cache_bounceTouched]:
            if eventPlayer.isUsingAbility1():
                waitUntil(not eventPlayer.isUsingAbility1(), true)
                wait()
            eventPlayer.setAbility1Enabled(true)
            smallMessage(eventPlayer, "   {0} {1} ".format(abilityIconString(Hero.GENJI, Button.ABILITY_1),"技能1影已就绪" checkCN "Dash is ready"))

        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)
    wait(0.24)
    if RULE_CONDITION: goto RULE_START
    eventPlayer.cache_bounceTouched = -1

rule "General | Death Reset":
    @Event playerDied
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.toggle_spectate == false
    @Condition eventPlayer.comp_done == false
    if len(CheckpointPositions):
        eventPlayer.resurrect()
    else:
        eventPlayer.respawn()
    CheckpointFailReset()
    # rest is to prevent dead spamming from crashing server
    # but doing waits only when needed without relying on a variable count
    waitUntil(eventPlayer.isAlive(), true)
    waitUntil(eventPlayer.isDead(), true)
    if eventPlayer.isDead() and not(eventPlayer.toggle_spectate or eventPlayer.comp_done):
        wait(0.16)
        eventPlayer.resurrect()
        CheckpointFailReset()
        waitUntil(eventPlayer.isAlive(), true)
        waitUntil(eventPlayer.isDead(), true)
        if eventPlayer.isDead() and not(eventPlayer.toggle_spectate or eventPlayer.comp_done):
            wait(0.44)
            eventPlayer.resurrect()
            CheckpointFailReset()
            waitUntil(eventPlayer.isAlive(), true)
            waitUntil(eventPlayer.isDead(), true)
            if eventPlayer.isDead() and not(eventPlayer.toggle_spectate or eventPlayer.comp_done):
                wait(0.64)
                eventPlayer.respawn()
                CheckpointFailReset()