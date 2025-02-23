#!mainFile "genji.opy"

rule "<tx0C00000000001344> Commands <tx0C00000000001344>":
    @Delimiter

rule "Command | Toggle Leaderboard (Hold Melee)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.EditorOn == false
    wait(1, Wait.ABORT_WHEN_FALSE)

    eventPlayer.LeaderboardToggle = not eventPlayer.LeaderboardToggle

rule "Command | Split hide (Hold Dash + Primary + Secondary)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    wait(1, Wait.ABORT_WHEN_FALSE)

    #smallMessage(eventPlayer, "   split display off" if eventPlayer.splitdisplay != -Math.INFINITY else "   split display on")
    eventPlayer.splitdisplay = 0 if eventPlayer.splitdisplay == -Math.INFINITY else -Math.INFINITY
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.32)
    smallMessage(eventPlayer, "   split display off" if eventPlayer.splitdisplay == -Math.INFINITY else "   split display on")

rule "Command | Toggle Invisible (Hold Deflect)":
    @Condition enableInvisCommand
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.EditorOn == false
    @Condition CompMode == false
    wait(1, Wait.ABORT_WHEN_FALSE)

    eventPlayer.invis = not eventPlayer.invis
    eventPlayer.setInvisibility(Invis.NONE)
    if eventPlayer.invis:
        eventPlayer.setInvisibility(Invis.ALL)

    smallMessage(eventPlayer, "   {1} {0}".format("on" if eventPlayer.invis else "off","隐身模式" checkCN "Invisible"))
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, null, eventPlayer, 100)

/*
previewarray = list of all vectors to be displayed
previewarray2 = stored item ID to be used to preview abilities etc
a few huds show/hides when reviewarray is not null !!!!!!!!!!!!!!!!!
*/
rule "Command | Preview Orbs & Portals (Hold Primary)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.EditorOn == false
    @Condition eventPlayer.LockState == false
    @Condition eventPlayer.NotOnLastCp
    #wait(0.9, Wait.ABORT_WHEN_FALSE)
    wait(0.45, Wait.ABORT_WHEN_FALSE)
    eventPlayer.PreviewsArray = [CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]]

    if len(BouncePadCheckpoints) > 0:
        eventPlayer.PreviewsArray.append( ( [i for i in BouncePositions if BouncePadCheckpoints[BouncePositions.index(i)] == eventPlayer.CurrentCheckpoint] ) )
        eventPlayer.PreviewsArray2 = [-2] # first entry is checkpoint itself, -1 would overlap with -1 in some orbs
        eventPlayer.PreviewsArray2.append( [i for _, i in BouncePadCheckpoints] )
        eventPlayer.PreviewsArray2 = [ i for i in eventPlayer.PreviewsArray2 if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint or i == -2 ]

    if len(CustomPortalStart) > 0:
        #eventPlayer.PreviewsArray.append( [i for i in CustomPortalStart if CustomPortalCP[CustomPortalStart.index(i)] == eventPlayer.CurrentCheckpoint] )
        for eventPlayer.PreviewsI in range(len(eventPlayer.PortalStart_Cache)):
            eventPlayer.PreviewsArray.append([eventPlayer.PortalStart_Cache[eventPlayer.PreviewsI ],eventPlayer.PortalEnd_cache[eventPlayer.PreviewsI ]])
            eventPlayer.PreviewsArray2.append([[0,eventPlayer.PreviewsI],[1,eventPlayer.PreviewsI]])
            wait()

    wait(0.1)
    eventPlayer.setMoveSpeed(0)
    eventPlayer.PreviewsI = 0
    eventPlayer.startCamera(
        eventPlayer.PreviewsArray[eventPlayer.PreviewsI] + eventPlayer.getFacingDirection()*-3.5,
        eventPlayer.PreviewsArray[eventPlayer.PreviewsI],
        15
    )
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.JUMP)
    while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.isAlive() and not eventPlayer.LockState:
        if eventPlayer.getThrottle().x < -0.5:
            eventPlayer.PreviewsI = 0 if eventPlayer.PreviewsI + 1 >= len(eventPlayer.PreviewsArray) else eventPlayer.PreviewsI + 1
            waitUntil(eventPlayer.getThrottle().x > -0.5, 1)
        elif eventPlayer.getThrottle().x > 0.5:
            eventPlayer.PreviewsI = len(eventPlayer.PreviewsArray) -1  if eventPlayer.PreviewsI == 0 else  eventPlayer.PreviewsI - 1
            waitUntil(eventPlayer.getThrottle().x < 0.5, 1)
        wait()
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.stopCamera()
    eventPlayer.setMoveSpeed(100)
    eventPlayer.PreviewsI = null
    eventPlayer.PreviewsArray = null
    eventPlayer.PreviewsArray2 = null

