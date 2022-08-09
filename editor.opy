#!mainFile "genji.opy"



rule "------------------------------------------------------------------------  Editor ------------------------------------------------------------------------":
    @Delimiter
    @Disabled
    
rule "Inspector | Update Every 10 Minutes":
    @Condition hostPlayer.EditorOn
    disableInspector()
    wait(10)
    enableInspector()
    goto RULE_START


rule "HUD | Clear Excess Data & Save Map":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer == hostPlayer
    
    SelectedCheckpoint_Editing = 0
    CheckpointRings_Editing = 0
    #Portal1PlayerList = 0
    #Portal2PlayerList = 0
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
    LeaderBoardFull = []
    #bigMessage(getAllPlayers(), "Excess data has been cleared")
    #bigMessage(getAllPlayers(), "Excess data has been cleared")
    enableInspector()

    hudHeader(eventPlayer, 
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "   0. clear excess data:\n"
        " Automatically done when opening this window\n\n"

        "   1. Copy data:\n" 
        " Open Workshop Inspector → Set variable target as global\n"
        " click the [x]\n\n"

        "   2. Insert data:\n"
        " Paste the data in the rule named 'map data pasta' (last rule)\n\n" 

        "   3. Turn editor off:\n"
        " ESC→SHOW LOBBY→SETTINGS→ workshop settings →\n"
        " toggle 'Editor mode' off\n"
        , HudPosition.TOP, -99, Color.LIME_GREEN, HudReeval.NONE
    )
    eventPlayer.savemaphud[0] = getLastCreatedText()

    hudHeader(eventPlayer, 
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "   4. Create intial sharecode:\n" 
        " ESC→SHOW LOBBY→SETTINGS→SHARE CODE→\n"
        " CREATE NEW CODE→COPY CODE\n\n"

        "   5. Add credits:\n" 
        " Enter your name & map code in the 'Credits here' rule\n"
        " (second to last rule) \n\n"
        
        "   6. Update for credits:\n"
        " ESC→SHOW LOBBY→SETTINGS→SHARE CODE→\n"
        " UPLOAD TO EXISTING CODE→ PASTE THE CODE YOU CREATED IN STEP 4\n"
        , HudPosition.TOP, -98, Color.LIME_GREEN, HudReeval.NONE
    )
    eventPlayer.savemaphud[1] = getLastCreatedText()

    hudHeader(eventPlayer, 
        "    > Press Interact to close this window <    "
        , HudPosition.TOP, -97, Color.LIME_GREEN, HudReeval.NONE
    )
    eventPlayer.savemaphud[2] = getLastCreatedText()

    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 9999)
    waitUntil(eventPlayer.isHoldingButton(Button.INTERACT), 9999)
    destroyHudText(eventPlayer.savemaphud[0])
    destroyHudText(eventPlayer.savemaphud[1])
    destroyHudText(eventPlayer.savemaphud[2])
    

rule "HUD | Show/Hide Guide | Hold Melee":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "HUD | Show Guide On Spawn":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.EditModeSelection = 1
    eventPlayer.GuideToggle = 1

