
#!define editortoggle(x) __script__("test-maps/togglescript.js")
# cheats
editortoggle(0) # 0 is editor, rest is numbers

#!define touchground false
#!define cpcheat true

#!include "settings.opy"
#!include "definitions.opy"



rule "fisho cp cheat for overpy toggle":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1) or (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.CurrentCheckpoint != 0)
    @Condition cpcheat

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
        #eventPlayer.Timer += 9999 




#!include "editor.opy"

rule "------------------------------------------------------------------------  General rules ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled


rule "Setup and Variables":
    # disableInspector()
    getAllPlayers().disableRespawn()
    disableGamemodeCompletion()
    disableScoring()
    disableMusic()
    pauseMatchTime()
    BladeEnabledCheckpoints = []
    DashEnabledCheckpoints = []
    BouncePadCheckpoints = []
    KillballCheckpoints = []
    CheckpointPositions = []
    Portal1PlayerList = []
    Portal2PlayerList = []
    KillBallPositions = []
    KillBallRadii = []
    KillBallEffects = []
    SelectedKillball_Editing = 0
    BouncePositions = []
    BounceEffects = []
    BounceStrength = []
    CurrentBounce_Editing = 0
    BounceToggleUlt = []
    BounceToggleDash = []
    LeaderBoardFull = []
    wait(1)
    SelectedCheckpoint_Editing = len(CheckpointPositions) - 1 # This probably isn't necessary.
    KILLBALL()
    wait(2)
    pinball()

    # if getCurrentGamemode() == Gamemode.SKIRMISH:
    #     hudText(getAllPlayers(), "", null, "{0} {1} {2}".format("Time left until server resets:", 270 - floor(getTotalTimeElapsed() / 60), "Minutes"), HudPosition.RIGHT, -15, Color.WHITE, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    # else:
    #     hudText(getAllPlayers(), "", null, "{0} {1} {2}".format("Time left until server resets:", 90 - floor(getTotalTimeElapsed() / 60), "Minutes"), HudPosition.RIGHT, -15, Color.WHITE, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    SavedProgress = []
    # old board
    /*
    #Top 5 best times hud text
    hudSubtext(getAllPlayers(), "Top 5 ", HudPosition.RIGHT, -8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #1th Place
    hudText(getAllPlayers() if toplistSortedTimes[1] != null else null, heroIcon(Hero.GENJI), toplistPlayers[toplistTimes.index(toplistSortedTimes[1])], "{0} sec".format(toplistSortedTimes[1]), HudPosition.RIGHT, -7, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #2nd Place
    hudText(getAllPlayers() if toplistSortedTimes[2] != null else null, heroIcon(Hero.GENJI), toplistPlayers[toplistTimes.index(toplistSortedTimes[2])], "{0} sec".format(toplistSortedTimes[2]), HudPosition.RIGHT, -6, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #3rd Place
    hudText(getAllPlayers() if toplistSortedTimes[3] != null else null, heroIcon(Hero.GENJI), toplistPlayers[toplistTimes.index(toplistSortedTimes[3])], "{0} sec".format(toplistSortedTimes[3]), HudPosition.RIGHT, -5, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #4th Place
    hudText(getAllPlayers() if toplistSortedTimes[4] != null else null, heroIcon(Hero.GENJI), toplistPlayers[toplistTimes.index(toplistSortedTimes[4])], "{0} sec".format(toplistSortedTimes[4]), HudPosition.RIGHT, -4, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #5th Place
    hudText(getAllPlayers() if toplistSortedTimes[5] != null else null, heroIcon(Hero.GENJI), toplistPlayers[toplistTimes.index(toplistSortedTimes[5])], "{0} sec".format(toplistSortedTimes[5]), HudPosition.RIGHT, -3, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #Other player best times hud text
    hudSubtext(getAllPlayers(), "Other", HudPosition.RIGHT, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    */

    # new board
    hudSubtext(getAllPlayers(), "Top 5 ", HudPosition.RIGHT, -8, Color.WHITE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(getAllPlayers() if LeaderBoardFull[0] != null else null, heroIcon(Hero.GENJI), LeaderBoardFull[0][0], "{0} sec".format(LeaderBoardFull[0][1]), HudPosition.RIGHT, -7, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getAllPlayers() if LeaderBoardFull[1] != null else null, heroIcon(Hero.GENJI), LeaderBoardFull[1][0], "{0} sec".format(LeaderBoardFull[1][1]), HudPosition.RIGHT, -6, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getAllPlayers() if LeaderBoardFull[2] != null else null, heroIcon(Hero.GENJI), LeaderBoardFull[2][0], "{0} sec".format(LeaderBoardFull[2][1]), HudPosition.RIGHT, -5, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getAllPlayers() if LeaderBoardFull[3] != null else null, heroIcon(Hero.GENJI), LeaderBoardFull[3][0], "{0} sec".format(LeaderBoardFull[3][1]), HudPosition.RIGHT, -4, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getAllPlayers() if LeaderBoardFull[4] != null else null, heroIcon(Hero.GENJI), LeaderBoardFull[4][0], "{0} sec".format(LeaderBoardFull[4][1]), HudPosition.RIGHT, -3, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudHeader([i for i in getAllPlayers() if i.LeaderboardToggle], "　　　　 {0} Leaderboard {0} 　　　".format(iconString(Icon.FLAG)), HudPosition.TOP, -9999, Color.BLUE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudHeader(
        [i for i in getAllPlayers() if i.LeaderboardToggle],
        "　　　　　　　　　　　　　　　　　　\n"
        "　 1:　{0} - {5}　\n"
        "　 2:　{1} - {6}　\n"
        "　 3:　{2} - {7}　\n"
        "　 4:　{3} - {8}　\n"
        "　 5:　{4} - {9}\n".format(
        LeaderBoardFull[0][0] if LeaderBoardFull[0] else "",
        LeaderBoardFull[1][0] if LeaderBoardFull[1] else "",
        LeaderBoardFull[2][0] if LeaderBoardFull[2] else "",
        LeaderBoardFull[3][0] if LeaderBoardFull[3] else "",
        LeaderBoardFull[4][0] if LeaderBoardFull[4] else "",
        LeaderBoardFull[0][1] if LeaderBoardFull[0] else "",
        LeaderBoardFull[1][1] if LeaderBoardFull[1] else "",
        LeaderBoardFull[2][1] if LeaderBoardFull[2] else "",
        LeaderBoardFull[3][1] if LeaderBoardFull[3] else "",
        LeaderBoardFull[4][1] if LeaderBoardFull[4] else ""
        ),HudPosition.TOP, -999, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudHeader(
       [i for i in getAllPlayers() if i.LeaderboardToggle],
        "　　　　　　　　　　　　　　　　　　\n"
        "　 6:　{0} - {5}　\n"
        "　 7:　{1} - {6}　\n"
        "　 8:　{2} - {7}　\n"
        "　 9:　{3} - {8}　\n"
        "　10:　{4} - {9}\n".format(
        LeaderBoardFull[5][0] if LeaderBoardFull[5] else "",
        LeaderBoardFull[6][0] if LeaderBoardFull[6] else "",
        LeaderBoardFull[7][0] if LeaderBoardFull[7] else "",
        LeaderBoardFull[8][0] if LeaderBoardFull[8] else "",
        LeaderBoardFull[9][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[5][1] if LeaderBoardFull[5] else "",
        LeaderBoardFull[6][1] if LeaderBoardFull[6] else "",
        LeaderBoardFull[7][1] if LeaderBoardFull[7] else "",
        LeaderBoardFull[8][1] if LeaderBoardFull[8] else "",
        LeaderBoardFull[9][1] if LeaderBoardFull[9] else ""
        ),HudPosition.TOP, -998, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    
    hudHeader( 
       [i for i in getAllPlayers() if i.LeaderboardToggle],
        "　　　　　　　　　　　　　　　　　　\n"
        "　11:　{0} - {5}　\n"
        "　12:　{1} - {6}　\n"
        "　13:　{2} - {7}　\n"
        "　14:　{3} - {8}　\n"
        "　15:　{4} - {9}\n".format(
        LeaderBoardFull[10][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[11][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[12][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[13][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[14][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[10][1] if LeaderBoardFull[9] else "",
        LeaderBoardFull[11][1] if LeaderBoardFull[9] else "",
        LeaderBoardFull[12][1] if LeaderBoardFull[9] else "",
        LeaderBoardFull[13][1] if LeaderBoardFull[9] else "",
        LeaderBoardFull[14][1] if LeaderBoardFull[9] else ""
        ),HudPosition.TOP, -997, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    
    hudHeader(
        [i for i in getAllPlayers() if i.LeaderboardToggle],
        "　　　　　　　　　　　　　　　　　　\n"
        "　16:　{0} - {5}　\n"
        "　17:　{1} - {6}　\n"
        "　18:　{2} - {7}　\n"
        "　19:　{3} - {8}　\n"
        "　20:　{4} - {9}\n".format(
        LeaderBoardFull[15][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[16][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[17][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[18][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[19][0] if LeaderBoardFull[9] else "",
        LeaderBoardFull[15][1] if LeaderBoardFull[9] else "",
        LeaderBoardFull[16][1] if LeaderBoardFull[9] else "",
        LeaderBoardFull[17][1] if LeaderBoardFull[9] else "",
        LeaderBoardFull[18][1] if LeaderBoardFull[9] else "",
        LeaderBoardFull[19][1] if LeaderBoardFull[9] else ""
        ),HudPosition.TOP, -996, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)



    hudSubtext(getAllPlayers(), "                                                   \r\n  \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", HudPosition.TOP, -6, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0}+{1} | Invincible".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)), HudPosition.RIGHT, -12, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0}+{1}+{2} | Restart".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT)), HudPosition.RIGHT, -11, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "Hold {0} | Spectate".format(buttonString(Button.INTERACT)), HudPosition.RIGHT, -11, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "Hold {0} |  Enable Quick reset".format(buttonString(Button.RELOAD)), HudPosition.RIGHT, -10, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "press {0} | Quick reset".format(buttonString(Button.RELOAD)), HudPosition.RIGHT, -9, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "Hold {0} | Toggle invis".format(buttonString(Button.ABILITY_2)), HudPosition.RIGHT, -8, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), " Spray | Toggle leaderboard", HudPosition.RIGHT, -8, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    EditorOn = createWorkshopSetting(bool, "Editor","Editor mode" ,  editoron 
        , 0) # breaks if the defined thing is on the same line

    

rule "Match time":
    # Created by Hax, edited by FishoFire
    if getCurrentGamemode() != Gamemode.SKIRMISH:
        wait(0.25)
        setMatchTime(1)
        wait(1.1)
        setMatchTime(1)
        wait(1.1)

    while TimeRemaining < 5:
        setMatchTime(3600)
        wait(2875)
        TimeRemaining += 1
   
    TimeRemaining = 1800
    hudHeader(getAllPlayers(), "  Server Restarts In {0} Min  ".format(ceil(TimeRemaining / 60)), HudPosition.RIGHT, -200, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    chase(TimeRemaining, 0, rate=1, ChaseReeval.NONE)
    wait(1795)
    bigMessage(getAllPlayers(), "maximum lobby time expired, restarting")
    wait(5)

    if getCurrentGamemode() == Gamemode.FFA:
        declarePlayerVictory(hostPlayer)
    else:
        declareTeamVictory(hostPlayer.getTeam())

rule "Initialize and CP HUD":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.hasSpawned() == true

    hudSubheader(eventPlayer,"{0}{1}".format("Invis on\n" if eventPlayer.invis else "","You are invincible" if eventPlayer.InvincibleToggle else "") , HudPosition.TOP, -12, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "{0} {1}".format("Checkpoint ", "{0} / {1}".format(eventPlayer.CurrentCheckpoint, len(CheckpointPositions) - 1)), HudPosition.TOP, -13, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "Time {0} sec".format(eventPlayer.Timer), HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    
    #StartGame_Sub is the initialization of the game
    StartGame_Sub()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.SpectateToggle = 0
    #Climbing the wall prompts the HUD
    eventPlayer.WallclimbUsed = 2
    #CheckpointEffect_Sub is the checkpoint effect display
    CheckpointEffect_Sub()

    eventPlayer.disableGamemodeHud()
    


def checkpointFailReset():
    @Name "SUB | Checkpoint Fail"
    if eventPlayer.EditModeSelection < 1:
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setUltEnabled(false)
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])
    if DeathBhopBan == true:
        eventPlayer.disallowButton(Button.JUMP)
        if eventPlayer.isHoldingButton(Button.JUMP):
            smallMessage(eventPlayer, "Deathbhop is banned!")
        wait(0.1)
        eventPlayer.allowButton(Button.JUMP)
    if eventPlayer.CurrentCheckpoint == 0:
        eventPlayer.Timer = 0
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)




def CheckpointEffect_Sub():
    @Name "SUB | Checkpoint Effects"
    
    createEffect(eventPlayer, Effect.RING, Color.SKY_BLUE, CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.PlayerEffects[0] = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.RING, Color.LIME_GREEN, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.PlayerEffects[1] = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.LIGHT_SHAFT, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.PlayerEffects[2] = getLastCreatedEntity()
    createIcon(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.SKY_BLUE, true)
    eventPlayer.PlayerEffects[3] = getLastCreatedEntity()
    createInWorldText(eventPlayer, "Come here", CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.PlayerEffects[4] = getLastCreatedText()


def StartGame_Sub():
    @Name "SUB | Start Game"
    
    if len(CheckpointPositions) != 0:
        if "{0}".format(eventPlayer) in SavedProgress:
            #if "{0}".format(eventPlayer) in save == true:
            eventPlayer.CurrentCheckpoint = SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
            eventPlayer.Timer = SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 2]
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 3] = eventPlayer
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 5] = 0
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 0
            eventPlayer.teleport(CheckpointPositions[SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]] + vect(0, 1, 0))
        else:
            eventPlayer.teleport(CheckpointPositions[0] + vect(0, 1, 0))
            eventPlayer.CurrentCheckpoint = 0
            eventPlayer.Timer = 0
            stopChasingVariable(eventPlayer.PauseTimer)
            eventPlayer.PauseTimer = 0
            SavedProgress.append(["{0}".format(eventPlayer), eventPlayer.CurrentCheckpoint, eventPlayer.Timer, eventPlayer, getTotalTimeElapsed(), 0, 0])
    chase(eventPlayer.Timer, 9999999, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.PortalText = []
    if eventPlayer.EditModeSelection < 1:
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setUltEnabled(false)
    else:
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint].append(eventPlayer)
    eventPlayer.InvincibleToggle = 0

def Leaderboardupdate():
    @Name "SUB | Leaderboard Update"
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    SavedProgress.remove("{0}".format(eventPlayer))
    # [i[0] for i in var1]   list of first element of each in var 1

    if "{0}".format(eventPlayer) in [i[0] for i in LeaderBoardFull]: # you already have a time
        if eventPlayer.Timer > [i for i in LeaderBoardFull if i[0] == "{0}".format(eventPlayer)][0][1]: # new time worse
            #printLog("{0} - {1} - worse time then old".format(eventPlayer,eventPlayer.Timer))
            goto lb0
        else: # new time better
            #printLog("{0} - {1} - replace own old time".format(eventPlayer,eventPlayer.Timer))
            LeaderBoardFull.remove( [i for i in LeaderBoardFull if i[0] == "{0}".format(eventPlayer)])
            LeaderBoardFull.append( [["{0}".format(eventPlayer),eventPlayer.Timer]] )

    else: # you are not in list yet
        if len(LeaderBoardFull) < 20: # board has room for more
            printLog("{0} - {1} - room on board".format(eventPlayer,eventPlayer.Timer))
            LeaderBoardFull.append( [["{0}".format(eventPlayer),eventPlayer.Timer] ])

        else: # 20 entries already
            if LeaderBoardFull[19][1] < eventPlayer.Timer:  # your time lower then last entry
                printLog("{0} - {1} - existing times are better".format(eventPlayer,eventPlayer.Timer))
                goto lb0
            else: # you beat the last entry, thus replacing it
                printLog("{0} - {1} - replace lowest time".format(eventPlayer,eventPlayer.Timer))
                del LeaderBoardFull[19]
                LeaderBoardFull.append( [["{0}".format(eventPlayer),eventPlayer.Timer]] )

    LeaderBoardFull = sorted(LeaderBoardFull, lambda i: i[1])
    lb0:


def KILLBALL():
    @Name "SUB | Kill Orb Effects"
    
    if KillBallPositions == []:
        return

    for TempIterator1 in range(0, len(KillBallPositions) - 1):
        createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[TempIterator1]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
        KillBallEffects.append(getLastCreatedEntity())


def pinball():
    @Name "SUB | Bounce Ball Effects"
    
    if BouncePositions == []:
        return

    for TempIterator1 in range(0, len(BouncePositions) - 1):
        createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[TempIterator1]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
        BounceEffects.append(getLastCreatedEntity())

rule "Checkpoint | Arrived":
    @Event eachPlayer
    @Condition distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= 1.4
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.isOnGround() == true
    @Condition (eventPlayer.EditModeSelection >= 1 or eventPlayer.InvincibleToggle == 0) == true
    
    eventPlayer.CurrentCheckpoint += 1

    # normal cp, but also runs when completed
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    SavedProgress.remove("{0}".format(eventPlayer))
    SavedProgress.append(["{0}".format(eventPlayer), eventPlayer.CurrentCheckpoint, eventPlayer.Timer, eventPlayer, getTotalTimeElapsed(), 0, 0])
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, CheckpointPositions[eventPlayer.CurrentCheckpoint] + vect(0, 1.5, 0), 4)
    bigMessage(eventPlayer, "{0} {1}".format("Arrived at", "{0} / {1}".format(eventPlayer.CurrentCheckpoint, len(CheckpointPositions) - 1)))
    ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint].append(eventPlayer)
    ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint - 1].remove(eventPlayer)
    if eventPlayer.EditModeSelection < 1:
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
    if eventPlayer.EditModeSelection >= 1:
        return
    if eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1: # complete lvl
   
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        stopChasingVariable(eventPlayer.Timer)
        bigMessage(getAllPlayers(), "{0} {1} {2}".format(eventPlayer, "Mission complete! Time", l"{0} sec".format(eventPlayer.Timer)))
        destroyEffect(eventPlayer.PlayerEffects[0])
        destroyEffect(eventPlayer.PlayerEffects[1])
        destroyEffect(eventPlayer.PlayerEffects[2])
        destroyIcon(eventPlayer.PlayerEffects[3])
        destroyInWorldText(eventPlayer.PlayerEffects[4])
        Portal1PlayerList.append(eventPlayer)
        Portal2PlayerList.append(eventPlayer)
        eventPlayer.PortalText = 2
        Leaderboardupdate()



rule "Checkpoint | Finish effects":
    @Event eachPlayer
    @Condition eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1
    @Condition eventPlayer.EditModeSelection < 1
    @Condition eventPlayer.isMoving() == true
    
    #@Condition (eventPlayer.isMoving() == true or eventPlayer.isHoldingButton(Button.JUMP) == true) == true
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer.getPosition(), 1.6)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.GREEN, eventPlayer.getPosition(), 1.4)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.getPosition(), 1.2)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer.getPosition(), 1)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.BLUE, eventPlayer.getPosition(), 0.8)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.AQUA, eventPlayer.getPosition(), 0.6)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, eventPlayer.getPosition(), 0.4)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, eventPlayer.getPosition(), 0.2)
    wait(0.35)
    if RULE_CONDITION:
        goto RULE_START




