#!mainFile "genji.opy"

rule "<tx0C00000000001344> Commands <tx0C00000000001344>":
    @Delimiter

rule "Command | Toggle Leaderboard (Hold Melee)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.editor_on == false
    wait(1, Wait.ABORT_WHEN_FALSE)

    eventPlayer.toggle_leaderboard = not eventPlayer.toggle_leaderboard

rule "Command | Split hide (Hold Dash + Primary + Secondary)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    wait(1, Wait.ABORT_WHEN_FALSE)

    #smallMessage(eventPlayer, "   split display off" if eventPlayer.timer_splitDisplay != -Math.INFINITY else "   split display on")
    eventPlayer.timer_splitDisplay = 0 if eventPlayer.timer_splitDisplay == -Math.INFINITY else -Math.INFINITY
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.32)
    smallMessage(eventPlayer, "   split display off" if eventPlayer.timer_splitDisplay == -Math.INFINITY else "   split display on")

rule "Command | Toggle Invisible (Hold Deflect)":
    @Condition enableInvisCommand
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.editor_on == false
    @Condition CompMode == false
    wait(1, Wait.ABORT_WHEN_FALSE)

    eventPlayer.toggle_invisible = not eventPlayer.toggle_invisible
    eventPlayer.setInvisibility(Invis.NONE)
    if eventPlayer.toggle_invisible:
        eventPlayer.setInvisibility(Invis.ALL)

    smallMessage(eventPlayer, "   {1} {0}".format("on" if eventPlayer.toggle_invisible else "off","隐身模式" checkCN "Invisible"))
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, null, eventPlayer, 100)

/*
previewarray = list of all vectors to be displayed
previewarray2 = stored item ID to be used to preview abilities etc
a few huds show/hides when reviewarray is not null !!!!!!!!!!!!!!!!!
*/
rule "Command | Preview Orbs & Portals (Hold Primary)": #$$ various
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.editor_on == false
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.checkpoint_notLast
    #wait(0.9, Wait.ABORT_WHEN_FALSE)
    wait(0.45, Wait.ABORT_WHEN_FALSE)
    eventPlayer.preview_array1 = [CheckpointPositions[eventPlayer.checkpoint_current + 1]]

    if len(BouncePadCheckpoints) > 0:
        eventPlayer.preview_array1.append([i for i in BouncePositions if BouncePadCheckpoints[BouncePositions.index(i)] == eventPlayer.checkpoint_current])
        # first entry is checkpoint itself, -1 would overlap with -1 in some orbs
        eventPlayer.preview_array2 = [i for i in [i for _, i in BouncePadCheckpoints].concat(-2) if BouncePadCheckpoints[i] == eventPlayer.checkpoint_current or i == -2]

    if len(CustomPortalStart) > 0:
        #eventPlayer.preview_array1.append( [i for i in CustomPortalStart if CustomPortalCP[CustomPortalStart.index(i)] == eventPlayer.checkpoint_current] )
        for eventPlayer.preview_i in range(len(eventPlayer.cache_portalStart)):
            eventPlayer.preview_array1.append([eventPlayer.cache_portalStart[eventPlayer.preview_i ],eventPlayer.cache_portalEnd[eventPlayer.preview_i ]])
            eventPlayer.preview_array2.append([[0,eventPlayer.preview_i],[1,eventPlayer.preview_i]])
            wait()

    wait(0.1)
    eventPlayer.addon_toggle3rdPov = null
    eventPlayer.setMoveSpeed(0)
    eventPlayer.preview_i = 0
    eventPlayer.startCamera(
        eventPlayer.preview_array1[eventPlayer.preview_i] + Vector.UP - (3.5 - 3 * eventPlayer.getThrottle().z) * eventPlayer.getFacingDirection(),
        eventPlayer.preview_array1[eventPlayer.preview_i] + Vector.UP, 15)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.JUMP)
    while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.isAlive() and not eventPlayer.lockState:
        if eventPlayer.getThrottle().x < -0.5:
            eventPlayer.preview_i = 0 if eventPlayer.preview_i + 1 >= len(eventPlayer.preview_array1) else eventPlayer.preview_i + 1
            waitUntil(eventPlayer.getThrottle().x > -0.5, 1)
        elif eventPlayer.getThrottle().x > 0.5:
            eventPlayer.preview_i = len(eventPlayer.preview_array1) -1  if eventPlayer.preview_i == 0 else  eventPlayer.preview_i - 1
            waitUntil(eventPlayer.getThrottle().x < 0.5, 1)
        wait()
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.stopCamera()
    eventPlayer.setMoveSpeed(100)
    eventPlayer.preview_i = null
    eventPlayer.preview_array1 = null
    eventPlayer.preview_array2 = null