rule "Command | Restart Run (Crouch + Interact + Deflect)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.LockEditor == false or eventPlayer != hostPlayer
    @Condition eventPlayer.LockState == false
    #@Condition eventPlayer.isUsingAbility1() == false

    eventPlayer.LockState = true
    # prevent 0.02 time bug with next 2 checks
    if eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 2 and eventPlayer.getAltitude() < 3:
        waitUntil(eventPlayer.isOnGround(), 3)
        wait(0.42) # 0.64
    if eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1:
        wait(0.42)

    if CompMode:
        wait()
        if CompTime < 1:
            smallMessage(eventPlayer, "   比赛结束" checkCN "   Competition is over"  )
            eventPlayer.LockState = false
            return
        elif eventPlayer.CompDone:
            eventPlayer.LockState = false
            return
        elif CompRestartLimit and eventPlayer.NotOnLastCp:
            smallMessage(eventPlayer, "   禁止在此比赛中运行期间重新启动" checkCN "   Restart during run is disabled for this competition")
            eventPlayer.LockState = false
            return
        elif CompAtmpNum > 0:
            if eventPlayer.AttemptCount == CompAtmpNum:
                smallMessage(eventPlayer, "   最后一次尝试" checkCN "   This is your final attempt"  )
                eventPlayer.LockState = false
                return
            if eventPlayer.AttemptCount == (-1):
                smallMessage(eventPlayer, "   你没有尝试过" checkCN "   You are out of attempts"  )
                eventPlayer.LockState = false
                return
            eventPlayer.AttemptCount ++
            CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))] = eventPlayer.AttemptCount


    eventPlayer.flytoggle = null
    eventPlayer.CurrentCheckpoint = 0
    eventPlayer.PracticeToggle = false
    stopChasingVariable(eventPlayer.practicetimer)
    eventPlayer.practicetimer = 0
    eventPlayer.splitdisplay = -Math.INFINITY if eventPlayer.splitdisplay == -Math.INFINITY else 0
    if eventPlayer in SaveEnt:
        DeleteSave()

    if eventPlayer.isDead():
        eventPlayer.resurrect()
        #eventPlayer.respawn()

    StartGame()
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait()
    #eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.LockState = false
    if CompMode:
        wait(1)
    else:
        wait()

