#Global variables
globalvar A # Checkpoint Positions
globalvar B # Current checkpoint in Editing context, maybe just a TempIterator count
globalvar C # Holds checkpoint effects in editing context (shows all ?)
globalvar DVA 3
globalvar dva 4


globalvar H # KillBall position
globalvar I # KillBall radius
globalvar J #  Current checkpoint in editing context? whats difference between B and J
globalvar K # Array holding killball effects
globalvar L # Kill sphere temp chase lpcation?
globalvar Dao 12  # Dash Enabled for Checkpoint
globalvar SHIFT 13 # If Dash is enabled for the checkpoint
globalvar SUPERJUMP 14 # Unused ..?
globalvar P # 2d array checkpoints for index with a list of players at each checkpoint
globalvar Q # I think this is just arr of active players. Non-saved, non-spectating active players
# All these TQ is cursed killball/pinball shit
globalvar TQ 18 # Pinball locations ? anything else?
globalvar TQ1 19
globalvar TQ2 20 # Pinball effect array
globalvar TQ3 21
globalvar EditMode 22 # EditMode important vars?
globalvar TQ5 23
globalvar TQ6 24
globalvar kz_xs 25  # level time limit ? ws setting
globalvar killballnumber 26 # 2d list of checkpoints that havea kill ball [[0], [3]]
globalvar pinballnumber 27 # 2d list like killballnumber
globalvar deathjump 28 # Ban bhop from reset

globalvar save 30  # saves player data in array for rejoining, sequential data.... should probably be 2d list

globalvar toplistPlayers 32
globalvar toplistTimes 33
globalvar toplistSortedTimes 34
globalvar kaxiaotiao 35 # Enabled if Bhop is banned

globalvar NANBA 38  # This seems like a tru TempIterator rather than B



#Player variables
playervar A # Current Checkpoint ??
playervar B # Player effect data array 0 - Cur Checkpoint Ring, 1 - Next CP ring, 2 - Lightshaft at next CP, 3 - Arrow icon, 4 - "Come here" text 
playervar C # i thikn this is invincible/normal mode toggle
playervar D # Timer
playervar E # EditMode 2 Killing sphere | 3 Bouncing ball | 1 checkpoint
playervar F # Portal switch ??? appends event player Portal 1 "entrance"
playervar G # Portal Switch ??? appends event player Portal 2 "exit"
playervar H # Portal String inworld text
playervar I # Unused ? Comment says tutorial HUD set to 2
playervar J # "Climbing the wall prompt" HUD set to 2
playervar K # Guide Enabled (1) /Disabled (2)
playervar L # Time trial-like checkpoint?
playervar ztjs 12  # Timer (countdown?) for time limit
playervar O # Bhop has been used 1, 0 if not
playervar T # Leaderboard Timer capture
playervar TY 26  # some kind of tracking for bhop/multi jumps
playervar paqiang 28 # climb counter ? HUD entity
playervar quick_restart 31 # If quick restart is enabled or not
playervar climbNum 32 # climb counter # for HUD paqiang
playervar HUB_DOTS_INDEX 117 # never true? never init. shows "wall climb" text. debug text most likely


#Subroutine names

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
    @Condition eventPlayer.E >= 1
    
    wait(0.8, Wait.ABORT_WHEN_FALSE)
    playEffect(hostPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    if eventPlayer.K == 1:
        eventPlayer.K = 2
        smallMessage(getAllPlayers(), "Guide is hidden")
    else:
        eventPlayer.K = 1
        smallMessage(getAllPlayers(), "Guide is open")


rule "Clear excess data":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer == hostPlayer
    
    B = 0
    C = 0
    DVA = 0
    dva = 0
    F = 0
    G = 0
    J = 0
    K = 0
    L = 0
    Dao = 0
    SHIFT = 0
    SUPERJUMP = 0
    P = 0
    Q = 0
    R = 0
    TQ1 = 0
    NANBA = 0
    TQ2 = 0
    TQ3 = 0
    save = 0
    kz_xs = 0
    bigMessage(getAllPlayers(), "Excess data has been cleared")
    bigMessage(getAllPlayers(), "Excess data has been cleared")
    enableInspector()


rule "Deflect TP":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.E == 1
    
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 3)


rule "Change editing mode":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer == hostPlayer
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.E == 1:
        eventPlayer.E = 2
        smallMessage(hostPlayer, "Current mode: Killing sphere")
    elif eventPlayer.E == 2:
        eventPlayer.E = 3
        smallMessage(hostPlayer, "Current mode: Bouncing Ball")
    elif eventPlayer.E == 3:
        eventPlayer.E = 1
        smallMessage(hostPlayer, "Current mode: Checkpoint")


rule "Change Killing Sphere size (increase)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.E > 1
    
    if eventPlayer.E == 2:
        if len(H) > 0:
            I[J] += 0.1
            wait(0.1)
            if RULE_CONDITION:
                goto RULE_START
            for NANBA in range(len(H)):
                destroyEffect(K[NANBA])
            K = []
            KILLBALL()
    elif eventPlayer.E == 3:
        if len(TQ) > 0:
            EditMode[TQ1] += 0.1
            wait(0.1)
            if RULE_CONDITION:
                goto RULE_START


rule "Change Killing Sphere size (decrease)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.E > 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    
    if len(H) > 0:
        if eventPlayer.E == 2:
            I[J] -= 0.1
            wait(0.1)
            if RULE_CONDITION:
                goto RULE_START
            for NANBA in range(len(H)):
                destroyEffect(K[NANBA])
            K = []
            KILLBALL()


rule "Bouncing Ball strenght":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.E == 3
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    
    if len(TQ) > 0:
        EditMode[TQ1] -= 0.1
        wait(0.1)
        if RULE_CONDITION:
            goto RULE_START


rule "Move the Killing sphere (toward)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.E > 1
    
    if eventPlayer.E == 2:
        if L != H[J]:
            goto lbl_0
        chase(L, eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), H[J]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_0:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(L)
        H[J] = L
        for NANBA in range(len(H)):
            destroyEffect(K[NANBA])
        K = []
        KILLBALL()
    elif eventPlayer.E == 3:
        if TQ3 != TQ[TQ1]:
            goto lbl_1
        chase(TQ3, eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), TQ[TQ1]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_1:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(TQ3)
        TQ[TQ1] = TQ3
        for NANBA in range(len(TQ)):
            destroyEffect(TQ2[NANBA])
        TQ2 = []
        pinball()