rule "Kill Orb | Activate":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.CurrentCheckpoint != 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition (KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[0])] == eventPlayer.CurrentCheckpoint or KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[1])] == eventPlayer.CurrentCheckpoint or KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[2])] == eventPlayer.CurrentCheckpoint or KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[3])] == eventPlayer.CurrentCheckpoint) == true
    
    
    # kill(eventPlayer, null)
    checkpointFailReset()


rule "Bounce Ball | Activate":
    @Event eachPlayer
    @Hero genji
    @Condition BouncePadCheckpoints[BouncePositions.index([player for player in BouncePositions if distance(eventPlayer, player) <= 1.2])] == eventPlayer.CurrentCheckpoint
    @Condition eventPlayer.CurrentCheckpoint != 0
    
    eventPlayer.applyImpulse(Vector.UP, BounceStrength[BouncePositions.index([player for player in BouncePositions if distance(eventPlayer.getPosition(), player) <= 2])], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

    if BounceToggleDash[BouncePositions.index([player for player in BouncePositions if distance(eventPlayer.getPosition(), player) <= 2])] == true:
        eventPlayer.setAbility1Enabled(true)
        smallMessage(eventPlayer, "Dash is ready")
    if BounceToggleUlt[BouncePositions.index([player for player in BouncePositions if distance(eventPlayer.getPosition(), player) <= 2])] == true:
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        smallMessage(eventPlayer, "Ultimate is ready")

/*
rule "Data for Top 5":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1
    @Condition eventPlayer.EditModeSelection < 1
    
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    SavedProgress.remove("{0}".format(eventPlayer))
    if eventPlayer.PlayerEffects[7] == null:
        eventPlayer.LeaderboardTimerCapture = eventPlayer.Timer
        hudText(null if toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))] in toplistSortedTimes else getAllPlayers(), heroIcon(Hero.GENJI), eventPlayer, "{0} sec".format(eventPlayer.LeaderboardTimerCapture), HudPosition.RIGHT, eventPlayer.LeaderboardTimerCapture, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
        eventPlayer.PlayerEffects[7] = getLastCreatedText()
    else:
        if eventPlayer.Timer > eventPlayer.LeaderboardTimerCapture:
            goto lbl_0
        eventPlayer.LeaderboardTimerCapture = eventPlayer.Timer
        lbl_0:
    #Save data for the Top 5 list
    if "{0}".format(eventPlayer) in toplistPlayers:
        if eventPlayer.Timer >= toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))]:
            goto lbl_1
        toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))] = eventPlayer.Timer
        lbl_1:
    else:
        toplistPlayers.append("{0}".format(eventPlayer))
        toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))] = eventPlayer.Timer
    #Reload the Sorted Array Times
    toplistSortedTimes = sorted(toplistTimes).slice(0, 6)
    stopChasingVariable(eventPlayer.PauseTimer)
    eventPlayer.PauseTimer = 0

*/


rule "Death Reset":
    @Event playerDied
    @Condition eventPlayer.SpectateToggle != 1
    @Condition len(CheckpointPositions) >= 2
    
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.resurrect()
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])




rule "Ground Reset":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition len(CheckpointPositions) >= 2
    @Condition eventPlayer.InvincibleToggle != 1
    @Condition eventPlayer.SpectateToggle != 1
    @Condition eventPlayer.isOnGround() == true    
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])) > 1.4
    @Condition not touchground

    checkpointFailReset()


rule "Player Effect":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatusEffect(Status.PHASED_OUT) == false
    
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)



rule "Ultimate Charge":
    @Event eachPlayer
    @Condition eventPlayer.getUltCharge() < 100
    
    eventPlayer.setUltCharge(100)


rule "Player Leaves":
    @Event playerLeft

    #if player's cur_checkpoint is 0, delete save info
    if SavedProgress[SavedProgress.index(eventPlayer) - 2] == 0:
        del SavedProgress[SavedProgress.index(eventPlayer) + 1]
        del SavedProgress[SavedProgress.index(eventPlayer) + 1]
        del SavedProgress[SavedProgress.index(eventPlayer) + 1]
        del SavedProgress[SavedProgress.index(eventPlayer) - 1]
        del SavedProgress[SavedProgress.index(eventPlayer) - 1]
        del SavedProgress[SavedProgress.index(eventPlayer) - 1]
        SavedProgress.remove(eventPlayer)
    else:
        if SavedProgress[SavedProgress.index(eventPlayer) - 2] >= len(CheckpointPositions) - 1:
            goto lbl_0
        if SavedProgress[SavedProgress.index(eventPlayer) + 3] == 1:
            goto lbl_1
        SavedProgress[SavedProgress.index(eventPlayer) - 1] = getTotalTimeElapsed() - (SavedProgress[SavedProgress.index(eventPlayer) + 1]) - (SavedProgress[SavedProgress.index(eventPlayer) + 2]) + (SavedProgress[SavedProgress.index(eventPlayer) - 1])
        lbl_0:
        lbl_1:
        SavedProgress[SavedProgress.index(eventPlayer) + 2] = 0
        SavedProgress[SavedProgress.index(eventPlayer) + 3] = 0


