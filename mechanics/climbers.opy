#!mainFile "../framework.opy"

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