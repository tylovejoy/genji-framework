#Global variables

globalvar CheckpointPositions 0 # Checkpoint Positions
globalvar B__ 1 # Current checkpoint in Editing context, maybe just a TempIterator count
globalvar CheckpointRings_Editing 2 # Holds checkpoint effects in editing context (shows all ?)
globalvar DVA 3
globalvar dva 4
globalvar Portal1PlayerList 5 # portal1 player list (visiblility)
globalvar Portal2PlayerList 6 # portal2 player list (visiblility)
globalvar KillBallPositions 7 # KillBall position
globalvar KillBallRadii 8 # KillBall radius
globalvar J__ 9 #  Current checkpoint in editing context? whats difference between B and J
globalvar KillBallEffects 10 # Array holding killball effects
globalvar KillBallChase 11 # Kill sphere temp chase lpcation?
globalvar Dao__ 12 # Dash Enabled for Checkpoint what difference?
globalvar SHIFT__ 13 # If Dash is enabled for the checkpoint whats difference?
globalvar SUPERJUMP_unused 14 # UNUSED
globalvar ListPlayersAtCheckpoints 15  # 2d array checkpoints for index with a list of players at each checkpoint
globalvar ActivePlayers 16 # I think this is just arr of active players. Non-saved, non-spectating active players
globalvar R_unused 17 # UNUSED

# Killball/Bounce Pad editing stuff
globalvar TQ__ 18
globalvar TQ1__ 19
globalvar TQ2__ 20
globalvar TQ3__ 21
globalvar EditMode__ 22
globalvar TQ5__ 23
globalvar TQ6__ 24

 
globalvar TimeLimitSettingToggle_ 25 # level time limit ? ws setting
globalvar KillballCheckpoints 26 # 2d list of checkpoints that havea kill ball [[0], [3]]
globalvar BouncePadCheckpoints 27 # 2d list like killballnumber
globalvar BhopBanFromReset 28 # Ban bhop from reset
globalvar SavedProgress 30 # saves player data in array for rejoining, sequential data.... should probably be 2d list

# Leaderboard stuff
globalvar toplistPlayers 32
globalvar toplistTimes 33
globalvar toplistSortedTimes 34


globalvar BhopBanToggle 35 # Enabled if Bhop is banned
globalvar TempIterator1 38 # This seems like a tru TempIterator rather than B


#Player variables

playervar A__ 0  # Current Checkpoint ??
playervar PlayerEffects 1  # Player effect data array 0 - Cur Checkpoint Ring, 1 - Next CP ring, 2 - Lightshaft at next CP, 3 - Arrow icon, 4 - "Come here" text 
playervar InvincibleToggle 2  # i thikn this is invincible/normal mode toggle
playervar D__ 3  # Timer
playervar EditModeSelection 4  # EditMode 2 Killing sphere | 3 Bouncing ball | 1 checkpoint
playervar SpectateToggle 5  # SpectateToggle
playervar G_unused 6  # unused?
playervar PortalText 7  # Portal String inworld text
playervar I_unused 8  # Unused ? Comment says tutorial HUD set to 2
playervar J__ 9  # "Climbing the wall prompt" HUD set to 2, multiclimb hud start ?
playervar GuideToggle 10  # Guide Enabled (1) /Disabled (2)
playervar L__ 11  # Time trial-like checkpoint?
playervar TimelimitTimer__ 12 # Timer (countdown?) for time limit
playervar BhopUsed 14 # Bhop has been used 1, 0 if not
playervar LeaderboardTimerCapture 19 # Leaderboard Timer capture
playervar TY__ 26 # some kind of tracking for bhop/multi jumps
playervar MultiClimbCountHUD 28 # climb counter . HUD entity
playervar QuickRestartToggle 31 # If quick restart is enabled or not
playervar MultiClimbCount 32  # climb counter # for HUD
playervar BhopHUDColor 85 # Color for Bhop HUD
playervar HUB_DOTS_INDEX 117 # never true? never init. shows "wall climb" text. debug text most likely


#Subroutine names

subroutine CheckpointEffect_Sub 0
subroutine StartGame_Sub 1
subroutine KILLBALL 3
subroutine pinball 4


rule "------------------------------------------------------Turn off the rules below after finishing editing--------------------------":
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


rule "------------------------------------------------------Turn off the rules above after finishing editing--------------------------":
    @Delimiter