rule "Combo | Leaderboard Toggle | Spray":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingSpray()

    eventPlayer.LeaderboardToggle = not eventPlayer.LeaderboardToggle


rule "Combo | Restart Run | Crouch + Interact + Deflect":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    if "{0}".format(eventPlayer) in SavedProgress:
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        SavedProgress.remove("{0}".format(eventPlayer))
    ListPlayersAtCheckpoints[eventPlayer.CurrentCheckpoint].remove(eventPlayer)
    if eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1:
        CheckpointEffect_Sub()
        #This action is "eliminate the display of player clearance results"
        destroyHudText(eventPlayer.PlayerEffects[7])
    if DashExploitToggle and eventPlayer.isUsingAbility2():
        smallMessage(eventPlayer, "Dash Start is banned!")
        waitUntil(not eventPlayer.isUsingAbility2(), 0.5)
        
    eventPlayer.CurrentCheckpoint = 0
    StartGame_Sub()
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    Portal1PlayerList.remove(eventPlayer)
    Portal2PlayerList.remove(eventPlayer)


rule "Combo | Enter Spectate | Hold Interact":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.EditModeSelection < 1
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "Hold Interact again to turn off spectate mode")
    if eventPlayer.isAlive():
        if eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1:
            chase(eventPlayer.PauseTimer, 999999, rate=1, ChaseReeval.DESTINATION_AND_RATE)
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 2] = eventPlayer.Timer
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 1
        eventPlayer.setRespawnTime(9999)
        eventPlayer.SpectateToggle = 1
        stopChasingVariable(eventPlayer.Timer)
        wait(0.2)
        kill(eventPlayer, null)
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])
    else:
        if eventPlayer.EditModeSelection >= 1:
            goto lbl_0
        eventPlayer.respawn()
        eventPlayer.SpectateToggle = 0
        lbl_0:
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])
        if eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1:
            goto lbl_1
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        chase(eventPlayer.Timer, 10000, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_1:
        eventPlayer.setRespawnTime(0)
        eventPlayer.InvincibleToggle = 0
        if eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1:
            stopChasingVariable(eventPlayer.PauseTimer)
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 5] = eventPlayer.PauseTimer
            eventPlayer.PauseTimer = 0
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 0


rule "Combo | Toggle Invincible Mode | Melee + Reload":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint], true)
    eventPlayer.flytoggle = null
    if eventPlayer.InvincibleToggle == 0:
        chase(eventPlayer.PauseTimer, 999999, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 2] = eventPlayer.Timer
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 1
        stopChasingVariable(eventPlayer.Timer)
        bigMessage(eventPlayer, "Invincible mode")
        eventPlayer.flytoggle = null
        eventPlayer.stopForcingPosition()
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        eventPlayer.setAbility1Enabled(true)
        wait(0.2)
        eventPlayer.InvincibleToggle = 1
    else:
        if eventPlayer.EditModeSelection >= 1:
            goto lbl_1
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        lbl_1:
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])
        wait(0.1)
        eventPlayer.InvincibleToggle = 0
        bigMessage(eventPlayer, "Normal mode")
        chase(eventPlayer.Timer, 9999999, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        eventPlayer.stopForcingPosition()
        eventPlayer.flytoggle = null
        stopChasingVariable(eventPlayer.PauseTimer)
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 5] = eventPlayer.PauseTimer
        eventPlayer.PauseTimer = 0
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 0



rule "Combo | Quick Reset | Reload, Hold Reload to Enable":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.EditModeSelection < 1
    
    if eventPlayer.isHoldingButton(Button.MELEE):
        return
    if eventPlayer.QuickRestartToggle == true:
        eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint], true)
        eventPlayer.flytoggle = null
        if eventPlayer.EditModeSelection >= 1 or eventPlayer.InvincibleToggle == 1:
            goto lbl_0
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        lbl_0:
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])
        wait(0.1)
        eventPlayer.stopForcingPosition()
        eventPlayer.flytoggle = null
    wait(1, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.QuickRestartToggle == false:
        eventPlayer.QuickRestartToggle = true
        bigMessage(eventPlayer, "Quick reset is enabled")
        playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    elif eventPlayer.QuickRestartToggle == true:
        playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        eventPlayer.QuickRestartToggle = false
        bigMessage(eventPlayer, "Quick reset is disabled")


rule "Combo | Invisible Toggle | Hold Deflect":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.EditModeSelection < 1

    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.invis = not eventPlayer.invis
    eventPlayer.setInvisibility(Invis.NONE)
    if eventPlayer.invis:
        eventPlayer.setInvisibility(Invis.ALL)

    smallMessage(eventPlayer, "Invisible {0}".format("on" if eventPlayer.invis else "off"))    
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, null, eventPlayer, 100)


rule "Limit Ultimate":
    @Event eachPlayer
    @Hero genji
    #The function of this rule is: ULT can only be used once when running the map
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.EditModeSelection < 1
    @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.setUltEnabled(false)


rule "Limit Dash":
    @Event eachPlayer
    #The function of this rule is: DASH can only be used once when running the map
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.EditModeSelection < 1
    @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.setAbility1Enabled(false)


rule "Give Blade":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.CurrentCheckpoint in BladeEnabledCheckpoints == true
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint].last() if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) > 1 else CheckpointPositions[eventPlayer.CurrentCheckpoint])) <= 1.4
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(0.1)
    if eventPlayer.isUsingUltimate():
        return
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)
    smallMessage(eventPlayer, "Ultimate is ready")


rule "Give Dash":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    #@Condition distance(eventPlayer, A[eventPlayer.A]) <= 1.4
    @Condition eventPlayer.CurrentCheckpoint in DashEnabledCheckpoints == true
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint].last() if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) > 1 else CheckpointPositions[eventPlayer.CurrentCheckpoint])) <= 1.4
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setAbility1Enabled(true)
    smallMessage(eventPlayer, "Dash is ready")



/*
globalvar itemp
rule "leaderboard test bots":
    wait(8) # wait for other entities to be created
    for itemp in range(22):
     
        createDummy(Hero.GENJI, Team.1, -1, null, null)
        wait(0.1)
        getLastCreatedEntity().startForcingName("bot number: {0}".format(len([i for i in getAllPlayers() if i.isDummy() and i.getCurrentHero() == Hero.GENJI]) ))
        

    itemp = 9999

rule "leaderboard test ai":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isDummy()
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) #- 1
    @Condition itemp == 9999
    # jump each ######################
    ###wait(0.2 + eventPlayer.getSlot()/30)
    #waitUntil(eventPlayer.isOnGround(),1)
    #wait( eventPlayer.getSlot()/30)
    #eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]+Vector.UP)
    #if RULE_CONDITION:
    #    goto RULE_START
    
    
    # jump to last ###############################
    wait(1 + eventPlayer.getSlot()*2)
    eventPlayer.CurrentCheckpoint = len(CheckpointPositions) - 2
    checkpointFailReset()
    wait(1)
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint+1]+ Vector.UP) # teleport not needed
    
*/



#!include "mechanics.opy"

#!include "addons.opy"

rule "Ms. Destructo | Destroys Breakable Objects On All Maps":
    # Credit: nebula#11571
    @Condition isGameInProgress() == true
    
    wait(2)
    #Init dummy at arbitrary location
    createDummy(Hero.DVA, hostPlayer.getTeam(), -1, vect(0, 200, 0), vect(0, 0, 0))
    MsDestructo = getLastCreatedEntity()
    MsDestructo.startForcingName("Ms. Destructo")
    wait(1)
    MsDestructo.setInvisibility(Invis.ALL)
    MsDestructo.MapVectorArray = [[0, Map.HANAMURA, Map.HANAMURA_WINTER, Map.HORIZON_LUNAR_COLONY, Map.PARIS, Map.TEMPLE_OF_ANUBIS, Map.DORADO, Map.HAVANA, Map.JUNKERTOWN, Map.RIALTO, Map.ROUTE66, Map.WATCHPOINT_GIBRALTAR, Map.BLIZZ_WORLD, Map.BLIZZ_WORLD_WINTER, Map.EICHENWALDE, Map.EICHENWALDE_HALLOWEEN, Map.HOLLYWOOD, Map.HOLLYWOOD_HALLOWEEN, Map.KINGS_ROW, Map.KINGS_ROW_WINTER, Map.NUMBANI, Map.AYUTTHAYA, Map.BUSAN_DOWNTOWN_LNY, Map.BUSAN_SANCTUARY_LNY, Map.ILIOS_LIGHTHOUSE, Map.ILIOS_RUINS, Map.ILIOS_WELL, Map.LIJIANG_CONTROL_CENTER, Map.LIJIANG_CONTROL_CENTER_LNY, Map.LIJIANG_GARDEN, Map.LIJIANG_GARDEN_LNY, Map.LIJIANG_NIGHT_MARKET, Map.LIJIANG_NIGHT_MARKET_LNY, Map.NEPAL_SANCTUM, Map.NEPAL_SHRINE, Map.NEPAL_VILLAGE, Map.NEPAL_VILLAGE_WINTER, Map.OASIS_CITY_CENTER, Map.OASIS_GARDENS, Map.OASIS_UNIVERSITY, Map.BLACK_FOREST, Map.BLACK_FOREST_WINTER, Map.CASTILLO, Map.ECOPOINT_ANTARCTICA, Map.ECOPOINT_ANTARCTICA_WINTER, Map.CHATEAU_GUILLARD, Map.CHATEAU_GUILLARD_HALLOWEEN, Map.KANEZAKA, Map.NECROPOLIS, Map.PETRA, Map.VOLSKAYA, Map.PRACTICE_RANGE, Map.ILIOS, Map.BUSAN, Map.LIJIANG_TOWER, Map.LIJIANG_TOWER_LNY, Map.NEPAL, Map.OASIS, Map.MALEVENTO], [vect(15.759, 30.576, -27.201)], [vect(15.759, 30.576, -27.201)], [vect(31.759, 40.003, -59.476)], [vect(-54.508, 40.179, -10.866)], [vect(-26.78, 23.366, 40.284)], [vect(69.418, 42.103, -17.712)], [vect(9.382, 38.635, -81.276)], [vect(9.382, 38.635, -81.276)], [vect(9.756, 30.753, -41.395)], [vect(30.313, 28.237, -16.925)], [vect(73.985, 26.198, -109.338)], [vect(-21.03, 35.127, 88.381)], [vect(-21.03, 35.127, 88.381)], [vect(54.798, 40.964, -82.78)], [vect(54.798, 40.964, -82.78)], [vect(-0.355, 28.167, -22.396)], [vect(-0.355, 28.167, -22.396)], [vect(-56.869, 24.061, -32.132)], [vect(-56.869, 24.061, -32.132)], [vect(105.299, 22.764, 14.89)], [vect(16.965, 26.541, -7.13)], [vect(51.885, 37.172, -113.654)], [vect(-329.934, 56.136, 149.839)], [vect(322.988, 15.716, -37.732)], [vect(27.711, 87.241, -161.298)], [vect(-223.895, 34.756, 0.89)], [vect(-5.808, 324.398, 282.523)], [vect(-5.808, 324.398, 282.523)], [vect(-0.414, 156.197, 148.681)], [vect(-0.414, 156.197, 148.681)], [vect(-0.381, 53.736, -33.335)], [vect(-0.381, 53.736, -33.335)], [vect(83.1, 178.926, 0.593)], [vect(-49.803, 63.29, -0.413)], [vect(-184.659, -38.73, -0.783)], [vect(-184.659, -38.73, -0.783)], [vect(150.125, 30.619, 251.966)], [vect(134.888, 36.76, -240.736)], [vect(-195.549, 60.35, -0.098)], [vect(-9.622, 44.751, 5.635)], [vect(-9.622, 44.751, 5.635)], [vect(-100.828, 76.566, 60.021)], [vect(-6.186, 35.564, 1.378)], [vect(-6.186, 35.564, 1.378)], [vect(200.414, 82.412, 78.813)], [vect(200.414, 82.412, 78.813)], [vect(-36.319, 32.305, 0.472)], [vect(-1.144, 47.168, -2.946)], [vect(9.678, 28.313, 13.4)], [vect(-49.147, 22.344, 76.844)], [vect(54.948, 50.769, 3.93)], [vect(322.988, 40, -37.732), vect(27.711, 100, -161.298), vect(-223.895, 50, 0.89)], [vect(51.885, 37.172, -113.654), vect(-329.934, 56.136, 149.839), vect(227.21, 43.353, 252.64)], [vect(-5.808, 324.398, 282.523), vect(-0.414, 156.197, 148.681), vect(-0.381, 53.736, -33.335)], [vect(-5.808, 324.398, 282.523), vect(-0.414, 156.197, 148.681), vect(-0.381, 53.736, -33.335)], [vect(83.1, 178.926, 0.593), vect(-49.803, 63.29, -0.413), vect(-184.659, -38.73, -0.783)], [vect(150.125, 30.619, 251.966), vect(134.888, 36.76, -240.736), vect(-195.549, 60.35, -0.098)], [vect(17.808, 35.955, 17.505)]]
    for MsDestructo.ArrayIterator in range(len(MsDestructo.MapVectorArray[MsDestructo.MapVectorArray[0].index(getCurrentMap())])):
        MsDestructo.startForcingPosition(MsDestructo.MapVectorArray[MsDestructo.MapVectorArray.index(getCurrentMap())][MsDestructo.ArrayIterator], true)
        MsDestructo.startScalingSize(20, true)
        MsDestructo.disableEnvironmentCollision(true)
        MsDestructo.setUltEnabled(true)
        MsDestructo.setUltCharge(100)
        wait(3)
        MsDestructo.startForcingButton(Button.ULTIMATE)
        wait(5)
        MsDestructo.respawn()
        wait(3)
    destroyDummy(MsDestructo.getTeam(), MsDestructo.getSlot())

rule "------------------------------------------------------------------------ Map pasta ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled


rule "Friend Title <----  DISPLAY MESSAGE HERE (ON PLAYER)":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    #In the field custom string your nickname
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(getAllPlayers(), "Message to the whole room")
        createInWorldText(getAllPlayers(), "Title <---------------The inscription that will be displayed on you", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    #Fill in the blank with your friend's name
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(getAllPlayers(), "Message to the whole room")
        createInWorldText(getAllPlayers(), "Title <---------------The inscription that will be displayed on you", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)


rule "Credits here <---- INSERT YOUR NAME HERE": #"Text <---- put code and author here!":
    hudSubtext(getAllPlayers(), "For more maps and records join:", HudPosition.LEFT, -14, Color.PURPLE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "dsc.gg/genjiparkour", HudPosition.LEFT, -13, Color.PURPLE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), "", null, "{0}\r\n{1}".format("MADE BY: Write your nickname here", "CODE: write maps code here"), HudPosition.LEFT, -15, Color.WHITE, Color.SKY_BLUE, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    @Delimiter

editorordata