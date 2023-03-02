#!mainFile "genji.opy"

rule "------------------------------------------------------------------------ commands ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled

rule "Toggle Leaderboard | Hold Melee":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition not eventPlayer.EditorOn
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.LeaderboardToggle = not eventPlayer.LeaderboardToggle

rule "Toggle Splits | Hold Ult":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition not eventPlayer.EditorOn
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.splitson = not eventPlayer.splitson
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, null, eventPlayer, 100)

rule "Toggle Invisible | Hold Deflect":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition not eventPlayer.EditorOn
    @Condition not CompMode
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.invis = not eventPlayer.invis
    eventPlayer.setInvisibility(Invis.NONE)
    if eventPlayer.invis:
        eventPlayer.setInvisibility(Invis.ALL)

    smallMessage(eventPlayer, "   Invisible {0}".format("on" if eventPlayer.invis else "off"))    
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, null, eventPlayer, 100)
    
rule "Preview orbs/portals | Hold Primary":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition not eventPlayer.EditorOn
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 0.9)
    if not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        return
    eventPlayer.PreviewsArray = [i for i in CustomPortalStart if CustomPortalCP[CustomPortalStart.index(i)] == eventPlayer.CurrentCheckpoint]
    eventPlayer.PreviewsArray.append( [i for i in BouncePositions if BouncePadCheckpoints[BouncePositions.index(i)] == eventPlayer.CurrentCheckpoint and BounceToggleLock[BouncePositions.index(i)] == true]) 
    if len(eventPlayer.PreviewsArray) < 1 or eventPlayer.PreviewsArray == null or (not eventPlayer.NotOnLastCp):
        return
    wait(0.1)  
    eventPlayer.setMoveSpeed(0)
    eventPlayer.PreviewsI = 0
    eventPlayer.startCamera(
        eventPlayer.PreviewsArray[eventPlayer.PreviewsI] + eventPlayer.getFacingDirection()*-3.5, 
        eventPlayer.PreviewsArray[eventPlayer.PreviewsI],
        15
    )
    while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isAlive():
        if eventPlayer.getThrottle().x < -0.5:
            eventPlayer.PreviewsI = 0 if eventPlayer.PreviewsI + 1 >= len(eventPlayer.PreviewsArray) else eventPlayer.PreviewsI + 1 
            waitUntil(eventPlayer.getThrottle().x > -0.5, 1)
        elif eventPlayer.getThrottle().x > 0.5:
            eventPlayer.PreviewsI = len(eventPlayer.PreviewsArray) -1  if eventPlayer.PreviewsI == 0 else  eventPlayer.PreviewsI - 1
            waitUntil(eventPlayer.getThrottle().x < 0.5, 1)
        wait()
    eventPlayer.stopCamera()
    eventPlayer.setMoveSpeed(100)
    eventPlayer.PreviewsArray = null

rule "Restart Run | Crouch + Interact + Deflect":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) 
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    #@Condition not eventPlayer.isUsingAbility1()
    
    eventPlayer.LockState = true 

    if CompMode:      
        wait()
        if CompTime < 1:
            smallMessage(eventPlayer, "   The competition is over")
            return
        elif eventPlayer.CompDone:
            return
        elif CompRestartLimit and eventPlayer.NotOnLastCp:
            smallMessage(eventPlayer,"   Restart during run is disabled for this competition")
            return
        elif CompAtmpNum > 0: 
            if eventPlayer.AttemptCount == CompAtmpNum:
                smallMessage(eventPlayer, "   You are on your last attempt")
                return
            if eventPlayer.AttemptCount == (-1):
                smallMessage(eventPlayer, "   You are out of attempts")
                return
            eventPlayer.AttemptCount ++
            CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))] = eventPlayer.AttemptCount 
    
    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.flytoggle = null
    eventPlayer.CurrentCheckpoint = 0  
    eventPlayer.PracticeToggle = false
    eventPlayer.PracticeCheckpoint = 0
    eventPlayer.InvincibleToggle = false
    stopChasingVariable(eventPlayer.practicetimer)
    eventPlayer.practicetimer = 0
    if eventPlayer in SaveEnt:
        DeleteSave()
    
    if eventPlayer.isDead():
        eventPlayer.respawn()

    StartGame_Sub()
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait()
    eventPlayer.LockState = false
    if CompMode:
        wait(1)
    else:
        wait()

