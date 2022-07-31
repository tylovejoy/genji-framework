
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
    if getCurrentGamemode() == Gamemode.SKIRMISH:
        hudText(getAllPlayers(), "", null, "{0} {1} {2}".format("Time left until server resets:", 270 - floor(getTotalTimeElapsed() / 60), "Minutes"), HudPosition.RIGHT, -15, Color.WHITE, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    else:
        hudText(getAllPlayers(), "", null, "{0} {1} {2}".format("Time left until server resets:", 90 - floor(getTotalTimeElapsed() / 60), "Minutes"), HudPosition.RIGHT, -15, Color.WHITE, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
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
    TimeLimitSettingToggle = createWorkshopSetting(bool, "Extended function", "Level time limit", false, 0)
   
    


def checkpointFailReset():
    if eventPlayer.EditModeSelection < 1:
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setUltEnabled(false)
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)
    if TimeLimitSettingToggle == true:
        eventPlayer.TimeLimitTimer = 0
        stopChasingVariable(eventPlayer.TimeLimitTimer)
        eventPlayer.CurrentCheckpoint = eventPlayer.CurrentCheckpoint if eventPlayer.EditModeSelection > 0 else 0
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])
    if DeathBhopBan == true:

        eventPlayer.disallowButton(Button.JUMP)
        wait(0.1)
        eventPlayer.allowButton(Button.JUMP)
    if eventPlayer.CurrentCheckpoint == 0:
        eventPlayer.Timer = 0
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)




def CheckpointEffect_Sub():
    @Name "Checkpoint | Effect"
    
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
    @Name "Checkpoint | Start the game"
    
    if len(CheckpointPositions) != 0:
        if "{0}".format(eventPlayer) in SavedProgress and TimeLimitSettingToggle == false:
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


def KILLBALL():
    @Name "Checkpoint | Killing Sphere effect"
    
    if KillBallPositions == []:
        return
    TempIterator1 = 0
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[0]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 1
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[1]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 2
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[2]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 3
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[3]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 4
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[4]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 5
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[5]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 6
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[6]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 7
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[7]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 8
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[8]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 9
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[9]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 10
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[10]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 11
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[11]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 12
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[12]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 13
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[13]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 14
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[14]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 15
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[15]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 16
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[16]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 17
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[17]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 18
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[18]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 19
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[19]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 20
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[20]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 21
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[21]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 22
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[22]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 23
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[23]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 24
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[24]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 25
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[25]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 26
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[26]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 27
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[27]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 28
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[28]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 29
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[29]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 30
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[30]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 31
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[31]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 32
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[32]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 33
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[33]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 34
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[34]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 35
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[35]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 36
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[36]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 37
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[37]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 38
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[38]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 39
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[39]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 40
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[40]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 41
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[41]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 42
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[42]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 43
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[43]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 44
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[44]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 45
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[45]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 46
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[46]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 47
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[47]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 48
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[48]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 49
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[49]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return
    TempIterator1 = 50
    createEffect(sorted(ListPlayersAtCheckpoints[KillballCheckpoints[50]]), Effect.SPHERE, Color.BLUE, KillBallPositions[TempIterator1], KillBallRadii[TempIterator1], EffectReeval.VISIBILITY)
    KillBallEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(KillBallPositions) - 1:
        return


def pinball():
    @Name "Checkpoint | Bouncing Ball effect"
    
    if BouncePositions == []:
        return
    TempIterator1 = 0
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[0]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 1
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[1]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 2
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[2]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 3
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[3]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 4
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[4]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 5
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[5]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 6
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[6]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 7
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[7]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 8
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[8]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 9
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[9]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 10
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[10]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 11
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[11]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 12
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[12]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 13
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[13]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 14
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[14]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 15
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[15]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 16
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[16]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 17
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[17]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 18
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[18]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 19
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[19]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 20
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[20]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 21
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[21]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 22
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[22]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 23
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[23]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 24
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[24]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 25
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[25]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 26
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[26]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 27
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[27]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 28
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[28]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 29
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[29]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 30
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[30]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 31
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[31]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 32
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[32]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 33
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[33]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 34
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[34]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 35
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[35]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 36
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[36]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 37
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[37]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 38
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[38]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 39
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[39]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 40
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[40]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 41
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[41]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 42
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[42]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 43
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[43]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 44
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[44]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 45
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[45]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 46
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[46]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 47
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[47]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 48
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[48]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 49
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[49]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 50
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[50]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 51
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[51]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 52
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[52]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 53
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[53]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 54
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[54]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 55
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[55]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 56
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[56]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 57
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[57]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 58
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[58]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 59
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[59]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 60
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[60]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 61
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[61]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 62
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[62]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 63
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[63]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 64
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[64]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 65
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[65]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 66
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[66]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 67
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[67]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 68
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[68]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 69
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[69]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 70
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[70]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 71
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[71]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 72
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[72]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 73
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[73]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 74
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[74]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return
    TempIterator1 = 75
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[75]]), Effect.ORB, Color.GREEN, BouncePositions[TempIterator1], 1, EffectReeval.VISIBILITY)
    BounceEffects.append(getLastCreatedEntity())
    if TempIterator1 == len(BouncePositions) - 1:
        return



rule "Initialize and CP HUD":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.hasSpawned() == true

    hudSubheader(eventPlayer,"{0}{1}".format("Invis on\n" if eventPlayer.invis else "","You are invincible" if eventPlayer.InvincibleToggle else "") , HudPosition.TOP, -12, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "{0} {1}".format("level ", "{0} / {1}".format(eventPlayer.CurrentCheckpoint, len(CheckpointPositions) - 1)), HudPosition.TOP, -13, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer, "{0} {1} {2}".format("Time", "{0} sec".format(eventPlayer.Timer), "| time limit: {0}".format(eventPlayer.TimeLimitTimer) if TimeLimitSettingToggle else ""), HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
   
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


rule "Checkpoint | Arrived":
    @Event eachPlayer
    @Condition distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= 1.4
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.isOnGround() == true
    @Condition (eventPlayer.EditModeSelection >= 1 or eventPlayer.InvincibleToggle == 0) == true
    
    eventPlayer.CurrentCheckpoint += 1
    if TimeLimitSettingToggle:
        smallMessage(eventPlayer, "Arrived at {0}/{1}".format(eventPlayer.CurrentCheckpoint, len(CheckpointPositions) - 1))
    else: # normal cp, but also runs when completed
 
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
    if TimeLimitSettingToggle == true:
        eventPlayer.TimeLimitTimer = 0
        chase(eventPlayer.TimeLimitTimer, 10, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "toggle leaderboard":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingSpray()

    eventPlayer.LeaderboardToggle = not eventPlayer.LeaderboardToggle


def Leaderboardupdate():
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





rule "Killing Sphere | Damage":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.CurrentCheckpoint != 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition (KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[0])] == eventPlayer.CurrentCheckpoint or KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[1])] == eventPlayer.CurrentCheckpoint or KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[2])] == eventPlayer.CurrentCheckpoint or KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[3])] == eventPlayer.CurrentCheckpoint) == true
    
    
    # kill(eventPlayer, null)
    checkpointFailReset()


rule "Bouncing Ball | Properties":
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


rule "Death Teleport":
    @Event playerDied
    @Condition eventPlayer.SpectateToggle != 1
    @Condition len(CheckpointPositions) >= 2
    
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.resurrect()
    if TimeLimitSettingToggle == true:
        eventPlayer.TimeLimitTimer = 0
        stopChasingVariable(eventPlayer.TimeLimitTimer)
        eventPlayer.CurrentCheckpoint = eventPlayer.CurrentCheckpoint if eventPlayer.EditModeSelection > 0 else 0
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])




