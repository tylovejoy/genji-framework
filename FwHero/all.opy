#!mainFile "../framework.opy"
/*
Generalized mechanics for all heroes here
*/
macro Fw_Mechanics_All(heroGroundReset=pass):
    rule "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Mechanics | Checks ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒":
        @Delimiter

    rule "Mechanic | All | Jump":
        @Event eachPlayer
        @Condition eventPlayer.isJumping()
        eventPlayer.skill_usedBhop = true
        if eventPlayer.skill_usedHop:
            smallMessage(eventPlayer, t"   Bhop") #"   小跳已用" checkCN "   Bhop"
            if eventPlayer.getVerticalSpeed() > 5.722:
                LobbyID = []
        else:
            eventPlayer.skill_usedHop = true

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
            wait(0)
            CheckpointFailReset()

    rule "Mechanic | All | Ground Reset":
        @Event eachPlayer
        @Condition eventPlayer.isOnGround()
        eventPlayer.skill_usedHop = null
        eventPlayer.skill_countBhops = null
        heroGroundReset