#!mainFile "framework.opy"

rule "<tx0C00000000001344> Commands <tx0C00000000001344>":
    @Delimiter

rule "Command | Toggle Leaderboard (Hold Melee)":
    @Event eachPlayer
    @Condition len(LeaderBoardFull) > 0
    @Condition EditorOn == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.toggle_leaderboard = not eventPlayer.toggle_leaderboard

rule "Command | Split hide (Hold Dash + Primary + Secondary)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.timer_splitDisplay = 0 if eventPlayer.timer_splitDisplay <= -Math.INFINITY else -Math.INFINITY
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)
    #$$ Language
    smallMessage(eventPlayer, "   Split Display Off" if eventPlayer.timer_splitDisplay <= -Math.INFINITY else "   Split Display On")
    wait(0.32)

rule "Command | Toggle Invisible (Hold Deflect)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition EditorOn == false
    @Condition CompMode == false
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.toggle_invisible = not eventPlayer.toggle_invisible
    eventPlayer.setInvisibility(INVIS)
    if eventPlayer.toggle_invisible:
        eventPlayer.setInvisibility(Invis.ALL)
    smallMessage(eventPlayer, f"  {t'Invisible'}{t' | On' if eventPlayer.toggle_invisible else t' | Off'}")
        #"   {0} {1}".format("隐身模式" checkCN "Invisible", "On" if eventPlayer.toggle_invisible else "Off"))
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, null, eventPlayer, 100)

/*
previewarray = list of all vectors to be displayed
previewarray2 = stored item ID to be used to preview abilities etc
a few huds show/hides when reviewarray is not null !!!!!!!!!!!!!!!!!
*/
rule "Command | Preview Orbs & Portals (Hold Primary + Secondary)":
    @Event eachPlayer
    #@Condition EditorOn == false
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.checkpoint_notLast
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    #wait(0.9, Wait.ABORT_WHEN_FALSE)
    wait(0.45, Wait.ABORT_WHEN_FALSE)
    eventPlayer.preview_array1 = [CheckpointPositions[eventPlayer.checkpoint_current + 1][0]]
    if len(BouncePadCheckpoints):
        eventPlayer.preview_array1.append([_ for _ , i in BouncePositions if BouncePadCheckpoints[i] == eventPlayer.checkpoint_current])
        eventPlayer.preview_array2.append([_ for _ in [i for _, i in BouncePadCheckpoints] if BouncePadCheckpoints[_] == eventPlayer.checkpoint_current])

    if len(CustomPortalStart):
        #eventPlayer.preview_array1.append( [i for i in CustomPortalStart if CustomPortalCP[CustomPortalStart.index(i)] == eventPlayer.checkpoint_current] )
        for eventPlayer.preview_i in range(len(eventPlayer.cache_portalStart)):
            eventPlayer.preview_array1.append([eventPlayer.cache_portalStart[eventPlayer.preview_i],eventPlayer.cache_portalEnd[eventPlayer.preview_i]])
            eventPlayer.preview_array2.append([[eventPlayer.preview_i, false],[eventPlayer.preview_i, true]])

    wait()
    eventPlayer.preview_i = 0
    if eventPlayer.addon_toggle3rdPov:
        eventPlayer.addon_toggle3rdPov = false
    eventPlayer.startCamera(
        eventPlayer.preview_array1[eventPlayer.preview_i] + Vector.UP - (3.5 - 3 * eventPlayer.getThrottle().z) * eventPlayer.getFacingDirection(),
        eventPlayer.preview_array1[eventPlayer.preview_i] + Vector.UP, 15)
    eventPlayer.setMoveSpeed(0)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.JUMP)
    while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.isAlive() and not eventPlayer.lockState:
        if eventPlayer.getThrottle().x < -0.5:
            eventPlayer.preview_i += 1
        elif eventPlayer.getThrottle().x > 0.5:
            eventPlayer.preview_i += len(eventPlayer.preview_array1) - true
        eventPlayer.preview_i %= len(eventPlayer.preview_array1)
        waitUntil(abs(eventPlayer.getThrottle().x) < 0.5, true)
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
    @Condition eventPlayer.editor_lock == false or eventPlayer != hostPlayer
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.lockState = true
    if CompMode:
        wait()
        if CompTime < 1:
            smallMessage(eventPlayer, "   比赛结束" checkCN "   Competition Is Over"  )
            eventPlayer.lockState = false
            return
        elif eventPlayer.comp_done:
            eventPlayer.lockState = false
            return
        elif CompRestartLimit and eventPlayer.checkpoint_notLast:
            smallMessage(eventPlayer, "   禁止在此比赛中运行期间重新启动" checkCN "   Restart During Run Is Disabled For This Competition")
            eventPlayer.lockState = false
            return
        elif CompAtmpNum:
            if eventPlayer.comp_countAttempts == CompAtmpNum:
                smallMessage(eventPlayer, "   最后一次尝试" checkCN "   This Is Your Final Attempt"  )
                eventPlayer.lockState = false
                return
            if eventPlayer.comp_countAttempts < 0:
                smallMessage(eventPlayer, "   你没有尝试过" checkCN "   You Are Out Of Attempts"  )
                eventPlayer.lockState = false
                return
            eventPlayer.comp_countAttempts++
            CompAtmpSaveCount[CompAtmpSaveNames.index(eventPlayer[0].split([]))] = eventPlayer.comp_countAttempts
    eventPlayer.editor_fly = null
    eventPlayer.checkpoint_current = 0
    eventPlayer.timer_splitDisplay = -Math.INFINITY * (eventPlayer.timer_splitDisplay <= -Math.INFINITY)
    eventPlayer.toggle_practice = false
    eventPlayer.timer_practice = 0
    stopChasingVariable(eventPlayer.timer_practice)
    if eventPlayer in SaveEnt:
        DeleteSave()
    if eventPlayer.isDead():
        eventPlayer.resurrect() #eventPlayer.respawn()
    StartGame()
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, null, eventPlayer, 100)
    wait(CompMode)
    #eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.lockState = false
    wait(0.096) #Anti spam