rule "Ground dead":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition len(CheckpointPositions) >= 2
    @Condition eventPlayer.InvincibleToggle != 1
    @Condition eventPlayer.SpectateToggle != 1
    @Condition eventPlayer.isOnGround() == true    
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])) > 1.4
    @Condition not touchground

    #Do a specific level to open the landing and die and then open it again
    #@Condition (eventPlayer.A == -1 or eventPlayer.A == -1 or eventPlayer.A == -1 or false) == true
    # if eventPlayer.EditModeSelection < 1:
    #     eventPlayer.setAbility1Enabled(false)
    #     eventPlayer.setUltEnabled(false)
    # eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    # eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)
    # if TimeLimitSettingToggle == true:
    #     eventPlayer.TimeLimitTimer = 0
    #     stopChasingVariable(eventPlayer.TimeLimitTimer)
    #     eventPlayer.CurrentCheckpoint = eventPlayer.CurrentCheckpoint if eventPlayer.EditModeSelection > 0 else 0
    # eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint][1] if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[eventPlayer.CurrentCheckpoint])
    # if DeathBhopBan == true:
    #     eventPlayer.disallowButton(Button.JUMP)
    #     wait(0.1)
    #     eventPlayer.allowButton(Button.JUMP)
    # if eventPlayer.CurrentCheckpoint == 0:
    #     eventPlayer.Timer = 0
    # if eventPlayer.isUsingUltimate():
    #     kill(eventPlayer, null)
    checkpointFailReset()


rule "Player Effect":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatusEffect(Status.PHASED_OUT) == false
    
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)


rule "Restart run":
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
    waitUntil(not eventPlayer.isUsingAbility2() and DashExploitToggle, 0.5)
    eventPlayer.CurrentCheckpoint = 0
    StartGame_Sub()
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    Portal1PlayerList.remove(eventPlayer)
    Portal2PlayerList.remove(eventPlayer)


rule "Enter Spectate":
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
    if TimeLimitSettingToggle == false:
        goto lbl_2
    eventPlayer.CurrentCheckpoint = 0
    lbl_2:


rule "Initialization | Double jump | Bhop":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    
    #The number "-1" after the variable A is the number of levels. For details, please refer to "Give the knife". 
    # When this rule is turned on, the effect is "open three stages in a specific level", 
    # and when it is turned off, it will be "banned three stages in all levels"
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    # Notes must be read! When this condition is turned on, the effect is "Automatically open three stages after customs clearance", 
    # and if it is turned off, three stages will still be banned after customs clearance.
    #@Condition eventPlayer.A < len(A) - 1
    eventPlayer.JumpCount = 0
    eventPlayer.WallclimbUsed = 2
    wait(0)
    if (eventPlayer.JumpCount != 0 or eventPlayer.WallclimbUsed != 2) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = 1






rule "Toggle Invincible/Normal mode":
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
        if TimeLimitSettingToggle == false:
            goto lbl_0
        smallMessage(eventPlayer, "Press ctrl+LMB/RMB to jump next/prev")
        stopChasingVariable(eventPlayer.TimeLimitTimer)
        lbl_0:
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
        if TimeLimitSettingToggle == false:
            goto lbl_2
        eventPlayer.CurrentCheckpoint = 0
        lbl_2:
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


rule "Ultimate charge":
    @Event eachPlayer
    @Condition eventPlayer.getUltCharge() < 100
    
    eventPlayer.setUltCharge(100)




rule "Player left the game":
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


rule "Create Bhop Climb HUD Text":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    wait(1)
    hudHeader(eventPlayer, "Bhop", HudPosition.LEFT, 1, Color.GREEN if eventPlayer.BhopUsed == 0 else eventPlayer.BhopHUDColor, HudReeval.COLOR, SpecVisibility.DEFAULT)


rule "Combo | Quick Reset":
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


rule "Limit Ultimate":
    @Event eachPlayer
    @Hero genji
    #The function of this rule is: SHIFT can only be used once when running the map
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.EditModeSelection < 1
    @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.setUltEnabled(false)


rule "Lmit Dash":
    @Event eachPlayer
    #The function of this rule is: SHIFT can only be used once when running the map
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.EditModeSelection < 1
    @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.setAbility1Enabled(false)


