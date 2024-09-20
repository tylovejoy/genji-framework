#!mainFile "genji.opy"

##### general #####
     #!define multipurposehud true

    # 100 is non
    #!define slowmotion 100

    #!define 3thpersoncam false
    #!define camspeed 15

##### average load show #####
    #!define avrgon true
    
##### orb visialize #####
    #!define orb_visialon false

    #!define show_playerradius false
    #!define show_orbradius true

#### test bots #####
    #!define testaion false

    ##### should do 19 max #####
    #!define testbotnumber 10
    ##### wait for all bots to be created #####
    #!define waitforcreate true
    ##### delay after all bots are created - toggle #####
    #!define aistartdelay true
    ##### delay after all bots are created - seconds #####
    #!define creationdelay 8 

    ##### delay between each action #####
    #!define aiactiondelay 3 + (testAI.index(eventPlayer) * 2)
    ##!define aiactiondelay 3
    ##!define aiactiondelay (testAI.index(eventPlayer) * 2)

    ##### AI #####
        #!define leaderboardai true 
        #!define actionai false

globalvar AvrgSecStore
globalvar AvrgSecDisplay
globalvar LastTimePeak
globalvar AvrgMinStore
globalvar AvrgMinDisplay
globalvar AvrgMinStoreTemp
globalvar AvrgMinStoreLen
globalvar testAI
globalvar AIcreated

# temps ######################################################################################################################################################

# general ######################################################################################################################################################

rule "slowmo":
    setSlowMotion(slowmotion)

rule "3th person cam":
    @Condition 3thpersoncam
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    eventPlayer.startCamera( eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * -2.5) + vect(0,0.5,0), eventPlayer.getEyePosition(), camspeed)

rule "multi purpose hud":
    @Condition multipurposehud
    hudSubheader(getAllPlayers(), 
        "hud count {}\n"
        "fx count: {}\n"
        "{}\n"
        "{}\n"
        "bounce {}, last {}"
        "".format(
        getNumberOfTextIds(),
        getNumberOfEntityIds(),
        localPlayer.NotOnLastCp,
        EditorMoveItem,
        localPlayer.bouncetouched,
        localPlayer.bouncetouchedlast
        )        
        , HudPosition.LEFT, HO.leftend + 10, Color.LIME_GREEN, HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

# Load Calc ######################################################################################################################################################

rule "server load hud":
    @Condition avrgon
    #wait(11)
    hudSubheader(
        getAllPlayers(), 
        "Load: {0} / Avrg: {1} \n"
        "Mavrg: {3} / Last: {4} \n"
        "Minu: {5} / Peak: {2} \n".format(
            getServerLoad(), 
            getAverageServerLoad(),
            getPeakServerLoad(),
            AvrgSecDisplay,
            LastTimePeak,
            AvrgMinDisplay
        ), 
    
        HudPosition.LEFT, HO.leftend, 
        Color.RED if getAverageServerLoad() > 220 else 
        Color.ORANGE if getAverageServerLoad() > 190 else 
        Color.YELLOW if getAverageServerLoad() > 160  else 
        Color.BLUE if getAverageServerLoad() > 130 else
        Color.LIME_GREEN, 
        HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

#!define avrg 125
rule "Avrg Seconds":
    @Condition avrgon
    while len(AvrgSecStore) < avrg:  
        AvrgSecStore.append(getAverageServerLoad())
        wait()

    AvrgSecDisplay = 0
    LastTimePeak = 0
    while len(AvrgSecStore):
        LastTimePeak = max(LastTimePeak,AvrgSecStore[0] )
        AvrgSecDisplay += AvrgSecStore[0]
        del AvrgSecStore[0]

    AvrgSecDisplay = AvrgSecDisplay / avrg
    AvrgMinStore.append(AvrgSecDisplay)
    goto RULE_START

#!define mintime 10
rule "Avrg Seconds":   
    @Condition avrgon
    #@Condition len(AvrgMinStore) == mintime/avrg
    AvrgMinDisplay = 0
    AvrgMinStoreTemp = AvrgMinStore
    AvrgMinStore = []
    AvrgMinStoreLen = len(AvrgMinStoreTemp)
    while len(AvrgMinStoreTemp) > 0:
        AvrgMinDisplay += AvrgMinStoreTemp[0]
        del AvrgMinStoreTemp[0]

    AvrgMinDisplay = AvrgMinDisplay / (AvrgMinStoreLen)
    wait(mintime)
    goto RULE_START

# orb radius ######################################################################################################################################################

rule "orbradiustest": # show radius on all bounce orbs
    @Condition orb_visialon
    @Condition show_orbradius
    wait(8)   
    for TempIterator1 in range(0,len(BouncePadCheckpoints)):
        
        createEffect(
            [i for i in getAllPlayers() if i.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)]], 
            Effect.SPHERE, 
            Color.WHITE, 
            BouncePositions[evalOnce(TempIterator1)], #bounceoffset,
            bounceorbdistance,
            EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
        
        createEffect(
            [i for i in getAllPlayers() if i.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)]], 
            Effect.SPHERE, 
            Color.RED, 
            BouncePositions[evalOnce(TempIterator1)], #bounceoffset,
            0.1,
            EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )

rule "orbradiustest": # show player orb hit detection
    @Condition orb_visialon
    @Event eachPlayer
    if show_orbradius:
        createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, updateEveryTick( eventPlayer.getPosition() bounceoffset), 0.1, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR) 
        createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, updateEveryTick( eventPlayer.getPosition() bounceoffset), 0.03, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR) 

    if show_playerradius:
        # own orb radius
        createEffect(getAllPlayers(), Effect.SPHERE, Color.YELLOW, updateEveryTick( eventPlayer.getPosition() bounceoffset), bounceorbdistance, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR) 


# AI - leaderboard ######################################################################################################################################################

rule "leaderboard test bots":
    @Condition testaion
    wait(creationdelay) # wait for other entities to be created
    while len(testAI) < testbotnumber:
        createDummy(Hero.GENJI, Team.1, -1, null, null)
        testAI.append(getLastCreatedEntity())
        wait(0.1)
        testAI[len(testAI)-1].startForcingName("bot {0}".format(len(testAI)-1))

    AIcreated = true

rule "leaderboard test ai":
    @Event eachPlayer
    @Condition testaion
    @Condition leaderboardai
    @Condition eventPlayer in testAI

    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) #- 1
    @Condition (waitforcreate and AIcreated) or not waitforcreate
    
    if aistartdelay:
        wait(aiactiondelay )

    if CompMode:
        wait(0.16)
        eventPlayer.forceButtonPress(Button.INTERACT)
        wait(0.16)
        
    else:
        wait(1)

    eventPlayer.CurrentCheckpoint = len(CheckpointPositions) - 2
    checkpointFailReset()
    wait(1)
    eventPlayer.LockCollected = eventPlayer.BouncePosition_Cache
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint+1]+ vect(0,3,0)) # teleport not needed


rule "action test ai":
    @Event eachPlayer
    @Condition testaion
    @Condition actionai
    @Condition eventPlayer in testAI
    @Condition (waitforcreate and AIcreated) or not waitforcreate

    if aistartdelay:
        wait(aiactiondelay )

    wait(1)
    wait( ((testAI.index(eventPlayer)) * 0.1 ) )
    # 1 for map 4 - 42 for rialto
    eventPlayer.CurrentCheckpoint = 1
    wait()
    UpdateCache()
    
    wait()
    checkpointFailReset()
    
    wait()
    eventPlayer.teleport(CheckpointPositions[2] + vect(0,10,0) )

    #wait(eventPlayer.getSlot()*0.5)
    #wait(0.2 + ((testAI.index(eventPlayer))*0.075) ) # one bot
    #waitUntil(eventPlayer.getAltitude() <  ((testAI.index(eventPlayer))*0.01), 4) # to early
    waitUntil(eventPlayer.isInAir(), 10)
    wait(0.1)
    #eventPlayer.CurrentCheckpoint = 42

    waitUntil(eventPlayer.isOnGround(), 40)
    #wait( ((testAI.index(eventPlayer))*0.01)  ) # result in 1
    wait( ((testAI.index(eventPlayer))*0.04)  ) 

    eventPlayer.startForcingButton(Button.CROUCH)
    eventPlayer.startForcingButton(Button.INTERACT)
    wait()
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait()
    eventPlayer.stopForcingButton(Button.CROUCH)
    eventPlayer.stopForcingButton(Button.INTERACT)

