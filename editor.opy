#!mainFile "genji.opy"

rule "------------------------------------------------------------------------  Editor ------------------------------------------------------------------------":
    @Delimiter
    @Disabled
    
# rule "Inspector | Update Every 10 seconds":
#     @Condition hostPlayer.EditorOn
#     disableInspector()
#     wait(10)
#     enableInspector()
#     goto RULE_START  

rule "HUD | Clear Excess Data & Save Map":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer == hostPlayer
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    SelectedCheckpoint_Editing = 0
    CheckpointRings_Editing = 0
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

    SaveName = []
    SaveCp = []
    SaveTimer = []
    SaveEnt = []
    SaveSplit = []
    SavePauseTime = []
    SavePauseEnabled = []
    SaveElapsed = []
    #SaveSplitToggle = [] 
    #SaveQuick = []

    LeaderBoardFull = []
    PortalOn = false

    enableInspector()

    hudText(eventPlayer,  
        " ",
        null,
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "   0. clear excess data:\n"
        " Automatically done when opening this window\n\n"

        "   1. Copy data:\n" 
        " Open Workshop Inspector → Set variable target as global\n"
        " click the [x]\n\n"

        "   2. Insert data:\n"
        " Paste the data in the rule named 'map data pasta' (first rule)\n\n" 

        "   3. Workshop settings:\n"
        " ESC→SHOW LOBBY→SETTINGS→ workshop settings →\n"
        " toggle 'Editor mode' off\n"
        " Select display difficulty\n", 
       HudPosition.TOP, HO.edit_clearec1, Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
    )
    
    eventPlayer.savemaphud[0] = getLastCreatedText()

    hudText(eventPlayer,  
        " ",
        null,
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "   4. Create initial sharecode:\n" 
        " ESC→SHOW LOBBY→SETTINGS→SHARE CODE→\n"
        " CREATE NEW CODE→COPY CODE\n\n"

        "   5. Add credits:\n" 
        " Enter your name & map code in the 'Credits here' rule\n"
        " (second rule) \n\n"

        
        "   6. Update for credits:\n"
        " ESC→SHOW LOBBY→SETTINGS→SHARE CODE→\n"
        " UPLOAD TO EXISTING CODE→ PASTE THE CODE YOU CREATED IN STEP 4\n",
        HudPosition.TOP, HO.edit_clearec2, Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
    )
    eventPlayer.savemaphud[1] = getLastCreatedText()

    hudHeader(eventPlayer, 
        "    > Press Interact to close this window <    "
        , HudPosition.TOP, HO.edit_clearec3, Color.LIME_GREEN, HudReeval.NONE
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
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection >= 1
    
    wait(0.8, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.RELOAD):
        return
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "   Guide is open" if eventPlayer.GuideToggle else "   Guide is hidden") 
    eventPlayer.GuideToggle = not eventPlayer.GuideToggle 


rule "HUD | Show Guide On Spawn": # maybe also for when u pass host?
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.hasSpawned()
    
    eventPlayer.EditModeSelection = 1
    eventPlayer.GuideToggle = true