rule "Command | Spectate (Hold Interact)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    @Condition not (eventPlayer.EditorOn and eventPlayer.isHoldingButton(Button.MELEE))
    @Condition not eventPlayer.EditorOn or not(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))
    #@Condition editoron == false
    wait(1, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.EditorOn: # editor has interact combos
        wait(1, Wait.ABORT_WHEN_FALSE)

    if eventPlayer.SpectateToggle:
        #eventPlayer.enableRespawn()
        eventPlayer.resurrect()
        #eventPlayer.respawn()
        if eventPlayer.PracticeToggle:
            chase(eventPlayer.practicetimer, Math.INFINITY, rate=1, ChaseReeval.NONE)
        elif eventPlayer.NotOnLastCp:
            chase(eventPlayer.Timer, Math.INFINITY, rate=1, ChaseReeval.NONE)
            StopPauseTimer()
        checkpointFailReset()
    else:
        smallMessage(eventPlayer, "   再次长按互动键关闭观战模式" checkCN "   Hold Interact again to turn off spectate mode")
        eventPlayer.InvincibleToggle = false
        if eventPlayer.NotOnLastCp:
            StartPauseTimer()
        stopChasingVariable(eventPlayer.practicetimer)
        stopChasingVariable(eventPlayer.Timer)
        #eventPlayer.disableRespawn()
        eventPlayer.setDamageReceived(100)
        kill(eventPlayer, null)
        eventPlayer.setDamageReceived(0)
    eventPlayer.SpectateToggle = not eventPlayer.SpectateToggle

rule "Command | Toggle Invincible Mode (Melee + Reload)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    #@Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isAlive()
    @Condition not (CompMode and eventPlayer.CompDone)
    @Condition eventPlayer.LockState == false

    eventPlayer.LockState = true
    eventPlayer.LockCollected = []

    if eventPlayer.InvincibleToggle:
        if eventPlayer.PracticeToggle:
            bigMessage(eventPlayer, "练习模式" checkCN "Practice mode")
            chase(eventPlayer.practicetimer, Math.INFINITY, rate=1, ChaseReeval.NONE)
        elif eventPlayer.NotOnLastCp:
            bigMessage(eventPlayer,"跑图模式" checkCN "Normal mode")
            chase(eventPlayer.Timer, Math.INFINITY, rate=1, ChaseReeval.NONE)
            StopPauseTimer()
        checkpointFailReset()
    else:
        bigMessage(eventPlayer,"探点模式" checkCN "Invincible mode")
        StartPauseTimer()
        stopChasingVariable(eventPlayer.Timer)
        stopChasingVariable(eventPlayer.practicetimer)
        async(CheckUlt(), AsyncBehavior.RESTART)
        async(CheckDash(), AsyncBehavior.RESTART)

    eventPlayer.InvincibleToggle = not eventPlayer.InvincibleToggle
    eventPlayer.LockState = false
    wait()

rule "Command | Toggle Practice Mode (Melee + Ultimate)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    #@Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.EditorOn == false
    @Condition CompMode == false
    @Condition eventPlayer.LockState == false

    eventPlayer.LockState = true
    #eventPlayer.disallowButton(Button.ABILITY_1)

    if eventPlayer.PracticeToggle:
        bigMessage(eventPlayer,"跑图模式" checkCN "Normal mode")
        eventPlayer.CurrentCheckpoint = eventPlayer.PracticeCheckpoint
        stopChasingVariable(eventPlayer.practicetimer)
        if eventPlayer.NotOnLastCp or eventPlayer.InvincibleToggle:
            eventPlayer.splittime = eventPlayer.Timer
            chase(eventPlayer.Timer, Math.INFINITY, rate=1, ChaseReeval.NONE)
            StopPauseTimer()
        UpdateCache()
        checkpointFailReset()
    else:
        bigMessage(eventPlayer,"练习模式" checkCN "Practice mode")
        eventPlayer.PracticeCheckpoint = eventPlayer.CurrentCheckpoint
        stopChasingVariable(eventPlayer.Timer)
        if eventPlayer.NotOnLastCp:
            StartPauseTimer()
        eventPlayer.splitdisplay = -Math.INFINITY if eventPlayer.splitdisplay == -Math.INFINITY else 0
        eventPlayer.splittime = 0
        eventPlayer.practicetimer = 0
        chase(eventPlayer.practicetimer, Math.INFINITY, rate=1, ChaseReeval.NONE)
        if eventPlayer.InvincibleToggle:
            eventPlayer.InvincibleToggle = false
            checkpointFailReset()
    #wait(0.2)
    #eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.PracticeToggle = not eventPlayer.PracticeToggle
    eventPlayer.LockState = false
    wait(0.1)

rule "Command | Restart Practice (Hold Interact)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    @Condition eventPlayer.isAlive() or eventPlayer.SpectateToggle
    @Condition eventPlayer.EditorOn == false
    @Condition eventPlayer.PracticeToggle
    @Condition eventPlayer.LockState == false

    #  first 2 ifs prevent collide with spec
    if eventPlayer.SpectateToggle:
        waitUntil(eventPlayer.isAlive(), Math.INFINITY)
        waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 2)
        return
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 0.9)
    if eventPlayer.isHoldingButton(Button.INTERACT):
        return

    eventPlayer.practicetimer = 0
    eventPlayer.splittime = 0
    eventPlayer.CurrentCheckpoint = eventPlayer.PracticeCheckpoint
    UpdateCache()
    checkpointFailReset()

