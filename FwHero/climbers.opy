#!mainFile "../framework.opy"
/*
Generalized mechanics for climber heroes here
*/
macro Fw_Mechanics_Climber():
    rule "Mechanic | Climbers | Climb":
        @Event eachPlayer
        @Condition eventPlayer.isOnWall()
        #if eventPlayer.isHoldingButton(Button.JUMP): goto climb
        if eventPlayer.toggle_invincible: pass
        elif eventPlayer.ban_multi and eventPlayer.skill_countMulti:
            CheckpointFailReset() 
            #"   蹭留 ∞ 已禁用!" checkCN "   Multiclimb ∞ is banned!"
            smallMessage(eventPlayer, t"   Multiclimb ∞ Is Banned!")
        wait(0)
        if eventPlayer.isOnWall():# and not eventPlayer.isHoldingButton(Button.JUMP): #Auto Climb
            climb:
            eventPlayer.skill_usedClimb = true
            if eventPlayer.toggle_invincible: return
            if not eventPlayer.ban_climb: return
            CheckpointFailReset()
            #"   爬墙 ↑ 已禁用!" checkCN "   Climb ↑ is banned!"
            smallMessage(eventPlayer, t"   Climb ↑ Is Banned!")
        else:
            eventPlayer.skill_countMulti += 1

    rule "Mechanic | Climbers | Bhop count for stand ban":
        @Event eachPlayer
        @Condition eventPlayer.isJumping()
        @Condition eventPlayer.ban_standcreate
        eventPlayer.skill_countBhops++
        if eventPlayer.toggle_invincible: return
        if eventPlayer.skill_countBhops > 1:
            #"   站卡 ♠ 已禁用!" checkCN "   Stand createBhop ♠ is banned!"
            smallMessage(eventPlayer, t"   Stand Create Bhop ♠ Is Banned!")
            CheckpointFailReset()

    rule "Mechanic | Climbers | Create Bhop":
        # Credit: Githuboy#5249
        @Event eachPlayer
        @Condition eventPlayer.isInAir()
        @Condition eventPlayer.isCrouching()
        @Condition eventPlayer.isJumping() == false
        @Condition eventPlayer.isHoldingButton(Button.CROUCH)
        @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
        eventPlayer.skill_usedBhop = false
        if eventPlayer.lockState: return # prevent restart from giving messsage, but stil allow it to become green
        if eventPlayer.ban_create and not eventPlayer.toggle_invincible:
            #"   卡小 ♂ 已禁用!" checkCN "   Create Bhop ♂ is banned!"
            smallMessage(eventPlayer, t"   Create Bhop ♂ Is Banned!")
            CheckpointFailReset()
        else:
            if eventPlayer.ban_standcreate and eventPlayer.skill_countBhops > null:
                eventPlayer.skill_countBhops--
            eventPlayer.skill_countCreates++
            #"   success!" checkCN "   Bhop has been created!"
            smallMessage(eventPlayer, t"   Bhop Created!")

    rule "Mechanic | Climbers | Auto Create Bhop":
        @Event eachPlayer
        @Condition eventPlayer.ban_create == false
        @Condition eventPlayer.ban_autocreate
        @Condition eventPlayer.toggle_invincible == false
        @Condition eventPlayer.cache_bounceTouched <= 0 #Ignore if Orb Create
        @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
        wait(0)
        if not ruleCondition: return
        wait(0)
        waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or (eventPlayer.isInAir() and eventPlayer.isCrouching()), Math.INFINITY)
        if not ruleCondition: return
        smallMessage(eventPlayer, t"   Auto Create Bhop ∀ Is Banned!") #"自动卡小 ∀ 已禁用!"
        CheckpointFailReset()

macro Fw_Mechanics_GroundReset_Climbers(heroReset = pass):
    eventPlayer.skill_usedClimb = null
    eventPlayer.skill_countMulti = null
    eventPlayer.skill_countCreates = null
    heroReset

################################################################################
macro Fw_AddonsPg1_Climbers():
    pass

macro Fw_AddonsPg2_Climbers():
    rule "Addon | Climbers | Ledge Grab Patch v1.5":
        # Obsolete for OW v2.12
        @Event eachPlayer
        @Condition false
        @Condition eventPlayer.isAlive() == true
        @Condition eventPlayer.isOnGround() == false
        @Condition eventPlayer.getCurrentHero() == Hero.GENJI == eventPlayer.skill_usedDouble
        @Condition eventPlayer.getCurrentHero() == Hero.HANZO == eventPlayer.getAbilityCooldown(Button.JUMP)
        @Condition (eventPlayer.getCurrentHero() == Hero.KIRIKO and eventPlayer.isHoldingButton(Button.JUMP)) == (eventPlayer.getCurrentHero() == Hero.KIRIKO)

        #Directly after Double Jumping
        eventPlayer.stopForcingButton(Button.JUMP)
        wait(0)
        eventPlayer.startForcingButton(Button.JUMP)
        wait(0)
        eventPlayer.stopForcingButton(Button.JUMP)
        wait(0)
        eventPlayer.startForcingButton(Button.JUMP)
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
        eventPlayer.stopForcingButton(Button.JUMP)
        #Ledge Grab loop
        while not eventPlayer.isOnGround():
            #Multi-Climb
            if eventPlayer.isOnWall():
                wait(0)
            else:
                eventPlayer.startForcingButton(Button.JUMP)
                wait(0)
                eventPlayer.stopForcingButton(Button.JUMP)
            waitUntil(not eventPlayer.isInAir() or eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
            waitUntil(not (eventPlayer.isInAir() and eventPlayer.isHoldingButton(Button.JUMP)), Math.INFINITY)
            #Create cBhop
            waitUntil(eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.CROUCH), 0.064)