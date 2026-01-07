#!mainFile "../framework.opy"
################################################################################
/* Rename Global Variables */
##!define 
################################################################################
/* Include Shared Skill Macros*/
#!include "all.opy"
################################################################################

macro Fw_Parkour_Setup_Hero():
    Ability1Checkpoints = Ability1Checkpoints if len(Ability1Checkpoints) else []
    #Ability2Checkpoints = Ability2Checkpoints if len(Ability2Checkpoints) else []
    #SecondaryCheckpoints = SecondaryCheckpoints if len(SecondaryCheckpoints) else []
    UltCheckpoints = UltCheckpoints if len(UltCheckpoints) else []

macro Fw_Parkour_UpdateCache_Hero():
    pass

################################################################################

macro Fw_Mechanics_GroundReset_Hero():
    pass

macro Fw_Mechanics_Hero():
    Fw_Mechanics_All(Fw_Mechanics_GroundReset_Hero())

    def ResetAbilities():
        @Name "Mechanic | Doomfist | SUB Reset Abilities"
        if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and EditorOn):
            eventPlayer.setUltEnabled(true)
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setAbility2Enabled(true)
        else:
            eventPlayer.setUltEnabled(eventPlayer.cache_startUlt)
            eventPlayer.setAbility1Enabled(eventPlayer.cache_startAbility1)
            #eventPlayer.setAbility2Enabled(eventPlayer.cache_startAbility2) # Not implemented yet.
        eventPlayer.setUltCharge(100)

    rule "Mechanic | Doomfist | Ability 1":
        @Event eachPlayer
        @Hero doomfist
        @Condition eventPlayer.isUsingAbility1()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass

    rule "Mechanic | Doomfist | Ability 2":
        @Event eachPlayer
        @Hero doomfist
        @Condition eventPlayer.isUsingAbility2()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass

    rule "Mechanic | Doomfist | Ultimate":
        @Event eachPlayer
        @Hero doomfist
        @Condition eventPlayer.isUsingUltimate()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        pass