rule "Command | Skip (Crouch + Primary-Next | Secondary-Previous)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) )
    #@Condition hostPlayer.EditorOn or ( eventPlayer.PracticeToggle and eventPlayer.isHoldingButton(Button.ABILITY_1) )
    @Condition eventPlayer.LockState == false
    @Condition hostPlayer.EditorOn or eventPlayer.PracticeToggle
    @Condition len(CheckpointPositions) > 1
    @Condition EditorMoveItem == false
    @Condition (eventPlayer.LockEditor and eventPlayer == hostPlayer) == false
    eventPlayer.LockState = true
    eventPlayer.splittime = 0
    eventPlayer.practicetimer = 0
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        #eventPlayer.LockState = true
        if eventPlayer.CurrentCheckpoint < 1:
            eventPlayer.CurrentCheckpoint = len(CheckpointPositions) - 1
        elif (len(CheckpointPositions[eventPlayer.CurrentCheckpoint -1]) > 1 and distance(CheckpointPositions[eventPlayer.CurrentCheckpoint ][0], CheckpointPositions[eventPlayer.CurrentCheckpoint-1][1]) < cpcircleradius):
            # if last cp is an instant complete teleport cp, go back further
            eventPlayer.CurrentCheckpoint -= 2
        else:
            eventPlayer.CurrentCheckpoint -= 1
    else:
        #eventPlayer.LockState = true

        if eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1:
            eventPlayer.CurrentCheckpoint = 0
        else:
            eventPlayer.CurrentCheckpoint += 1

    wait(0.064)
    eventPlayer.LockState = false
    UpdateCache()
    checkpointFailReset()
    eventPlayer.MovedCheckpoint = true
    wait()
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 0.28) # faster if you spam button
    if RULE_CONDITION:
        goto RULE_START

rule "Command | Quick Reset (Reload | Hold Reload to Enable)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false

    if eventPlayer.QuickRestartToggle:
        if eventPlayer.flytoggle:
            eventPlayer.flytoggle = CheckpointPositions[eventPlayer.CurrentCheckpoint].last()
        checkpointFailReset()
        wait(0.32)
    wait(1, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    eventPlayer.QuickRestartToggle = not eventPlayer.QuickRestartToggle
    bigMessage(eventPlayer,
        ("快速回点已启用" if eventPlayer.QuickRestartToggle else "快速回点已关闭")
        checkCN
        "Quick reset is enabled" if eventPlayer.QuickRestartToggle else "Quick reset is disabled"
    )

rule "Command | Toggle Hud (Hold Secondary)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition not (eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.ABILITY_1)) # don't trigger during skipping
    @Condition not (eventPlayer.EditorOn and eventPlayer == hostPlayer and eventPlayer.isHoldingButton(Button.MELEE))
    @Condition EditorMoveItem == false

    wait(1.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer,
        ("   HUD已开启" if eventPlayer.GuideToggle else  "HUD已隐藏")
        checkCN
        ("   Hud is now open" if eventPlayer.GuideToggle else "   Hud is now hidden")
    )
    eventPlayer.GuideToggle = not eventPlayer.GuideToggle

rule "Command | Toggle Hints (Melee + Deflect)":
    @Event eachPlayer
    @Condition HintText != null
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.HintsOn or eventPlayer.CurrentCheckpoint in HintCp

    eventPlayer.HintsOn = not eventPlayer.HintsOn