rule "Command | Restart Run (Crouch + Interact + Deflect)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.editor_lock == false or eventPlayer != hostPlayer
    @Condition eventPlayer.lockState == false
    #@Condition eventPlayer.isUsingAbility1() == false

    eventPlayer.lockState = true
    # prevent 0.02 time bug with next 2 checks
    if eventPlayer.checkpoint_current == len(CheckpointPositions) - 2 and eventPlayer.getAltitude() < 3:
        waitUntil(eventPlayer.isOnGround(), 3)
        wait(0.42) # 0.64
    if eventPlayer.checkpoint_current == len(CheckpointPositions) - 1:
        wait(0.42)

    if CompMode:
        wait()
        if CompTime < 1:
            smallMessage(eventPlayer, "   比赛结束" checkCN "   Competition is over"  )
            eventPlayer.lockState = false
            return
        elif eventPlayer.comp_done:
            eventPlayer.lockState = false
            return
        elif CompRestartLimit and eventPlayer.checkpoint_notLast:
            smallMessage(eventPlayer, "   禁止在此比赛中运行期间重新启动" checkCN "   Restart during run is disabled for this competition")
            eventPlayer.lockState = false
            return
        elif CompAtmpNum > 0:
            if eventPlayer.comp_countAttempts == CompAtmpNum:
                smallMessage(eventPlayer, "   最后一次尝试" checkCN "   This is your final attempt"  )
                eventPlayer.lockState = false
                return
            if eventPlayer.comp_countAttempts == (-1):
                smallMessage(eventPlayer, "   你没有尝试过" checkCN "   You are out of attempts"  )
                eventPlayer.lockState = false
                return
            eventPlayer.comp_countAttempts++
            CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))] = eventPlayer.comp_countAttempts


    eventPlayer.editor_fly = null
    eventPlayer.checkpoint_current = 0
    eventPlayer.toggle_practice = false
    stopChasingVariable(eventPlayer.timer_practice)
    eventPlayer.timer_practice = 0
    eventPlayer.timer_splitDisplay = -Math.INFINITY if eventPlayer.timer_splitDisplay == -Math.INFINITY else 0
    if eventPlayer in SaveEnt:
        DeleteSave()

    if eventPlayer.isDead():
        eventPlayer.resurrect()
        #eventPlayer.respawn()

    StartGame()
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait()
    #eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.lockState = false
    if CompMode:
        wait(1)
    else:
        wait()

