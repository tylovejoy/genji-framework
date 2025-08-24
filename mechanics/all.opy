#!mainFile "../framework.opy"
/*
Generalized mechanics for all heroes here
*/
rule "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Mechanics | Checks ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒":
    @Delimiter

rule "Mechanic | All | Jump":
    @Event eachPlayer
    @Condition eventPlayer.isJumping()
    eventPlayer.skill_usedBhop = true
    if eventPlayer.skill_usedHop:
        smallMessage(eventPlayer, t"   Bhop") #"   小跳已用" checkCN "   Bhop"
    else:
        eventPlayer.skill_usedHop = true
        if eventPlayer.getVerticalSpeed() > 5.7197263e0:
            LobbyID = []

rule "Mechanic | All | No Jump":
    @Event eachPlayer
    @Condition eventPlayer.skill_usedHop == null
    @Condition eventPlayer.isOnGround() == false
    eventPlayer.skill_usedHop = true

rule "Mechanic | All | Bhop Reset":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    eventPlayer.skill_usedBhop = false

rule "Mechanic | All | Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    eventPlayer.skill_usedBhop = false
    if eventPlayer.addon_toggle3rdPov:
        eventPlayer.addon_toggle3rdPov = false
        eventPlayer.stopCamera()
    if eventPlayer.ban_emote:
        waitUntil(not eventPlayer.isCommunicatingEmote(), Math.INFINITY)
        if eventPlayer.toggle_invincible: return
        #"   表情留小 ♥ 已禁用!" checkCN "   Emote Savehop ♥ is banned!"
        smallMessage(eventPlayer, t"   Emote Savehop ♥ Is Banned!")
        wait()
        CheckpointFailReset()

rule "Mechanic | All | Ground Reset":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    #All
    eventPlayer.skill_usedHop = null
    eventPlayer.skill_countBhops = null
    #$$ Climb
    eventPlayer.skill_usedClimb = false
    eventPlayer.skill_countMulti = null
    eventPlayer.skill_countCreates = null
    #$$ Genji
    eventPlayer.skill_usedDouble = null