rule "Setup and Variables":
    disableInspector()
    getAllPlayers().disableRespawn()
    disableGamemodeCompletion()
    disableScoring()
    disableMusic()
    pauseMatchTime()
    Dao__ = []
    SHIFT__ = []
    BouncePadCheckpoints = []
    KillballCheckpoints = []
    CheckpointPositions = []
    Portal1PlayerList = []
    Portal2PlayerList = []
    KillBallPositions = []
    KillBallRadii = []
    KillBallEffects = []
    J__ = 0
    ActivePlayers = []
    TQ__ = []
    TQ2__ = []
    EditMode__ = []
    TQ1__ = 0
    TQ5__ = []
    TQ6__ = []
    wait(1)
    B__ = len(CheckpointPositions) - 1
    KILLBALL()
    wait(2)
    pinball()
    if getCurrentGamemode() == Gamemode.SKIRMISH:
        hudText(getAllPlayers(), "", null, "{0} {1} {2}".format("Time left until server resets:", 270 - floor(getTotalTimeElapsed() / 60), "Minutes"), HudPosition.RIGHT, -15, Color.WHITE, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    else:
        hudText(getAllPlayers(), "", null, "{0} {1} {2}".format("Time left until server resets:", 90 - floor(getTotalTimeElapsed() / 60), "Minutes"), HudPosition.RIGHT, -15, Color.WHITE, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    SavedProgress = []
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
    hudSubtext(getAllPlayers(), "                                                   \r\n  \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", HudPosition.TOP, -6, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0}+{1} | Invincible".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)), HudPosition.RIGHT, -12, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0}+{1}+{2} | Restart".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT)), HudPosition.RIGHT, -11, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "Hold {0} | Spectate".format(buttonString(Button.INTERACT)), HudPosition.RIGHT, -11, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "Hold {0} |  Enable Quick reset".format(buttonString(Button.RELOAD)), HudPosition.RIGHT, -10, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "press {0} | Quick reset".format(buttonString(Button.RELOAD)), HudPosition.RIGHT, -9, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    TimeLimitSettingToggle_ = createWorkshopSetting(bool, "Extended function", "Level time limit", false, 0)


