#!mainFile "../framework.opy"

#!include "climbers.opy"

rule "Mechanic | Genji | Double Jump":
    @Event eachPlayer
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

rule "Mechanic | Genji | Ban Save Double - 封禁二段跳":
    @Event eachPlayer
    @Condition eventPlayer.ban_savedouble
    @Condition eventPlayer.toggle_invincible == false
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.skill_usedDouble == false
    waitUntil(eventPlayer.getThrottle().z > null or eventPlayer.isOnGround() or eventPlayer.skill_usedDouble, Math.INFINITY)
    if not RULE_CONDITION: return
    waitUntil(eventPlayer.getThrottle().z <= null or eventPlayer.isOnGround() or eventPlayer.skill_usedDouble, Math.INFINITY)
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
    smallMessage(eventPlayer, "   延二段跳已禁用!" checkCN "  save double banned!")
    CheckpointFailReset()