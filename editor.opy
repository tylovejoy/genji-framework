#!mainFile "genji.opy"



rule "------------------------------------------------------Turn off the rules below after finishing editing--------------------------":   
    @Delimiter
    @Disabled

rule "inspector":
    disableInspector()
    wait(10)
    enableInspector()
    goto RULE_START


rule "Hide/Show Guide HUD":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection >= 1
    
    wait(0.8, Wait.ABORT_WHEN_FALSE)
    playEffect(hostPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    if eventPlayer.GuideToggle == 1:
        eventPlayer.GuideToggle = 2
        smallMessage(getAllPlayers(), "Guide is hidden")
    else:
        eventPlayer.GuideToggle = 1
        smallMessage(getAllPlayers(), "Guide is open")


rule "Clear excess data":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer == hostPlayer
    
    SelectedCheckpoint_Editing = 0
    CheckpointRings_Editing = 0
    Portal1PlayerList = 0
    Portal2PlayerList = 0
    SelectedKillball_Editing = 0
    KillBallEffects = 0
    KillBallChase = 0
    BladeEnabledCheckpoints = 0
    DashEnabledCheckpoints = 0
    ListPlayersAtCheckpoints = 0
    CurrentBounce_Editing = 0
    TempIterator1 = 0
    BounceEffects = 0
    CurrentBouncePosition_Editing = 0
    SavedProgress = 0
    TimeLimitSettingToggle = 0
    bigMessage(getAllPlayers(), "Excess data has been cleared")
    bigMessage(getAllPlayers(), "Excess data has been cleared")
    enableInspector()


rule "Deflect TP":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.EditModeSelection == 1
    
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 3)


rule "Change editing mode":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer == hostPlayer
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.EditModeSelection == 1:
        eventPlayer.EditModeSelection = 2
        smallMessage(hostPlayer, "Current mode: Killing sphere")
    elif eventPlayer.EditModeSelection == 2:
        eventPlayer.EditModeSelection = 3
        smallMessage(hostPlayer, "Current mode: Bouncing Ball")
    elif eventPlayer.EditModeSelection == 3:
        eventPlayer.EditModeSelection = 1
        smallMessage(hostPlayer, "Current mode: Checkpoint")


rule "Change Killing Sphere size (increase)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection > 1
    
    if eventPlayer.EditModeSelection == 2:
        if len(KillBallPositions) > 0:
            KillBallRadii[SelectedKillball_Editing] += 0.1
            wait(0.1)
            if RULE_CONDITION:
                goto RULE_START
            for TempIterator1 in range(len(KillBallPositions)):
                destroyEffect(KillBallEffects[TempIterator1])
            KillBallEffects = []
            KILLBALL()
    elif eventPlayer.EditModeSelection == 3:
        if len(BouncePositions) > 0:
            BounceStrength[CurrentBounce_Editing] += 0.1
            wait(0.1)
            if RULE_CONDITION:
                goto RULE_START


rule "Change Killing Sphere size (decrease)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection > 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    
    if len(KillBallPositions) > 0:
        if eventPlayer.EditModeSelection == 2:
            KillBallRadii[SelectedKillball_Editing] -= 0.1
            wait(0.1)
            if RULE_CONDITION:
                goto RULE_START
            for TempIterator1 in range(len(KillBallPositions)):
                destroyEffect(KillBallEffects[TempIterator1])
            KillBallEffects = []
            KILLBALL()


rule "Bouncing Ball strenght":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 3
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    
    if len(BouncePositions) > 0:
        BounceStrength[CurrentBounce_Editing] -= 0.1
        wait(0.1)
        if RULE_CONDITION:
            goto RULE_START