def CheckpointEffect_Sub():
    @Name "Checkpoint | Effect |-------------------------------------------------SUB0"
    
    createEffect(eventPlayer, Effect.RING, Color.SKY_BLUE, CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.PlayerEffects[0] = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.RING, Color.LIME_GREEN, CheckpointPositions[eventPlayer.A__ + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.PlayerEffects[1] = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.LIGHT_SHAFT, Color.WHITE, CheckpointPositions[eventPlayer.A__ + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.PlayerEffects[2] = getLastCreatedEntity()
    createIcon(eventPlayer, CheckpointPositions[eventPlayer.A__ + 1] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.SKY_BLUE, true)
    eventPlayer.PlayerEffects[3] = getLastCreatedEntity()
    createInWorldText(eventPlayer, "Come here", CheckpointPositions[eventPlayer.A__ + 1], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.PlayerEffects[4] = getLastCreatedText()


def StartGame_Sub():
    @Name "Checkpoint | Start the game |-------------------------------------SUB1"
    
    if len(CheckpointPositions) != 0:
        if "{0}".format(eventPlayer) in SavedProgress and TimeLimitSettingToggle_ == false:
            #if "{0}".format(eventPlayer) in save == true:
            eventPlayer.A__ = SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
            eventPlayer.D__ = SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 2]
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 3] = eventPlayer
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 5] = 0
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 0
            eventPlayer.teleport(CheckpointPositions[SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]] + vect(0, 1, 0))
        else:
            eventPlayer.teleport(CheckpointPositions[0] + vect(0, 1, 0))
            eventPlayer.A__ = 0
            eventPlayer.D__ = 0
            stopChasingVariable(eventPlayer.TimelimitTimer__)
            eventPlayer.TimelimitTimer__ = 0
            SavedProgress.append(["{0}".format(eventPlayer), eventPlayer.A__, eventPlayer.D__, eventPlayer, getTotalTimeElapsed(), 0, 0])
    chase(eventPlayer.D__, 9999999, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.G_unused = 0
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
    ListPlayersAtCheckpoints[eventPlayer.A__].append(eventPlayer)
    eventPlayer.InvincibleToggle = 0


def KILLBALL():
    @Name "Checkpoint | Killing Sphere effect |-------------------------------------SUB"
    
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
    @Name "Checkpoint | Bouncing Ball effect |-------------------------------------SUB"
    
    if TQ__ == []:
        return
    TempIterator1 = 0
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[0]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 1
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[1]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 2
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[2]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 3
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[3]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 4
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[4]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 5
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[5]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 6
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[6]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 7
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[7]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 8
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[8]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 9
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[9]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 10
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[10]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 11
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[11]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 12
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[12]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 13
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[13]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 14
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[14]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 15
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[15]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 16
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[16]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 17
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[17]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 18
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[18]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 19
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[19]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 20
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[20]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 21
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[21]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 22
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[22]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 23
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[23]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 24
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[24]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 25
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[25]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 26
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[26]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 27
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[27]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 28
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[28]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 29
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[29]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 30
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[30]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 31
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[31]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 32
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[32]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 33
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[33]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 34
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[34]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 35
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[35]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 36
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[36]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 37
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[37]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 38
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[38]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 39
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[39]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 40
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[40]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 41
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[41]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 42
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[42]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 43
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[43]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 44
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[44]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 45
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[45]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 46
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[46]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 47
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[47]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 48
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[48]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 49
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[49]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 50
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[50]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 51
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[51]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 52
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[52]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 53
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[53]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 54
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[54]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 55
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[55]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 56
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[56]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 57
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[57]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 58
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[58]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 59
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[59]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 60
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[60]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 61
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[61]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 62
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[62]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 63
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[63]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 64
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[64]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 65
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[65]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 66
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[66]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 67
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[67]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 68
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[68]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 69
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[69]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 70
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[70]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 71
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[71]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 72
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[72]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 73
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[73]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 74
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[74]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return
    TempIterator1 = 75
    createEffect(sorted(ListPlayersAtCheckpoints[BouncePadCheckpoints[75]]), Effect.ORB, Color.GREEN, TQ__[TempIterator1], 1, EffectReeval.VISIBILITY)
    TQ2__.append(getLastCreatedEntity())
    if TempIterator1 == len(TQ__) - 1:
        return


rule "Checkpoint | Position <---------------------------------------------------------------------------- paste here!":
    @Delimiter

rule "Checkpoint | HUD":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.setDamageDealt(0)
    if eventPlayer in ActivePlayers:
        hudSubtext(eventPlayer, "{0} {1}".format("level ", "{0} / {1}".format(eventPlayer.A__, len(CheckpointPositions) - 1)), HudPosition.TOP, -13, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudSubtext(eventPlayer, "{0} {1} {2}".format("Time", l"{0} sec".format(eventPlayer.D__), "| time limit: {0}".format(eventPlayer.L__) if TimeLimitSettingToggle_ else ""), HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    ActivePlayers.append(eventPlayer)
    #子程序1为游戏的初始化设置
    StartGame_Sub()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    #玩家F：自杀防止复活
    eventPlayer.SpectateToggle = 0
    #玩家I：教程HUD
    eventPlayer.I_unused = 2
    #玩家J：爬墙提示HUD
    eventPlayer.J__ = 2
    #子程序0为检查点效果显示
    CheckpointEffect_Sub()


rule "Checkpoint | Arrived":
    @Event eachPlayer
    @Condition distance(eventPlayer, CheckpointPositions[eventPlayer.A__ + 1]) <= 1.4
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    @Condition eventPlayer.isOnGround() == true
    @Condition (eventPlayer.EditModeSelection >= 1 or eventPlayer.InvincibleToggle == 0) == true
    
    eventPlayer.A__ += 1
    if TimeLimitSettingToggle_:
        smallMessage(eventPlayer, "Arrived at {0}/{1}".format(eventPlayer.A__, len(CheckpointPositions) - 1))
    else:
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
        SavedProgress.remove("{0}".format(eventPlayer))
        SavedProgress.append(["{0}".format(eventPlayer), eventPlayer.A__, eventPlayer.D__, eventPlayer, getTotalTimeElapsed(), 0, 0])
        playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, CheckpointPositions[eventPlayer.A__] + vect(0, 1.5, 0), 4)
        bigMessage(eventPlayer, "{0} {1}".format("Arrived at", "{0} / {1}".format(eventPlayer.A__, len(CheckpointPositions) - 1)))
    ListPlayersAtCheckpoints[eventPlayer.A__].append(eventPlayer)
    ListPlayersAtCheckpoints[eventPlayer.A__ - 1].remove(eventPlayer)
    if eventPlayer.EditModeSelection < 1:
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
    if eventPlayer.EditModeSelection >= 1:
        return
    if eventPlayer.A__ >= len(CheckpointPositions) - 1:
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        stopChasingVariable(eventPlayer.D__)
        bigMessage(getAllPlayers(), "{0} {1} {2}".format(eventPlayer, "Mission complete! Time", l"{0} sec".format(eventPlayer.D__)))
        destroyEffect(eventPlayer.PlayerEffects[0])
        destroyEffect(eventPlayer.PlayerEffects[1])
        destroyEffect(eventPlayer.PlayerEffects[2])
        destroyIcon(eventPlayer.PlayerEffects[3])
        destroyInWorldText(eventPlayer.PlayerEffects[4])
        Portal1PlayerList.append(eventPlayer)
        Portal2PlayerList.append(eventPlayer)
        #H传送门字符串
        eventPlayer.PortalText = 2
    if TimeLimitSettingToggle_ == true:
        eventPlayer.L__ = 0
        chase(eventPlayer.L__, 10, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "nope":
    @Event eachPlayer
    
    getAllPlayers().disableGamemodeHud()


rule "Killing Sphere | Damage":
    @Event eachPlayer
    @Hero genji
    @Condition (KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[0])] == eventPlayer.A__ or KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[1])] == eventPlayer.A__ or KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[2])] == eventPlayer.A__ or KillballCheckpoints[KillBallPositions.index(([player for player in KillBallPositions if distance(eventPlayer, player) <= KillBallRadii[KillBallPositions.index(player)]])[3])] == eventPlayer.A__) == true
    @Condition eventPlayer.A__ != 0
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    @Condition eventPlayer.InvincibleToggle == 0
    
    kill(eventPlayer, null)


