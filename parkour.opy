#!mainFile "framework.opy"

rule "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Parkour v" versionhere " ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒":
    @Delimiter

rule "Parkour | Setup & Variables":
    #◀ The Official Genji Parkour Editor ▶
    #Discord: dsc.gg/genjiparkour
    #Code: 54CRY
    #Adapted by: LulledLion, FishoFire, Nebula
    disableGamemodeCompletion()
    disableScoring()
    disableMusic()
    disableAnnouncer()
    startForcingSpawn(Team.ALL, 0)
    startForcingSpawn(Team.ALL, 1)
    startForcingSpawn(Team.ALL, 2)

    wait(LoadOrder.setup) # wait for map data rule
    EditorOn = createWorkshopSetting(bool, "Map Settings ■ 地图设置 ■ 맵 설정", "Editor Mode ■ 作图模式 ■ 수정 모드", editorDefaultOn, 0) # Turn Editor On
    if createWorkshopSetting(bool, "Map Settings ■ 地图设置 ■ 맵 설정", "Basic Map Validator ■ 验证地图 ■ 맵 가능 여부 확인기", true, 3):
        async(AddonCheckMap, AsyncBehavior.NOOP)
    PortalOn = createWorkshopSetting(bool, "Map Settings ■ 地图设置 ■ 맵 설정", "Portals (Control Maps) ■ 启用传送门 (占点地图) ■ 순간이동 활성화 (쟁탈 맵)", true, 4)
    CompMode = not EditorOn and createWorkshopSetting(bool, "Tournament Mode ■ 竞赛模式 ■ 토너먼트 모드", "Tournament Mode ■ 开启竞赛模式 ■ 토너먼트 모드 활성화", compModeToggle, 100)
    if CompMode:
        # -! comp minutes !-
        CompTime = createWorkshopSetting(int[1:240], "Tournament Mode ■ 竞赛模式 ■ 토너먼트 모드", "Time Limit (Global) ■ 时间限制 ■ 시간 제한 (전체)", compTimeLimit, 101) # 5-240
        # -! comp attempt count !-
        CompAtmpNum = createWorkshopSetting(int[0:500], "Tournament Mode ■ 竞赛模式 ■ 토너먼트 모드", "Attempt Count ■ 尝试次数 ■ 시도 수 확인", attemptCount, 102)
        # -! comp restartlimiter !-
        CompRestartLimit = createWorkshopSetting(bool, "Tournament Mode ■ 竞赛模式 ■ 토너먼트 모드", "Disable Restart During Run ■ 竞赛中禁用重新开始 ■ 시도 중 재시작 비활성화", compRestartLimit, 103)
    else:
        InstructionText = null

    SaveName = []
    SaveCp = []
    SaveTimer = []
    SaveEnt = []
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

rule "Parkour | Match time":
    if getCurrentGamemode() != Gamemode.SKIRMISH:
        wait()
        setMatchTime(false)
        wait()
        setMatchTime(false)
        wait()

    setMatchTime(70)
    pauseMatchTime()
    wait()
    LobbyID = "v"
    TimeRemaining = 265
    while TimeRemaining:
        wait(60)
        TimeRemaining--
        if CompMode:
            CompTime--
            if not CompTime:
                bigMessage(true[0], "时间到了" checkCN "Time's Up")
                getAllPlayers().comp_done = true
                stopChasingVariable(getAllPlayers().timer_normal)
                getAllPlayers().setDamageReceived(100)
                kill(getAllPlayers(), null)
                #wait(0.032)
                #LeaderBoardRemake = true #async(CreateLeaderboard(), AsyncBehavior.RESTART)
    #"房间已达最大持续时间, 即将重启" checkCN "Maximum Lobby Time Reached, Restarting"
    bigMessage(true[0], t"Maximum Lobby Time Reached, Restarting")
    wait(5)
    #Prevent crash during POTG and closing lobby
    getAllPlayers().lockState = true
    declarePlayerVictory(hostPlayer)
    declareTeamVictory(hostPlayer.getTeam())

