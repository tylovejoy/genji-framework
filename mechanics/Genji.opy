#!mainFile "../framework.opy"

#!include "climbers.opy"

def CheckUlt(): # checks if ult should be turned on
    @Name "Mechanic | Genji | SUB Check Ultimate"
    if eventPlayer.lockState:
        eventPlayer.setUltCharge(0) # for dash start etc you can be away from cp so the keep charge activators
    /*
    eventPlayer.disallowButton(Button.ULTIMATE) # make sure the button cant be pressed until the entire rule ends even if it restarts
    #if eventPlayer.skill_ultCd > getTotalTimeElapsed(): # global cooldown that works even when rule is reset
        wait(eventPlayer.skill_ultCd - getTotalTimeElapsed())
    else:
        eventPlayer.skill_ultCd = getTotalTimeElapsed() + 0.36 # Set cooldown
    */
    if eventPlayer.isUsingUltimate():
        waitUntil(not eventPlayer.isUsingUltimate(), 2)
        wait()
    if eventPlayer.isHoldingButton(Button.ULTIMATE): # incase spamming the button
        wait()

    if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and eventPlayer.editor_on) or (not eventPlayer.checkpoint_notLast):
        goto lbl_a #skip msg if these
    elif eventPlayer.checkpoint_current in BladeEnabledCheckpoints and distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last() ) <= cpcircleradius: 
        #"终极技能已就绪" checkCN "Ultimate is ready"
        smallMessage(eventPlayer, f"   {abilityIconString(Hero.GENJI, Button.ULTIMATE)} {t'Ultimate Is Ready'}")
        lbl_a:
        wait()        
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
    elif distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last()) <= 2 or eventPlayer.getUltCharge() < 100: # used to be just else, but have to deal with multi ult orbs
        eventPlayer.setUltEnabled(false)
        eventPlayer.setUltCharge(0)
    wait(0.36)

def CheckAbility1(): # checks if dash should be  turned on
    @Name "Mechanic | Genji | SUB Check Dash"
    waitUntil(not eventPlayer.isUsingAbility1(), true)
    if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and eventPlayer.editor_on) or (not eventPlayer.checkpoint_notLast):
        goto lbl_a #skip msg if these
    elif eventPlayer.checkpoint_current in DashEnabledCheckpoints and distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last()) <= cpcircleradius: 
        #"技能1影已就绪" checkCN "Dash is ready"
        smallMessage(eventPlayer, f"   {abilityIconString(Hero.GENJI, Button.ABILITY_1)} {t'Dash Is Ready'}")
        lbl_a:
        eventPlayer.setAbility1Enabled(true)
    else:
        eventPlayer.setAbility1Enabled(false)

rule "Mechanic | Genji | Ultimate":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()
    wait(1.8, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.checkpoint_notLast and (not eventPlayer.toggle_invincible):
        eventPlayer.disallowButton(Button.PRIMARY_FIRE) # disable primary fire because of slash exploit
    waitUntil(not eventPlayer.isUsingUltimate(), 2)
    wait()
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    async(CheckUlt(), AsyncBehavior.NOOP) # sets ult charge back if done with map etc

rule "Mechanic | Genji | Dash":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()
    #async(CheckAbility1(), AsyncBehavior.NOOP)
    CheckAbility1()

rule "Mechanic | Genji | Double Jump":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isInAir()
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

rule "Mechanic | Genji | Ban Save Double - 封禁二段跳":
    @Event eachPlayer
    @Condition eventPlayer.ban_savedouble
    @Condition eventPlayer.toggle_invincible == false
    @Condition eventPlayer.isInAir()
    @Condition eventPlayer.skill_usedDouble == false
    waitUntil(eventPlayer.getThrottle().z > null or not eventPlayer.isInAir() or eventPlayer.skill_usedDouble, Math.INFINITY)
    if not RULE_CONDITION: return
    waitUntil(eventPlayer.getThrottle().z <= null or not eventPlayer.isInAir() or eventPlayer.skill_usedDouble, Math.INFINITY)
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
    #"   延二段跳已禁用!" checkCN "   save double banned!"
    smallMessage(eventPlayer, t"   Save Double Banned!")
    CheckpointFailReset()