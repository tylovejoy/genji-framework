#!mainFile "genji.opy"

rule "------------------------------------------------------------------------ Checks ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled


rule "HUD | Wallclimb and Bhop":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    wait(1)
    hudHeader(eventPlayer, "Climb{0}".format(
        "" if eventPlayer.MultiClimbCount < 1 else
        " ({})".format(eventPlayer.MultiClimbCount)
        ), 
        HudPosition.LEFT, HO.game_climb, 
        Color.GREEN if eventPlayer.WallclimbUsed == 2 else Color.RED, 
        HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    
    hudHeader(eventPlayer, "Bhop", HudPosition.LEFT, HO.game_bhop, Color.GREEN if eventPlayer.BhopUsed == 0 else eventPlayer.BhopHUDColor, HudReeval.COLOR, SpecVisibility.DEFAULT)



rule "Checking | Jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.JumpCount != 2
    
    eventPlayer.JumpCount += 1


rule "Checking | Bhop in the air":
    @Event eachPlayer
    @Condition eventPlayer.JumpCount == 0
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    
    eventPlayer.BhopUsed = 0


rule "Checking | In the air":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.JumpCount == 0
    @Condition eventPlayer.isInAir() == true
    
    eventPlayer.JumpCount = 1


rule "Checking | Triple jump":
    @Event eachPlayer
    @Condition eventPlayer.JumpCount == 1
    
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.JumpCount = 2


rule "Checking | Player on the wall":
    @Event eachPlayer
    #This rule is also linked to the determination of wall climbing, please do not close/delete
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.JumpCount = 2
    eventPlayer.WallclimbUsed = 1



rule "Checking | Using Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    
    eventPlayer.BhopUsed = 0


rule "Checking | Bhop":
    @Event eachPlayer
    @Condition eventPlayer.BhopUsed == 0
    @Condition eventPlayer.isJumping() == true
    
    eventPlayer.BhopUsed = 1
    smallMessage(eventPlayer, "   Bhop")


rule "Checking | Create Bhop":
    # Credit: Githuboy#5249
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isJumping() == false
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isCrouching() == true
    eventPlayer.BhopUsed = 0
    if BhopBanToggle == true and eventPlayer.InvincibleToggle == 0 and eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1:
        smallMessage(eventPlayer, "   Create Bhop is banned!")
        checkpointFailReset()
        return
    smallMessage(eventPlayer, "   Bhop has been created!")    

rule "Checking | Double jump, initialized with small jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.JumpCount = 0
    eventPlayer.WallclimbUsed = 2
    eventPlayer.MultiClimbCount = 0
    wait(0)
    if (eventPlayer.JumpCount != 0 or eventPlayer.WallclimbUsed != 2) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = 1


rule "HUD | Multiclimb Counter":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.WallclimbUsed == 2
    # @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.MultiClimbCount += 1


rule "HUD | Bhop Indicator | Unused | Green":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    
    eventPlayer.BhopHUDColor = Color.GREEN


rule "HUD | Bhop Indicator | Used | Red":
    @Event eachPlayer
    @Condition eventPlayer.isJumping() == true
    
    eventPlayer.BhopHUDColor = Color.RED


rule "-------------------------------------------------------------------------- Bans --------------------------------------------------------------------------":
    @Delimiter
    @Disabled


rule "Ban | Wallclimb for specific CPs <---- EDIT ME":
    # Credit: TITANXPASCAL#5554
    @Event eachPlayer
    @Condition eventPlayer.ban_climb
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.WallclimbUsed == 1
    checkpointFailReset()
    smallMessage(eventPlayer, "   Climb is banned!")


rule "Ban | Bhop for specific CPs      <---- EDIT ME":
    # Credit: TITANXPASCAL#5554
    @Event eachPlayer
    @Condition eventPlayer.ban_bhop
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.BhopUsed == 1
    checkpointFailReset()
    smallMessage(eventPlayer, "   Bhop is banned!")


rule "Ban | Triple Jump":
    @Event eachPlayer
    @Condition eventPlayer.ban_triple
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.getVerticalSpeed() >= 5.8
    @Condition eventPlayer.JumpCount == 1
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition not eventPlayer.isOnWall()
    #if eventPlayer.isOnWall():
    #    return
    smallMessage(eventPlayer, "   Triple Jump is banned!")
    checkpointFailReset()


rule "Ban | Multiclimb":
    @Event eachPlayer
    @Condition eventPlayer.ban_multi
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.MultiClimbCount > 0
    
    smallMessage(eventPlayer, "   Multiclimb is banned!")
    checkpointFailReset() 


rule "Ban | Emote Savehop":
    @Event eachPlayer
    @Condition eventPlayer.ban_emote
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.isCommunicatingEmote() == true
    
    smallMessage(eventPlayer, "   Emote Savehop is banned!")
    checkpointFailReset()







/*
old multi hud
rule "HUD | Multiclimbs Used":
    @Event eachPlayer
    @Condition eventPlayer.WallclimbUsed == 2
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb{0}".format("({0})".format(eventPlayer.MultiClimbCount) if eventPlayer.MultiClimbCount > 0 else ""), HudPosition.LEFT, HO.game_climb, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()
 

rule "HUD | Wallclimb Used":
    @Event eachPlayer
    @Condition eventPlayer.WallclimbUsed == 1
    @Condition eventPlayer.hasSpawned() == true

    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb", HudPosition.LEFT, HO.game_climb, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()
*/



/*
# removed coz duplicatewith "Checking | Double jump, initialized with small jump"
rule "Checking | Bhop/Double Jump Initialization":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true

    eventPlayer.JumpCount = 0
    eventPlayer.WallclimbUsed = 2
    wait(0)
    if (eventPlayer.JumpCount != 0 or eventPlayer.WallclimbUsed != 2) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = 1
*/