rule "Command | Spectate (Hold Interact)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    @Condition not (eventPlayer.editor_on and eventPlayer.isHoldingButton(Button.MELEE))
    @Condition not eventPlayer.editor_on or not(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))
    #@Condition editoron == false
    wait(1, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.editor_on: # editor has interact combos
        wait(1, Wait.ABORT_WHEN_FALSE)

    if eventPlayer.toggle_spectate:
        #eventPlayer.enableRespawn()
        eventPlayer.resurrect()
        #eventPlayer.respawn()
        if eventPlayer.toggle_practice:
            chase(eventPlayer.timer_practice, Math.INFINITY, rate=1, ChaseReeval.NONE)
        elif eventPlayer.checkpoint_notLast:
            chase(eventPlayer.timer_normal, Math.INFINITY, rate=1, ChaseReeval.NONE)
            StopPauseTimer()
        checkpointFailReset()
    else:
        smallMessage(eventPlayer, "   再次长按互动键关闭观战模式" checkCN "   Hold Interact again to turn off spectate mode")
        eventPlayer.toggle_invincible = false
        if eventPlayer.checkpoint_notLast:
            StartPauseTimer()
        stopChasingVariable(eventPlayer.timer_practice)
        stopChasingVariable(eventPlayer.timer_normal)
        #eventPlayer.disableRespawn()
        eventPlayer.setDamageReceived(100)
        kill(eventPlayer, null)
        eventPlayer.setDamageReceived(0)
    eventPlayer.toggle_spectate = not eventPlayer.toggle_spectate

rule "Command | Toggle Invincible Mode (Melee + Reload)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    #@Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isAlive()
    @Condition not (CompMode and eventPlayer.comp_done)
    @Condition eventPlayer.lockState == false

    eventPlayer.lockState = true
    eventPlayer.cache_collectedLocks = []

    if eventPlayer.toggle_invincible:
        if eventPlayer.toggle_practice:
            bigMessage(eventPlayer, "练习模式" checkCN "Practice mode")
            chase(eventPlayer.timer_practice, Math.INFINITY, rate=1, ChaseReeval.NONE)
        elif eventPlayer.checkpoint_notLast:
            bigMessage(eventPlayer,"跑图模式" checkCN "Normal mode")
            chase(eventPlayer.timer_normal, Math.INFINITY, rate=1, ChaseReeval.NONE)
            StopPauseTimer()
        checkpointFailReset()
    else:
        bigMessage(eventPlayer,"探点模式" checkCN "Invincible mode")
        StartPauseTimer()
        stopChasingVariable(eventPlayer.timer_normal)
        stopChasingVariable(eventPlayer.timer_practice)
        async(CheckUlt(), AsyncBehavior.RESTART)
        async(CheckDash(), AsyncBehavior.RESTART)

    eventPlayer.toggle_invincible = not eventPlayer.toggle_invincible
    eventPlayer.lockState = false
    wait()

rule "Command | Toggle Practice Mode (Melee + Ultimate)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    #@Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.editor_on == false
    @Condition CompMode == false
    @Condition eventPlayer.lockState == false

    eventPlayer.lockState = true
    #eventPlayer.disallowButton(Button.ABILITY_1)

    if eventPlayer.toggle_practice:
        bigMessage(eventPlayer,"跑图模式" checkCN "Normal mode")
        eventPlayer.checkpoint_current = eventPlayer.checkpoint_practice
        stopChasingVariable(eventPlayer.timer_practice)
        if eventPlayer.checkpoint_notLast or eventPlayer.toggle_invincible:
            eventPlayer.timer_split = eventPlayer.timer_normal
            chase(eventPlayer.timer_normal, Math.INFINITY, rate=1, ChaseReeval.NONE)
            StopPauseTimer()
        UpdateCache()
        checkpointFailReset()
    else:
        bigMessage(eventPlayer,"练习模式" checkCN "Practice mode")
        eventPlayer.checkpoint_practice = eventPlayer.checkpoint_current
        stopChasingVariable(eventPlayer.timer_normal)
        if eventPlayer.checkpoint_notLast:
            StartPauseTimer()
        eventPlayer.timer_splitDisplay = -Math.INFINITY if eventPlayer.timer_splitDisplay == -Math.INFINITY else 0
        eventPlayer.timer_split = 0
        eventPlayer.timer_practice = 0
        chase(eventPlayer.timer_practice, Math.INFINITY, rate=1, ChaseReeval.NONE)
        if eventPlayer.toggle_invincible:
            eventPlayer.toggle_invincible = false
            checkpointFailReset()
    #wait(0.2)
    #eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.toggle_practice = not eventPlayer.toggle_practice
    eventPlayer.lockState = false
    wait(0.1)

rule "Command | Restart Practice (Hold Interact)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    @Condition eventPlayer.isAlive() or eventPlayer.toggle_spectate
    @Condition eventPlayer.editor_on == false
    @Condition eventPlayer.toggle_practice
    @Condition eventPlayer.lockState == false

    #  first 2 ifs prevent collide with spec
    if eventPlayer.toggle_spectate:
        waitUntil(eventPlayer.isAlive(), Math.INFINITY)
        waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 2)
        return
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 0.9)
    if eventPlayer.isHoldingButton(Button.INTERACT):
        return

    eventPlayer.timer_practice = 0
    eventPlayer.timer_split = 0
    eventPlayer.checkpoint_current = eventPlayer.checkpoint_practice
    UpdateCache()
    checkpointFailReset()