rule "Move the Killing sphere (toward)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection > 1
    
    if eventPlayer.EditModeSelection == 2:
        if KillBallChase != KillBallPositions[SelectedKillball_Editing]:
            goto lbl_0
        chase(KillBallChase, eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), KillBallPositions[SelectedKillball_Editing]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_0:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(KillBallChase)
        KillBallPositions[SelectedKillball_Editing] = KillBallChase
        for TempIterator1 in range(len(KillBallPositions)):
            destroyEffect(KillBallEffects[TempIterator1])
        KillBallEffects = []
        KILLBALL()
    elif eventPlayer.EditModeSelection == 3:
        if CurrentBouncePosition_Editing != BouncePositions[CurrentBounce_Editing]:
            goto lbl_1
        chase(CurrentBouncePosition_Editing, eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), BouncePositions[CurrentBounce_Editing]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_1:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(CurrentBouncePosition_Editing)
        BouncePositions[CurrentBounce_Editing] = CurrentBouncePosition_Editing
        for TempIterator1 in range(len(BouncePositions)):
            destroyEffect(BounceEffects[TempIterator1])
        BounceEffects = []
        pinball()


rule "Move the Killing sphere (backward)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection > 1
    
    if eventPlayer.EditModeSelection == 2:
        if KillBallChase != KillBallPositions[SelectedKillball_Editing]:
            goto lbl_0
        chase(KillBallChase, eventPlayer.getEyePosition() - (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), KillBallPositions[SelectedKillball_Editing]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_0:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(KillBallChase)
        KillBallPositions[SelectedKillball_Editing] = KillBallChase
        for TempIterator1 in range(len(KillBallPositions)):
            destroyEffect(KillBallEffects[TempIterator1])
        KillBallEffects = []
        KILLBALL()
    elif eventPlayer.EditModeSelection == 3:
        if CurrentBouncePosition_Editing != BouncePositions[CurrentBounce_Editing]:
            goto lbl_1
        chase(CurrentBouncePosition_Editing, eventPlayer.getEyePosition() - (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), BouncePositions[CurrentBounce_Editing]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_1:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(CurrentBouncePosition_Editing)
        BouncePositions[CurrentBounce_Editing] = CurrentBouncePosition_Editing
        for TempIterator1 in range(len(BouncePositions)):
            destroyEffect(BounceEffects[TempIterator1])
        BounceEffects = []
        pinball()


rule "Edit mode":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.EditModeSelection = 1
    eventPlayer.GuideToggle = 1


rule "Create Checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        CheckpointPositions.append(eventPlayer.getPosition() - vect(0, 0, 0))
        SelectedCheckpoint_Editing = len(CheckpointPositions) - 1
        smallMessage(getAllPlayers(), "New Checkpoint has been created")
    elif eventPlayer.EditModeSelection == 2:
        if eventPlayer.CurrentCheckpoint == 0:
            bigMessage(getAllPlayers(), "Cannot place killing sphere on level 0")
        else:
            KillBallPositions.append(eventPlayer.getPosition())
            KillballCheckpoints.append(eventPlayer.CurrentCheckpoint)
            SelectedKillball_Editing = len(KillBallPositions) - 1
            KillBallRadii[SelectedKillball_Editing] = 5
            for TempIterator1 in range(len(KillBallPositions)):
                destroyEffect(KillBallEffects[TempIterator1])
            KillBallEffects = []
            KILLBALL()
            KillBallChase = KillBallPositions[SelectedKillball_Editing]
            bigMessage(getAllPlayers(), "New killing sphere has been created! \r\nIt's only valid for level {0}".format(eventPlayer.CurrentCheckpoint))
    elif eventPlayer.EditModeSelection == 3:
        if eventPlayer.CurrentCheckpoint == 0:
            bigMessage(getAllPlayers(), "Cannot place bouncing balls on level 0")
        else:
            BouncePositions.append(eventPlayer.getPosition())
            CurrentBounce_Editing = len(BouncePositions) - 1
            BounceStrength[CurrentBounce_Editing] = 10
            BounceToggleUlt[CurrentBounce_Editing] = false
            BounceToggleDash[CurrentBounce_Editing] = false
            for TempIterator1 in range(len(BouncePositions)):
                destroyEffect(BounceEffects[TempIterator1])
            BounceEffects = []
            pinball()
            CurrentBouncePosition_Editing = BouncePositions[CurrentBounce_Editing]
            BouncePadCheckpoints.append(eventPlayer.CurrentCheckpoint)
            bigMessage(getAllPlayers(), "New bouncing ball has been created! \r\nIt's only valid for level {0}".format(eventPlayer.CurrentCheckpoint))


rule "Delete Checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        del CheckpointPositions[SelectedCheckpoint_Editing]
        del CheckpointRings_Editing[SelectedCheckpoint_Editing]
        if SelectedCheckpoint_Editing <= 0:
            goto lbl_0
        SelectedCheckpoint_Editing -= 1
        lbl_0:
        smallMessage(getAllPlayers(), "Checkpoint has been deleted")
    elif eventPlayer.EditModeSelection == 2 and len(KillBallPositions) != 0:
        del KillBallPositions[SelectedKillball_Editing]
        del KillBallRadii[SelectedKillball_Editing]
        del KillballCheckpoints[SelectedKillball_Editing]
        destroyEffect(KillBallEffects[SelectedKillball_Editing])
        del KillBallEffects[SelectedKillball_Editing]
        if SelectedKillball_Editing <= 0:
            goto lbl_1
        SelectedKillball_Editing -= 1
        lbl_1:
        KillBallChase = KillBallPositions[SelectedKillball_Editing]
    elif eventPlayer.EditModeSelection == 3 and len(BouncePositions) != 0:
        del BouncePositions[CurrentBounce_Editing]
        del BounceStrength[CurrentBounce_Editing]
        del BounceToggleUlt[CurrentBounce_Editing]
        del BounceToggleDash[CurrentBounce_Editing]
        destroyEffect(BounceEffects[CurrentBounce_Editing])
        del BounceEffects[CurrentBounce_Editing]
        del BouncePadCheckpoints[CurrentBounce_Editing]
        if CurrentBounce_Editing <= 0:
            goto lbl_2
        CurrentBounce_Editing -= 1
        lbl_2:
        CurrentBouncePosition_Editing = BouncePositions[CurrentBounce_Editing]


rule "Move checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer == hostPlayer
    
    smallMessage(getAllPlayers(), "Checkpoint {0} has been deleted".format(SelectedCheckpoint_Editing) if len(CheckpointPositions[SelectedCheckpoint_Editing]) != 0 else "")
    CheckpointPositions[SelectedCheckpoint_Editing] = eventPlayer.getPosition() - vect(0, 0, 0)
    smallMessage(getAllPlayers(), "Checkpoint has been moved to your position")


rule "Add a teleport":
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition hostPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition len(CheckpointPositions) > 1
    @Condition hostPlayer.EditModeSelection == 1
    @Condition SelectedCheckpoint_Editing > 0
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == false
    
    if hostPlayer.isHoldingButton(Button.MELEE):
        return
    CheckpointPositions[SelectedCheckpoint_Editing] = [CheckpointPositions[SelectedCheckpoint_Editing][0] if len(CheckpointPositions[SelectedCheckpoint_Editing]) != 0 else CheckpointPositions[SelectedCheckpoint_Editing], hostPlayer.getPosition()]
    smallMessage(getAllPlayers(), "Teleport has been added for checkpoint {0}".format(SelectedCheckpoint_Editing))


rule "Swap selected point (back)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        if SelectedCheckpoint_Editing <= 0:
            goto lbl_0
        SelectedCheckpoint_Editing -= 1
        lbl_0:
    elif eventPlayer.EditModeSelection == 2:
        if SelectedKillball_Editing <= 0:
            goto lbl_1
        SelectedKillball_Editing -= 1
        KillBallChase = KillBallPositions[SelectedKillball_Editing]
        lbl_1:
    elif eventPlayer.EditModeSelection == 3:
        if CurrentBounce_Editing <= 0:
            goto lbl_2
        CurrentBounce_Editing -= 1
        CurrentBouncePosition_Editing = BouncePositions[CurrentBounce_Editing]
        lbl_2:


rule "Swap selected point (forward)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        if SelectedCheckpoint_Editing == len(CheckpointPositions) - 1:
            goto lbl_0
        SelectedCheckpoint_Editing += 1
        lbl_0:
    elif eventPlayer.EditModeSelection == 2:
        if SelectedKillball_Editing == len(KillBallPositions) - 1:
            goto lbl_1
        SelectedKillball_Editing += 1
        KillBallChase = KillBallPositions[SelectedKillball_Editing]
        lbl_1:
    elif eventPlayer.EditModeSelection == 3:
        if CurrentBounce_Editing == len(BouncePositions) - 1:
            goto lbl_2
        CurrentBounce_Editing += 1
        CurrentBouncePosition_Editing = BouncePositions[CurrentBounce_Editing]
        lbl_2:


rule "Bouncing Ball turn on/off ultimate":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 3
    @Condition len(BouncePositions) != 0
    
    wait(1)
    if BounceToggleUlt[CurrentBounce_Editing] == false:
        BounceToggleUlt[CurrentBounce_Editing] = true
    elif BounceToggleUlt[CurrentBounce_Editing] == true:
        BounceToggleUlt[CurrentBounce_Editing] = false


rule "Bouncing Ball turn on/off dash":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 3
    @Condition len(BouncePositions) != 0
    
    wait(1)
    if BounceToggleDash[CurrentBounce_Editing] == false:
        BounceToggleDash[CurrentBounce_Editing] = true
    elif BounceToggleDash[CurrentBounce_Editing] == true:
        BounceToggleDash[CurrentBounce_Editing] = false


rule "Guide HUD":
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), HudPosition.RIGHT, -2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), HudPosition.RIGHT, -1, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), HudPosition.LEFT, -12, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), null, [].concat("").concat("").concat("").concat("Hold Q+LMB=Turn Ultimate On/Off\r\nHold Q+RMB=Turn Dash On/Off")[hostPlayer.EditModeSelection], HudPosition.LEFT, -6, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Guide HUD effects":
    createIcon(getAllPlayers(), CheckpointPositions[SelectedCheckpoint_Editing] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
    createInWorldText(getAllPlayers(), "Selected Checkpoint", CheckpointPositions[SelectedCheckpoint_Editing] + vect(0, 0.5, 0), 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, H[J], I[J], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.PURPLE, BouncePositions[CurrentBounce_Editing], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Don't open it easily, the action will be too long
    hudText(getAllPlayers(), [].concat(0).concat("Selected Checkpoint's number: {0}".format(SelectedCheckpoint_Editing)).concat("Current Killing Sphere's radius: {0}".format(KillBallRadii[SelectedKillball_Editing])).concat("Current Bouncing Ball's strenght: {0}".format(BounceStrength[CurrentBounce_Editing]))[hostPlayer.EditModeSelection], null, [].concat("").concat("").concat("").concat("Current Bouncing Ball's Ultimate: {0}\r\nCurrent Bouncing Ball's Dash: {1}".format(BounceToggleUlt[CurrentBounce_Editing], BounceToggleDash[CurrentBounce_Editing]))[hostPlayer.EditModeSelection], HudPosition.TOP, -14, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), "Selected Killing Sphere", KillBallPositions[SelectedKillball_Editing], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    createEffect(getAllPlayers(), Effect.ORB, Color.RED, KillBallChase, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(hostPlayer, l"{0} m".format(distance(hostPlayer, KillBallChase)), KillBallChase - vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    createIcon(getAllPlayers(), KillBallPositions[SelectedKillball_Editing] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)


rule "Hide excess checkpoints":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer == hostPlayer
    
    for SelectedCheckpoint_Editing in range(len(CheckpointRings_Editing) - 1, 0, -1):
        destroyEffect(CheckpointRings_Editing[SelectedCheckpoint_Editing])
        del CheckpointRings_Editing[SelectedCheckpoint_Editing]
    SelectedCheckpoint_Editing = -2


rule "Show checkpoints":
    @Condition SelectedCheckpoint_Editing == -2
    
    for SelectedCheckpoint_Editing in range(len(CheckpointPositions)):
        createEffect(getAllPlayers(), Effect.RING, Color.RED, CheckpointPositions[SelectedCheckpoint_Editing], 1, EffectReeval.VISIBILITY)
        CheckpointRings_Editing.append(getLastCreatedEntity())


rule "Jump to next checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    
    eventPlayer.CurrentCheckpoint += 1
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint])
    ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint].append(eventPlayer)
    ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint - 1].remove(eventPlayer)


rule "Jump to previous checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.CurrentCheckpoint != 0
    
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint - 1])
    eventPlayer.CurrentCheckpoint -= 1
    ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint].append(eventPlayer)
    ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint + 1].remove(eventPlayer)