rule "Parkour | Player Initialize":
    @Event playerJoined
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
    #eventPlayer.toggle_quickRestart = true
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

rule "Parkour | Player Leaves":
    @Event playerLeft
    if SaveCp[SaveEnt.index(eventPlayer)]:
        if SaveCp[SaveEnt.index(eventPlayer)] < len(CheckpointPositions) - 1 and SaveElapsed[SaveEnt.index(eventPlayer)]:
            SaveTimer[SaveEnt.index(eventPlayer)] = (getTotalTimeElapsed() - SaveElapsed[SaveEnt.index(eventPlayer)]) + SaveTimer[SaveEnt.index(eventPlayer)]
    else: # delete if player didnt do first cp
        DeleteSave()

rule "Parkour | Ground: Traces, Arrive, & Reset":
    @Event eachPlayer
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isAlive()
    if not eventPlayer.checkpoint_notLast:
        if (eventPlayer.isMoving() and not (eventPlayer.toggle_practice or eventPlayer.toggle_invisible or EditorOn or CompMode)):
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
    elif eventPlayer.toggle_invincible or eventPlayer.toggle_spectate or (CompMode and not CompTime):# or eventPlayer.lockState:
        # Do nothing
    elif distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current + 1]) <= cpCircleRadius:
        # arrived ----------------------------------------------------------------------------------------------------
        if len(eventPlayer.cache_collectedLocks) < eventPlayer.cache_bounceMaxLocks:
            #"   ! 进点前需集齐所有收集球 !" checkCN "   ! collect ALL {} orbs to unlock !".format(ColorConfig[Customize.orb_lock])
            smallMessage(eventPlayer, t"   ! Collect All Lock Orbs To Complete !")  
            CheckpointFailReset() # kill player if not colleted the locks
        elif eventPlayer.ban_climb and eventPlayer.skill_usedClimb:
            #"   爬墙 ↑ 已禁用!" checkCN "   Climb ↑ is banned!")
            smallMessage(eventPlayer, t"   Climb ↑ Is Banned!")
            CheckpointFailReset()
        elif eventPlayer.ban_bhop and eventPlayer.skill_usedBhop:
            #"   ≥ 留小跳进点!" checkCN "   ≥ Must Have A Bhop To Complete!!"
            smallMessage(eventPlayer, t"   ≥ Must Have A Bhop To Complete!")
            CheckpointFailReset()
        elif eventPlayer.ban_djump and eventPlayer.skill_usedDouble:
            #"   » 留二段跳!" checkCN "   » Must Have A Double Jump To Complete!"
            smallMessage(eventPlayer, t"   » Must Have A Double Jump To Complete!")
            CheckpointFailReset()
        else:
            eventPlayer.checkpoint_moved = true
            eventPlayer.checkpoint_current += 1
            if eventPlayer.timer_splitDisplay > -Math.INFINITY:
                eventPlayer.timer_splitDisplay = (eventPlayer.timer_practice if eventPlayer.toggle_practice else eventPlayer.timer_normal) - eventPlayer.timer_split
            if eventPlayer.toggle_practice:
                eventPlayer.timer_split = eventPlayer.timer_practice
            else:
                eventPlayer.timer_split = eventPlayer.timer_normal
                DeleteSave()
                if eventPlayer.checkpoint_current == len(CheckpointPositions) - 1 and not EditorOn: # complete lvl
                    stopChasingVariable(eventPlayer.timer_normal)
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
                    #"已通关! 用时" checkCN "Mission Complete! Time"
                    bigMessage(true[0], f"{eventPlayer} {t'Mission Complete! Time'} {eventPlayer.timer_normal} Sec")
                    wait()
                else: # update save
                    MakeSave()
                UpdateTitle()
            UpdateCache()
            if len(CheckpointPositions[eventPlayer.checkpoint_current]) > 1:# teleport cps
                CheckpointFailReset()
            else:
                AddonCustomLoadAndReset()
            wait()
            # msg disabled due to annoying new sound
            #bigMessage(eventPlayer,  "{1} {0}".format(eventPlayer.checkpoint_current, "抵达检查点" checkCN "Arrived at level"))
            playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, null, eventPlayer, 100)
            playEffect(eventPlayer if CompMode or eventPlayer.toggle_invisible else true, DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, eventPlayer.getPosition(), 4)
    elif distance(eventPlayer,CheckpointPositions[eventPlayer.checkpoint_current].last()) > cpCircleRadius:
        CheckpointFailReset()
    elif not(eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility1()) and eventPlayer.getHorizontalSpeed() > 6.0008:
        LobbyID = []

    eventPlayer.cache_collectedLocks = []
    wait(0.048)
    if RULE_CONDITION: goto RULE_START