rule "Enter Spectate | Hold Interact":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    @Condition not CompMode
    wait(1, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.EditorOn: # editor has interact combos
        wait(1, Wait.ABORT_WHEN_FALSE)

    smallMessage(eventPlayer, "   Hold Interact again to turn off spectate mode")
    if eventPlayer.SpectateToggle:
        eventPlayer.respawn()
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint].last())
        if eventPlayer.NotOnLastCp:
            if eventPlayer.PracticeToggle:
                chase(eventPlayer.practicetimer, 9999999, rate=1, ChaseReeval.NONE)
            else:
                chase(eventPlayer.Timer, 9999999, rate=1, ChaseReeval.NONE)

        async(CheckUlt(),AsyncBehavior.RESTART)
        async(CheckDash(), AsyncBehavior.RESTART) 
        eventPlayer.enableRespawn()
        eventPlayer.InvincibleToggle = false
        eventPlayer.LockCollected = []
        if eventPlayer.NotOnLastCp:
            StopPauseTimer()
    else:
        if eventPlayer.NotOnLastCp:
            StartPauseTimer()
        stopChasingVariable(eventPlayer.practicetimer)
        stopChasingVariable(eventPlayer.Timer)
        eventPlayer.disableRespawn()
        wait(0.2)
        kill(eventPlayer, null)
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint].last())
 
    eventPlayer.SpectateToggle = not eventPlayer.SpectateToggle

rule "Toggle Invincible Mode | Melee + Reload":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isAlive()
    @Condition (not CompMode) or (not eventPlayer.CompDone)
    @Condition not eventPlayer.LockState
    
    eventPlayer.LockCollected = []
    eventPlayer.flytoggle = null

    if eventPlayer.InvincibleToggle:
        eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.CurrentCheckpoint].last(), true)
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint].last())
        wait(0.1)
        if eventPlayer.PracticeToggle:
            bigMessage(eventPlayer, "Practice mode")
            chase(eventPlayer.practicetimer, 9999999, rate=1, ChaseReeval.NONE)
        else:
            bigMessage(eventPlayer, "Normal mode")
            chase(eventPlayer.Timer, 9999999, rate=1, ChaseReeval.NONE)
            StopPauseTimer()
        eventPlayer.stopForcingPosition()
        eventPlayer.flytoggle = null
        
    else:
        if not eventPlayer.NotOnLastCp:
            return
        StartPauseTimer()
        stopChasingVariable(eventPlayer.Timer)
        stopChasingVariable(eventPlayer.practicetimer)
        bigMessage(eventPlayer, "Invincible mode")
        eventPlayer.flytoggle = null
        wait(0.2)
    
    eventPlayer.InvincibleToggle = not eventPlayer.InvincibleToggle
    async( CheckUlt(), AsyncBehavior.RESTART)
    async( CheckDash(), AsyncBehavior.RESTART)
    

rule "Toggle Practice Mode | Melee + Ultimate":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE) 
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isAlive()
    @Condition not eventPlayer.EditorOn
    @Condition not CompMode 

    if eventPlayer.InvincibleToggle:
        smallMessage(eventPlayer, "   Cannot toggle practice mode while in invincible")
        wait()
        return

    eventPlayer.LockState = true
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)
      
    wait(0.16)
    if eventPlayer.PracticeToggle:
        eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.PracticeCheckpoint].last(), true)
        eventPlayer.CurrentCheckpoint = eventPlayer.PracticeCheckpoint
        checkpointFailReset()
        eventPlayer.LockCollected = []
        UpdateCache()
        wait(0.1)
        stopChasingVariable(eventPlayer.practicetimer)
        bigMessage(eventPlayer, "Normal mode")
        if eventPlayer.NotOnLastCp:
            eventPlayer.splittime = eventPlayer.Timer
            chase(eventPlayer.Timer, 9999999, rate=1, ChaseReeval.NONE) #abs removed
            StopPauseTimer()
        async(CheckUlt(), AsyncBehavior.RESTART)
        async(CheckDash(), AsyncBehavior.RESTART)
        eventPlayer.stopForcingPosition()
    else:
        eventPlayer.PracticeCheckpoint = eventPlayer.CurrentCheckpoint
        eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.CurrentCheckpoint].last(), true)
        stopChasingVariable(eventPlayer.Timer)
        bigMessage(eventPlayer, "Practice mode")
        eventPlayer.stopForcingPosition()
        if eventPlayer.NotOnLastCp:
            StartPauseTimer()
        eventPlayer.splittime = 0
        eventPlayer.practicetimer = 0
        chase(eventPlayer.practicetimer, 9999999, rate=1, ChaseReeval.NONE)
        wait(0.2)
        
   
    eventPlayer.PracticeToggle = not eventPlayer.PracticeToggle 
    wait(0.3)
    eventPlayer.LockState = false