rule "Move the Killing sphere (backward)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.E > 1
    
    if eventPlayer.E == 2:
        if L != H[J]:
            goto lbl_0
        chase(L, eventPlayer.getEyePosition() - (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), H[J]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_0:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(L)
        H[J] = L
        for NANBA in range(len(H)):
            destroyEffect(K[NANBA])
        K = []
        KILLBALL()
    elif eventPlayer.E == 3:
        if TQ3 != TQ[TQ1]:
            goto lbl_1
        chase(TQ3, eventPlayer.getEyePosition() - (eventPlayer.getFacingDirection() * (distance(eventPlayer.getPosition(), TQ[TQ1]) + 5)), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_1:
        wait(0.25)
        if RULE_CONDITION:
            goto RULE_START
        stopChasingVariable(TQ3)
        TQ[TQ1] = TQ3
        for NANBA in range(len(TQ)):
            destroyEffect(TQ2[NANBA])
        TQ2 = []
        pinball()


rule "Edit mode":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    #玩家E：编辑模式
    eventPlayer.E = 1
    eventPlayer.K = 1


rule "Create Checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.E == 1:
        A.append(eventPlayer.getPosition() - vect(0, 0, 0))
        B = len(A) - 1
        smallMessage(getAllPlayers(), "New Checkpoint has been created")
    elif eventPlayer.E == 2:
        if eventPlayer.A == 0:
            bigMessage(getAllPlayers(), "Cannot place killing sphere on level 0")
        else:
            H.append(eventPlayer.getPosition())
            killballnumber.append(eventPlayer.A)
            J = len(H) - 1
            I[J] = 5
            for NANBA in range(len(H)):
                destroyEffect(K[NANBA])
            K = []
            KILLBALL()
            L = H[J]
            bigMessage(getAllPlayers(), "New killing sphere has been created! \r\nIt's only valid for level {0}".format(eventPlayer.A))
    elif eventPlayer.E == 3:
        if eventPlayer.A == 0:
            bigMessage(getAllPlayers(), "Cannot place bouncing balls on level 0")
        else:
            TQ.append(eventPlayer.getPosition())
            TQ1 = len(TQ) - 1
            EditMode[TQ1] = 10
            TQ5[TQ1] = false
            TQ6[TQ1] = false
            for NANBA in range(len(TQ)):
                destroyEffect(TQ2[NANBA])
            TQ2 = []
            pinball()
            TQ3 = TQ[TQ1]
            pinballnumber.append(eventPlayer.A)
            bigMessage(getAllPlayers(), "New bouncing ball has been created! \r\nIt's only valid for level {0}".format(eventPlayer.A))


rule "Delete Checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.E == 1:
        del A[B]
        del C[B]
        if B <= 0:
            goto lbl_0
        B -= 1
        lbl_0:
        smallMessage(getAllPlayers(), "Checkpoint has been deleted")
    elif eventPlayer.E == 2 and len(H) != 0:
        del H[J]
        del I[J]
        del killballnumber[J]
        destroyEffect(K[J])
        del K[J]
        if J <= 0:
            goto lbl_1
        J -= 1
        lbl_1:
        L = H[J]
    elif eventPlayer.E == 3 and len(TQ) != 0:
        del TQ[TQ1]
        del EditMode[TQ1]
        del TQ5[TQ1]
        del TQ6[TQ1]
        destroyEffect(TQ2[TQ1])
        del TQ2[TQ1]
        del pinballnumber[TQ1]
        if TQ1 <= 0:
            goto lbl_2
        TQ1 -= 1
        lbl_2:
        TQ3 = TQ[TQ1]


rule "Move checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer == hostPlayer
    
    smallMessage(getAllPlayers(), "Checkpoint {0} has been deleted".format(B) if len(A[B]) != 0 else "")
    A[B] = eventPlayer.getPosition() - vect(0, 0, 0)
    smallMessage(getAllPlayers(), "Checkpoint has been moved to your position")


rule "Add a teleport":
    @Condition (hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD)) == true
    @Condition len(A) > 1
    @Condition hostPlayer.E == 1
    @Condition B > 0
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == false
    
    if hostPlayer.isHoldingButton(Button.MELEE) == true:
        return
    A[B] = [A[B][0] if len(A[B]) != 0 else A[B], hostPlayer.getPosition()]
    smallMessage(getAllPlayers(), "Teleport has been added for level {0}".format(B))


rule "Swap selected point (back)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.E == 1:
        if B <= 0:
            goto lbl_0
        B -= 1
        lbl_0:
    elif eventPlayer.E == 2:
        if J <= 0:
            goto lbl_1
        J -= 1
        L = H[J]
        lbl_1:
    elif eventPlayer.E == 3:
        if TQ1 <= 0:
            goto lbl_2
        TQ1 -= 1
        TQ3 = TQ[TQ1]
        lbl_2:


rule "Swap selected point (forward)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.E == 1:
        if B == len(A) - 1:
            goto lbl_0
        B += 1
        lbl_0:
    elif eventPlayer.E == 2:
        if J == len(H) - 1:
            goto lbl_1
        J += 1
        L = H[J]
        lbl_1:
    elif eventPlayer.E == 3:
        if TQ1 == len(TQ) - 1:
            goto lbl_2
        TQ1 += 1
        TQ3 = TQ[TQ1]
        lbl_2:


rule "Bouncing Ball turn on/off ultimate":
    @Event eachPlayer
    @Condition (eventPlayer.isHoldingButton(Button.ULTIMATE) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.E == 3
    @Condition len(TQ) != 0
    
    wait(1)
    if TQ5[TQ1] == false:
        TQ5[TQ1] = true
    elif TQ5[TQ1] == true:
        TQ5[TQ1] = false


rule "Bouncing Ball turn on/off dash":
    @Event eachPlayer
    @Condition (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.isHoldingButton(Button.ULTIMATE)) == true
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.E == 3
    @Condition len(TQ) != 0
    
    wait(1)
    if TQ6[TQ1] == false:
        TQ6[TQ1] = true
    elif TQ6[TQ1] == true:
        TQ6[TQ1] = false


rule "Guide HUD":
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.K), HudPosition.RIGHT, -2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.K), HudPosition.RIGHT, -1, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.K), HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{{0}}".format(hostPlayer.K), HudPosition.LEFT, -12, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), "{{0}}".format(hostPlayer.K), null, [].concat("").concat("").concat("").concat("Hold Q+LMB=Turn Ultimate On/Off\r\nHold Q+RMB=Turn Dash On/Off")[hostPlayer.E], HudPosition.LEFT, -6, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Guide HUD effects":
    createIcon(getAllPlayers(), A[B] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
    createInWorldText(getAllPlayers(), "Selected Checkpoint", A[B] + vect(0, 0.5, 0), 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, H[J], I[J], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.PURPLE, TQ[TQ1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #轻易别打开，动作太长会
    hudText(getAllPlayers(), [].concat(0).concat("Selected Checkpoint's number: {0}".format(B)).concat("Current Killing Sphere's radius: {0}".format(I[J])).concat("Current Bouncing Ball's strenght: {0}".format(EditMode[TQ1]))[hostPlayer.E], null, [].concat("").concat("").concat("").concat("Current Bouncing Ball's Ultimate: {0}\r\nCurrent Bouncing Ball's Dash: {1}".format(TQ5[TQ1], TQ6[TQ1]))[hostPlayer.E], HudPosition.TOP, -14, Color.RED, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers(), "Selected Killing Sphere", H[J], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    createEffect(getAllPlayers(), Effect.ORB, Color.RED, L, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(hostPlayer, l"{0} m".format(distance(hostPlayer, L)), L - vect(0, 1.5, 0), 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT)
    createIcon(getAllPlayers(), H[J] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)


rule "Hide excess checkpoints":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer == hostPlayer
    
    for B in range(len(C) - 1, 0, -1):
        destroyEffect(C[B])
        del C[B]
    B = -2


rule "Show checkpoints":
    @Condition B == -2
    
    for B in range(len(A)):
        createEffect(getAllPlayers(), Effect.RING, Color.RED, A[B], 1, EffectReeval.VISIBILITY)
        C.append(getLastCreatedEntity())


rule "Jump to next checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.A < len(A) - 1
    
    eventPlayer.A += 1
    eventPlayer.teleport(A[eventPlayer.A])
    P[eventPlayer.A].append(eventPlayer)
    P[eventPlayer.A - 1].remove(eventPlayer)


rule "Jump to previous checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.A != 0
    
    eventPlayer.teleport(A[eventPlayer.A - 1])
    eventPlayer.A -= 1
    P[eventPlayer.A].append(eventPlayer)
    P[eventPlayer.A + 1].remove(eventPlayer)


rule "------------------------------------------------------Turn off the rules above after finishing editing--------------------------":
    @Delimiter

rule "Setup and Variables":
    disableInspector()
    getAllPlayers().disableRespawn()
    disableGamemodeCompletion()
    disableScoring()
    disableMusic()
    pauseMatchTime()
    Dao = []
    SHIFT = []
    pinballnumber = []
    killballnumber = []
    A = []
    F = []
    G = []
    H = []
    I = []
    K = []
    J = 0
    Q = []
    TQ = []
    TQ2 = []
    EditMode = []
    TQ1 = 0
    TQ5 = []
    TQ6 = []
    wait(1)
    B = len(A) - 1
    KILLBALL()
    wait(2)
    pinball()
    if getCurrentGamemode() == Gamemode.SKIRMISH:
        hudText(getAllPlayers(), "", null, l"{0} {1} {2}".format("Time left until server resets:", 270 - floor(getTotalTimeElapsed() / 60), "Minutes"), HudPosition.RIGHT, -15, Color.WHITE, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    else:
        hudText(getAllPlayers(), "", null, l"{0} {1} {2}".format("Time left until server resets:", 90 - floor(getTotalTimeElapsed() / 60), "Minutes"), HudPosition.RIGHT, -15, Color.WHITE, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    save = []
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
    kz_xs = createWorkshopSetting(bool, "Extended function", "Level time limit", false, 0)


def Sub0():
    @Name "Checkpoint | Effect |-------------------------------------------------SUB0"
    
    createEffect(eventPlayer, Effect.RING, Color.SKY_BLUE, A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.B[0] = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.RING, Color.LIME_GREEN, A[eventPlayer.A + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.B[1] = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.LIGHT_SHAFT, Color.WHITE, A[eventPlayer.A + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.B[2] = getLastCreatedEntity()
    createIcon(eventPlayer, A[eventPlayer.A + 1] + vect(0, 1, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.SKY_BLUE, true)
    eventPlayer.B[3] = getLastCreatedEntity()
    createInWorldText(eventPlayer, "Come here", A[eventPlayer.A + 1], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.B[4] = getLastCreatedText()


def Sub1():
    @Name "Checkpoint | Start the game |-------------------------------------SUB1"
    
    if len(A) != 0:
        if ("{0}".format(eventPlayer) in save and kz_xs == false) == true:
            #if "{0}".format(eventPlayer) in save == true:
            eventPlayer.A = save[save.index("{0}".format(eventPlayer)) + 1]
            eventPlayer.D = save[save.index("{0}".format(eventPlayer)) + 2]
            save[save.index("{0}".format(eventPlayer)) + 3] = eventPlayer
            save[save.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
            save[save.index("{0}".format(eventPlayer)) + 5] = 0
            save[save.index("{0}".format(eventPlayer)) + 6] = 0
            eventPlayer.teleport(A[save[save.index("{0}".format(eventPlayer)) + 1]] + vect(0, 1, 0))
        else:
            eventPlayer.teleport(A[0] + vect(0, 1, 0))
            eventPlayer.A = 0
            eventPlayer.D = 0
            stopChasingVariable(eventPlayer.ztjs)
            eventPlayer.ztjs = 0
            save.append(["{0}".format(eventPlayer), eventPlayer.A, eventPlayer.D, eventPlayer, getTotalTimeElapsed(), 0, 0])
    chase(eventPlayer.D, abs(9999999), rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.G = 0
    eventPlayer.H = []
    if eventPlayer.E < 1:
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setUltEnabled(false)
    else:
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    P[eventPlayer.A].append(eventPlayer)
    eventPlayer.C = 0


def KILLBALL():
    @Name "Checkpoint | Killing Sphere effect |-------------------------------------SUB"
    
    if H == []:
        return
    NANBA = 0
    createEffect(sorted(P[killballnumber[0]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 1
    createEffect(sorted(P[killballnumber[1]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 2
    createEffect(sorted(P[killballnumber[2]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 3
    createEffect(sorted(P[killballnumber[3]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 4
    createEffect(sorted(P[killballnumber[4]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 5
    createEffect(sorted(P[killballnumber[5]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 6
    createEffect(sorted(P[killballnumber[6]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 7
    createEffect(sorted(P[killballnumber[7]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 8
    createEffect(sorted(P[killballnumber[8]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 9
    createEffect(sorted(P[killballnumber[9]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 10
    createEffect(sorted(P[killballnumber[10]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 11
    createEffect(sorted(P[killballnumber[11]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 12
    createEffect(sorted(P[killballnumber[12]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 13
    createEffect(sorted(P[killballnumber[13]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 14
    createEffect(sorted(P[killballnumber[14]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 15
    createEffect(sorted(P[killballnumber[15]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 16
    createEffect(sorted(P[killballnumber[16]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 17
    createEffect(sorted(P[killballnumber[17]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 18
    createEffect(sorted(P[killballnumber[18]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 19
    createEffect(sorted(P[killballnumber[19]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 20
    createEffect(sorted(P[killballnumber[20]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 21
    createEffect(sorted(P[killballnumber[21]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 22
    createEffect(sorted(P[killballnumber[22]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 23
    createEffect(sorted(P[killballnumber[23]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 24
    createEffect(sorted(P[killballnumber[24]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 25
    createEffect(sorted(P[killballnumber[25]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 26
    createEffect(sorted(P[killballnumber[26]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 27
    createEffect(sorted(P[killballnumber[27]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 28
    createEffect(sorted(P[killballnumber[28]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 29
    createEffect(sorted(P[killballnumber[29]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 30
    createEffect(sorted(P[killballnumber[30]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 31
    createEffect(sorted(P[killballnumber[31]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 32
    createEffect(sorted(P[killballnumber[32]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 33
    createEffect(sorted(P[killballnumber[33]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 34
    createEffect(sorted(P[killballnumber[34]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 35
    createEffect(sorted(P[killballnumber[35]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 36
    createEffect(sorted(P[killballnumber[36]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 37
    createEffect(sorted(P[killballnumber[37]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 38
    createEffect(sorted(P[killballnumber[38]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 39
    createEffect(sorted(P[killballnumber[39]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 40
    createEffect(sorted(P[killballnumber[40]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 41
    createEffect(sorted(P[killballnumber[41]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 42
    createEffect(sorted(P[killballnumber[42]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 43
    createEffect(sorted(P[killballnumber[43]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 44
    createEffect(sorted(P[killballnumber[44]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 45
    createEffect(sorted(P[killballnumber[45]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 46
    createEffect(sorted(P[killballnumber[46]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 47
    createEffect(sorted(P[killballnumber[47]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 48
    createEffect(sorted(P[killballnumber[48]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 49
    createEffect(sorted(P[killballnumber[49]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return
    NANBA = 50
    createEffect(sorted(P[killballnumber[50]]), Effect.SPHERE, Color.BLUE, H[NANBA], I[NANBA], EffectReeval.VISIBILITY)
    K.append(getLastCreatedEntity())
    if NANBA == len(H) - 1:
        return


def pinball():
    @Name "Checkpoint | Bouncing Ball effect |-------------------------------------SUB"
    
    if TQ == []:
        return
    NANBA = 0
    createEffect(sorted(P[pinballnumber[0]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 1
    createEffect(sorted(P[pinballnumber[1]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 2
    createEffect(sorted(P[pinballnumber[2]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 3
    createEffect(sorted(P[pinballnumber[3]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 4
    createEffect(sorted(P[pinballnumber[4]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 5
    createEffect(sorted(P[pinballnumber[5]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 6
    createEffect(sorted(P[pinballnumber[6]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 7
    createEffect(sorted(P[pinballnumber[7]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 8
    createEffect(sorted(P[pinballnumber[8]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 9
    createEffect(sorted(P[pinballnumber[9]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 10
    createEffect(sorted(P[pinballnumber[10]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 11
    createEffect(sorted(P[pinballnumber[11]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 12
    createEffect(sorted(P[pinballnumber[12]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 13
    createEffect(sorted(P[pinballnumber[13]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 14
    createEffect(sorted(P[pinballnumber[14]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 15
    createEffect(sorted(P[pinballnumber[15]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 16
    createEffect(sorted(P[pinballnumber[16]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 17
    createEffect(sorted(P[pinballnumber[17]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 18
    createEffect(sorted(P[pinballnumber[18]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 19
    createEffect(sorted(P[pinballnumber[19]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 20
    createEffect(sorted(P[pinballnumber[20]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 21
    createEffect(sorted(P[pinballnumber[21]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 22
    createEffect(sorted(P[pinballnumber[22]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 23
    createEffect(sorted(P[pinballnumber[23]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 24
    createEffect(sorted(P[pinballnumber[24]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 25
    createEffect(sorted(P[pinballnumber[25]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 26
    createEffect(sorted(P[pinballnumber[26]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 27
    createEffect(sorted(P[pinballnumber[27]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 28
    createEffect(sorted(P[pinballnumber[28]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 29
    createEffect(sorted(P[pinballnumber[29]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 30
    createEffect(sorted(P[pinballnumber[30]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 31
    createEffect(sorted(P[pinballnumber[31]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 32
    createEffect(sorted(P[pinballnumber[32]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 33
    createEffect(sorted(P[pinballnumber[33]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 34
    createEffect(sorted(P[pinballnumber[34]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 35
    createEffect(sorted(P[pinballnumber[35]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 36
    createEffect(sorted(P[pinballnumber[36]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 37
    createEffect(sorted(P[pinballnumber[37]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 38
    createEffect(sorted(P[pinballnumber[38]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 39
    createEffect(sorted(P[pinballnumber[39]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 40
    createEffect(sorted(P[pinballnumber[40]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 41
    createEffect(sorted(P[pinballnumber[41]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 42
    createEffect(sorted(P[pinballnumber[42]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 43
    createEffect(sorted(P[pinballnumber[43]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 44
    createEffect(sorted(P[pinballnumber[44]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 45
    createEffect(sorted(P[pinballnumber[45]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 46
    createEffect(sorted(P[pinballnumber[46]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 47
    createEffect(sorted(P[pinballnumber[47]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 48
    createEffect(sorted(P[pinballnumber[48]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 49
    createEffect(sorted(P[pinballnumber[49]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 50
    createEffect(sorted(P[pinballnumber[50]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 51
    createEffect(sorted(P[pinballnumber[51]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 52
    createEffect(sorted(P[pinballnumber[52]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 53
    createEffect(sorted(P[pinballnumber[53]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 54
    createEffect(sorted(P[pinballnumber[54]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 55
    createEffect(sorted(P[pinballnumber[55]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 56
    createEffect(sorted(P[pinballnumber[56]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 57
    createEffect(sorted(P[pinballnumber[57]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 58
    createEffect(sorted(P[pinballnumber[58]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 59
    createEffect(sorted(P[pinballnumber[59]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 60
    createEffect(sorted(P[pinballnumber[60]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 61
    createEffect(sorted(P[pinballnumber[61]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 62
    createEffect(sorted(P[pinballnumber[62]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 63
    createEffect(sorted(P[pinballnumber[63]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 64
    createEffect(sorted(P[pinballnumber[64]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 65
    createEffect(sorted(P[pinballnumber[65]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 66
    createEffect(sorted(P[pinballnumber[66]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 67
    createEffect(sorted(P[pinballnumber[67]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 68
    createEffect(sorted(P[pinballnumber[68]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 69
    createEffect(sorted(P[pinballnumber[69]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 70
    createEffect(sorted(P[pinballnumber[70]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 71
    createEffect(sorted(P[pinballnumber[71]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 72
    createEffect(sorted(P[pinballnumber[72]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 73
    createEffect(sorted(P[pinballnumber[73]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 74
    createEffect(sorted(P[pinballnumber[74]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return
    NANBA = 75
    createEffect(sorted(P[pinballnumber[75]]), Effect.ORB, Color.GREEN, TQ[NANBA], 1, EffectReeval.VISIBILITY)
    TQ2.append(getLastCreatedEntity())
    if NANBA == len(TQ) - 1:
        return


rule "Checkpoint | Position <---------------------------------------------------------------------------- paste here!":
    @Delimiter

rule "Checkpoint | HUD":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.setDamageDealt(0)
    if eventPlayer in Q:
        hudSubtext(eventPlayer, l"{0} {1}".format("level ", l"{0} / {1}".format(eventPlayer.A, len(A) - 1)), HudPosition.TOP, -13, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudSubtext(eventPlayer, l"{0} {1} {2}".format("Time", l"{0} sec".format(eventPlayer.D), "| time limit: {0}".format(eventPlayer.L) if kz_xs else ""), HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    Q.append(eventPlayer)
    #子程序1为游戏的初始化设置
    Sub1()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    #玩家F：自杀防止复活
    eventPlayer.F = 0
    #玩家I：教程HUD
    eventPlayer.I = 2
    #玩家J：爬墙提示HUD
    eventPlayer.J = 2
    #子程序0为检查点效果显示
    Sub0()


rule "Checkpoint | Arrived":
    @Event eachPlayer
    @Condition distance(eventPlayer, A[eventPlayer.A + 1]) <= 1.4
    @Condition eventPlayer.A < len(A) - 1
    @Condition eventPlayer.isOnGround() == true
    @Condition (eventPlayer.E >= 1 or eventPlayer.C == 0) == true
    
    eventPlayer.A += 1
    if kz_xs:
        smallMessage(eventPlayer, "Arrived at {0}/{1}".format(eventPlayer.A, len(A) - 1))
    else:
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        save.remove("{0}".format(eventPlayer))
        save.append(["{0}".format(eventPlayer), eventPlayer.A, eventPlayer.D, eventPlayer, getTotalTimeElapsed(), 0, 0])
        playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, A[eventPlayer.A] + vect(0, 1.5, 0), 4)
        bigMessage(eventPlayer, l"{0} {1}".format("Arrived at", l"{0} / {1}".format(eventPlayer.A, len(A) - 1)))
    P[eventPlayer.A].append(eventPlayer)
    P[eventPlayer.A - 1].remove(eventPlayer)
    if eventPlayer.E < 1:
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
    if eventPlayer.E >= 1:
        return
    if eventPlayer.A >= len(A) - 1:
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        stopChasingVariable(eventPlayer.D)
        bigMessage(getAllPlayers(), l"{0} {1} {2}".format(eventPlayer, "Mission complete! Time", l"{0} sec".format(eventPlayer.D)))
        destroyEffect(eventPlayer.B[0])
        destroyEffect(eventPlayer.B[1])
        destroyEffect(eventPlayer.B[2])
        destroyIcon(eventPlayer.B[3])
        destroyInWorldText(eventPlayer.B[4])
        #F传送门开关
        F.append(eventPlayer)
        #G传送门开关
        G.append(eventPlayer)
        #H传送门字符串
        eventPlayer.H = 2
    if kz_xs == true:
        eventPlayer.L = 0
        chase(eventPlayer.L, 10, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "nope":
    @Event eachPlayer
    
    getAllPlayers().disableGamemodeHud()


rule "Killing Sphere | Damage":
    @Event eachPlayer
    @Hero genji
    @Condition (killballnumber[H.index(([player for player in H if distance(eventPlayer, player) <= I[H.index(player)]])[0])] == eventPlayer.A or killballnumber[H.index(([player for player in H if distance(eventPlayer, player) <= I[H.index(player)]])[1])] == eventPlayer.A or killballnumber[H.index(([player for player in H if distance(eventPlayer, player) <= I[H.index(player)]])[2])] == eventPlayer.A or killballnumber[H.index(([player for player in H if distance(eventPlayer, player) <= I[H.index(player)]])[3])] == eventPlayer.A) == true
    @Condition eventPlayer.A != 0
    @Condition eventPlayer.A < len(A) - 1
    @Condition eventPlayer.C == 0
    
    kill(eventPlayer, null)


rule "Bouncing Ball | Properties":
    @Event eachPlayer
    @Hero genji
    @Condition pinballnumber[TQ.index([player for player in TQ if distance(eventPlayer, player) <= 1.2])] == eventPlayer.A == true
    @Condition eventPlayer.A != 0
    
    eventPlayer.applyImpulse(Vector.UP, EditMode[TQ.index([player for player in TQ if distance(eventPlayer.getPosition(), player) <= 2])], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    #eventPlayer.setAbility1Enabled(TQ6[TQ.index([player for player in TQ if distance(eventPlayer.getPosition(), player) <= 2])])
    #eventPlayer.setUltEnabled(TQ5[TQ.index([player for player in TQ if distance(eventPlayer.getPosition(), player) <= 2])])
    if TQ6[TQ.index([player for player in TQ if distance(eventPlayer.getPosition(), player) <= 2])] == true:
        eventPlayer.setAbility1Enabled(true)
        smallMessage(eventPlayer, "Dash is ready")
    if TQ5[TQ.index([player for player in TQ if distance(eventPlayer.getPosition(), player) <= 2])] == true:
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        smallMessage(eventPlayer, "Ultimate is ready")


rule "Data for Top 5":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.A == len(A) - 1
    @Condition eventPlayer.E < 1
    
    del save[save.index("{0}".format(eventPlayer)) + 1]
    del save[save.index("{0}".format(eventPlayer)) + 1]
    del save[save.index("{0}".format(eventPlayer)) + 1]
    del save[save.index("{0}".format(eventPlayer)) + 1]
    del save[save.index("{0}".format(eventPlayer)) + 1]
    del save[save.index("{0}".format(eventPlayer)) + 1]
    save.remove("{0}".format(eventPlayer))
    if eventPlayer.B[7] == null:
        eventPlayer.T = eventPlayer.D
        hudText(null if toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))] in toplistSortedTimes == true else getAllPlayers(), heroIcon(Hero.GENJI), eventPlayer, "{0} sec".format(eventPlayer.T), HudPosition.RIGHT, eventPlayer.T, rgb(158, 255, 187), rgb(158, 255, 187), rgb(158, 255, 187), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)
        eventPlayer.B[7] = getLastCreatedText()
    else:
        if eventPlayer.D > eventPlayer.T:
            goto lbl_0
        eventPlayer.T = eventPlayer.D
        lbl_0:
    #Save data for the Top 5 list
    if "{0}".format(eventPlayer) in toplistPlayers == true:
        if eventPlayer.D >= toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))]:
            goto lbl_1
        toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))] = eventPlayer.D
        lbl_1:
    else:
        toplistPlayers.append("{0}".format(eventPlayer))
        toplistTimes[toplistPlayers.index("{0}".format(eventPlayer))] = eventPlayer.D
    #Reload the Sorted Array Times
    toplistSortedTimes = sorted(toplistTimes).slice(0, 6)
    stopChasingVariable(eventPlayer.ztjs)
    eventPlayer.ztjs = 0


rule "Checkpoint | Finish effects":
    @Event eachPlayer
    @Condition eventPlayer.A == len(A) - 1
    @Condition eventPlayer.E < 1
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
    @Condition eventPlayer.F != 1
    @Condition len(A) >= 2
    
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.resurrect()
    if kz_xs == true:
        eventPlayer.L = 0
        stopChasingVariable(eventPlayer.L)
        eventPlayer.A = eventPlayer.A if eventPlayer.E > 0 else 0
    eventPlayer.teleport(A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A])


rule "Landing on Checkpoint (In some circumstances turn off?)":
    @Event eachPlayer
    @Hero genji
    @Condition (((distance(eventPlayer, A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A])) > 1.4) or false) == true
    @Condition (eventPlayer.isOnGround() == true or false) == true
    @Condition eventPlayer.A < len(A) - 1
    @Condition len(A) >= 2
    @Condition eventPlayer.C != 1
    @Condition eventPlayer.F != 1
    #做特定关卡开启落地死亡再打开
    #@Condition (eventPlayer.A == -1 or eventPlayer.A == -1 or eventPlayer.A == -1 or false) == true
    
    if eventPlayer.E < 1:
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setUltEnabled(false)
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)
    if kz_xs == true:
        eventPlayer.L = 0
        stopChasingVariable(eventPlayer.L)
        eventPlayer.A = eventPlayer.A if eventPlayer.E > 0 else 0
    eventPlayer.teleport(A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A])
    if deathjump == true:
        eventPlayer.disallowButton(Button.JUMP)
        wait(0.1)
        eventPlayer.allowButton(Button.JUMP)
    if eventPlayer.A == 0:
        eventPlayer.D = 0
    if eventPlayer.isUsingUltimate() == true:
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
    
    if "{0}".format(eventPlayer) in save == true:
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        del save[save.index("{0}".format(eventPlayer)) + 1]
        save.remove("{0}".format(eventPlayer))
    P[eventPlayer.A].remove(eventPlayer)
    if eventPlayer.A >= len(A) - 1:
        Sub0()
        #这条动作为“消除玩家通关成绩显示”
        destroyHudText(eventPlayer.B[7])
        #效果B5.B6代表的是光环通关特效，需保持和规则“通关特效”同步开启/关闭
        #destroyEffect(eventPlayer.B[5])
        #destroyEffect(eventPlayer.B[6])
    Sub1()
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    F.remove(eventPlayer)
    G.remove(eventPlayer)


rule "Combo | Spectate | Interact":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.E < 1
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "Hold Interact again to turn off spectate mode")
    if eventPlayer.isAlive() == true:
        if eventPlayer.A < len(A) - 1:
            chase(eventPlayer.ztjs, abs(999999), rate=1, ChaseReeval.DESTINATION_AND_RATE)
            save[save.index("{0}".format(eventPlayer)) + 2] = eventPlayer.D
            save[save.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
            save[save.index("{0}".format(eventPlayer)) + 6] = 1
        eventPlayer.setRespawnTime(9999)
        eventPlayer.F = 1
        stopChasingVariable(eventPlayer.D)
        wait(0.2)
        kill(eventPlayer, null)
        eventPlayer.teleport(A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A])
    else:
        if eventPlayer.E >= 1:
            goto lbl_0
        eventPlayer.respawn()
        eventPlayer.F = 0
        lbl_0:
        eventPlayer.teleport(A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A])
        if eventPlayer.A >= len(A) - 1:
            goto lbl_1
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        chase(eventPlayer.D, 10000, rate=1, ChaseReeval.DESTINATION_AND_RATE)
        lbl_1:
        eventPlayer.setRespawnTime(0)
        eventPlayer.C = 0
        if eventPlayer.A < len(A) - 1:
            stopChasingVariable(eventPlayer.ztjs)
            save[save.index("{0}".format(eventPlayer)) + 5] = eventPlayer.ztjs
            eventPlayer.ztjs = 0
            save[save.index("{0}".format(eventPlayer)) + 6] = 0
    if kz_xs == false:
        goto lbl_2
    eventPlayer.A = 0
    lbl_2:


rule "Initialization | Double jump | Bhop":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    #变量A后的数字“-1”为关卡数，具体操作参考“给刀”。此条规则开启效果为“特定关卡开启三段”，关闭则为“所有关卡封禁三段”
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #注释一定要看！此条条件开启的效果为“通关后自动开启三段”，关闭则通关后仍封禁三段
    #@Condition eventPlayer.A < len(A) - 1
    
    eventPlayer.TY = 0
    eventPlayer.J = 2
    wait(0)
    if (eventPlayer.TY != 0 or eventPlayer.J != 2) and eventPlayer.isOnGround() == true:
        goto RULE_START
    eventPlayer.O = 1


rule "二段跳，小跳初始化":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    #变量A后的数字“-1”为关卡数，具体操作参考“给刀”。此条规则开启效果为“特定关卡开启三段”，关闭则为“所有关卡封禁三段”
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #注释一定要看！此条条件开启的效果为“通关后自动开启三段”，关闭则通关后仍封禁三段
    #@Condition eventPlayer.A < len(A) - 1
    
    eventPlayer.TY = 0
    eventPlayer.J = 2
    eventPlayer.climbNum = 0
    wait(0)
    if (eventPlayer.TY != 0 or eventPlayer.J != 2) and eventPlayer.isOnGround() == true:
        goto RULE_START
    eventPlayer.O = 1


rule "Checking | Jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.TY != 2
    #变量A后的数字“-1”为关卡数，具体操作参考“给刀”。此条规则开启效果为“特定关卡开启三段”，关闭则为“所有关卡封禁三段
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #注释一定要看！此条条件开启的效果为“通关后自动开启三段”，关闭则通关后仍封禁三
    #@Condition eventPlayer.A < len(A) - 1
    
    eventPlayer.TY += 1


rule "Checking | Bhop in the air":
    @Event eachPlayer
    @Condition eventPlayer.TY == 0
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    
    eventPlayer.O = 0


rule "Checking | In the air":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.TY == 0
    @Condition eventPlayer.isInAir() == true
    #变量A后的数字“-1”为关卡数，具体操作参考“给刀”。此条规则开启效果为“特定关卡开启三段”，关闭则为“所有关卡封禁三段
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #注释一定要看！此条条件开启的效果为“通关后自动开启三段”，关闭则通关后仍封禁三
    #@Condition eventPlayer.A < len(A) - 1
    
    eventPlayer.TY = 1


rule "Checking | Triple jump":
    @Event eachPlayer
    @Condition eventPlayer.TY == 1
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.TY = 2


rule "Checking | Player on the wall":
    @Event eachPlayer
    #此条规则同时与爬墙判定挂钩，请勿关闭/删除
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.TY = 2
    eventPlayer.J = 1


rule "Combo | Invincible/Normal mode":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.A < len(A) - 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.startForcingPosition(A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A], true)
    if eventPlayer.C == 0:
        chase(eventPlayer.ztjs, abs(999999), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        save[save.index("{0}".format(eventPlayer)) + 2] = eventPlayer.D
        save[save.index("{0}".format(eventPlayer)) + 4] = getTotalTimeElapsed()
        save[save.index("{0}".format(eventPlayer)) + 6] = 1
        if kz_xs == false:
            goto lbl_0
        smallMessage(eventPlayer, "Press ctrl+LMB/RMB to jump next/prev")
        stopChasingVariable(eventPlayer.L)
        lbl_0:
        stopChasingVariable(eventPlayer.D)
        bigMessage(eventPlayer, "Invincible mode")
        eventPlayer.stopForcingPosition()
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        eventPlayer.setAbility1Enabled(true)
        wait(0.2)
        eventPlayer.C = 1
    else:
        if eventPlayer.E >= 1:
            goto lbl_1
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        lbl_1:
        if kz_xs == false:
            goto lbl_2
        eventPlayer.A = 0
        lbl_2:
        eventPlayer.teleport(A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A])
        wait(0.1)
        eventPlayer.C = 0
        bigMessage(eventPlayer, "Normal mode")
        chase(eventPlayer.D, abs(9999999), rate=1, ChaseReeval.DESTINATION_AND_RATE)
        eventPlayer.stopForcingPosition()
        stopChasingVariable(eventPlayer.ztjs)
        save[save.index("{0}".format(eventPlayer)) + 5] = eventPlayer.ztjs
        eventPlayer.ztjs = 0
        save[save.index("{0}".format(eventPlayer)) + 6] = 0


rule "Ultimate charge":
    @Event eachPlayer
    @Condition eventPlayer.getUltCharge() < 100
    
    eventPlayer.setUltCharge(100)


rule "Checking | Using Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    
    eventPlayer.O = 0


rule "Checking | Bhop":
    @Event eachPlayer
    @Condition eventPlayer.O == 0
    @Condition eventPlayer.isJumping() == true
    
    eventPlayer.O = 1
    smallMessage(eventPlayer, "Bhop")


rule "Player left the game":
    @Event playerLeft
    
    Q.remove(eventPlayer)
    if save[save.index(eventPlayer) - 2] == 0:
        del save[save.index(eventPlayer) + 1]
        del save[save.index(eventPlayer) + 1]
        del save[save.index(eventPlayer) + 1]
        del save[save.index(eventPlayer) - 1]
        del save[save.index(eventPlayer) - 1]
        del save[save.index(eventPlayer) - 1]
        save.remove(eventPlayer)
    else:
        if save[save.index(eventPlayer) - 2] >= len(A) - 1:
            goto lbl_0
        if save[save.index(eventPlayer) + 3] == 1:
            goto lbl_1
        save[save.index(eventPlayer) - 1] = getTotalTimeElapsed() - (save[save.index(eventPlayer) + 1]) - (save[save.index(eventPlayer) + 2]) + (save[save.index(eventPlayer) - 1])
        lbl_0:
        lbl_1:
        save[save.index(eventPlayer) + 2] = 0
        save[save.index(eventPlayer) + 3] = 0


rule "Create Bhop Climb HUD Text":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    wait(1)
    hudHeader(eventPlayer, "Bhop", HudPosition.LEFT, 1, Color.GREEN if eventPlayer.O == 0 else eventPlayer.CH, HudReeval.COLOR, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "Climb", HudPosition.LEFT, 2, eventPlayer.CG, HudReeval.COLOR, SpecVisibility.DEFAULT)


rule "爬墙未用HUD___Counter":
    @Event eachPlayer
    @Condition eventPlayer.J == 2
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.paqiang)
    hudHeader(eventPlayer, "Climb{0}".format("({0})".format(eventPlayer.climbNum) if eventPlayer.climbNum > 0 else ""), HudPosition.LEFT, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.paqiang = getLastCreatedText()


rule "爬墙已用HUD___Counter":
    @Event eachPlayer
    @Condition eventPlayer.J == 1
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.paqiang)
    hudHeader(eventPlayer, "Climb", HudPosition.LEFT, 2, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.paqiang = getLastCreatedText()
    if eventPlayer.HUB_DOTS_INDEX == 2:
        smallMessage(eventPlayer, "Wallclimb ")


rule "爬墙计数":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.J == 2
    @Condition eventPlayer.C == 0
    
    eventPlayer.climbNum += 1


rule "Bhop Green":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    
    eventPlayer.CH = Color.GREEN


rule "Bhop Red":
    @Event eachPlayer
    @Condition eventPlayer.isJumping() == true
    
    eventPlayer.CH = Color.RED


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
    eventPlayer.O = 0
    if kaxiaotiao == true:
        kill(eventPlayer, null)
        smallMessage(eventPlayer, l"{0} {1}".format(heroIcon(Hero.GENJI), ": Double Bhop is disabled"))


rule "Combo | Quick Reset":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.E < 1
    
    if eventPlayer.isHoldingButton(Button.MELEE) == true:
        return
    if eventPlayer.quick_restart == true:
        eventPlayer.startForcingPosition(A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A], true)
        if eventPlayer.E >= 1 or eventPlayer.C == 1:
            goto lbl_0
        eventPlayer.setUltEnabled(false)
        eventPlayer.setAbility1Enabled(false)
        lbl_0:
        eventPlayer.teleport(A[eventPlayer.A][1] if len(A[eventPlayer.A]) != 0 else A[eventPlayer.A])
        wait(0.1)
        eventPlayer.stopForcingPosition()
    wait(1, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.quick_restart == false:
        eventPlayer.quick_restart = true
        bigMessage(eventPlayer, "Quick reset is enabled")
        playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    elif eventPlayer.quick_restart == true:
        playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
        eventPlayer.quick_restart = false
        bigMessage(eventPlayer, "Quick reset is disabled")


rule "Limit Ultimate":
    @Event eachPlayer
    @Hero genji
    #此条规则作用为：在跑图时令SHIFT只能使用一次
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.A < len(A) - 1
    @Condition eventPlayer.E < 1
    @Condition eventPlayer.C == 0
    
    eventPlayer.setUltEnabled(false)


rule "Lmit Dash":
    @Event eachPlayer
    #此条规则作用为：在跑图时令SHIFT只能使用一次
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.A < len(A) - 1
    @Condition eventPlayer.E < 1
    @Condition eventPlayer.C == 0
    
    eventPlayer.setAbility1Enabled(false)


rule "Give Blade":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.A < len(A) - 1
    @Condition (distance(eventPlayer, A[eventPlayer.A].last() if len(A[eventPlayer.A]) > 1 else A[eventPlayer.A])) <= 1.4
    @Condition eventPlayer.A in Dao == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(0.1)
    if eventPlayer.isUsingUltimate() == true:
        return
    eventPlayer.setUltEnabled(true)
    eventPlayer.setUltCharge(100)
    smallMessage(eventPlayer, "Ultimate is ready")


rule "Give Dash":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.A < len(A) - 1
    #@Condition distance(eventPlayer, A[eventPlayer.A]) <= 1.4
    @Condition (distance(eventPlayer, A[eventPlayer.A].last() if len(A[eventPlayer.A]) > 1 else A[eventPlayer.A])) <= 1.4
    @Condition eventPlayer.A in SHIFT == true
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setAbility1Enabled(true)
    smallMessage(eventPlayer, "Dash is ready")


rule "-------------------------------------------Addons-------------------------------------------------------":


/*
rule "Add Blade to Checkpoint":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Blade to Checkpoint 2 and 6 change one of "-1" to 2 and other "-1" to 6
    Dao = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
*/

/*
rule "Add Dash to Checkpoint":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    SHIFT = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
*/

/*
rule "Portal 1-2":
    @Event eachPlayer
    #将矢量（0，0，0）修改为开始的传送位置
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #将“-1”修改为传送门关卡的关卡数
    @Condition (eventPlayer.A == -1 or eventPlayer.A >= len(A) - 1) == true
    
    #将矢量（0，0，0）修改为传送结束的位置
    #eventPlayer.teleport(vect(0, 0, 0))
    #不想找坐标的，直接传送到关卡0
    #eventPlayer.teleport(A[0])
*/

/*
rule "Portal 2-3":
    @Event eachPlayer
    #将矢量（0，0，0）修改为开始的传送位置
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #将“-1”修改为传送门关卡的关卡数
    @Condition (eventPlayer.A == -1 or eventPlayer.A >= len(A) - 1) == true
    
    #将矢量（0，0，0）修改为传送结束的位置
    #eventPlayer.teleport(vect(0, 0, 0))
    #不想找坐标的，直接传送到关卡0
    #eventPlayer.teleport(A[0])
*/

/*
rule "Portal 3-1":
    @Event eachPlayer
    #将矢量（0，0，0）修改为开始的传送位置
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #将“-1”修改为传送门关卡的关卡数
    @Condition (eventPlayer.A == -1 or eventPlayer.A >= len(A) - 1) == true
    
    #将矢量（0，0，0）修改为传送结束的位置
    #eventPlayer.teleport(vect(0, 0, 0))
    #不想找坐标的，直接传送到关卡0
    #eventPlayer.teleport(A[0])
*/

/*
rule "In world text for certain Checkpoints":
    #createInWorldText(sorted(P[0]), "Text for checkpoint 0", vect(0, 0, 0), 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    #createInWorldText(sorted(P[1]), "Text for checkpoint 1", vect(0, 0, 0), 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    #createInWorldText(sorted(P[2]), "Text for checkpoint 2", vect(0, 0, 0), 3, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
*/

/*
rule "HUD text for certain Checkpoints":
    #hudHeader(sorted(P[0]), "Text for checkpoint 0", HudPosition.TOP, -4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(sorted(P[1]), "Text for checkpoint 1", HudPosition.TOP, -4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(sorted(P[2]), "Text for checkpoint 2", HudPosition.TOP, -4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
*/

/*
rule "orld text":
*/

/*
rule "DVA Bomb to destroy railings - Coordinates":
    DVA = []
    dva = 0
    #Change Vector (0, 0, 0) to position where DVA will detonate
    #DVA.append(vect(-78.678, 15.092, -97.781))
    #DVA.append(vect(-68.359, 16.199, -89.387))
    #DVA.append(vect(-79.1, 16.199, -88.1))
*/

/*
rule "Summon DVA":
    @Condition dva == 0
    @Condition len(getPlayers(Team.2)) < 6
    
    createDummy(Hero.DVA, Team.2, 5, DVA[dva], Vector.UP)
    dva += 1
    getPlayersOnHero(Hero.DVA, Team.ALL).startForcingButton(Button.ULTIMATE)
    wait(6.5)
    if dva < len(DVA):
        goto RULE_START
    getPlayersOnHero(Hero.DVA, Team.ALL).stopForcingButton(Button.ULTIMATE)
    destroyDummy(Team.2, 5)
*/

/*
rule "Portal Effect - Text":
    @Event eachPlayer
    
    #Change Vector (0, 0, 0) to starting position of Portal 1-2
    createInWorldText(eventPlayer, "{{0}}".format(eventPlayer.H), vect(276.288, -17.222, -74.522), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW, SpecVisibility.DEFAULT)
    #Change Vector (1, 1, 1) to starting position of Portal 2-3
    createInWorldText(eventPlayer, "{{0}}".format(eventPlayer.H), vect(1, 1, 1), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW, SpecVisibility.DEFAULT)
*/

/*
rule "Portal Effects":
    #Effects of Portal 1-2
    createEffect(F, Effect.RING, Color.LIME_GREEN, vect(0, 0, 0), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 1-2
    createEffect(F, Effect.LIGHT_SHAFT, Color.RED, vect(276.288, -17.222, -74.522), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 2-3
    createEffect(G, Effect.RING, Color.LIME_GREEN, vect(1, 1, 1), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 2-3
    createEffect(G, Effect.LIGHT_SHAFT, Color.RED, vect(1, 1, 1), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 3-1
    createEffect(F, Effect.RING, Color.LIME_GREEN, vect(2, 2, 2), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 3-1
    createEffect(F, Effect.LIGHT_SHAFT, Color.RED, vect(2, 2, 2), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Change Vector  (0, 0, 0) to starting position of Portal 3-1
    createInWorldText(F, "to next map", vect(0, 0, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW, SpecVisibility.DEFAULT)
*/

/*
rule "开启传送门视野—————————— 特定关卡时开启 ————————————":
    @Event eachPlayer
    #将“-1”分别改为两个传送门所在关卡的关卡数
    @Condition (eventPlayer.A == -1 or eventPlayer.A == -1 or eventPlayer.A >= len(A) - 1) == true
    
    eventPlayer.H = 1
    #将“-1”修改为第一个传送门所在的关卡数
    if eventPlayer.A == -1:
        F.append(eventPlayer)
        #将“-2”修改为第二个传送门所在的关卡数
    elif eventPlayer.A == -2:
        G.append(eventPlayer)
        #无需更改
    elif eventPlayer.A >= len(A) - 1:
        G.append(eventPlayer)
        F.append(eventPlayer)
        eventPlayer.H = 2
*/

/*
rule "关闭传送门视野—————————— 特定关卡时关闭 ————————————":
    @Event eachPlayer
    #将“-2”分别修改为两个传送门传送过去后的关卡数
    @Condition (eventPlayer.A == -2 or eventPlayer.A == -2 or false) == true
    
    eventPlayer.H = 0
    #将此处的“-2”修改为第一个传送门传送过去之后的关卡数
    if eventPlayer.A == -2:
        F.remove(eventPlayer)
        #将此处的“-2”修改为第二个传送门传送过去之后的关卡数
    elif eventPlayer.A == -2:
        G.remove(eventPlayer)
*/

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


rule "-------------------------------Workshop settings-------------------------":


rule "Ban | Triple Jump":
    @Event eachPlayer
    @Condition eventPlayer.getVerticalSpeed() >= 5.8
    @Condition eventPlayer.TY == 1
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Triple Jump", false, 0) == true
    
    if eventPlayer.isOnWall() == true:
        return
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)


rule "Ban | Multiclimb":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.J == 2
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Multiclimb", false, 1) == true
    
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    smallMessage(eventPlayer, l"{0} {1}".format(heroIcon(Hero.GENJI), ": Multiclimb is Disabled"))


rule "Ban | Double Bhop":
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Double Bhop", false, 2) == true
    
    kaxiaotiao = true


rule "Ban | Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    @Condition eventPlayer.A < len(A) - 1
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Emote", false, 3) == true
    
    kill(eventPlayer, null)
    smallMessage(eventPlayer, l"{0} {1}".format(heroIcon(Hero.GENJI), ": Emote jumping is disabled"))


rule "Ban | Bhop from Reset":
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban bhop from reset", false, 4) == true
    
    deathjump = true


rule "Extended function | Strengthen stall (家里有妖怪#5202 | Easier to stall | Jump farther)":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.getVerticalSpeed() >= -0.2 and eventPlayer.getVerticalSpeed() <= 0.05) == true
    @Condition eventPlayer.getHorizontalSpeed() <= 1.3
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isOnGround() == false
    @Condition createWorkshopSetting(bool, "Extended function", "Strengthen stall", false, 0) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    waitUntil(eventPlayer.isMoving() == false, 10)
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
    waitUntil(eventPlayer.isOnWall() == false, 1)
    eventPlayer.setStatusEffect(null, Status.HACKED, 0.1)
    wait(0.1)
    eventPlayer.clearStatusEffect(Status.HACKED)


rule "Extended function | Save climb into the checkpoint(TITANXPASCAL#5554 *Remember to create text to prompt players)":
    @Event eachPlayer
    @Condition distance(eventPlayer, A[eventPlayer.A + 1]) <= 2
    @Condition createWorkshopSetting(bool, "Extended function", "Save climb into the checkpoint", false, 2) == true
    #Change "-1" to certain Checkpoints' number
    @Condition eventPlayer.A in [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] == true
    #If all checkpoints need this function, enable this rule and disable Rule: "Array Contains" 
    #@Condition eventPlayer.A < len(A) - 1
    
    if eventPlayer.J == 1:
        kill(eventPlayer, null)
        smallMessage(eventPlayer, "Fail to meet clear condition: Save climb")


rule "Extended function | Save Bhop into the checkpoint(TITANXPASCAL#5554 *Remember to create text to prompt players)":
    @Event eachPlayer
    @Condition distance(eventPlayer, A[eventPlayer.A + 1]) <= 2
    @Condition createWorkshopSetting(bool, "Extended function", "Save Bhop into the checkpoint", false, 3) == true
    #Change "-1" to certain Checkpoints' number
    @Condition eventPlayer.A in [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] == true
    #If all checkpoints need this function, enable this rule and disable Rule: "Array Contains" 
    #@Condition eventPlayer.A < len(A) - 1
    
    if eventPlayer.O == 1:
        kill(eventPlayer, null)
        smallMessage(eventPlayer, "Fail to meet clear condition: Save bhop")


rule "rule 91":
    @Event eachPlayer
    @Condition (distance(eventPlayer, A[eventPlayer.A if eventPlayer.E > 0 else 0])) > 1.4
    @Condition kz_xs == true
    @Condition (0 if eventPlayer.E > 0 else eventPlayer.C) != 1
    @Condition (0 if eventPlayer.E > 0 else eventPlayer.A) == 0
    #@Condition eventPlayer.A == 0
    #@Condition eventPlayer.C != 1
    # I think this is testing a checkpoint in edit mode. having a timer run
    eventPlayer.L = 0
    chase(eventPlayer.L, 10, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.D = 0


rule "rule 92":
    @Event eachPlayer
    @Condition kz_xs == true
    @Condition eventPlayer.L >= 5
    @Condition eventPlayer.A < len(A) - 1
    
    eventPlayer.A = eventPlayer.A if eventPlayer.E > 0 else 0
    if eventPlayer.C == 1:
        goto lbl_0
    if eventPlayer.E > 0 and eventPlayer.isOnGround():
        goto lbl_1
    eventPlayer.teleport(A[0 if eventPlayer.E < 1 else eventPlayer.A])
    lbl_0:
    smallMessage(eventPlayer, "Time out!")
    lbl_1:
    stopChasingVariable(eventPlayer.L)


rule "rule 93":
    @Event eachPlayer
    @Condition distance(eventPlayer, A[0]) < 1
    @Condition eventPlayer.A == 0
    @Condition kz_xs == true
    
    stopChasingVariable(eventPlayer.L)
    eventPlayer.L = 0
    eventPlayer.D = 0


rule "rule 94":
    @Event eachPlayer
    @Condition eventPlayer.C == 1
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition kz_xs == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.A += 1 if eventPlayer.A < len(A) - 2 else 0
    eventPlayer.teleport(A[eventPlayer.A])


rule "rule 95":
    @Event eachPlayer
    @Condition eventPlayer.C == 1
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition kz_xs == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.A -= 1 if eventPlayer.A > 0 else 0
    eventPlayer.teleport(A[eventPlayer.A])


