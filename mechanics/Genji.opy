#!mainFile "../framework.opy"

#!include "all.opy"

#!include "climbers.opy"

def ResetAbilities():
    @Name "Mechanic | Genji | SUB Reset Abilities"
    if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and EditorOn):
        eventPlayer.setUltEnabled(true)
        eventPlayer.setAbility1Enabled(true)
    else:
        eventPlayer.setUltEnabled(eventPlayer.cache_startUlt)
        eventPlayer.setAbility1Enabled(eventPlayer.cache_startAbility1)
    eventPlayer.setUltCharge(100)

rule "Mechanic | Genji | Dash":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()
    waitUntil(not eventPlayer.isUsingAbility1(), true)
    if distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last()) <= cpCircleRadius:
        #eventPlayer.setAbility1Enabled(true)
        ResetAbilities()
    else:
        eventPlayer.setAbility1Enabled(false)

rule "Mechanic | Genji | Ultimate":
    @Event eachPlayer
    # Total Duration: 218 ticks, 3.488s
    # Casting: 76 ticks, 1.216s
    # Blade: 125 ticks, 2s
    # Recovery: 17 ticks, 0.272s
    # Swing Duration: 38 ticks, 0.608s
    @Condition eventPlayer.isUsingUltimate() 
    if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast:
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        wait(3.488, Wait.ABORT_WHEN_FALSE)
        if ruleCondition: loop()
    else:
        waitUntil(not eventPlayer.isUsingUltimate(), (3 * 38) * 0.016)
        eventPlayer.disallowButton(Button.PRIMARY_FIRE) # Disallow primary fire because of slash exploit
        waitUntil(not eventPlayer.isUsingUltimate(), (218 - (3 * 38)) * 0.016)
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        if distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last()) <= cpCircleRadius:
            ResetAbilities()

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