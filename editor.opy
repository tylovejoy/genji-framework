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
    #bigMessage(getAllPlayers(), "Excess data has been cleared")
    #bigMessage(getAllPlayers(), "Excess data has been cleared")
    enableInspector()

    hudHeader(eventPlayer, 
        " \n"
        " 0. open this window to clear data excess (done)\n\n"
        " 1. Open Workshop Inspector\n Set variable target as global\n click the [x]\n\n"
        " 2. Open Workshop Editor\n open [Checkpoint | Position]\n CLICK THE YELLOW [+] SIGN \n\n"
        " 3. TURN OFF EDIT RULES\n\n"
        " 4. ESC→SHOW LOBBY→SETTINGS→SHARE CODE→\n CREATE NEW CODE→COPY CODE\n\n"
        " 5. OPEN WORKSHOP EDITOR\n PASTE MAP CODE AND THE AUTHOR NAME IN the \"TEXT\" rule \n\n"
        " 6. ESC→SHOW LOBBY→SETTINGS→SHARE CODE→\n UPLOAD TO EXISTING CODE→\n"
        " PASTE THE CODE YOU CREATED IN STEP 5 \n\n"
        , HudPosition.TOP, -99, Color.LIME_GREEN, HudReeval.NONE
    )
    eventPlayer.savemaphud[0] = getLastCreatedText()
    hudHeader(eventPlayer, 
        "    > Press Interact to hide this window <    "
        , HudPosition.TOP, -98, Color.LIME_GREEN, HudReeval.NONE
    )
    eventPlayer.savemaphud[1] = getLastCreatedText()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 9999)
    waitUntil(eventPlayer.isHoldingButton(Button.INTERACT), 9999)
    destroyHudText(eventPlayer.savemaphud[0])
    destroyHudText(eventPlayer.savemaphud[1])


rule "Fly toggle editor":
    @Event eachPlayer
    #@Condition eventPlayer.EditModeSelection > 0
    @Condition eventPlayer.EditModeSelection == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.flytoggle == null

    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2), 1)
    eventPlayer.flytoggle = eventPlayer.getPosition() + Vector.UP
    eventPlayer.startForcingPosition(eventPlayer.flytoggle, true)
    eventPlayer.disableEnvironmentCollision(true)
    while eventPlayer.isAlive() and eventPlayer.flytoggle != null and not eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.flytoggle += eventPlayer.getFacingDirection() * (
            0.25 + eventPlayer.isHoldingButton(Button.JUMP) if eventPlayer.getThrottle().z > 0 else 
            -0.25 - eventPlayer.isHoldingButton(Button.JUMP) if eventPlayer.getThrottle().z < 0 else 
            0
            )
        eventPlayer.flytoggle += worldVector(vect(eventPlayer.getThrottle().x*0.3,0,0), eventPlayer, Transform.ROTATION) 
        wait()
    

    eventPlayer.enableEnvironmentCollision()
    #if eventPlayer.flytoggle != null:
    eventPlayer.flytoggle = null
    eventPlayer.stopForcingPosition()

    wait(1)

/*
rule "Deflect TP":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.EditModeSelection == 1
    
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 3)
*/

