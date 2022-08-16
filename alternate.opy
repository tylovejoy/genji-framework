rule "Player Joins":
    @Event playerJoined

    if eventPlayer.getCurrentHero() != Hero.GENJI:
        return

    

    hudSubtext(eventPlayer, "Level {0} / {1}".format(eventPlayer.CurrentCheckpoint, len(CheckpointPositions) - 1), HudPosition.TOP, -14, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "Time {0}".format(prettyTime(eventPlayer.Timer)), HudPosition.LEFT, -5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT) #LEFT, -2
    
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.disableGamemodeHud()

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)

    eventPlayer.SpectateToggle = 0
    eventPlayer.InvincibleToggle = 0
    eventPlayer.PracticeToggle = 0

    # Climbing the wall prompts the HUD
    eventPlayer.WallclimbUsed = 2

    createEffect(eventPlayer if eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1 else null, Effect.RING, Color.SKY_BLUE, CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.PlayerEffects[0] = getLastCreatedEntity()
    createEffect(eventPlayer if eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1 else null, Effect.RING, Color.LIME_GREEN, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.PlayerEffects[1] = getLastCreatedEntity()
    createEffect(eventPlayer if eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1 else null, Effect.LIGHT_SHAFT, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.PlayerEffects[2] = getLastCreatedEntity()
    createIcon(eventPlayer if eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1 else null, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.SKY_BLUE, true)
    eventPlayer.PlayerEffects[3] = getLastCreatedEntity()
    createInWorldText(eventPlayer if eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1 else null, "Come here", CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.PlayerEffects[4] = getLastCreatedText()

    waitUntil(eventPlayer.hasSpawned(), 9999)

    if "{0}".format(eventPlayer) in SavedProgress:
        eventPlayer.CurrentCheckpoint = SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        eventPlayer.Timer = SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 2]
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 3] = eventPlayer
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 5] = 0
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 0
        eventPlayer.teleport(CheckpointPositions[SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]] + vect(0, 1, 0))
    else:
        eventPlayer.CurrentCheckpoint = 0
        eventPlayer.teleport(CheckpointPositions[0] + vect(0, 1, 0)) 
        eventPlayer.Timer = 0
        SavedProgress.append(["{0}".format(eventPlayer), eventPlayer.CurrentCheckpoint, eventPlayer.Timer, eventPlayer, getTotalTimeElapsed(), 0, 0])
    
    if eventPlayer.EditModeSelection < 1:
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setUltEnabled(false)
    else:
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)

rule "Timer Start":
    @Condition eventPlayer.CurrentCheckpoint == 0
    @Condition distance(eventPlayer.getPosition(), CheckpointPositions[0]) > 1.4
    chase(eventPlayer.Timer, 9999999, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "Checkpoint Clear/Fail":
    @Condition eventPlayer.Timer > 0
    @Condition (eventPlayer.EditModeSelection >= 1 or eventPlayer.InvincibleToggle == 0) == true
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition distance(eventPlayer.getPosition(), CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= 1.4
    eventPlayer.LockState = true
    eventPlayer.CurrentCheckpoint += 1
    
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, CheckpointPositions[eventPlayer.CurrentCheckpoint] + vect(0, 1.5, 0), 4)
    bigMessage(eventPlayer, "{0} {1}".format("Arrived at", "{0} / {1}".format(eventPlayer.CurrentCheckpoint, len(CheckpointPositions) - 1)))

    if eventPlayer.PracticeToggle == 1:
        eventPlayer.PracticeCheckpoint += 1
        if eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1:
            goto level_not_complete
        if eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1:
            goto level_complete
    else:  # normal cp, but also runs when completed
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        SavedProgress.remove("{0}".format(eventPlayer))
        SavedProgress.append(["{0}".format(eventPlayer), eventPlayer.CurrentCheckpoint, eventPlayer.Timer, eventPlayer, getTotalTimeElapsed(), 0, 0])
    
    
    level_complete:
    if eventPlayer.EditModeSelection < 1:
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
    if eventPlayer.EditModeSelection >= 1:
        return
    if eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1: # complete lvl
   
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)

        if eventPlayer.PracticeToggle != 1:
            stopChasingVariable(eventPlayer.Timer)
            bigMessage(getAllPlayers(), "{0} {1}".format(eventPlayer, "Mission complete! Time {0}".format(prettyTime(eventPlayer.Timer))))
            Leaderboardupdate()
    level_not_complete:

def CheckpointFail():
    @Name "SUB | Checkpoint Fail"
    eventPlayer.cancelPrimaryAction()
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)
        return
    eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])
    if DeathBhopBan == true and eventPlayer.InvincibleToggle == 0 and eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1:
        eventPlayer.disallowButton(Button.JUMP)
        if eventPlayer.isHoldingButton(Button.JUMP):
            smallMessage(eventPlayer, "Deathbhop is banned!")
        wait(0.1)
        eventPlayer.allowButton(Button.JUMP)
    if eventPlayer.CurrentCheckpoint == 0:
        stopChasingVariable(eventPlayer.Timer)
        eventPlayer.Timer = 0
    eventPlayer.stopForcingPosition()

rule "Death Reset":
    @Event playerDied
    @Condition eventPlayer.Spectate == false
    
    CheckpointFail()
    eventPlayer.resurrect()