rule "Bouncing Ball | Properties":
    @Event eachPlayer
    @Hero genji
    @Condition BouncePadCheckpoints[TQ__.index([player for player in TQ__ if distance(eventPlayer, player) <= 1.2])] == eventPlayer.A__
    @Condition eventPlayer.A__ != 0
    
    eventPlayer.applyImpulse(Vector.UP, EditMode__[TQ__.index([player for player in TQ__ if distance(eventPlayer.getPosition(), player) <= 2])], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    #eventPlayer.setAbility1Enabled(TQ6[TQ.index([player for player in TQ if distance(eventPlayer.getPosition(), player) <= 2])])
    #eventPlayer.setUltEnabled(TQ5[TQ.index([player for player in TQ if distance(eventPlayer.getPosition(), player) <= 2])])
    if TQ6__[TQ__.index([player for player in TQ__ if distance(eventPlayer.getPosition(), player) <= 2])] == true:
        eventPlayer.setAbility1Enabled(true)
        smallMessage(eventPlayer, "Dash is ready")
    if TQ5__[TQ__.index([player for player in TQ__ if distance(eventPlayer.getPosition(), player) <= 2])] == true:
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        smallMessage(eventPlayer, "Ultimate is ready")


rule "Data for Top 5":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.A__ == len(CheckpointPositions) - 1
    @Condition eventPlayer.EditModeSelection < 1
    
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    del SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 1]
    SavedProgress.remove("{0}".format(eventPlayer))
    if eventPlayer.PlayerEffects[7] == null:
        eventPlayer.LeaderboardTimerCapture = eventPlayer.D__
        hudText(null if toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))] in toplistSortedTimes else getAllPlayers(), heroIcon(Hero.GENJI), eventPlayer, "{0} sec".format(eventPlayer.LeaderboardTimerCapture), HudPosition.RIGHT, eventPlayer.LeaderboardTimerCapture, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
        eventPlayer.PlayerEffects[7] = getLastCreatedText()
    else:
        if eventPlayer.D__ > eventPlayer.LeaderboardTimerCapture:
            goto lbl_0
        eventPlayer.LeaderboardTimerCapture = eventPlayer.D__
        lbl_0:
    #Save data for the Top 5 list
    if "{0}".format(eventPlayer) in toplistPlayers:
        if eventPlayer.D__ >= toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))]:
            goto lbl_1
        toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))] = eventPlayer.D__
        lbl_1:
    else:
        toplistPlayers.append("{0}".format(eventPlayer))
        toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))] = eventPlayer.D__
    #Reload the Sorted Array Times
    toplistSortedTimes = sorted(toplistTimes).slice(0, 6)
    stopChasingVariable(eventPlayer.TimelimitTimer__)
    eventPlayer.TimelimitTimer__ = 0


rule "Checkpoint | Finish effects":
    @Event eachPlayer
    @Condition eventPlayer.A__ == len(CheckpointPositions) - 1
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
    if TimeLimitSettingToggle_ == true:
        eventPlayer.L__ = 0
        stopChasingVariable(eventPlayer.L__)
        eventPlayer.A__ = eventPlayer.A__ if eventPlayer.EditModeSelection > 0 else 0
    eventPlayer.teleport(CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__])


