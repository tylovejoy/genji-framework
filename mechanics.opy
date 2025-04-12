#!mainFile "framework.opy"

rule "<tx0C00000000001344> Mechanics | Checks <tx0C00000000001344>":
    @Delimiter

def CheckUlt(): # checks if ult should be turned on
    @Name "Mechanic | SUB Check Ultimate"
    if eventPlayer.lockState:
        eventPlayer.setUltCharge(0) # for dash start etc you can be away from cp so the keep charge triggers
    
    eventPlayer.disallowButton(Button.ULTIMATE) # make sure the button cant be pressed until the entire rule ends even if it restarts
    #if eventPlayer.ult_cd_global > 0: # global cooldown construction that works even when rule is reset
    if eventPlayer.skill_ultCd > getTotalTimeElapsed():
        #waitUntil(not eventPlayer.ult_cd_global, 1)
        wait(eventPlayer.skill_ultCd - getTotalTimeElapsed())
    else:
        #eventPlayer.ult_cd_global = 1 # this number doesnt matter because its a duration chase
        #chase(eventPlayer.ult_cd_global, 0, duration=0.36, ChaseReeval.NONE) # duration = the cooldown
        eventPlayer.skill_ultCd = getTotalTimeElapsed() + 0.36

    if eventPlayer.isUsingUltimate():
        waitUntil(not eventPlayer.isUsingUltimate(), 2)
        wait()
    if eventPlayer.isHoldingButton(Button.ULTIMATE): # incase spamming the button
        wait()

    if eventPlayer.toggle_invincible or eventPlayer.editor_on or (not eventPlayer.checkpoint_notLast):
        goto lbl_a #skip msg if these
    elif eventPlayer.checkpoint_current in BladeEnabledCheckpoints and distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last() ) <= cpcircleradius: 
        smallMessage(eventPlayer, "   {0} {1} ".format(abilityIconString(Hero.GENJI, Button.ULTIMATE),"终极技能已就绪" checkCN "Ultimate is ready")) 
        lbl_a:
        wait()        
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
    elif distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last() ) <= 2 or eventPlayer.getUltCharge() < 100: # used to be just else, but have to deal with multi ult orbs
        eventPlayer.setUltEnabled(false)
        eventPlayer.setUltCharge(0)

    eventPlayer.allowButton(Button.ULTIMATE)

def CheckDash(): # checks if dash should be  turned on
    @Name "Mechanic | SUB Check Dash"
    waitUntil(not eventPlayer.isUsingAbility1(), 2)
    if eventPlayer.toggle_invincible or eventPlayer.editor_on or (not eventPlayer.checkpoint_notLast):
        goto lbl_a #skip msg if these
    elif eventPlayer.checkpoint_current in DashEnabledCheckpoints and distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last()) <= cpcircleradius: 
        smallMessage(eventPlayer, "   {0} {1}".format(abilityIconString(Hero.GENJI, Button.ABILITY_1),"技能1影已就绪" checkCN "Dash is ready")) 
        lbl_a:
        wait()        
        eventPlayer.setAbility1Enabled(true)
    else:
        eventPlayer.setAbility1Enabled(false)