rule "Parkour | Boundary Sphere":
    @Event eachPlayer
    @Condition eventPlayer.cache_killPosition != []
    @Condition eventPlayer.toggle_invincible == false
    @Condition eventPlayer.checkpoint_notLast
    @Condition (any([normalize(rad) * distance(eventPlayer.cache_killPosition[i], eventPlayer) < rad for rad, i in eventPlayer.cache_killRadii]))
    CheckpointFailReset()

rule "Parkour | Bounce Ball / Orb":
    @Event eachPlayer
    @Condition eventPlayer.cache_bouncePosition != []
    #@Condition eventPlayer.checkpoint_notLast # disabled coz editor
    @Condition (any([distance(pos, eventPlayer.getPosition() + Vector.UP * bounceOffset) < bounceOrbDistance for pos in eventPlayer.cache_bouncePosition]))

    eventPlayer.cache_bounceTouched = BouncePositions.index([pos for pos, i in BouncePositions if
        BouncePadCheckpoints[i] == eventPlayer.checkpoint_current and
        i != eventPlayer.cache_bounceTouched and
        not (i in eventPlayer.cache_collectedLocks) and
        distance(eventPlayer + Vector.UP * bounceOffset, pos) < bounceOrbDistance])

    if eventPlayer.cache_bounceTouched >= 0: # prevent same one activating twice in a row
        if BounceToggleLock[eventPlayer.cache_bounceTouched]:
            #eventPlayer.cache_collectedLocks.append(eventPlayer.cache_bouncePosition[eventPlayer.cache_bounceTouched])
            eventPlayer.cache_collectedLocks.append(eventPlayer.cache_bounceTouched)
            #"   弹球已收集" checkCN "   orb has been collected"
            smallMessage(eventPlayer, t"   Collected Orb")

        if BounceStrength[eventPlayer.cache_bounceTouched] > 0:
            eventPlayer.applyImpulse(Vector.UP, BounceStrength[eventPlayer.cache_bounceTouched], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        elif BounceStrength[eventPlayer.cache_bounceTouched] < 0:
            eventPlayer.cancelPrimaryAction()
            eventPlayer.skill_usedDouble = null
            #"   二段跳已就绪" checkCN "   » Double Jump is ready"
            smallMessage(eventPlayer, t"   » Double Jump Is Ready")

        if BounceToggleUlt[eventPlayer.cache_bounceTouched]:
            eventPlayer.setUltEnabled(true)
            eventPlayer.setUltCharge(100)
            #"终极技能已就绪" checkCN "Ultimate is ready"
            smallMessage(eventPlayer, f"   {abilityIconString(Hero.GENJI, Button.ULTIMATE)} {t'Ultimate Is Ready'}")

        if BounceToggleDash[eventPlayer.cache_bounceTouched]:
            if eventPlayer.isUsingAbility1():
                waitUntil(not eventPlayer.isUsingAbility1(), true)
                wait()
            eventPlayer.setAbility1Enabled(true)
            #"技能1影已就绪" checkCN "Dash is ready"
            smallMessage(eventPlayer, f"   {abilityIconString(Hero.GENJI, Button.ABILITY_1)} {t'Dash Is Ready'}")

        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, null, eventPlayer, 75)
    wait(0.24)
    if RULE_CONDITION: goto RULE_START
    eventPlayer.cache_bounceTouched = -1

