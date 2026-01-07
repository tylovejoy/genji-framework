#!mainFile "../framework.opy"

################################################################################
/* Rename Global Variables */
##!define 
################################################################################
/* Include Shared Skill Macros*/
#!include "all.opy"
################################################################################
/* Bind Button Commands */

macro Fw_Commands_Leaderboard():
    pass

macro Fw_Commands_Split():
    pass

macro Fw_Commands_Invisible():
    pass

macro Fw_Commands_Preview():
    pass

macro Fw_Commands_Restart():
    pass

macro Fw_Commands_Spectate():
    pass

macro Fw_Commands_Invincible():
    pass

macro Fw_Commands_Practice():
    pass

macro Fw_Commands_PracticeRestart():
    pass

macro Fw_Commands_PracticeSkip():
    pass

macro Fw_Commands_QuickReset():
    pass

macro Fw_Commands_Huds():
    pass

macro Fw_Commands_Hints():
    pass

macro Fw_Commands_3rdPerson():
    pass

################################################################################

macro Fw_Parkour_Setup_Hero():
    pass

macro Fw_Parkour_UpdateCache_Hero():
    pass

macro Fw_Mechanics_GroundReset_Hero():
    pass

macro Fw_Mechanics_Hero():
    Fw_Mechanics_All(Fw_Mechanics_GroundReset_Hero())

    def ResetAbilities():
        @Name "Mechanic | TEMPLATE | SUB Reset Abilities"
        if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and EditorOn):
            eventPlayer.setUltEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(true)
        else:
            eventPlayer.setUltEnabled(eventPlayer.cache_startUlt)
            eventPlayer.setAbility1Enabled(eventPlayer.cache_startAbility1)
            #eventPlayer.setAbility2Enabled(eventPlayer.cache_startAbility2) # Not implemented yet.
        eventPlayer.setUltCharge(100)

    rule "Mechanic | TEMPLATE | Ability 1":
        @Event eachPlayer
        @Hero template
        @Condition eventPlayer.isUsingAbility1()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass

    rule "Mechanic | TEMPLATE | Ability 2":
        @Event eachPlayer
        @Hero template
        @Condition eventPlayer.isUsingAbility2()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass

    rule "Mechanic | TEMPLATE | Ultimate":
        @Event eachPlayer
        @Hero template
        @Condition eventPlayer.isUsingUltimate()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass