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
    
    B__ = 0
    CheckpointRings_Editing = 0
    DVA = 0
    dva = 0
    Portal1PlayerList = 0
    Portal2PlayerList = 0
    J__ = 0
    KillBallEffects = 0
    KillBallChase = 0
    Dao__ = 0
    SHIFT__ = 0
    SUPERJUMP_unused = 0
    ListPlayersAtCheckpoints = 0
    ActivePlayers = 0
    R_unused = 0
    TQ1__ = 0
    TempIterator1 = 0
    TQ2__ = 0
    TQ3__ = 0
    SavedProgress = 0
    TimeLimitSettingToggle_ = 0
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
            KillBallRadii[J__] += 0.1
            wait(0.1)
            if RULE_CONDITION:
                goto RULE_START
            for TempIterator1 in range(len(KillBallPositions)):
                destroyEffect(KillBallEffects[TempIterator1])
            KillBallEffects = []
            KILLBALL()
    elif eventPlayer.EditModeSelection == 3:
        if len(TQ__) > 0:
            EditMode__[TQ1__] += 0.1
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
            KillBallRadii[J__] -= 0.1
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
    
    if len(TQ__) > 0:
        EditMode__[TQ1__] -= 0.1
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
        if KillBallChase != KillBallPositions[J__]:
            goto lbl_0
        chase(KillBallChase, eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), KillBallPositions[J__]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_0:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(KillBallChase)
        KillBallPositions[J__] = KillBallChase
        for TempIterator1 in range(len(KillBallPositions)):
            destroyEffect(KillBallEffects[TempIterator1])
        KillBallEffects = []
        KILLBALL()
    elif eventPlayer.EditModeSelection == 3:
        if TQ3__ != TQ__[TQ1__]:
            goto lbl_1
        chase(TQ3__, eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), TQ__[TQ1__]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_1:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(TQ3__)
        TQ__[TQ1__] = TQ3__
        for TempIterator1 in range(len(TQ__)):
            destroyEffect(TQ2__[TempIterator1])
        TQ2__ = []
        pinball()