rule "Parkour | Death Reset":
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

def UpdateCache():
    @Name "Parkour | SUB Update Effect Cache"
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
        eventPlayer.ban_multi = createWorkshopSetting(bool, "Ban (All Levels) ■ 封禁(应用于所有关卡) ■ 금지 (모든 레벨에 적용)", "Ban Multiclimb ■ 封禁蹭留 ■ 무한 벽타기 금지", false, 1) or eventPlayer.checkpoint_current in BanMulti
        if eventPlayer.ban_multi:
            eventPlayer.banString = "∞ {}".format(eventPlayer.banString)
        eventPlayer.ban_create = createWorkshopSetting(bool, "Ban (All Levels) ■ 封禁(应用于所有关卡) ■ 금지 (모든 레벨에 적용)", "Ban Createbhop ■ 封禁卡小 ■ 콩콩이 생성 금지", false, 2) or eventPlayer.checkpoint_current in BanCreate
        if eventPlayer.ban_create:
            eventPlayer.banString = "♂ {}".format(eventPlayer.banString)
        eventPlayer.ban_standcreate = createWorkshopSetting(bool, "Ban (All Levels) ■ 封禁(应用于所有关卡) ■ 금지 (모든 레벨에 적용)","Ban Standcreate ■ 封禁站卡 ■ 서서 콩콩이 생성 금지", false, 3) or eventPlayer.checkpoint_current in BanStand
        if eventPlayer.ban_standcreate:
            eventPlayer.banString = "♠ {}".format(eventPlayer.banString) # ≥  √ ▼ ↓
        eventPlayer.ban_dead = createWorkshopSetting(bool, "Ban (All Levels) ■ 封禁(应用于所有关卡) ■ 금지 (모든 레벨에 적용)", "Ban Deathbhop ■ 封禁死小 ■ 죽음 콩콩이 금지", false, 4) or eventPlayer.checkpoint_current in BanDead
        if eventPlayer.ban_dead:
            eventPlayer.banString = "X {}".format(eventPlayer.banString)
        eventPlayer.ban_emote = createWorkshopSetting(bool, "Ban (All Levels) ■ 封禁(应用于所有关卡) ■ 금지 (모든 레벨에 적용)", "Ban Emote Savehop ■ 封禁表情留小 ■ 감정표현 콩콩이 금지", false, 5) or eventPlayer.checkpoint_current in BanEmote
        if eventPlayer.ban_emote:
            eventPlayer.banString = "♥ {}".format(eventPlayer.banString)
        eventPlayer.ban_savedouble = createWorkshopSetting(bool, "Ban (All Levels) ■ 封禁(应用于所有关卡) ■ 금지 (모든 레벨에 적용)", "Ban Save Double ■ 封禁留二段跳 ■ 이단점프 킵 금지", false, 6) or eventPlayer.checkpoint_current in BanSaveDouble
        if eventPlayer.ban_savedouble:
            eventPlayer.banString = "△ {}".format(eventPlayer.banString)
        eventPlayer.ban_climb = createWorkshopSetting(bool, "Ban (All Levels) ■ 封禁(应用于所有关卡) ■ 금지 (모든 레벨에 적용)", "Ban Wallclimb ■ 封禁爬墙 ■ 벽타기 금지", false, 7) or eventPlayer.checkpoint_current in BanClimb
        if eventPlayer.ban_climb:
            eventPlayer.banString = "↑ {}".format(eventPlayer.banString)
        eventPlayer.ban_bhop = createWorkshopSetting(bool, "Ban (All Levels) ■ 封禁(应用于所有关卡) ■ 금지 (모든 레벨에 적용)","Require Bhop Available ■ 留小跳进点 ■ 도착 시 콩콩이 필요", false, 8) or eventPlayer.checkpoint_current in BanBhop
        if eventPlayer.ban_bhop:
            eventPlayer.banString = "≥ {}".format(eventPlayer.banString) # ≥  √ ▼ ↓
        eventPlayer.ban_djump = createWorkshopSetting(bool, "Ban (All Levels) ■ 封禁(应用于所有关卡) ■ 금지 (모든 레벨에 적용)","Require Djump Available ■ 留二段跳进点 ■ 도착 시 이단 점프 필요", false, 9) or eventPlayer.checkpoint_current in BanDjump
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
    async(CheckUlt(), AsyncBehavior.NOOP)
    async(CheckAbility1(), AsyncBehavior.NOOP)

    if eventPlayer != hostPlayer or not EditorOn: return
    EditUpdateSelectedIds()
    destroyEffect(hostPlayer.editor_hitboxEffect)
    createEffect(hostPlayer if hostPlayer.editor_hitboxToggle else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[hostPlayer.checkpoint_current], cpCircleRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    hostPlayer.editor_hitboxEffect = getLastCreatedEntity()
    createEffect(hostPlayer if hostPlayer.editor_hitboxToggle and hostPlayer.checkpoint_notLast else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[hostPlayer.checkpoint_current + 1], cpCircleRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    hostPlayer.editor_hitboxEffect.append(getLastCreatedEntity())
    hostPlayer.editor_bounceIndex = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in BouncePadCheckpoints] if e >=0]
    hostPlayer.editor_killIndex = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in KillballCheckpoints] if e >=0]
    if hostPlayer.checkpoint_moved:
        EditorSelectLast()
        hostPlayer.checkpoint_moved = false