rule "Landing on Checkpoint (In some circumstances turn off?)":
    @Event eachPlayer
    @Hero genji
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__])) > 1.4
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    @Condition len(CheckpointPositions) >= 2
    @Condition eventPlayer.InvincibleToggle != 1
    @Condition eventPlayer.SpectateToggle != 1
    
    #做特定关卡开启落地死亡再打开
    #@Condition (eventPlayer.A == -1 or eventPlayer.A == -1 or eventPlayer.A == -1 or false) == true
    if eventPlayer.EditModeSelection < 1:
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setUltEnabled(false)
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)
    if TimeLimitSettingToggle_ == true:
        eventPlayer.L__ = 0
        stopChasingVariable(eventPlayer.L__)
        eventPlayer.A__ = eventPlayer.A__ if eventPlayer.EditModeSelection > 0 else 0
    eventPlayer.teleport(CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__])
    if BhopBanFromReset == true:
        eventPlayer.disallowButton(Button.JUMP)
        wait(0.1)
        eventPlayer.allowButton(Button.JUMP)
    if eventPlayer.A__ == 0:
        eventPlayer.D__ = 0
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)


rule "Player Effect":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatusEffect(Status.PHASED_OUT) == false
    
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)


rule "Combo | Reset the run | RESTART":
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
    ListPlayersAtCheckpoints[eventPlayer.A__].remove(eventPlayer)
    if eventPlayer.A__ >= len(CheckpointPositions) - 1:
        CheckpointEffect_Sub()
        #这条动作为“消除玩家通关成绩显示”
        destroyHudText(eventPlayer.PlayerEffects[7])
    StartGame_Sub()
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    Portal1PlayerList.remove(eventPlayer)
    Portal2PlayerList.remove(eventPlayer)


rule "Combo | Spectate | Interact":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.EditModeSelection < 1
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "Hold Interact again to turn off spectate mode")
    if eventPlayer.isAlive():
        if eventPlayer.A__ < len(CheckpointPositions) - 1:
            chase(eventPlayer.TimelimitTimer__, 999999, rate=1, ChaseReeval.DESTINATION_AND_RATE)
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 2] = eventPlayer.D__
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 1
        eventPlayer.setRespawnTime(9999)
        eventPlayer.SpectateToggle = 1
        stopChasingVariable(eventPlayer.D__)
        wait(0.2)
        kill(eventPlayer, null)
        eventPlayer.teleport(CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__])
    else:
        if eventPlayer.EditModeSelection >= 1:
            goto lbl_0
        eventPlayer.respawn()
        eventPlayer.SpectateToggle = 0
        lbl_0:
        eventPlayer.teleport(CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__])
        if eventPlayer.A__ >= len(CheckpointPositions) - 1:
            goto lbl_1
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        chase(eventPlayer.D__, 10000, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_1:
        eventPlayer.setRespawnTime(0)
        eventPlayer.InvincibleToggle = 0
        if eventPlayer.A__ < len(CheckpointPositions) - 1:
            stopChasingVariable(eventPlayer.TimelimitTimer__)
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 5] = eventPlayer.TimelimitTimer__
            eventPlayer.TimelimitTimer__ = 0
            SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 0
    if TimeLimitSettingToggle_ == false:
        goto lbl_2
    eventPlayer.A__ = 0
    lbl_2:


rule "Initialization | Double jump | Bhop":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    
    #变量A后的数字“-1”为关卡数，具体操作参考“给刀”。此条规则开启效果为“特定关卡开启三段”，关闭则为“所有关卡封禁三段”
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #注释一定要看！此条条件开启的效果为“通关后自动开启三段”，关闭则通关后仍封禁三段
    #@Condition eventPlayer.A < len(A) - 1
    eventPlayer.TY__ = 0
    eventPlayer.J__ = 2
    wait(0)
    if (eventPlayer.TY__ != 0 or eventPlayer.J__ != 2) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = 1


rule "二段跳，小跳初始化":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    
    #变量A后的数字“-1”为关卡数，具体操作参考“给刀”。此条规则开启效果为“特定关卡开启三段”，关闭则为“所有关卡封禁三段”
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #注释一定要看！此条条件开启的效果为“通关后自动开启三段”，关闭则通关后仍封禁三段
    #@Condition eventPlayer.A < len(A) - 1
    eventPlayer.TY__ = 0
    eventPlayer.J__ = 2
    eventPlayer.MultiClimbCount = 0
    wait(0)
    if (eventPlayer.TY__ != 0 or eventPlayer.J__ != 2) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = 1


