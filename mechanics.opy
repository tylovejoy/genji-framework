#!mainFile "framework.opy"

def CheckUlt(): # checks if ult should be turned on
    @Name "Mechanic | SUB Check Ultimate"
    if eventPlayer.lockState:
        eventPlayer.setUltCharge(0) # for dash start etc you can be away from cp so the keep charge triggers
    
    eventPlayer.disallowButton(Button.ULTIMATE) # make sure the button cant be pressed until the entire rule ends even if it restarts
    if eventPlayer.skill_ultCd > getTotalTimeElapsed(): # global cooldown that works even when rule is reset
        wait(eventPlayer.skill_ultCd - getTotalTimeElapsed())
    else:
        eventPlayer.skill_ultCd = getTotalTimeElapsed() + 0.36 # Set cooldown

    if eventPlayer.isUsingUltimate():
        waitUntil(not eventPlayer.isUsingUltimate(), 2)
        wait()
    if eventPlayer.isHoldingButton(Button.ULTIMATE): # incase spamming the button
        wait()

    if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and eventPlayer.editor_on) or (not eventPlayer.checkpoint_notLast):
        goto lbl_a #skip msg if these
    elif eventPlayer.checkpoint_current in BladeEnabledCheckpoints and distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last() ) <= cpcircleradius: 
        smallMessage(eventPlayer, "   {0} {1} ".format(abilityIconString(Hero.GENJI, Button.ULTIMATE),"终极技能已就绪" checkCN "Ultimate is ready")) 
        lbl_a:
        wait()        
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
    elif distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last()) <= 2 or eventPlayer.getUltCharge() < 100: # used to be just else, but have to deal with multi ult orbs
        eventPlayer.setUltEnabled(false)
        eventPlayer.setUltCharge(0)

    eventPlayer.allowButton(Button.ULTIMATE)

def CheckAbility1(): # checks if dash should be  turned on
    @Name "Mechanic | SUB Check Dash"
    waitUntil(not eventPlayer.isUsingAbility1(), true)
    if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and eventPlayer.editor_on) or (not eventPlayer.checkpoint_notLast):
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
    async(CheckAbility1(), AsyncBehavior.RESTART)

rule "Mechanic | On Wall":
    @Event eachPlayer
    #This rule is also linked to the determination of wall climbing, please do not close/delete
    @Condition eventPlayer.isOnWall()
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    eventPlayer.skill_usedClimb = true

rule "Mechanic | Bhop count for stand ban":
    @Event eachPlayer
    @Condition eventPlayer.isJumping()
    @Condition eventPlayer.ban_standcreate
    eventPlayer.skill_countBhops++
    if eventPlayer.skill_countBhops > 1 and not eventPlayer.toggle_invincible:   
        smallMessage(eventPlayer, "   站卡 ♠ 已禁用!" checkCN "   Stand createBhop ♠ is banned!")
        CheckpointFailReset()

rule "Mechanic | Create Bhop":
    # Credit: Githuboy#5249
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isCrouching()
    @Condition eventPlayer.isInAir()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isJumping() == false
    eventPlayer.skill_usedBhop = false
    if eventPlayer.lockState: return # prevent restart from giving messsage, but stil allow it to become green

    if eventPlayer.ban_create and not eventPlayer.toggle_invincible:
        smallMessage(eventPlayer, "   卡小 ♂ 已禁用!" checkCN "   Create Bhop ♂ is banned!")
        CheckpointFailReset()
    else:
        if eventPlayer.ban_standcreate and eventPlayer.skill_countBhops > null:
            eventPlayer.skill_countBhops--
        eventPlayer.skill_countCreates++
        smallMessage(eventPlayer, "   success!" checkCN "   Bhop has been created!")    

rule "Mechanic | Ground Reset":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    eventPlayer.skill_usedHop = null
    eventPlayer.skill_usedClimb = false
    eventPlayer.skill_countMulti = null
    eventPlayer.skill_countCreates = null
    eventPlayer.skill_countBhops = null
    eventPlayer.skill_usedDouble = null

rule "Mechanic | Multiclimb":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.skill_usedClimb == false
    wait()
    if eventPlayer.isOnWall() and not eventPlayer.isHoldingButton(Button.JUMP):
        #AutoClimb used
        eventPlayer.skill_usedClimb = true
    else:
        if eventPlayer.ban_multi and eventPlayer.checkpoint_notLast and not eventPlayer.toggle_invincible:
            smallMessage(eventPlayer, "   蹭留 ∞ 已禁用!" checkCN "   Multiclimb ∞ is banned!")
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