rule "Command | Spectate (Hold Interact)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    @Condition (EditorOn and (
        eventPlayer.isHoldingButton(Button.MELEE) or
        eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or
        eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))) == false
    #@Condition editoron == false
    wait(1, Wait.ABORT_WHEN_FALSE)
    if EditorOn: # editor has interact combos
        wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.enableRespawn()
    eventPlayer.disableRespawn()
    if eventPlayer.toggle_spectate:
        eventPlayer.resurrect()
        if eventPlayer.toggle_practice:
            chase(eventPlayer.timer_practice, Math.INFINITY, rate=1, ChaseReeval.NONE)
        elif eventPlayer.checkpoint_notLast:
            TimerResume()
        CheckpointFailReset()
    else:
        eventPlayer.toggle_invincible = false
        TimerPause()
        stopChasingVariable(eventPlayer.timer_practice)
        eventPlayer.setDamageReceived(100)
        kill(eventPlayer, null)
        eventPlayer.setDamageReceived(0)
        smallMessage(eventPlayer, t"   Hold Interact Again To Turn Off Spectate Mode")
            #"   再次长按互动键关闭观战模式" checkCN "   Hold Interact again to turn off spectate mode")
    eventPlayer.toggle_spectate = not eventPlayer.toggle_spectate

rule "Command | Toggle Invincible Mode (Melee + Reload)":
    @Event eachPlayer
    @Condition (CompMode and eventPlayer.comp_done) == false
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false

    eventPlayer.lockState = true
    eventPlayer.toggle_invincible = not eventPlayer.toggle_invincible
    eventPlayer.cache_collectedLocks = []

    if eventPlayer.toggle_invincible:
        #"探点模式" checkCN "Invincible mode"
        bigMessage(eventPlayer, t"Invincible Mode")
        TimerPause()
        stopChasingVariable(eventPlayer.timer_practice)
        async(CheckUlt(), AsyncBehavior.NOOP)
        async(CheckAbility1(), AsyncBehavior.NOOP)
    else:
        if eventPlayer.toggle_practice:
            #"练习模式" checkCN "Practice mode"
            bigMessage(eventPlayer, t"Practice Mode")
            chase(eventPlayer.timer_practice, Math.INFINITY, rate=1, ChaseReeval.NONE)
            CheckpointFailReset()
        elif eventPlayer.checkpoint_notLast:
            #"跑图模式" checkCN "Normal mode"
            bigMessage(eventPlayer, t"Normal Mode")
            TimerResume()
            CheckpointFailReset()
    eventPlayer.lockState = false
    wait(0.096) #Anti spam