rule "Checking | Jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.TY__ != 2
    
    #变量A后的数字“-1”为关卡数，具体操作参考“给刀”。此条规则开启效果为“特定关卡开启三段”，关闭则为“所有关卡封禁三段
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #注释一定要看！此条条件开启的效果为“通关后自动开启三段”，关闭则通关后仍封禁三
    #@Condition eventPlayer.A < len(A) - 1
    eventPlayer.TY__ += 1


rule "Checking | Bhop in the air":
    @Event eachPlayer
    @Condition eventPlayer.TY__ == 0
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    
    eventPlayer.BhopUsed = 0


rule "Checking | In the air":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.TY__ == 0
    @Condition eventPlayer.isInAir() == true
    
    #变量A后的数字“-1”为关卡数，具体操作参考“给刀”。此条规则开启效果为“特定关卡开启三段”，关闭则为“所有关卡封禁三段
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #注释一定要看！此条条件开启的效果为“通关后自动开启三段”，关闭则通关后仍封禁三
    #@Condition eventPlayer.A < len(A) - 1
    eventPlayer.TY__ = 1


rule "Checking | Triple jump":
    @Event eachPlayer
    @Condition eventPlayer.TY__ == 1
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.TY__ = 2


rule "Checking | Player on the wall":
    @Event eachPlayer
    #此条规则同时与爬墙判定挂钩，请勿关闭/删除
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.TY__ = 2
    eventPlayer.J__ = 1


rule "Combo | Invincible/Normal mode":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__], true)
    if eventPlayer.InvincibleToggle == 0:
        chase(eventPlayer.TimelimitTimer__, 999999, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 2] = eventPlayer.D__
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 1
        if TimeLimitSettingToggle_ == false:
            goto lbl_0
        smallMessage(eventPlayer, "Press ctrl+LMB/RMB to jump next/prev")
        stopChasingVariable(eventPlayer.L__)
        lbl_0:
        stopChasingVariable(eventPlayer.D__)
        bigMessage(eventPlayer, "Invincible mode")
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
        if TimeLimitSettingToggle_ == false:
            goto lbl_2
        eventPlayer.A__ = 0
        lbl_2:
        eventPlayer.teleport(CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__])
        wait(0.1)
        eventPlayer.InvincibleToggle = 0
        bigMessage(eventPlayer, "Normal mode")
        chase(eventPlayer.D__, 9999999, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        eventPlayer.stopForcingPosition()
        stopChasingVariable(eventPlayer.TimelimitTimer__)
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 5] = eventPlayer.TimelimitTimer__
        eventPlayer.TimelimitTimer__ = 0
        SavedProgress[SavedProgress.index("{0}".format(eventPlayer)) + 6] = 0


rule "Ultimate charge":
    @Event eachPlayer
    @Condition eventPlayer.getUltCharge() < 100
    
    eventPlayer.setUltCharge(100)


rule "Checking | Using Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    
    eventPlayer.BhopUsed = 0


rule "Checking | Bhop":
    @Event eachPlayer
    @Condition eventPlayer.BhopUsed == 0
    @Condition eventPlayer.isJumping() == true
    
    eventPlayer.BhopUsed = 1
    smallMessage(eventPlayer, "Bhop")


rule "Player left the game":
    @Event playerLeft
    
    ActivePlayers.remove(eventPlayer)
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


rule "爬墙未用HUD___Counter":
    @Event eachPlayer
    @Condition eventPlayer.J__ == 2
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb{0}".format("({0})".format(eventPlayer.MultiClimbCount) if eventPlayer.MultiClimbCount > 0 else ""), HudPosition.LEFT, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()


rule "爬墙已用HUD___Counter":
    @Event eachPlayer
    @Condition eventPlayer.J__ == 1
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb", HudPosition.LEFT, 2, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()
    if eventPlayer.HUB_DOTS_INDEX == 2:
        smallMessage(eventPlayer, "Wallclimb ")


rule "爬墙计数":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.J__ == 2
    @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.MultiClimbCount += 1


rule "Bhop Green":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    
    eventPlayer.BhopHUDColor = Color.GREEN


rule "Bhop Red":
    @Event eachPlayer
    @Condition eventPlayer.isJumping() == true
    
    eventPlayer.BhopHUDColor = Color.RED


rule "Checking | Double bhop | thank for Githuboy#5249":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isJumping() == false
    @Condition eventPlayer.isCrouching() == true
    
    smallMessage(eventPlayer, "Success")
    eventPlayer.BhopUsed = 0
    if BhopBanToggle == true:
        kill(eventPlayer, null)
        smallMessage(eventPlayer, "{0} {1}".format(heroIcon(Hero.GENJI), ": Double Bhop is disabled"))