def DeleteSave():
    @Name "Parkour | SUB Delete Save"
    del SaveName[SaveEnt.index(eventPlayer)]
    del SaveCp[SaveEnt.index(eventPlayer)]
    del SaveTimer[SaveEnt.index(eventPlayer)]
    del SaveElapsed[SaveEnt.index(eventPlayer)]
    del SaveEnt[SaveEnt.index(eventPlayer)] # must always be last because its the index itself

def MakeSave():
    @Name "Parkour | SUB Make Save"
    SaveEnt.append(eventPlayer)
    SaveName.append(eventPlayer[0].split([]))
    SaveCp.append(eventPlayer.checkpoint_current)
    SaveTimer.append(eventPlayer.timer_normal)
    SaveElapsed.append(getTotalTimeElapsed())

def TimerPause():
    @Name "Parkour | SUB Timer Pause"
    stopChasingVariable(eventPlayer.timer_normal)
    if not eventPlayer in SaveEnt: return
    SaveTimer[SaveEnt.index(eventPlayer)] = eventPlayer.timer_normal
    SaveElapsed[SaveEnt.index(eventPlayer)] = null

def TimerResume():
    @Name "Parkour | SUB Timer Resume"
    chase(eventPlayer.timer_normal, Math.INFINITY, rate=1, ChaseReeval.NONE)
    SaveElapsed[SaveEnt.index(eventPlayer)] = getTotalTimeElapsed()

def LeaderboardUpdate():
    @Name "Parkour | SUB Leaderboard Update"
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
    LeaderBoardFull.append([[eventPlayer[0].split([]), eventPlayer.timer_normal, "{0} sec".format(eventPlayer.timer_normal)]])
    LeaderBoardRemake = true #CreateLeaderboard()

def CheckpointFailReset():
    @Name "Parkour | SUB Checkpoint Fail"
    eventPlayer.timer_split = eventPlayer.timer_practice if eventPlayer.toggle_practice else eventPlayer.timer_normal
    eventPlayer.cache_collectedLocks = []
    eventPlayer.cancelPrimaryAction()
    eventPlayer.skill_usedDouble = null

    if not (eventPlayer.checkpoint_current or eventPlayer.toggle_practice):
        eventPlayer.timer_normal = 0
        eventPlayer.timer_split = 0

    if len(CheckpointPositions):
        if eventPlayer.isUsingAbility1():
            eventPlayer.startForcingPosition(eventPlayer, false)
            waitUntil(not eventPlayer.isUsingAbility1(), true)
            wait()
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
    @Name "Parkour | SUB Start Game"
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