rule "Change editing mode":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer == hostPlayer
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.flytoggle = null
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
    CheckpointPositions[SelectedCheckpoint_Editing] = [
        CheckpointPositions[SelectedCheckpoint_Editing][0] 
            if len(CheckpointPositions[SelectedCheckpoint_Editing]) != 0 else 
            CheckpointPositions[SelectedCheckpoint_Editing], hostPlayer.getPosition()
            ]

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
    #done#hudSubtext(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, [].concat(0).concat("{0}\r\n{1}\r\n{2}".format("Interact+LMB=Create New Checkpoint\r\nInteract+RMB=Delete selected Checkpoint\r\nInteract+R=Add teleport to Checkpoint", "Interact+Ultimate=Set Checkpoint to your current position\r\nInteract+Crouch=Select previous Checkpoint", "Interact+Jump=Select next Checkpoint\r\nInteract+1 ability=Show all checkpoints")).concat("{0}\r\n{1}\r\n{2}".format("Interact+LMB=Create new killing sphere\r\nInteract+RMB=Delete selected sphere\r\nInteract+Crouch=Select previous sphere", "Interact+Jump=Select nex sphere\r\nDeflect+Jump=Make sphere bigger\r\nDeflect+Crouch=Shrink the sphere", "Deflect+LMB=Move forward\r\nDeflect+RMB=Move Backward")).concat("{0}\r\n{1}\r\n{2}".format("Interact+LMB=Create new Bouncing Ball\r\nInteract+RMB=Delete selected Ball\r\nInteract+Crouch=Select previous Ball", "Interact+Jump=Select next Ball\r\nDeflect+Jump=Increase Ball's strenght\r\nDeflect+Crouch=Decrease Ball's strenght", "Deflect+LMB=Move Ball forward\r\nDeflect+RMB=Move Ball back"))[hostPlayer.E], "Hold melee to open the guidance text"), HudPosition.RIGHT, -2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #to test#hudSubtext(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, "Crouch+LMB=Next lvl\r\nCrouch+RMB=Prev lvl\r\nIn invincbile mode:\r\nE=Trough Wall", ""), HudPosition.RIGHT, -1, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #to test#hudSubtext(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, "Hold melee to hide guidence text\r\nCreated by: 易忘#51876\r\nUdpated by: 五里雾中#51574\r\nTranslated by: Xerteks#2929,FATHER", ""), HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    
    #hudSubtext(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, "{0}\r\n{1}{2}\r\n{3}".format("To save the map:\r\n1.Interact+Melee+Reload to clear excess data", "2.Open Workshop Inspector - Set variable target as global - click the [x]\r\n3.Open Workshop Editor - open [Checkpoint | Position]", "- CLICK THE YELLOW [+] SIGN\r\n4.TURN OFF EDIT RULES\r\n{0}{1}\r\n{2}".format("ESC→SHOW LOBBY→SETTINGS→SHARE CODE→CREATE NEW CODE→COPY CODE\r\n6.OPEN WORKSHOP EDITOR - PASTE MAP CODE AND ADD YOUR", "NICKNAME AS AUTHOR IN \"TEXT\" \r\n7.ESC→SHOW LOBBY→SETTINGS→SHARE CODE→UPLOAD TO EXISTING CODE→\r\n{0}".format(" PASTE THE CODE YOU CREATED IN STEP 5"), "\n")), ""), HudPosition.LEFT, -12, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudText(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, [].concat(0).concat("Hold Dash to change editing mode\r\nCurrent mode: Checkpoints").concat("Hold Dash to change editing mode\r\nCurrent mode: Killing Sphere").concat("Hold Dash to change editing mode\r\nCurrent mode: Bouncing Ball")[hostPlayer.E], "Guide HUD has been closed"), null, [].concat("").concat("").concat("").concat("Hold Q+LMB=Turn Ultimate On/Off\r\nHold Q+RMB=Turn Dash On/Off")[hostPlayer.E], HudPosition.LEFT, -6, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)



    hudSubtext(hostPlayer if hostPlayer.GuideToggle == 1 else null, 
        "{0}".format(
        [
        "Interact+LMB=Create New Checkpoint\n"
        "Interact+RMB=Delete selected Checkpoint\n"
        "Interact+R=Add teleport to Checkpoint\n"
        "Interact+Ultimate=Set Checkpoint to your current position\n"
        "Interact+Crouch=Select previous Checkpoint\n"
        "Interact+Jump=Select next Checkpoint\n"
        "Interact+1 ability=Show all checkpoints",

        "Interact+LMB=Create new killing sphere\n"
        "Interact+RMB=Delete selected sphere\n"
        "Interact+Crouch=Select previous sphere\n"
        "Interact+Jump=Select nex sphere\n"
        "Deflect+Jump=Make sphere bigger\r\nDeflect+Crouch=Shrink the sphere\n"
        "Deflect+LMB=Move forward\n"
        "Deflect+RMB=Move Backward",

        "Interact+LMB=Create new Bouncing Ball\n"
        "Interact+RMB=Delete selected Ball\n"
        "Interact+Crouch=Select previous Ball\n"
        "Interact+Jump=Select next Ball\n"
        "Deflect+Jump=Increase Ball's strenght\n"
        "Deflect+Crouch=Decrease Ball's strenght\n"
        "Deflect+LMB=Move Ball forward\n"
        "Deflect+RMB=Move Ball back"
        ][hostPlayer.EditModeSelection-1]), 
        HudPosition.RIGHT, 10, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer, #if hostPlayer.GuideToggle else null, 
        "Crouch+LMB=Next lvl\n"
        "Crouch+RMB=Prev lvl\n"
        "hold melee to toggle guidence text\n"
        #"In invincbile mode:\n"
        "E=Fly (checkpoint mode only)\n"
        if hostPlayer.GuideToggle == 1  else
        "Hold melee to toggle guidence text"
        ,
        HudPosition.RIGHT, 11, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    /*
    # just replace by guide togle info
     hudSubtext(getAllPlayers() if hostPlayer.GuideToggle else null, 
        "Hold melee to hide guidence text\r\nCreated by: 易忘#51876\r\nUdpated by: 五里雾中#51574\r\nTranslated by: Xerteks#2929,FATHER" 
        HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    */
    hudSubtext(hostPlayer if hostPlayer.GuideToggle == 1 else null, 
        "save map: hold interact+melee+reload and follow instructions",
        #"Interact+Melee+Reload to clear excess data\n"
        #"2. Open Workshop Inspector - Set variable target as global - click the [x]\n"
        #"3. Open Workshop Editor - open [Checkpoint | Position] - CLICK THE YELLOW [+] SIGN\n"
        #"4. TURN OFF EDIT RULES\n"
        #"5. ESC→SHOW LOBBY→SETTINGS→SHARE CODE→CREATE NEW CODE→COPY CODE\n"
        #"6. OPEN WORKSHOP EDITOR - PASTE MAP CODE AND ADD YOUR NICKNAME AS AUTHOR IN \"TEXT\" \n"
        #"7. ESC→SHOW LOBBY→SETTINGS→SHARE CODE→UPLOAD TO EXISTING CODE→\n"
        #"  PASTE THE CODE YOU CREATED IN STEP 5",
        HudPosition.LEFT, -12, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudText(getAllPlayers(), #if hostPlayer.GuideToggle == 1 else null, 
        "Hold Dash to change editing mode\n"
        "Current mode: {0}".format(["Checkpoints","Killing Sphere","Bouncing Ball"][hostPlayer.EditModeSelection -1])
        if localPlayer == hostPlayer else "Current editor/host: {0}".format(hostPlayer)
        ,
        null,        
        "Hold Q+LMB=Turn Ultimate On/Off\n"
        "Hold Q+RMB=Turn Dash On/Off" if hostPlayer.EditModeSelection == 3 else "",
          
        HudPosition.LEFT, -6, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)



rule "Guide HUD effects":
    createIcon(getAllPlayers(), CheckpointPositions[SelectedCheckpoint_Editing] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
    createInWorldText(getAllPlayers(), "Selected Checkpoint", CheckpointPositions[SelectedCheckpoint_Editing] + vect(0, 0.5, 0), 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, H[J], I[J], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.PURPLE, BouncePositions[CurrentBounce_Editing], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Don't open it easily, the action will be too long
    hudText(hostPlayer, [].concat(0).concat("Selected Checkpoint's number: {0}".format(SelectedCheckpoint_Editing)).concat("Current Killing Sphere's radius: {0}".format(KillBallRadii[SelectedKillball_Editing])).concat("Current Bouncing Ball's strenght: {0}".format(BounceStrength[CurrentBounce_Editing]))[hostPlayer.EditModeSelection], null, [].concat("").concat("").concat("").concat("Current Bouncing Ball's Ultimate: {0}\r\nCurrent Bouncing Ball's Dash: {1}".format(BounceToggleUlt[CurrentBounce_Editing], BounceToggleDash[CurrentBounce_Editing]))[hostPlayer.EditModeSelection], HudPosition.TOP, -14, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
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


rule "editor jump cp":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1) or (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.CurrentCheckpoint != 0)

    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint - 1])
        eventPlayer.CurrentCheckpoint -= 1
        ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint].append(eventPlayer)
        ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint + 1].remove(eventPlayer)
    else:
        eventPlayer.CurrentCheckpoint += 1
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint])
        ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint].append(eventPlayer)
        ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint - 1].remove(eventPlayer)
        eventPlayer.Timer = 9999
/*
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

*/
# 8539