rule "Combo | Quick Reset":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.EditModeSelection < 1
    
    if eventPlayer.isHoldingButton(Button.MELEE):
        return
    if eventPlayer.QuickRestartToggle == true:
        eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__], true)
        if eventPlayer.EditModeSelection >= 1 or eventPlayer.InvincibleToggle == 1:
            goto lbl_0
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        lbl_0:
        eventPlayer.teleport(CheckpointPositions[eventPlayer.A__][1] if len(CheckpointPositions[eventPlayer.A__]) != 0 else CheckpointPositions[eventPlayer.A__])
        wait(0.1)
        eventPlayer.stopForcingPosition()
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
    #此条规则作用为：在跑图时令SHIFT只能使用一次
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    @Condition eventPlayer.EditModeSelection < 1
    @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.setUltEnabled(false)


rule "Lmit Dash":
    @Event eachPlayer
    #此条规则作用为：在跑图时令SHIFT只能使用一次
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    @Condition eventPlayer.EditModeSelection < 1
    @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.setAbility1Enabled(false)


rule "Give Blade":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.A__].last() if len(CheckpointPositions[eventPlayer.A__]) > 1 else CheckpointPositions[eventPlayer.A__])) <= 1.4
    @Condition eventPlayer.A__ in Dao__ == true
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
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    #@Condition distance(eventPlayer, A[eventPlayer.A]) <= 1.4
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.A__].last() if len(CheckpointPositions[eventPlayer.A__]) > 1 else CheckpointPositions[eventPlayer.A__])) <= 1.4
    @Condition eventPlayer.A__ in SHIFT__ == true
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setAbility1Enabled(true)
    smallMessage(eventPlayer, "Dash is ready")


rule "Text <------------------------------------------------- put code and author here!":
    hudSubtext(getAllPlayers(), "For more maps and records join:", HudPosition.LEFT, -14, Color.PURPLE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "dsc.gg/genjiparkour", HudPosition.LEFT, -13, Color.PURPLE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), "", null, "{0}\r\n{1}".format("MADE BY: Write your nickname here", "CODE: write maps code here"), HudPosition.LEFT, -15, Color.WHITE, Color.SKY_BLUE, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Friend Title - Displaying your message (on you)":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    #In the field custom string your nickname
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(getAllPlayers(), "Message to the whole room")
        createInWorldText(getAllPlayers(), "Title <---------------The inscription that will be displayed on you", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    #空白处填写您好友的名字
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(getAllPlayers(), "Message to the whole room")
        createInWorldText(getAllPlayers(), "Title <---------------The inscription that will be displayed on you", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)


rule "Ban | Triple Jump":
    @Event eachPlayer
    @Condition eventPlayer.getVerticalSpeed() >= 5.8
    @Condition eventPlayer.TY__ == 1
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Triple Jump", false, 0) == true
    
    if eventPlayer.isOnWall():
        return
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)


rule "Ban | Multiclimb":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.J__ == 2
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Multiclimb", false, 1) == true
    
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    smallMessage(eventPlayer, "{0} {1}".format(heroIcon(Hero.GENJI), ": Multiclimb is Disabled"))


rule "Ban | Double Bhop":
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Double Bhop", false, 2) == true
    
    BhopBanToggle = true


rule "Ban | Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Emote", false, 3) == true
    
    kill(eventPlayer, null)
    smallMessage(eventPlayer, "{0} {1}".format(heroIcon(Hero.GENJI), ": Emote jumping is disabled"))


rule "Ban | Bhop from Reset":
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban bhop from reset", false, 4) == true
    
    BhopBanFromReset = true


rule "Extended function | Strengthen stall (家里有妖怪#5202 | Easier to stall | Jump farther)":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getVerticalSpeed() >= -0.2
    @Condition eventPlayer.getVerticalSpeed() <= 0.05
    @Condition eventPlayer.getHorizontalSpeed() <= 1.3
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isOnGround() == false
    @Condition createWorkshopSetting(bool, "Extended function", "Strengthen stall", false, 0) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    waitUntil(not eventPlayer.isMoving(), 10)
    eventPlayer.stopForcingPosition()
    eventPlayer.setMoveSpeed(0)
    eventPlayer.setGravity(0)
    wait(3)
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if RULE_CONDITION:
        goto RULE_START