rule "Editor | initialize":
    #@Condition hostPlayer.EditorOn
    # condition messes up if host player leaves
    waitUntil(hostPlayer.hasSpawned(), 90)
    wait(5)
    if not hostPlayer.EditorOn:
        HudStoreEdit = null
        return

    while len(HudStoreEdit) > 0: # remove unnesesary huds
        destroyHudText(HudStoreEdit[0])
        destroyInWorldText(HudStoreEdit[0])
        del HudStoreEdit[0]

    wait()
    # huds ========================================
    hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
        "{0}".format(    
        [   
        "{0} + {1} | Create New Checkpoint\n"
        "{0} + {2} | Delete selected Checkpoint\n"
        "{0} + {3} | Add teleport to Checkpoint\n"
        "{0} + {4} | Set Checkpoint to current position\n"
        "{0} + {5} | Toggle Checkpoint Hitbox".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_1)),

        "{0} + {1} | Create new kill orb\n"
        "{0} + {2} | Delete selected orb\n"
        "{0} + {3} | Select previous orb\n"
        "{0} + {4} | Select next orb\n\n"
        "{5} + {4} | Increase orb size\n"
        "{5} + {3} | Decrease orb size\n"
        "{5} + {1} | Move orb forward\n"
        "{5} + {2} | Move orb Backward".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2)),
 
        "{0} + {1} | Create new Bounce orb\n"
        "{0} + {3} | Select previous orb\n"
        "{0} + {4} | Select next orb\n"
        "\n"
        "{0} + {2} | Delete selected orb\n"
        "{5} + {4} | Increase orb strength\n"
        "{5} + {3} | Decrease orb strength\n"
        "{5} + {1} | Move orb forward\n"
        "{5} + {2} | Move orb back".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2))
        ][hostPlayer.EditModeSelection-1]), 
        HudPosition.RIGHT, HO.edit_instructions_edit, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer, 
        " \n{0} + {1} | Next checkpoint\n"
        "{0} + {2} | Prev checkpoint\n"
        "{4} | Fly (checkpoint mode only)\n"
        "Hold {3} | toggle guide\n".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.MELEE), buttonString(Button.ABILITY_2))
        if hostPlayer.GuideToggle else
        "Hold {0} | toggle guide".format(buttonString(Button.MELEE)),
        HudPosition.RIGHT, HO.edit_instructions_general, Color.GREEN if hostPlayer.GuideToggle else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    
    hudSubheader(hostPlayer if hostPlayer.GuideToggle else null, 
        "to save map hold {0} + {1} + {2} and follow instructions".format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD)),
        HudPosition.LEFT, HO.edit_savemap, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    
    hudText(getAllPlayers(),  #  LEFT at -6 original position
        " {1} {0} ".format(
            ["Checkpoints mode" ,"Kill Orb mode","Bounce Orb mode"][hostPlayer.EditModeSelection -1],
            [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON)][hostPlayer.EditModeSelection -1]
        ) if localPlayer == hostPlayer else " Current editor/host: {0} ".format(hostPlayer)
        , null, null,   
        HudPosition.TOP, HO.edit_host_mode, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    hudText(hostPlayer if hostPlayer.GuideToggle else null, 
        null,  # original part of the one ontop of it
        "Hold {0} to change mode".format(buttonString(Button.ABILITY_1)),   
        null,   
        HudPosition.TOP, HO.edit_changemode, Color.SKY_BLUE, Color.SKY_BLUE, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer if hostPlayer.EditModeSelection == 3 and hostPlayer.GuideToggle else null, 
        "{0} + {1} | orb give ult {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.PRIMARY_FIRE), 
            "on" if BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "off",
            abilityIconString(Hero.GENJI, Button.ULTIMATE)
        ), HudPosition.LEFT, HO.edit_orb_ult, Color.GREEN  if BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    hudSubtext(hostPlayer if hostPlayer.EditModeSelection == 3 and hostPlayer.GuideToggle else null, 
        "{0} + {1} | orb give dash {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.SECONDARY_FIRE),
            "on" if BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "off",
            abilityIconString(Hero.GENJI, Button.ABILITY_1)
        ), HudPosition.LEFT, HO.edit_orb_dash, Color.GREEN  if BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    
    hudSubtext(hostPlayer if hostPlayer.EditModeSelection == 3 and hostPlayer.GuideToggle else null,
        "{0} + {1} | unlocks checkpoint {3} | {2}\n".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.ABILITY_2),
            "on" if BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "off",
            iconString(Icon.ASTERISK)
        ), HudPosition.LEFT, HO.edit_orb_lock, Color.GREEN if BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    # 10659
    # curent selected thing data
    hudText(hostPlayer if hostPlayer.GuideToggle else null, 
         
            "\n Selected Checkpoint \n Vector: {0}{1} \n".format(
                CheckpointPositions[SelectedCheckpoint_Editing],
                "" if len(CheckpointPositions[SelectedCheckpoint_Editing]) < 2 else
                "\n Teleport: {0}".format(CheckpointPositions[SelectedCheckpoint_Editing][1])
            )
            if hostPlayer.EditModeSelection == 1 else  
            "\n Selected Kill Orb \n Vector: {1} \n radius: {0} \n".format(
                KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]],
                KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]      
            ) 
            if hostPlayer.EditModeSelection == 2 else             
            "\n Selected Bounce Orb \n Vector: {1} \n strength: {0} \n".format(
                BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]],
                BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
            )
            if hostPlayer.EditModeSelection == 3 else   
            ""
        /*
        "\n{0}\n".format(
            " Selected Checkpoint \n Vector: {0}{1} ".format(
                CheckpointPositions[SelectedCheckpoint_Editing],
                "" if len(CheckpointPositions[SelectedCheckpoint_Editing]) < 2 else
                "\n Teleport: {0}".format(CheckpointPositions[SelectedCheckpoint_Editing][1])
            )
            if hostPlayer.EditModeSelection == 1 else  
            " Selected Kill Orb \n Vector: {1} \n radius: {0} ".format(
                KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]],
                KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]      
            ) 
            if hostPlayer.EditModeSelection == 2 else             
            " Selected Bounce Orb \n Vector: {1} \n strength: {0}".format(
                BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]],
                BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
            ) 
            if hostPlayer.EditModeSelection == 3 else   
            ""
            */
            ,              
        null, null, HudPosition.LEFT, HO.edit_selecteddata, Color.WHITE, Color.ORANGE,Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    # orb limit count
    hudText(hostPlayer if hostPlayer.GuideToggle else null, 
        " orb/portal limit: {0}/{1} ".format(
            len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart),
            fxlimit
        ),
        null,
        null,
        HudPosition.LEFT, HO.edit_orblimit, Color.BLUE, Color.SKY_BLUE,Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    
    wait()
    # effects ==================================

    # Purple bounce selectino aura
    createEffect(getAllPlayers() if SelectedCheckpoint_Editing != -1 and hostPlayer.BouncePosition_Cache else null, Effect.GOOD_AURA, Color.PURPLE, CurrentBouncePosition_Editing, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)    
    # Selected kill orb text
    createInWorldText(getAllPlayers() if SelectedCheckpoint_Editing != -1 and hostPlayer.KillPosition_Cache else null, "Selected Kill Orb", KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    # Red distance orb for kill orb
    createEffect(getAllPlayers() if SelectedCheckpoint_Editing != -1 and hostPlayer.KillPosition_Cache else null, Effect.ORB, Color.RED, KillBallChase, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    # Distance # text for kill orb (removed the L from M string)
    createInWorldText(getAllPlayers() if SelectedCheckpoint_Editing != -1 and hostPlayer.KillPosition_Cache else null, "{0} m".format(distance(hostPlayer, KillBallChase)), KillBallChase - vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    # Selected kill orb arrow icon
    createIcon(getAllPlayers() if SelectedCheckpoint_Editing != -1 and hostPlayer.KillPosition_Cache else null, KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
    # Purple sphere for teleport location
    createEffect(getAllPlayers() if len(CheckpointPositions[SelectedCheckpoint_Editing] ) > 1 else null, Effect.SPHERE, Color.PURPLE, CheckpointPositions[SelectedCheckpoint_Editing][1]-vect(0,0.1,0), 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    # Teleport arrow icon
    createIcon(getAllPlayers() if len(CheckpointPositions[SelectedCheckpoint_Editing] ) > 1 else null, CheckpointPositions[SelectedCheckpoint_Editing][1] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.PURPLE, true)
    # Teleport text
    createInWorldText(getAllPlayers() if len(CheckpointPositions[SelectedCheckpoint_Editing] ) > 1 else null, "TELEPORTER EXIT", CheckpointPositions[SelectedCheckpoint_Editing][1], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)

    wait(1)
    if CompMode:
        CompAtmpNum = 0
        CompTime = 99999
        getAllPlayers().AttemptCount = null
        getAllPlayers().CompDone = false

rule "Fly/Noclip Toggle | Hold Deflect":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.EditModeSelection == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition not eventPlayer.isHoldingButton(Button.CROUCH)
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
    eventPlayer.flytoggle = null
    eventPlayer.stopForcingPosition()
    wait(1)

rule "Change Edit Mode | Hold Dash":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    
    wait(0.84, Wait.ABORT_WHEN_FALSE)
    eventPlayer.flytoggle = null

    if eventPlayer.EditModeSelection == 1:
        eventPlayer.EditModeSelection = 2
        smallMessage(hostPlayer, "   Current mode: Kill Orb")
    elif eventPlayer.EditModeSelection == 2:
        eventPlayer.EditModeSelection = 3
        smallMessage(hostPlayer, "   Current mode: Bounce Orb")
    elif eventPlayer.EditModeSelection == 3:
        eventPlayer.EditModeSelection = 1
        smallMessage(hostPlayer, "   Current mode: Checkpoint")
    

rule "Bounce Ball | Toggle ult / dash / lock":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 3
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition len(BouncePositions) != 0
    
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = not BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
    elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = not BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] 
    else: 
        BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = not BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] 
        BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = 0 if BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] else 10
    UpdateCache()
    wait()


rule "Bounce/Kill | strength/size change ":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer 
    @Condition eventPlayer.EditModeSelection > 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH) 
    @Condition not eventPlayer.isHoldingButton(Button.INTERACT)
    
    if eventPlayer.EditModeSelection == 3 and len(BouncePositions) > 0:
        BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] += 0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1    
    elif eventPlayer.EditModeSelection == 2 and len(KillBallPositions) > 0:
        KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]] +=  0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1
    wait(0.1)
    if RULE_CONDITION:
        goto RULE_START
    UpdateCache()