rule "Command | Toggle Practice Mode (Melee + Ultimate)":
    @Event eachPlayer
    @Condition EditorOn == false
    @Condition CompMode == false
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)

    eventPlayer.lockState = true
    eventPlayer.toggle_practice = not eventPlayer.toggle_practice
    if eventPlayer.toggle_practice:
        #"练习模式" checkCN "Practice mode"
        bigMessage(eventPlayer, t"Practice Mode")
        TimerPause()
        eventPlayer.checkpoint_practice = eventPlayer.checkpoint_current
        eventPlayer.timer_splitDisplay = -Math.INFINITY * (eventPlayer.timer_splitDisplay <= -Math.INFINITY)
        eventPlayer.timer_split = 0
        eventPlayer.timer_practice = 0
        chase(eventPlayer.timer_practice, Math.INFINITY, rate=1, ChaseReeval.NONE)
        if eventPlayer.toggle_invincible:
            eventPlayer.toggle_invincible = false
            CheckpointFailReset()
    else:
        #"跑图模式" checkCN "Normal mode"
        bigMessage(eventPlayer, t"Normal Mode")
        stopChasingVariable(eventPlayer.timer_practice)
        eventPlayer.checkpoint_current = eventPlayer.checkpoint_practice
        UpdateCache()
        if eventPlayer.checkpoint_notLast and not eventPlayer.toggle_invincible:
            eventPlayer.timer_split = eventPlayer.timer_normal
            TimerResume()
            CheckpointFailReset()
    eventPlayer.lockState = false
    wait(0.096) #Anti spam

rule "Command | Restart Practice (Hold Interact)":
    @Event eachPlayer
    @Condition EditorOn == false
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.toggle_practice
    @Condition eventPlayer.isAlive() or eventPlayer.toggle_spectate
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false

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
    CheckpointFailReset()

rule "Command | Skip (Crouch + Primary-Next | Secondary-Previous)":
    @Event eachPlayer
    @Condition len(CheckpointPositions) > 1
    @Condition EditorMoveItem == false
    @Condition (eventPlayer.editor_lock and eventPlayer == hostPlayer) == false
    @Condition EditorOn or eventPlayer.toggle_practice
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) != (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) )
    #@Condition hostPlayer.editor_on or ( eventPlayer.toggle_practice and eventPlayer.isHoldingButton(Button.ABILITY_1) )

    eventPlayer.lockState = true
    eventPlayer.timer_split = 0
    eventPlayer.timer_practice = 0
    eventPlayer.checkpoint_current += len(CheckpointPositions) - 1 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else true
    eventPlayer.checkpoint_current %= len(CheckpointPositions)
    eventPlayer.checkpoint_moved = true

    UpdateCache()
    CheckpointFailReset()
    wait(0.064) #Anti spam
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 0.256) # faster if you spam button
    if RULE_CONDITION: goto RULE_START
    # After loop to prevent instant teleports
    eventPlayer.lockState = false

rule "Command | Quick Reset (Reload | Hold Reload to Enable)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false

    if eventPlayer.toggle_quickRestart:
        if eventPlayer.editor_fly:
            eventPlayer.editor_fly = CheckpointPositions[eventPlayer.checkpoint_current].last()
        CheckpointFailReset()
        wait(0.32)
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.toggle_quickRestart = not eventPlayer.toggle_quickRestart
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)
    #("快速回点已启用" if eventPlayer.toggle_quickRestart else "快速回点已关闭") checkCN
    #"Quick reset is enabled" if eventPlayer.toggle_quickRestart else "Quick reset is disabled"
    bigMessage(eventPlayer, t"Quick Reset Is Enabled" if eventPlayer.toggle_quickRestart else t"Quick Reset Is Disabled")

rule "Command | Toggle Hud (Hold Secondary)":
    @Event eachPlayer
    @Condition EditorMoveItem == false
    @Condition (EditorOn and eventPlayer == hostPlayer and eventPlayer.isHoldingButton(Button.MELEE)) == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false # don't activate during skipping

    wait(1.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.toggle_guide = not eventPlayer.toggle_guide
    smallMessage(eventPlayer, t"   HUD Is Now Shown" if eventPlayer.toggle_guide else t"   HUD Is Now Hidden")
        #("   HUD已隐藏" if eventPlayer.toggle_guide else  "   HUD已开启")
        #checkCN
        #("   Hud is now hidden" if eventPlayer.toggle_guide else "   Hud is now shown"))
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)

rule "Command | Toggle Hints (Melee + Deflect)":
    @Event eachPlayer
    @Condition HintText != null
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.toggle_hints or eventPlayer.checkpoint_current in HintCp
    eventPlayer.toggle_hints = not eventPlayer.toggle_hints

rule "Command | Toggle 3rd Person Camera (Hold Crouch + Jump)":
    @Event eachPlayer
    @Condition eventPlayer.addon_toggle3rdPov <= true #True if not null
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.editor_lock == false
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.addon_toggle3rdPov = not eventPlayer.addon_toggle3rdPov
    Addon3rdPerson()