rule "HUD | Guide":
    @Condition hostPlayer.EditorOn
    #done#hudSubtext(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, [].concat(0).concat("{0}\r\n{1}\r\n{2}".format("Interact+LMB=Create New Checkpoint\r\nInteract+RMB=Delete selected Checkpoint\r\nInteract+R=Add teleport to Checkpoint", "Interact+Ultimate=Set Checkpoint to your current position\r\nInteract+Crouch=Select previous Checkpoint", "Interact+Jump=Select next Checkpoint\r\nInteract+1 ability=Show all checkpoints")).concat("{0}\r\n{1}\r\n{2}".format("Interact+LMB=Create new Kill Orb\r\nInteract+RMB=Delete selected sphere\r\nInteract+Crouch=Select previous sphere", "Interact+Jump=Select nex sphere\r\nDeflect+Jump=Make sphere bigger\r\nDeflect+Crouch=Shrink the sphere", "Deflect+LMB=Move forward\r\nDeflect+RMB=Move Backward")).concat("{0}\r\n{1}\r\n{2}".format("Interact+LMB=Create new Bounce Orb\r\nInteract+RMB=Delete selected Ball\r\nInteract+Crouch=Select previous Ball", "Interact+Jump=Select next Ball\r\nDeflect+Jump=Increase Ball's strength\r\nDeflect+Crouch=Decrease Ball's strength", "Deflect+LMB=Move Ball forward\r\nDeflect+RMB=Move Ball back"))[hostPlayer.E], "Hold melee to open the guidance text"), HudPosition.RIGHT, -2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #to test#hudSubtext(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, "Crouch+LMB=Next lvl\r\nCrouch+RMB=Prev lvl\r\nIn invincbile mode:\r\nE=Trough Wall", ""), HudPosition.RIGHT, -1, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #to test#hudSubtext(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, "Hold melee to hide guidence text\r\nCreated by: 易忘#51876\r\nUdpated by: 五里雾中#51574\r\nTranslated by: Xerteks#2929,FATHER", ""), HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    
    #hudSubtext(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, "{0}\r\n{1}{2}\r\n{3}".format("To save the map:\r\n1.Interact+Melee+Reload to clear excess data", "2.Open Workshop Inspector - Set variable target as global - click the [x]\r\n3.Open Workshop Editor - open [Checkpoint | Position]", "- CLICK THE YELLOW [+] SIGN\r\n4.TURN OFF EDIT RULES\r\n{0}{1}\r\n{2}".format("ESC→SHOW LOBBY→SETTINGS→SHARE CODE→CREATE NEW CODE→COPY CODE\r\n6.OPEN WORKSHOP EDITOR - PASTE MAP CODE AND ADD YOUR", "NICKNAME AS AUTHOR IN \"TEXT\" \r\n7.ESC→SHOW LOBBY→SETTINGS→SHARE CODE→UPLOAD TO EXISTING CODE→\r\n{0}".format(" PASTE THE CODE YOU CREATED IN STEP 5"), "\n")), ""), HudPosition.LEFT, -12, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudText(getAllPlayers(), "{0}{1}{2}".format(hostPlayer.K, [].concat(0).concat("Hold Dash to change editing mode\r\nCurrent mode: Checkpoints").concat("Hold Dash to change editing mode\r\nCurrent mode: Kill Orb").concat("Hold Dash to change editing mode\r\nCurrent mode: Bounce Orb")[hostPlayer.E], "Guide HUD has been closed"), null, [].concat("").concat("").concat("").concat("Hold Q+LMB=Turn Ultimate On/Off\r\nHold Q+RMB=Turn Dash On/Off")[hostPlayer.E], HudPosition.LEFT, -6, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudSubtext(hostPlayer if hostPlayer.GuideToggle == 1 else null, 
        " \n{0}".format(    
    [   
        "{0} + {1} | Create New Checkpoint\n"
        "{0} + {2} | Delete selected Checkpoint\n"
        "{0} + {3} | Add teleport to Checkpoint\n"
        "{0} + {4} | Set Checkpoint to current position\n"
        "{0} + {5} | Select previous Checkpoint\n"
        "{0} + {6} | Select next Checkpoint\n"
        "{0} + {7} | Show all checkpoints".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_1)),

        "{0} + {1} | Create new kill orb\n"
        "{0} + {2} | Delete selected orb\n"
        "{0} + {3} | Select previous orb\n"
        "{0} + {4} | Select next orb\n"
        "{5} + {4} | Increase orb size\n"
        "{5} + {3} | Decrease orb size\n"
        "{5} + {1} | Move orb forward\n"
        "{5} + {2} | Move orb Backward".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2)),
 
        "{0} + {1} | Create new Bounce orb\n"
        "{0} + {2} | Delete selected orb\n"
        "{0} + {3} | Select previous orb\n"
        "{0} + {4} | Select next orb\n"
        "{5} + {4} | Increase orb strength\n"
        "{5} + {3} | Decrease orb strength\n"
        "{5} + {1} | Move orb forward\n"
        "{5} + {2} | Move orb back".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2))
        ][hostPlayer.EditModeSelection-1]), 
        HudPosition.RIGHT, 10, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer, #if hostPlayer.GuideToggle else null, 
        " \n{0} + {1} | Next checkpoint\n"
        "{0} + {2} | Prev checkpoint\n"
        "Hold {3} | toggle guide\n"
        #"In invincbile mode:\n"
        "{4} | Fly (checkpoint mode only)\n".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.MELEE), buttonString(Button.ABILITY_2))
        if hostPlayer.GuideToggle == 1  else
        "Hold {0} | toggle guide".format(buttonString(Button.MELEE)),
        HudPosition.RIGHT, 11, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )


    hudSubtext(hostPlayer if hostPlayer.GuideToggle == 1 else null, 
    "save map: hold {0} + {1} + {2} and follow instructions".format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD)),
        HudPosition.LEFT, -12, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    hudText(getAllPlayers(), #if hostPlayer.GuideToggle == 1 else null, 
        "Current mode: {1}\n"
        "Hold {0} to change ".format(buttonString(Button.ABILITY_1), ["Checkpoints","Kill Orb","Bounce Orb"][hostPlayer.EditModeSelection -1])
        if localPlayer == hostPlayer else "Current editor/host: {0}".format(hostPlayer)
        ,
        null,      
        null,  
        #" \nHold {0} + {1} | Turn Ultimate On/Off\n"
        #"Hold {0} + {2} | Turn Dash On/Off".format(buttonString(Button.ULTIMATE), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE))
        #if hostPlayer.EditModeSelection == 3 else "",   
        HudPosition.LEFT, -6, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudSubtext(hostPlayer if hostPlayer.EditModeSelection == 3 else null, 
        "Orb gives ultimate: {0} | toggle with {1} + {2}\n"
        "Orb gives dash: {3} | toggle with {1} + {4}".format(BounceToggleUlt[CurrentBounce_Editing] if BounceToggleUlt[CurrentBounce_Editing] != 0 else "false", buttonString(Button.ULTIMATE), buttonString(Button.PRIMARY_FIRE), BounceToggleDash[CurrentBounce_Editing] if BounceToggleDash[CurrentBounce_Editing] != 0 else "false", buttonString(Button.SECONDARY_FIRE))
        , HudPosition.TOP, -18, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudText(hostPlayer,
        [
        "Selected Checkpoint's number: {0}".format(SelectedCheckpoint_Editing),
        "Current Kill Orb's radius: {0}".format(KillBallRadii[SelectedKillball_Editing]),
        "Current Bounce Orb's strength: {0}".format(BounceStrength[CurrentBounce_Editing])
        ][hostPlayer.EditModeSelection -1],
        null,
        null,#"Current Bounce Orb's Ultimate: {0}\nCurrent Bounce Orb's Dash: {1}".format(BounceToggleUlt[CurrentBounce_Editing], BounceToggleDash[CurrentBounce_Editing]) if hostPlayer.EditModeSelection == 3 else "",
        HudPosition.TOP, -20, Color.RED, Color.ORANGE,Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

rule "HUD | Guide Effects":
    @Condition hostPlayer.EditorOn
    createIcon(getAllPlayers(), CheckpointPositions[SelectedCheckpoint_Editing] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
    createInWorldText(getAllPlayers(), "Selected Checkpoint", CheckpointPositions[SelectedCheckpoint_Editing] + vect(0, 0.5, 0), 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    ###createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, H[J], I[J], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.PURPLE, BouncePositions[CurrentBounce_Editing], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Don't open it easily, the action will be too long
    
    createInWorldText(getAllPlayers(), "Selected Kill Orb", KillBallPositions[SelectedKillball_Editing], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    createEffect(getAllPlayers(), Effect.ORB, Color.RED, KillBallChase, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(hostPlayer, l"{0} m".format(distance(hostPlayer, KillBallChase)), KillBallChase - vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    createIcon(getAllPlayers(), KillBallPositions[SelectedKillball_Editing] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
    createEffect(localPlayer if len(CheckpointPositions[SelectedCheckpoint_Editing] ) > 1 else null, Effect.SPHERE, Color.PURPLE, CheckpointPositions[SelectedCheckpoint_Editing][1]-vect(0,0.1,0), 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Fly/Noclip Toggle | Hold Deflect":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    #@Condition eventPlayer.EditModeSelection > 0
    @Condition eventPlayer.EditModeSelection == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    #@Condition not eventPlayer.isHoldingButton(Button.JUMP)
    @Condition not eventPlayer.isHoldingButton(Button.CROUCH)
    #@Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    #@Condition not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.flytoggle == null

    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2) or (eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT)), 1)
    if eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT):
        wait()
        return

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

rule "Change Edit Mode | Hold Dash":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer == hostPlayer
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.flytoggle = null
    if eventPlayer.EditModeSelection == 1:
        eventPlayer.EditModeSelection = 2
        smallMessage(hostPlayer, "Current mode: Kill Orb")
    elif eventPlayer.EditModeSelection == 2:
        eventPlayer.EditModeSelection = 3
        smallMessage(hostPlayer, "Current mode: Bounce Orb")
    elif eventPlayer.EditModeSelection == 3:
        eventPlayer.EditModeSelection = 1
        smallMessage(hostPlayer, "Current mode: Checkpoint")


rule "Bounce Ball | Toggle Ultimate | Ultimate + Primary Fire":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Bounce Ball | Toggle Dash | Ultimate + Secondary Fire":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Bounce Ball | Increase Strength | Deflect + Jump":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 3    
    if len(BouncePositions) > 0:
        BounceStrength[CurrentBounce_Editing] += 0.1
        wait(0.1)
        if RULE_CONDITION:
            goto RULE_START


rule "Bounce Ball | Decrease Strength | Deflect + Crouch":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Kill Orb | Increase Size | Deflect + Jump":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Kill Orb | Decrease Size | Deflect + Crouch":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Kill Orb | Move Toward | Deflect + Primary Fire":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Kill Orb | Move Backward | Deflect + Secondary Fire":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Checkpoint | Create | Interact + Primary Fire":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        CheckpointPositions.append(eventPlayer.getPosition() - vect(0, 0, 0))
        SelectedCheckpoint_Editing = len(CheckpointPositions) - 1
        smallMessage(getAllPlayers(), "New Checkpoint has been created")
    elif eventPlayer.EditModeSelection == 2:
        if eventPlayer.CurrentCheckpoint == 0:
            bigMessage(getAllPlayers(), "Cannot place Kill Orb on first checkpoint")
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
            bigMessage(getAllPlayers(), "New Kill Orb has been created! \r\nIt's only valid for checkpoint {0}".format(eventPlayer.CurrentCheckpoint))
    elif eventPlayer.EditModeSelection == 3:
        if eventPlayer.CurrentCheckpoint == 0:
            bigMessage(getAllPlayers(), "Cannot place bounce orb on first checkpoint")
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
            bigMessage(getAllPlayers(), "New Bounce Orb has been created! \r\nIt's only valid for checkpoint {0}".format(eventPlayer.CurrentCheckpoint))


rule "Checkpoint | Delete | Interact + Secondary Fire":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Checkpoint | Move | Ultimate + Interact":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer == hostPlayer
    
    smallMessage(getAllPlayers(), "Checkpoint {0} has been deleted".format(SelectedCheckpoint_Editing) if len(CheckpointPositions[SelectedCheckpoint_Editing]) != 0 else "")
    CheckpointPositions[SelectedCheckpoint_Editing] = eventPlayer.getPosition() - vect(0, 0, 0)
    smallMessage(getAllPlayers(), "Checkpoint has been moved to your position")


rule "Checkpoint | Select Previous | Interact + Crouch":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Checkpoint | Select Next | Interact + Jump":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
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


rule "Checkpoint | Hide All | Interact + Dash":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer == hostPlayer
    
    for SelectedCheckpoint_Editing in range(len(CheckpointRings_Editing) - 1, 0, -1):
        destroyEffect(CheckpointRings_Editing[SelectedCheckpoint_Editing])
        del CheckpointRings_Editing[SelectedCheckpoint_Editing]
    SelectedCheckpoint_Editing = -2


rule "Checkpoint | Show All |":
    @Condition hostPlayer.EditorOn
    @Condition SelectedCheckpoint_Editing == -2
    
    for SelectedCheckpoint_Editing in range(len(CheckpointPositions)):
        createEffect(getAllPlayers(), Effect.RING, Color.RED, CheckpointPositions[SelectedCheckpoint_Editing], 1, EffectReeval.VISIBILITY)
        CheckpointRings_Editing.append(getLastCreatedEntity())


rule "Checkpoint | Skip | Crouch + Primary/Secondary Fire":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn or eventPlayer.PracticeToggle == 1
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1) or (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.CurrentCheckpoint != 0)

    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint - 1])
        eventPlayer.CurrentCheckpoint -= 1
        if eventPlayer.PracticeToggle == 1:
            eventPlayer.PracticeCheckpoint -= 1
        ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint].append(eventPlayer)
        ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint + 1].remove(eventPlayer)
    else:
        eventPlayer.CurrentCheckpoint += 1
        if eventPlayer.PracticeToggle == 1:
            eventPlayer.PracticeCheckpoint += 1
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint])
        # eventPlayer.Timer += 9999
        ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint].append(eventPlayer)
        ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint - 1].remove(eventPlayer)


rule "Teleport | Add | Interact + Reload":
    @Condition hostPlayer.EditorOn
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == false
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition hostPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition len(CheckpointPositions) > 1
    
    @Condition hostPlayer.EditModeSelection == 1
    @Condition SelectedCheckpoint_Editing > 0
    
    
    if hostPlayer.isHoldingButton(Button.MELEE):
        return
    CheckpointPositions[SelectedCheckpoint_Editing] = [
        CheckpointPositions[SelectedCheckpoint_Editing][0] 
            if len(CheckpointPositions[SelectedCheckpoint_Editing]) != 0 else 
            CheckpointPositions[SelectedCheckpoint_Editing], hostPlayer.getPosition()
            ]

    smallMessage(getAllPlayers(), "Teleport has been added for checkpoint {0}".format(SelectedCheckpoint_Editing))







        

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