rule "Kill Orb / Bounce Orb | Move Toward/Backward | Deflect + Primary Fire":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection > 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) 
    
    if eventPlayer.EditModeSelection == 2 and len(KillBallPositions) > 0:
        while eventPlayer.isHoldingButton(Button.ABILITY_2) and (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            KillBallChase += eventPlayer.getFacingDirection() * (0.0625 if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) else -0.0625)
            wait()
        KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]] = KillBallChase

    elif eventPlayer.EditModeSelection == 3 and len(BouncePositions) > 0:
        while eventPlayer.isHoldingButton(Button.ABILITY_2) and (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            CurrentBouncePosition_Editing += eventPlayer.getFacingDirection() * (0.0625 if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) else -0.0625)
            wait()  
        BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = CurrentBouncePosition_Editing

    UpdateCache()
    wait()


rule "Checkpoint / Kill Orb / Bounce Orb | Create | Interact + Primary Fire":
    @Event eachPlayer
    @Condition eventPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    
    if eventPlayer.EditModeSelection == 1:
        if SelectedCheckpoint_Editing != -1 and distance(eventPlayer, CheckpointPositions[SelectedCheckpoint_Editing]) <= 1.4:
            smallMessage(eventPlayer, "   Cannot place checkpoints too close.")
            return

        if SelectedCheckpoint_Editing == len(CheckpointPositions) - 1:
            CheckpointPositions.append(eventPlayer.getPosition() ) # - vect(0, 0, 0)
            SelectedCheckpoint_Editing = len(CheckpointPositions) - 1
            UpdateCache()
            #eventPlayer.CurrentCheckpoint ++
        else:
            insert(CheckpointPositions, SelectedCheckpoint_Editing + 1, eventPlayer.getPosition())
            SelectedCheckpoint_Editing = SelectedCheckpoint_Editing + 1            
            KillballCheckpoints = [x + (1 if x >= SelectedCheckpoint_Editing else 0) for x in KillballCheckpoints]
            BouncePadCheckpoints = [x + (1 if x >= SelectedCheckpoint_Editing else 0) for x in BouncePadCheckpoints]
            UpdateCache()
            #if len(CheckpointPositions) > 2:
            #    eventPlayer.CurrentCheckpoint = SelectedCheckpoint_Editing + 1
            RebuildKillOrbs()
            RebuildBounceOrbs()
        smallMessage(getAllPlayers(), "   New Checkpoint has been created")
        #UpdateCache()

    elif eventPlayer.EditModeSelection == 2:
        if len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart) >= fxlimit:
            bigMessage(getAllPlayers(), "Orb/portal limit reached for this map, delete old orbs first")
            wait()
            return
        KillBallPositions.append(eventPlayer.getPosition())
        KillballCheckpoints.append(eventPlayer.CurrentCheckpoint)
        UpdateCache()
        SelectedKillball_Editing = len(hostPlayer.KillIndex_Cache) - 1
        KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]] = 5
        createEffect([x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == KillballCheckpoints[evalOnce(hostPlayer.KillIndex_Cache[SelectedKillball_Editing])]], Effect.SPHERE, Color.BLUE, KillBallPositions[evalOnce(hostPlayer.KillIndex_Cache[SelectedKillball_Editing])], KillBallRadii[evalOnce(hostPlayer.KillIndex_Cache[SelectedKillball_Editing])], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        KillBallEffects.append(getLastCreatedEntity())
        UpdateCache()
        SelectedKillball_Editing = len(hostPlayer.KillIndex_Cache) - 1
        KillBallChase = KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        RebuildKillOrbs()
    
        bigMessage(getAllPlayers(), "New Kill Orb has been created! \r\nIt's only valid for checkpoint {0}".format(eventPlayer.CurrentCheckpoint))
    elif eventPlayer.EditModeSelection == 3:
        if len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart) >= fxlimit:
            bigMessage(getAllPlayers(), "Orb/portal limit reached for this map, delete old orbs first")
            wait()
            return
        BouncePositions.append(eventPlayer.getPosition())
        BouncePadCheckpoints.append(eventPlayer.CurrentCheckpoint)
        UpdateCache()
        CurrentBounce_Editing = len(hostPlayer.BounceIndex_Cache) - 1
        BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = 10
        BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = false
        BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = false
        BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = false
        createEffect(
            #[x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)]], 
            [x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(hostPlayer.BounceIndex_Cache[CurrentBounce_Editing])] and not evalOnce(BouncePositions[evalOnce(hostPlayer.BounceIndex_Cache[CurrentBounce_Editing])]) in x.LockCollected], 
            Effect.ORB, 
            Color.ORANGE if BounceToggleLock[evalOnce(hostPlayer.BounceIndex_Cache[CurrentBounce_Editing])] else Color.GREEN, 
            BouncePositions[evalOnce(hostPlayer.BounceIndex_Cache[CurrentBounce_Editing])], 
            1, 
            EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
        BounceEffects.append(getLastCreatedEntity())
        UpdateCache()
        CurrentBounce_Editing = len(hostPlayer.BounceIndex_Cache) - 1
        CurrentBouncePosition_Editing = BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        RebuildBounceOrbs()
        bigMessage(getAllPlayers(), "New Bounce Orb has been created! \r\nIt's only valid for checkpoint {0}".format(eventPlayer.CurrentCheckpoint))
    
    
    wait(0.64)

rule "Checkpoint / Kill Orb / Bounce Orb | Delete | Interact + Secondary Fire":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) 
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 1:
        # Resync Kill Orbs
        eventPlayer.Temp = []
        eventPlayer.Temp = [e for e in [(i if e2 == SelectedCheckpoint_Editing else -1) for e2, i in KillballCheckpoints] if  e >=0]

        # eventPlayer.Temp = [i for e, i in KillballCheckpoints if e == SelectedCheckpoint_Editing]
        for TempIterator1 in range(len(eventPlayer.Temp)):
            destroyEffect(KillBallEffects[eventPlayer.Temp[TempIterator1]])
            del KillBallEffects[eventPlayer.Temp[TempIterator1]]
            wait()
        # Remove specified checkpoint
        KillballCheckpoints = [x for x in KillballCheckpoints if x != SelectedCheckpoint_Editing]
        # Decrement checkpoints after removed one
        KillballCheckpoints = [x - (1 if x > SelectedCheckpoint_Editing else 0) for x in KillballCheckpoints]
        # Remove Radii at Checkpoint indexes (temp)
        KillBallRadii = [x for x, i in KillBallRadii if i not in eventPlayer.Temp]
        KillBallPositions = [x for x, i in KillBallPositions if i not in eventPlayer.Temp]
        SelectedKillball_Editing = len(hostPlayer.KillIndex_Cache) - 1
        KillBallChase = KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        eventPlayer.Temp = []
        # Resync Bounce Orbs
        eventPlayer.Temp = [e for e in [(i if e2 == SelectedCheckpoint_Editing else -1) for e2, i in BouncePadCheckpoints] if  e >= 0]
        # eventPlayer.Temp = [i for e, i in BouncePadCheckpoints if e == SelectedCheckpoint_Editing]
        for TempIterator1 in range(len(eventPlayer.Temp)):
            destroyEffect(BounceEffects[eventPlayer.Temp[TempIterator1]])
            del BounceEffects[eventPlayer.Temp[TempIterator1]]
            wait()

        # Remove specified checkpoint
        BouncePadCheckpoints = [x for x in BouncePadCheckpoints if x != SelectedCheckpoint_Editing]
        # Decrement checkpoints after removed one
        BouncePadCheckpoints = [x - (1 if x > SelectedCheckpoint_Editing else 0) for x in BouncePadCheckpoints]
        
        BouncePositions = [x for x, i in BouncePositions if i not in eventPlayer.Temp]
        BounceStrength = [x for x, i in BounceStrength if i not in eventPlayer.Temp]
        BounceToggleUlt = [x for x, i in BounceToggleUlt if i not in eventPlayer.Temp]
        BounceToggleDash = [x for x, i in BounceToggleDash if i not in eventPlayer.Temp]
        BounceToggleLock = [x for x, i in BounceToggleLock if i not in eventPlayer.Temp]
        CurrentBounce_Editing = len(hostPlayer.BounceIndex_Cache) - 1
        CurrentBouncePosition_Editing = BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]


        del CheckpointPositions[SelectedCheckpoint_Editing]
        del CheckpointRings_Editing[SelectedCheckpoint_Editing]
        if SelectedCheckpoint_Editing <= 0:
            SelectedCheckpoint_Editing = -1
            goto lbl_0
        SelectedCheckpoint_Editing -= 1
        lbl_0:
        RebuildKillOrbs()
        RebuildBounceOrbs()
        smallMessage(getAllPlayers(), "   Checkpoint has been deleted")
    elif eventPlayer.EditModeSelection == 2 and len(KillBallPositions) != 0 and hostPlayer.KillPosition_Cache:
        del KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        del KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        del KillballCheckpoints[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        destroyEffect(KillBallEffects[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]])
        del KillBallEffects[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        if SelectedKillball_Editing <= 0:
            goto lbl_1
        SelectedKillball_Editing -= 1
        lbl_1:
        UpdateCache()
        RebuildKillOrbs()
        KillBallChase = KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
    elif eventPlayer.EditModeSelection == 3 and len(BouncePositions) != 0 and hostPlayer.BouncePosition_Cache:
        del BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        destroyEffect(BounceEffects[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]])
        del BounceEffects[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BouncePadCheckpoints[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        if CurrentBounce_Editing <= 0:
            goto lbl_2
        CurrentBounce_Editing -= 1
        lbl_2:
        UpdateCache()
        RebuildBounceOrbs()
        CurrentBouncePosition_Editing = BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
    UpdateCache()

rule "Checkpoint | Move | Ultimate + Interact":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer    
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    
    smallMessage(getAllPlayers(), "   Checkpoint {0} has been deleted".format(SelectedCheckpoint_Editing) if len(CheckpointPositions[SelectedCheckpoint_Editing]) != 0 else "")
    CheckpointPositions[SelectedCheckpoint_Editing] = eventPlayer.getPosition() - vect(0, 0, 0)
    smallMessage(getAllPlayers(), "   Checkpoint has been moved to your position")


rule "Kill Orb / Bounce Orb | Selection change":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection > 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.JUMP)
    if eventPlayer.EditModeSelection == 2:
        if eventPlayer.isHoldingButton(Button.CROUCH):
            SelectedKillball_Editing = (SelectedKillball_Editing - 1) % len(eventPlayer.KillIndex_Cache)
            SelectedKillball_Editing = SelectedKillball_Editing if SelectedKillball_Editing >= 0 else len(eventPlayer.KillIndex_Cache) - 1
        else:
            SelectedKillball_Editing = (SelectedKillball_Editing + 1) % len(eventPlayer.KillIndex_Cache)
        KillBallChase = KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
    
    elif eventPlayer.EditModeSelection == 3:
        if eventPlayer.isHoldingButton(Button.CROUCH):
            CurrentBounce_Editing = (CurrentBounce_Editing - 1) % len(eventPlayer.BounceIndex_Cache)
            CurrentBounce_Editing = CurrentBounce_Editing if CurrentBounce_Editing >= 0 else len(eventPlayer.BounceIndex_Cache) - 1
        else:
            CurrentBounce_Editing = (CurrentBounce_Editing + 1) % len(eventPlayer.BounceIndex_Cache)
        
        CurrentBouncePosition_Editing = BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        
rule "Checkpoint | Toggle Checkpoint Sizes | Interact + Dash":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    
    eventPlayer.EffectSizeToggle = not eventPlayer.EffectSizeToggle
    

rule "Teleport | Add | Interact + Reload":
    @Condition hostPlayer.EditorOn
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.RELOAD)
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == false
    @Condition len(CheckpointPositions) > 1
    @Condition hostPlayer.EditModeSelection == 1
    @Condition SelectedCheckpoint_Editing > 0
    
    waitUntil(hostPlayer.isHoldingButton(Button.MELEE) or not (hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD)), 0.5)
    if hostPlayer.isHoldingButton(Button.MELEE) or hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD):
      return

    CheckpointPositions[SelectedCheckpoint_Editing] = [
        CheckpointPositions[SelectedCheckpoint_Editing][0] 
            if len(CheckpointPositions[SelectedCheckpoint_Editing]) != 0 
            else CheckpointPositions[SelectedCheckpoint_Editing], 
        hostPlayer.getPosition()
    ]

    smallMessage(getAllPlayers(), "   Teleport has been added for checkpoint {0}".format(SelectedCheckpoint_Editing))

    

