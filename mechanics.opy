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

rule "Mechanic | Ground Reset":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    #All
    eventPlayer.skill_usedHop = null
    eventPlayer.skill_countBhops = null
    #Climb
    eventPlayer.skill_usedClimb = false
    eventPlayer.skill_countMulti = null
    eventPlayer.skill_countCreates = null
    #Genji
    eventPlayer.skill_usedDouble = null