rule "Move the Killing sphere (backward)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection > 1
    
    if eventPlayer.EditModeSelection == 2:
        if KillBallChase != KillBallPositions[J__]:
            goto lbl_0
        chase(KillBallChase, eventPlayer.getEyePosition() - (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), KillBallPositions[J__]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_0:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(KillBallChase)
        KillBallPositions[J__] = KillBallChase
        for TempIterator1 in range(len(KillBallPositions)):
            destroyEffect(KillBallEffects[TempIterator1])
        KillBallEffects = []
        KILLBALL()
    elif eventPlayer.EditModeSelection == 3:
        if TQ3__ != TQ__[TQ1__]:
            goto lbl_1
        chase(TQ3__, eventPlayer.getEyePosition() - (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), TQ__[TQ1__]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_1:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(TQ3__)
        TQ__[TQ1__] = TQ3__
        for TempIterator1 in range(len(TQ__)):
            destroyEffect(TQ2__[TempIterator1])
        TQ2__ = []
        pinball()


rule "Edit mode":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    #玩家E：编辑模式
    eventPlayer.EditModeSelection = 1
    eventPlayer.GuideToggle = 1


rule "Create Checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        CheckpointPositions.append(eventPlayer.getPosition() - vect(0, 0, 0))
        B__ = len(CheckpointPositions) - 1
        smallMessage(getAllPlayers(), "New Checkpoint has been created")
    elif eventPlayer.EditModeSelection == 2:
        if eventPlayer.A__ == 0:
            bigMessage(getAllPlayers(), "Cannot place killing sphere on level 0")
        else:
            KillBallPositions.append(eventPlayer.getPosition())
            KillballCheckpoints.append(eventPlayer.A__)
            J__ = len(KillBallPositions) - 1
            KillBallRadii[J__] = 5
            for TempIterator1 in range(len(KillBallPositions)):
                destroyEffect(KillBallEffects[TempIterator1])
            KillBallEffects = []
            KILLBALL()
            KillBallChase = KillBallPositions[J__]
            bigMessage(getAllPlayers(), "New killing sphere has been created! \r\nIt's only valid for level {0}".format(eventPlayer.A__))
    elif eventPlayer.EditModeSelection == 3:
        if eventPlayer.A__ == 0:
            bigMessage(getAllPlayers(), "Cannot place bouncing balls on level 0")
        else:
            TQ__.append(eventPlayer.getPosition())
            TQ1__ = len(TQ__) - 1
            EditMode__[TQ1__] = 10
            TQ5__[TQ1__] = false
            TQ6__[TQ1__] = false
            for TempIterator1 in range(len(TQ__)):
                destroyEffect(TQ2__[TempIterator1])
            TQ2__ = []
            pinball()
            TQ3__ = TQ__[TQ1__]
            BouncePadCheckpoints.append(eventPlayer.A__)
            bigMessage(getAllPlayers(), "New bouncing ball has been created! \r\nIt's only valid for level {0}".format(eventPlayer.A__))


rule "Delete Checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        del CheckpointPositions[B__]
        del CheckpointRings_Editing[B__]
        if B__ <= 0:
            goto lbl_0
        B__ -= 1
        lbl_0:
        smallMessage(getAllPlayers(), "Checkpoint has been deleted")
    elif eventPlayer.EditModeSelection == 2 and len(KillBallPositions) != 0:
        del KillBallPositions[J__]
        del KillBallRadii[J__]
        del KillballCheckpoints[J__]
        destroyEffect(KillBallEffects[J__])
        del KillBallEffects[J__]
        if J__ <= 0:
            goto lbl_1
        J__ -= 1
        lbl_1:
        KillBallChase = KillBallPositions[J__]
    elif eventPlayer.EditModeSelection == 3 and len(TQ__) != 0:
        del TQ__[TQ1__]
        del EditMode__[TQ1__]
        del TQ5__[TQ1__]
        del TQ6__[TQ1__]
        destroyEffect(TQ2__[TQ1__])
        del TQ2__[TQ1__]
        del BouncePadCheckpoints[TQ1__]
        if TQ1__ <= 0:
            goto lbl_2
        TQ1__ -= 1
        lbl_2:
        TQ3__ = TQ__[TQ1__]


rule "Move checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer == hostPlayer
    
    smallMessage(getAllPlayers(), "Checkpoint {0} has been deleted".format(B__) if len(CheckpointPositions[B__]) != 0 else "")
    CheckpointPositions[B__] = eventPlayer.getPosition() - vect(0, 0, 0)
    smallMessage(getAllPlayers(), "Checkpoint has been moved to your position")


rule "Add a teleport":
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition hostPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition len(CheckpointPositions) > 1
    @Condition hostPlayer.EditModeSelection == 1
    @Condition B__ > 0
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == false
    
    if hostPlayer.isHoldingButton(Button.MELEE):
        return
    CheckpointPositions[B__] = [CheckpointPositions[B__][0] if len(CheckpointPositions[B__]) != 0 else CheckpointPositions[B__], hostPlayer.getPosition()]
    smallMessage(getAllPlayers(), "Teleport has been added for level {0}".format(B__))


rule "Swap selected point (back)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        if B__ <= 0:
            goto lbl_0
        B__ -= 1
        lbl_0:
    elif eventPlayer.EditModeSelection == 2:
        if J__ <= 0:
            goto lbl_1
        J__ -= 1
        KillBallChase = KillBallPositions[J__]
        lbl_1:
    elif eventPlayer.EditModeSelection == 3:
        if TQ1__ <= 0:
            goto lbl_2
        TQ1__ -= 1
        TQ3__ = TQ__[TQ1__]
        lbl_2:


rule "Swap selected point (forward)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        if B__ == len(CheckpointPositions) - 1:
            goto lbl_0
        B__ += 1
        lbl_0:
    elif eventPlayer.EditModeSelection == 2:
        if J__ == len(KillBallPositions) - 1:
            goto lbl_1
        J__ += 1
        KillBallChase = KillBallPositions[J__]
        lbl_1:
    elif eventPlayer.EditModeSelection == 3:
        if TQ1__ == len(TQ__) - 1:
            goto lbl_2
        TQ1__ += 1
        TQ3__ = TQ__[TQ1__]
        lbl_2:


rule "Bouncing Ball turn on/off ultimate":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 3
    @Condition len(TQ__) != 0
    
    wait(1)
    if TQ5__[TQ1__] == false:
        TQ5__[TQ1__] = true
    elif TQ5__[TQ1__] == true:
        TQ5__[TQ1__] = false


rule "Bouncing Ball turn on/off dash":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 3
    @Condition len(TQ__) != 0
    
    wait(1)
    if TQ6__[TQ1__] == false:
        TQ6__[TQ1__] = true
    elif TQ6__[TQ1__] == true:
        TQ6__[TQ1__] = false


rule "Guide HUD":
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), HudPosition.RIGHT, -2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), HudPosition.RIGHT, -1, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), HudPosition.LEFT, -12, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), "{{0}}".format(hostPlayer.GuideToggle), null, [].concat("").concat("").concat("").concat("Hold Q+LMB=Turn Ultimate On/Off\r\nHold Q+RMB=Turn Dash On/Off")[hostPlayer.EditModeSelection], HudPosition.LEFT, -6, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Guide HUD effects":
    createIcon(getAllPlayers(), CheckpointPositions[B__] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
    createInWorldText(getAllPlayers(), "Selected Checkpoint", CheckpointPositions[B__] + vect(0, 0.5, 0), 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, H[J], I[J], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.PURPLE, TQ__[TQ1__], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #轻易别打开，动作太长会
    hudText(getAllPlayers(), [].concat(0).concat("Selected Checkpoint's number: {0}".format(B__)).concat("Current Killing Sphere's radius: {0}".format(KillBallRadii[J__])).concat("Current Bouncing Ball's strenght: {0}".format(EditMode__[TQ1__]))[hostPlayer.EditModeSelection], null, [].concat("").concat("").concat("").concat("Current Bouncing Ball's Ultimate: {0}\r\nCurrent Bouncing Ball's Dash: {1}".format(TQ5__[TQ1__], TQ6__[TQ1__]))[hostPlayer.EditModeSelection], HudPosition.TOP, -14, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), "Selected Killing Sphere", KillBallPositions[J__], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    createEffect(getAllPlayers(), Effect.ORB, Color.RED, KillBallChase, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(hostPlayer, l"{0} m".format(distance(hostPlayer, KillBallChase)), KillBallChase - vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    createIcon(getAllPlayers(), KillBallPositions[J__] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)


rule "Hide excess checkpoints":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer == hostPlayer
    
    for B__ in range(len(CheckpointRings_Editing) - 1, 0, -1):
        destroyEffect(CheckpointRings_Editing[B__])
        del CheckpointRings_Editing[B__]
    B__ = -2


rule "Show checkpoints":
    @Condition B__ == -2
    
    for B__ in range(len(CheckpointPositions)):
        createEffect(getAllPlayers(), Effect.RING, Color.RED, CheckpointPositions[B__], 1, EffectReeval.VISIBILITY)
        CheckpointRings_Editing.append(getLastCreatedEntity())


rule "Jump to next checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    
    eventPlayer.A__ += 1
    eventPlayer.teleport(CheckpointPositions[eventPlayer.A__])
    ListPlayersAtCheckpoints[eventPlayer.A__].append(eventPlayer)
    ListPlayersAtCheckpoints[eventPlayer.A__ - 1].remove(eventPlayer)


rule "Jump to previous checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.A__ != 0
    
    eventPlayer.teleport(CheckpointPositions[eventPlayer.A__ - 1])
    eventPlayer.A__ -= 1
    ListPlayersAtCheckpoints[eventPlayer.A__].append(eventPlayer)
    ListPlayersAtCheckpoints[eventPlayer.A__ + 1].remove(eventPlayer)