rule "Practice Restart | Interact":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false
    @Condition eventPlayer.isAlive() or eventPlayer.SpectateToggle
    @Condition not eventPlayer.EditorOn
    @Condition eventPlayer.PracticeToggle
   
    #  first 2 ifs prevent collide with spec
    if eventPlayer.SpectateToggle: 
        waitUntil(eventPlayer.isAlive(), 9999)
        waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 2)
        return
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 0.9)
    if eventPlayer.isHoldingButton(Button.INTERACT):
        return
    
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)

    eventPlayer.practicetimer = 0
    eventPlayer.splittime = 0
    eventPlayer.teleport(CheckpointPositions[eventPlayer.PracticeCheckpoint])
    eventPlayer.CurrentCheckpoint = eventPlayer.PracticeCheckpoint

    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.2)
    eventPlayer.LockCollected = []
    UpdateCache()

rule "Skip | Crouch + Primary/Secondary Fire":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) )
    @Condition eventPlayer.LockState == false
    @Condition hostPlayer.EditorOn or eventPlayer.PracticeToggle
    
    eventPlayer.splittime = 0
    eventPlayer.practicetimer = 0
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.LockState = true
        if eventPlayer.CurrentCheckpoint < 1:
            eventPlayer.CurrentCheckpoint = len(CheckpointPositions) - 1
        elif (len(CheckpointPositions[eventPlayer.CurrentCheckpoint -1]) > 1 and distance(CheckpointPositions[eventPlayer.CurrentCheckpoint ][0], CheckpointPositions[eventPlayer.CurrentCheckpoint-1][1]) < 1.4):
            # if last cp is an instand complete teleport cp, go back further
            eventPlayer.CurrentCheckpoint -= 2 
        else:
            eventPlayer.CurrentCheckpoint -= 1
    else:
        eventPlayer.LockState = true
        
        if eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1:
            eventPlayer.CurrentCheckpoint = 0
        else:
            eventPlayer.CurrentCheckpoint += 1

    wait()
    checkpointFailReset()
    wait(0.064)
    eventPlayer.LockState = false
    eventPlayer.MovedCheckpoint = true
    UpdateCache() 
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 0.28) # faster if you spam button
    if RULE_CONDITION:
        goto RULE_START

rule "Quick Reset | Reload, Hold Reload to Enable":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition not eventPlayer.isHoldingButton(Button.MELEE)
    if eventPlayer.QuickRestartToggle:
        eventPlayer.LockCollected = []
        if eventPlayer.isUsingUltimate():
            kill(eventPlayer, null)
        eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.CurrentCheckpoint].last(), true)
        eventPlayer.flytoggle = null
        async(CheckUlt(), AsyncBehavior.RESTART)
        async(CheckDash(), AsyncBehavior.RESTART)
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint].last())
        wait(0.1)
        eventPlayer.stopForcingPosition()
        eventPlayer.flytoggle = null
        wait(0.24)
    wait(1, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    eventPlayer.QuickRestartToggle = not eventPlayer.QuickRestartToggle
    bigMessage(eventPlayer, "Quick reset is enabled" if eventPlayer.QuickRestartToggle else "Quick reset is disabled")