rule "Command | Skip (Crouch + Primary-Next | Secondary-Previous)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) )
    #@Condition hostPlayer.editor_on or ( eventPlayer.toggle_practice and eventPlayer.isHoldingButton(Button.ABILITY_1) )
    @Condition eventPlayer.lockState == false
    @Condition hostPlayer.editor_on or eventPlayer.toggle_practice
    @Condition len(CheckpointPositions) > 1
    @Condition EditorMoveItem == false
    @Condition (eventPlayer.editor_lock and eventPlayer == hostPlayer) == false
    eventPlayer.lockState = true
    eventPlayer.timer_split = 0
    eventPlayer.timer_practice = 0
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        #eventPlayer.lockState = true
        if eventPlayer.checkpoint_current < 1:
            eventPlayer.checkpoint_current = len(CheckpointPositions) - 1
        elif (len(CheckpointPositions[eventPlayer.checkpoint_current -1]) > 1 and distance(CheckpointPositions[eventPlayer.checkpoint_current][0], CheckpointPositions[eventPlayer.checkpoint_current - 1][1]) < cpcircleradius):
            # if last cp is an instant complete teleport cp, go back further
            eventPlayer.checkpoint_current -= 2
        else:
            eventPlayer.checkpoint_current -= 1
    else:
        #eventPlayer.lockState = true

        if eventPlayer.checkpoint_current >= len(CheckpointPositions) - 1:
            eventPlayer.checkpoint_current = 0
        else:
            eventPlayer.checkpoint_current += 1

    wait(0.064)
    eventPlayer.checkpoint_moved = true
    UpdateCache()
    checkpointFailReset()
    eventPlayer.lockState = false
    wait()
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 0.28) # faster if you spam button
    if RULE_CONDITION:
        goto RULE_START

rule "Command | Quick Reset (Reload | Hold Reload to Enable)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false

    if eventPlayer.toggle_quickRestart:
        if eventPlayer.editor_fly:
            eventPlayer.editor_fly = CheckpointPositions[eventPlayer.checkpoint_current].last()
        checkpointFailReset()
        wait(0.32)
    wait(1, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    eventPlayer.toggle_quickRestart = not eventPlayer.toggle_quickRestart
    bigMessage(eventPlayer,
        ("快速回点已启用" if eventPlayer.toggle_quickRestart else "快速回点已关闭")
        checkCN
        "Quick reset is enabled" if eventPlayer.toggle_quickRestart else "Quick reset is disabled"
    )

rule "Command | Toggle Hud (Hold Secondary)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition not (eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.ABILITY_1)) # don't trigger during skipping
    @Condition not (eventPlayer.editor_on and eventPlayer == hostPlayer and eventPlayer.isHoldingButton(Button.MELEE))
    @Condition EditorMoveItem == false

    wait(1.5, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer,
        ("   HUD已开启" if eventPlayer.toggle_guide else  "HUD已隐藏")
        checkCN
        ("   Hud is now open" if eventPlayer.toggle_guide else "   Hud is now hidden")
    )
    eventPlayer.toggle_guide = not eventPlayer.toggle_guide

rule "Command | Toggle Hints (Melee + Deflect)":
    @Event eachPlayer
    @Condition HintText != null
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.toggle_hints or eventPlayer.checkpoint_current in HintCp

    eventPlayer.toggle_hints = not eventPlayer.toggle_hints

rule "Command | Toggle 3rd Person Camera (Hold Crouch + Hold Jump)":
    @Event eachPlayer
    @Condition eventPlayer.addon_toggle3rdPov <= true #True if not null
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.editor_lock == false
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.addon_toggle3rdPov = not eventPlayer.addon_toggle3rdPov
    if eventPlayer.addon_toggle3rdPov:
        eventPlayer.startCamera(updateEveryTick(
            raycast(0.5 * Vector.UP + eventPlayer.getEyePosition(),
            0.5 * Vector.UP + eventPlayer.getEyePosition() + -3.5 * eventPlayer.getFacingDirection(), [], [], false).getHitPosition() + 0.5 * eventPlayer.getFacingDirection()),
            updateEveryTick(0.5 * Vector.UP + eventPlayer.getEyePosition()), false)
    else:
        eventPlayer.stopCamera()