rule "Mechanic | Ultimate":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()
    wait(1.8, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.checkpoint_notLast and (not eventPlayer.toggle_invincible):
        eventPlayer.disallowButton(Button.PRIMARY_FIRE) # disable primary fire because of slash exploit
    waitUntil(not eventPlayer.isUsingUltimate(), 2)
    wait()
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    async(CheckUlt(), AsyncBehavior.RESTART) # sets ult charge back if done with map etc

rule "Mechanic | Dash":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()
    async(CheckDash(), AsyncBehavior.RESTART)

rule "Mechanic | Jump":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    @Condition eventPlayer.skill_countJumps != 2
    eventPlayer.skill_countJumps += 1

rule "Mechanic | In the air":
    @Event eachPlayer
    @Condition eventPlayer.skill_countJumps == null
    @Condition eventPlayer.isInAir() 
    eventPlayer.skill_countJumps = 1

/* Remove this rule? */
rule "Mechanic | Triple jump":
    @Event eachPlayer
    @Condition eventPlayer.skill_countJumps == 1
    # actually just checks if you been in the air for at least 0.1 seconds
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.skill_countJumps = 2

rule "Mechanic | Player on the wall":
    @Event eachPlayer
    #This rule is also linked to the determination of wall climbing, please do not close/delete
    @Condition eventPlayer.isOnWall()
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    eventPlayer.skill_countJumps = 2
    eventPlayer.skill_usedClimb = true

rule "Mechanic | Using Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    eventPlayer.skill_usedBhop = false
    if eventPlayer.addon_toggle3rdPov:
        eventPlayer.addon_toggle3rdPov = false
        eventPlayer.stopCamera()
    if eventPlayer.ban_emote:
        waitUntil(not eventPlayer.isCommunicatingEmote(), Math.INFINITY)
        if eventPlayer.toggle_invincible: return
        smallMessage(eventPlayer, "   表情留小 ♥ 已禁用!" checkCN "   Emote Savehop ♥ is banned!")
        wait()
        CheckpointFailReset()

rule "Mechanic | Bhop":
    @Event eachPlayer
    @Condition eventPlayer.skill_usedBhop == false
    @Condition eventPlayer.isJumping()
    eventPlayer.skill_usedBhop = true
    if eventPlayer.skill_countJumps > 1:
        smallMessage(eventPlayer,"   小跳已用" checkCN "   Bhop")

rule "Mechanic | Bhop count for stand ban":
    @Event eachPlayer
    @Condition eventPlayer.isJumping()
    @Condition eventPlayer.ban_standcreate
    eventPlayer.skill_countBhops++
    if eventPlayer.skill_countBhops > 1 and not eventPlayer.toggle_invincible:   
        smallMessage(eventPlayer, "   站卡 ♠ 已禁用!" checkCN "   Stand createBhop ♠ is banned!")
        CheckpointFailReset()
        return

rule "Mechanic | Create Bhop":
    # Credit: Githuboy#5249
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isCrouching()
    @Condition eventPlayer.isInAir()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isJumping() == false
    
    eventPlayer.skill_usedBhop = false
    if eventPlayer.lockState: # prevent restart from giving messsage, but stil allow it to become green
        return

    if eventPlayer.ban_create and not eventPlayer.toggle_invincible:
        smallMessage(eventPlayer, "   卡小 ♂ 已禁用!" checkCN "   Create Bhop ♂ is banned!")
        CheckpointFailReset()
        return
    
    if eventPlayer.ban_standcreate and eventPlayer.skill_countBhops > null:
        eventPlayer.skill_countBhops--

    eventPlayer.skill_countCreates++
    smallMessage(eventPlayer, "   success!" checkCN "   Bhop has been created!")    

rule "Mechanic | Ground Reset":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    eventPlayer.skill_countJumps = null
    eventPlayer.skill_usedClimb = false
    eventPlayer.skill_countMulti = null
    eventPlayer.skill_countCreates = null
    eventPlayer.skill_countBhops = null
    eventPlayer.skill_usedDouble = null
    wait()
    if (eventPlayer.skill_countJumps or eventPlayer.skill_usedClimb) and eventPlayer.isOnGround():
        goto RULE_START
    #eventPlayer.skill_usedBhop = true

rule "Mechanic | Bhop Reset":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    eventPlayer.skill_usedBhop = false

rule "Mechanic | Double Jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.ban_djump or eventPlayer.ban_savedouble or eventPlayer.addon_enableDoubleChecks
    #Save drop
    waitUntil(eventPlayer.isOnGround() or eventPlayer.isJumping() or eventPlayer.isHoldingButton(Button.JUMP), 0.096)
    if not RULE_CONDITION: return
    while true:
        #Released Jump
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
        if not RULE_CONDITION: return
        #Double Jumped
        waitUntil(eventPlayer.isOnGround() or eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
        if not RULE_CONDITION: return
        eventPlayer.skill_usedDouble = true
        #Reset
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.skill_usedDouble, Math.INFINITY)
        if not RULE_CONDITION: return

rule "Mechanic | Multiclimb":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.skill_usedClimb == false
    
    wait()
    if eventPlayer.isOnWall() and not eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.skill_countJumps = 2
        eventPlayer.skill_usedClimb = true
    else:
        if eventPlayer.ban_multi and eventPlayer.checkpoint_notLast and not eventPlayer.toggle_invincible:
            smallMessage(eventPlayer, "    蹭留 ∞ 已禁用!" checkCN "   Multiclimb ∞ is banned!")
            CheckpointFailReset() 
        else:
            eventPlayer.skill_countMulti += 1

rule "Mechanic | Ban Wallclimb - Message":
    # Credit: TITANXPASCAL#5554
    @Event eachPlayer
    @Condition eventPlayer.ban_climb
    @Condition eventPlayer.toggle_invincible == false
    @Condition eventPlayer.skill_usedClimb
    #CheckpointFailReset()
    #eventPlayer.setStatusEffect(null,Status.BURNING, 0.1)
    smallMessage(eventPlayer, "   爬墙 ↑ 已禁用!" checkCN "   Climb ↑ is banned!")

rule "Mechanic | Ban Save Double - 封禁二段跳":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.ban_savedouble
    @Condition eventPlayer.toggle_invincible == false
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.skill_usedDouble == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    waitUntil(eventPlayer.getThrottle().z > null or eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    if not RULE_CONDITION: return
    waitUntil(eventPlayer.getThrottle().z <= null or eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    if not RULE_CONDITION: return
    #Prevent false positives
    #Default climb speed is 7.8 and small slowdown upon mantling
    if eventPlayer.getVerticalSpeed() < 6: goto RULE_START 
    if eventPlayer.skill_usedBhop:
        wait(0.8, Wait.ABORT_WHEN_FALSE)
    else:
        wait(0.8, Wait.ABORT_WHEN_FALSE)
        #This can give a false negative, but advantage is small
        if eventPlayer.skill_usedBhop: return
    smallMessage(eventPlayer, "   延二段跳已禁用!" checkCN "   save double banned!")
    CheckpointFailReset()