/*

## hud performance tests #################
 
globalvar hudtestafafafg
playervar sflkj

rule "hud test":
    wait(10)
    destroyAllHudTexts()

    hudSubheader(getAllPlayers(), 
        "hud count {}\n"
        "fx count: {}\n"
        "angles: {} : {}\n"
        "alt: {}\n"
        "".format(
        getNumberOfTextIds(),
        getNumberOfEntityIds(),
        localPlayer.getHorizontalFacingAngle(),
        localPlayer.getVerticalFacingAngle(),
        localPlayer.getAltitude()

        ),
        HudPosition.LEFT, HO.leftend + 10, Color.LIME_GREEN, HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    while getNumberOfTextIds() < 95:
        hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
            "{0}".format(    
            [   
            "{0} + {1} | Create New Checkpoint\n"
            "{0} + {2} | Delete selected Checkpoint\n"
            "{0} + {3} | Remove/Add teleport\n"
            "{0} + {4} | Set Checkpoint to current position\n"
            "{0} + {5} | Toggle Checkpoint Hitbox\n"
            "{4} (hold) | Precise position changing".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_1)),

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
            ][hostPlayer.EditModeSelection])
            
            checkCN
            
            #if localPlayer.sflkj else
            "{0}".format(    
            [   
            "{0} + {1} | Careate New Checkpoint\n"
            "{0} + {2} | asdDelete selected Checkpoint\n"
            "{0} + {3} | Rasmove/Add teleport\n"
            "{0} + {4} | Set fCheckpoint to current position\n"
            "{0} + {5} | Toggfle Checkpoint Hitbox\n"
            "{4} (hold) | Precfafise position changing".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_1)),

            "{0} + {1} | Creasfate new kill orb\n"
            "{0} + {2} | Deafslete selected orb\n"
            "{0} + {3} | Selafsect previous orb\n"
            "{0} + {4} | Seleafsct next orb\n\n"
            "{5} + {4} | Incrasfease orb size\n"
            "{5} + {3} | Decrasfease orb size\n"
            "{5} + {1} | Move afsorb forward\n"
            "{5} + {2} | Moveafs orb Backward".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2)),
    
            "{0} + {1} | Creaafste new Bounce orb\n"
            "{0} + {3} | Seleafsct previous orb\n"
            "{0} + {4} | Seleasfct next orb\n"
            "\n"
            "{0} + {2} | Delasdete selected orb\n"
            "{5} + {4} | Incasfrease orb strength\n"
            "{5} + {3} | Decasfrease orb strength\n"
            "{5} + {1} | Movasfe orb forward\n"
            "{5} + {2} | Moveafaf orb back".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2))
            ][hostPlayer.EditModeSelection])
            
            , 
            HudPosition.RIGHT, HO.edit_instructions_edit, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
        )
        wait()

    hudtestafafafg = true

rule "each":
    @Event eachPlayer
    @Condition hudtestafafafg

    eventPlayer.sflkj = 0

    while eventPlayer.sflkj <= 3:
           hudSubtext(eventPlayer if eventPlayer.GuideToggle else null, 
            "{0}".format(    
            [   
            "{0} + {1} | Create New Checkpoint\n"
            "{0} + {2} | Delete selected Checkpoint\n"
            "{0} + {3} | Remove/Add teleport\n"
            "{0} + {4} | Set Checkpoint to current position\n"
            "{0} + {5} | Toggle Checkpoint Hitbox\n"
            "{4} (hold) | Precise position changing".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_1)),

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
            ][hostPlayer.EditModeSelection])
            
            checkCN
            
            #if localPlayer.sflkj else
            "{0}".format(    
            [   
            "{0} + {1} | Careate New Checkpoint\n"
            "{0} + {2} | asdDelete selected Checkpoint\n"
            "{0} + {3} | Rasmove/Add teleport\n"
            "{0} + {4} | Set fCheckpoint to current position\n"
            "{0} + {5} | Toggfle Checkpoint Hitbox\n"
            "{4} (hold) | Precfafise position changing".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_1)),

            "{0} + {1} | Creasfate new kill orb\n"
            "{0} + {2} | Deafslete selected orb\n"
            "{0} + {3} | Selafsect previous orb\n"
            "{0} + {4} | Seleafsct next orb\n\n"
            "{5} + {4} | Incrasfease orb size\n"
            "{5} + {3} | Decrasfease orb size\n"
            "{5} + {1} | Move afsorb forward\n"
            "{5} + {2} | Moveafs orb Backward".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2)),
    
            "{0} + {1} | Creaafste new Bounce orb\n"
            "{0} + {3} | Seleafsct previous orb\n"
            "{0} + {4} | Seleasfct next orb\n"
            "\n"
            "{0} + {2} | Delasdete selected orb\n"
            "{5} + {4} | Incasfrease orb strength\n"
            "{5} + {3} | Decasfrease orb strength\n"
            "{5} + {1} | Movasfe orb forward\n"
            "{5} + {2} | Moveafaf orb back".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2))
            ][hostPlayer.EditModeSelection])
            
            , 
            HudPosition.TOP, HO.edit_instructions_edit, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
        )
        wait()
        eventPlayer.sflkj ++
        */