rule "Extended function | Climb the wall to refresh double jump(喵喵酱#51379 | Touch and Multi will not trigger)":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition createWorkshopSetting(bool, "Extended function", "Climb the wall to refresh double jump", false, 1) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    waitUntil(not eventPlayer.isOnWall(), 1)
    eventPlayer.setStatusEffect(null, Status.HACKED, 0.1)
    wait(0.1)
    eventPlayer.clearStatusEffect(Status.HACKED)


rule "Extended function | Save climb into the checkpoint(TITANXPASCAL#5554 *Remember to create text to prompt players)":
    @Event eachPlayer
    @Condition distance(eventPlayer, CheckpointPositions[eventPlayer.A__ + 1]) <= 2
    @Condition createWorkshopSetting(bool, "Extended function", "Save climb into the checkpoint", false, 2) == true
    #Change "-1" to certain Checkpoints' number
    @Condition eventPlayer.A__ in [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] == true
    
    #If all checkpoints need this function, enable this rule and disable Rule: "Array Contains" 
    #@Condition eventPlayer.A < len(A) - 1
    if eventPlayer.J__ == 1:
        kill(eventPlayer, null)
        smallMessage(eventPlayer, "Fail to meet clear condition: Save climb")


rule "Extended function | Save Bhop into the checkpoint(TITANXPASCAL#5554 *Remember to create text to prompt players)":
    @Event eachPlayer
    @Condition distance(eventPlayer, CheckpointPositions[eventPlayer.A__ + 1]) <= 2
    @Condition createWorkshopSetting(bool, "Extended function", "Save Bhop into the checkpoint", false, 3) == true
    #Change "-1" to certain Checkpoints' number
    @Condition eventPlayer.A__ in [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] == true
    
    #If all checkpoints need this function, enable this rule and disable Rule: "Array Contains" 
    #@Condition eventPlayer.A < len(A) - 1
    if eventPlayer.BhopUsed == 1:
        kill(eventPlayer, null)
        smallMessage(eventPlayer, "Fail to meet clear condition: Save bhop")


rule "rule 91":
    @Event eachPlayer
    @Condition (distance(eventPlayer, CheckpointPositions[eventPlayer.A__ if eventPlayer.EditModeSelection > 0 else 0])) > 1.4
    @Condition TimeLimitSettingToggle_ == true
    @Condition (0 if eventPlayer.EditModeSelection > 0 else eventPlayer.InvincibleToggle) != 1
    @Condition (0 if eventPlayer.EditModeSelection > 0 else eventPlayer.A__) == 0
    
    #@Condition eventPlayer.A == 0
    #@Condition eventPlayer.C != 1
    # I think this is testing a checkpoint in edit mode. having a timer run
    eventPlayer.L__ = 0
    chase(eventPlayer.L__, 10, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.D__ = 0


rule "rule 92":
    @Event eachPlayer
    @Condition TimeLimitSettingToggle_ == true
    @Condition eventPlayer.L__ >= 5
    @Condition eventPlayer.A__ < len(CheckpointPositions) - 1
    
    eventPlayer.A__ = eventPlayer.A__ if eventPlayer.EditModeSelection > 0 else 0
    if eventPlayer.InvincibleToggle == 1:
        goto lbl_0
    if eventPlayer.EditModeSelection > 0 and eventPlayer.isOnGround():
        goto lbl_1
    eventPlayer.teleport(CheckpointPositions[0 if eventPlayer.EditModeSelection < 1 else eventPlayer.A__])
    lbl_0:
    smallMessage(eventPlayer, "Time out!")
    lbl_1:
    stopChasingVariable(eventPlayer.L__)


rule "rule 93":
    @Event eachPlayer
    @Condition distance(eventPlayer, CheckpointPositions[0]) < 1
    @Condition eventPlayer.A__ == 0
    @Condition TimeLimitSettingToggle_ == true
    
    stopChasingVariable(eventPlayer.L__)
    eventPlayer.L__ = 0
    eventPlayer.D__ = 0


rule "rule 94":
    @Event eachPlayer
    @Condition eventPlayer.InvincibleToggle == 1
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition TimeLimitSettingToggle_ == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.A__ += 1 if eventPlayer.A__ < len(CheckpointPositions) - 2 else 0
    eventPlayer.teleport(CheckpointPositions[eventPlayer.A__])


rule "rule 95":
    @Event eachPlayer
    @Condition eventPlayer.InvincibleToggle == 1
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition TimeLimitSettingToggle_ == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.A__ -= 1 if eventPlayer.A__ > 0 else 0
    eventPlayer.teleport(CheckpointPositions[eventPlayer.A__])


