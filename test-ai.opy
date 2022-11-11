#!mainFile "genji.opy"

# should do 19 max
#!define testbotnumber 19

# create = wait for all to finish, startdelay = delay after al of em are created
#!define waitforcreate true
#!define aistartdelay true
#!define creationdelay 8 

#!define leaderboardai true

#!define aiactiondelay 3 + (testAI.index(eventPlayer) * 2)
##!define aiactiondelay 3
##!define aiactiondelay (testAI.index(eventPlayer) * 2)

globalvar AvrgSecStore
globalvar AvrgSecDisplay
globalvar LastTimePeak
globalvar AvrgMinStore
globalvar AvrgMinDisplay
globalvar AvrgMinStoreTemp
globalvar AvrgMinStoreLen

globalvar testAI
globalvar AIcreated

rule "server load hud":
    hudSubheader(
        getAllPlayers(), 
        "Load: {0} / Avrg: {1} \n"
        "Mavrg: {3} / Last: {4} \n"
        "Minu: {5} / Peak: {2}".format(
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
    
    while len(AvrgSecStore) < avrg:  
        AvrgSecStore.append(getAverageServerLoad())
        wait()

    AvrgSecDisplay = 0
    LastTimePeak = 0
    while len(AvrgSecStore) > 0:
        LastTimePeak = max(LastTimePeak,AvrgSecStore[0] )
        AvrgSecDisplay += AvrgSecStore[0]
        del AvrgSecStore[0]

    AvrgSecDisplay = AvrgSecDisplay / avrg
    AvrgMinStore.append(AvrgSecDisplay)
    goto RULE_START

#!define mintime 10
rule "Avrg Seconds":   
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


rule "leaderboard test bots":
 
    wait(creationdelay) # wait for other entities to be created
    while len(testAI) < testbotnumber:
        createDummy(Hero.GENJI, Team.1, -1, null, null)
        testAI.append(getLastCreatedEntity())
        wait(0.1)
        testAI[len(testAI)-1].startForcingName("bot {0}".format(len(testAI)-1))
        
    AIcreated = true

rule "leaderboard test ai":
    @Event eachPlayer
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
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint+1]+ Vector.UP) # teleport not needed