rule "Give Blade":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint].last() if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) > 1 else CheckpointPositions[eventPlayer.CurrentCheckpoint])) <= 1.4
    @Condition eventPlayer.CurrentCheckpoint in BladeEnabledCheckpoints == true
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
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint].last() if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) > 1 else CheckpointPositions[eventPlayer.CurrentCheckpoint])) <= 1.4
    @Condition eventPlayer.CurrentCheckpoint in DashEnabledCheckpoints == true
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setAbility1Enabled(true)
    smallMessage(eventPlayer, "Dash is ready")





rule "rule 91":
    @Event eachPlayer
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint if eventPlayer.EditModeSelection > 0 else 0])) > 1.4
    @Condition TimeLimitSettingToggle == true
    @Condition (0 if eventPlayer.EditModeSelection > 0 else eventPlayer.InvincibleToggle) != 1
    @Condition (0 if eventPlayer.EditModeSelection > 0 else eventPlayer.CurrentCheckpoint) == 0
    
    #@Condition eventPlayer.A == 0
    #@Condition eventPlayer.C != 1

    eventPlayer.TimeLimitTimer = 0
    chase(eventPlayer.TimeLimitTimer, 10, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.Timer = 0


rule "Checkpoint Time Limit":
    @Event eachPlayer
    @Condition TimeLimitSettingToggle == true
    @Condition eventPlayer.TimeLimitTimer >= 5
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    
    eventPlayer.CurrentCheckpoint = eventPlayer.CurrentCheckpoint if eventPlayer.EditModeSelection > 0 else 0
    if eventPlayer.InvincibleToggle == 1:
        goto lbl_0
    if eventPlayer.EditModeSelection > 0 and eventPlayer.isOnGround():
        goto lbl_1
    eventPlayer.teleport(CheckpointPositions[0 if eventPlayer.EditModeSelection < 1 else eventPlayer.CurrentCheckpoint])
    lbl_0:
    smallMessage(eventPlayer, "Time out!")
    lbl_1:
    stopChasingVariable(eventPlayer.TimeLimitTimer)


rule "Reset Timelimit Timer When at Checkpoint 0":
    @Event eachPlayer
    @Condition distance(eventPlayer, CheckpointPositions[0]) < 1
    @Condition eventPlayer.CurrentCheckpoint == 0
    @Condition TimeLimitSettingToggle == true
    
    stopChasingVariable(eventPlayer.TimeLimitTimer)
    eventPlayer.TimeLimitTimer = 0
    eventPlayer.Timer = 0


rule "Go Forward Checkpoint (Invincible Mode | TimeLimitSetting Enabled)":
    @Event eachPlayer
    @Condition eventPlayer.InvincibleToggle == 1
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition TimeLimitSettingToggle == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.CurrentCheckpoint += 1 if eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 2 else 0
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint])


rule "Go Backward Checkpoint (Invincible Mode | TimeLimitSetting Enabled)":
    @Event eachPlayer
    @Condition eventPlayer.InvincibleToggle == 1
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition TimeLimitSettingToggle == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.CurrentCheckpoint -= 1 if eventPlayer.CurrentCheckpoint > 0 else 0
    eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint])


rule "invis toggle":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.EditModeSelection < 1

    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.invis = not eventPlayer.invis
    eventPlayer.setInvisibility(Invis.NONE)
    if eventPlayer.invis:
        eventPlayer.setInvisibility(Invis.ALL)

    smallMessage(eventPlayer, "invis {0}".format("on" if eventPlayer.invis else "off"))    
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, null, eventPlayer, 100)



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

rule "------------------------------------------------------------------------ Map pasta ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled


rule "Friend Title <----  Displaying your message (on you)":
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


rule "Credits here <---- insert your name": #"Text <---- put code and author here!":
    hudSubtext(getAllPlayers(), "For more maps and records join:", HudPosition.LEFT, -14, Color.PURPLE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "dsc.gg/genjiparkour", HudPosition.LEFT, -13, Color.PURPLE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), "", null, "{0}\r\n{1}".format("MADE BY: Write your nickname here", "CODE: write maps code here"), HudPosition.LEFT, -15, Color.WHITE, Color.SKY_BLUE, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "map data <---- insert your map data":
    @Delimiter

editorordata