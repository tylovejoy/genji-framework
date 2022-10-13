#!mainFile "genji.opy"

rule "------------------------------------------------------------------------ Checks ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled


rule "Checking | Jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.JumpCount != 2
    
    #The number "-1" after the variable A is the number of levels. For details, please refer to "Give the knife". 
    #When this rule is turned on, the effect is "open three stages for a specific checkpoint", 
    #and when it is turned off, it means "ban all levels for three stages"
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #Notes must be read! The effect of this condition being turned on is "Automatically open three stages after customs clearance", 
    #and if it is turned off, it will still be banned for three stages after customs clearance.
    #@Condition eventPlayer.A < len(A) - 1
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
    
    #The number "-1" after the variable A is the number of levels. For details, please refer to "Give the knife". 
    #When this rule is turned on, the effect is "open three stages for a specific checkpoint", 
    #and when it is turned off, it means "ban all levels for three stages"
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #Notes must be read! The effect of this condition being turned on is "Automatically open three stages after customs clearance", 
    #and if it is turned off, it will still be banned for three stages after customs clearance.
    #@Condition eventPlayer.A < len(A) - 1
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
    smallMessage(eventPlayer, "Bhop")


rule "Checking | Create Bhop":
    # Credit: Githuboy#5249
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isJumping() == false
    @Condition eventPlayer.isCrouching() == true
    eventPlayer.BhopUsed = 0
    if BhopBanToggle == true and eventPlayer.InvincibleToggle == 0 and eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1:
        smallMessage(eventPlayer, "Create Bhop is banned!")
        checkpointFailReset()
        return
    smallMessage(eventPlayer, "Bhop has been created!")    


rule "Checking | Bhop/Double Jump Initialization":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    
    #The number "-1" after the variable A is the number of levels. For details, please refer to "Give the knife". 
    # When this rule is turned on, the effect is "open three stages in a specific checkpoint", 
    # and when it is turned off, it will be "banned three stages in all levels"
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    # Notes must be read! When this condition is turned on, the effect is "Automatically open three stages after customs clearance", 
    # and if it is turned off, three stages will still be banned after customs clearance.
    #@Condition eventPlayer.A < len(A) - 1
    eventPlayer.JumpCount = 0
    eventPlayer.WallclimbUsed = 2
    wait(0)
    if (eventPlayer.JumpCount != 0 or eventPlayer.WallclimbUsed != 2) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = 1


rule "Checking | Double jump, initialized with small jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    
    #The number "-1" after the variable A is the number of levels. For details, please refer to "Give the knife". 
    #When this rule is turned on, the effect is "open three stages for a specific checkpoint", 
    #and when it is turned off, it means "ban all levels for three stages"
    #@Condition (eventPlayer.A != -1 or eventPlayer.A != -1 or false) == true
    #Notes must be read! The effect of this condition being turned on is "Automatically open three stages after customs clearance", 
    #and if it is turned off, it will still be banned for three stages after customs clearance.
    #@Condition eventPlayer.A < len(A) - 1
    eventPlayer.JumpCount = 0
    eventPlayer.WallclimbUsed = 2
    eventPlayer.MultiClimbCount = 0
    wait(0)
    if (eventPlayer.JumpCount != 0 or eventPlayer.WallclimbUsed != 2) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = 1


rule "HUD | Multiclimbs Used":
    @Event eachPlayer
    @Condition eventPlayer.WallclimbUsed == 2
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb{0}".format("({0})".format(eventPlayer.MultiClimbCount) if eventPlayer.MultiClimbCount > 0 else ""), HudPosition.LEFT, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()


rule "HUD | Wallclimb Used":
    @Event eachPlayer
    @Condition eventPlayer.WallclimbUsed == 1
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb", HudPosition.LEFT, 2, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    smallMessage(eventPlayer,"climbed") # NOHUDTAG
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()


rule "HUD | Multiclimb Counter":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.WallclimbUsed == 2
    # @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.MultiClimbCount += 1


rule "HUD | Bhop":
        @Event eachPlayer
        @Condition eventPlayer.hasSpawned() == true
        
        wait(1)
        hudHeader(eventPlayer, "Bhop", HudPosition.LEFT, 1, Color.GREEN if eventPlayer.BhopUsed == 0 else eventPlayer.BhopHUDColor, HudReeval.COLOR, SpecVisibility.DEFAULT)


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
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Wallclimb for specific CPs", false, 2) == true
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    # Change "-1" to certain Checkpoints' number
    @Condition eventPlayer.CurrentCheckpoint in [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] == true
    # If all checkpoints need this function, enable this rule and disable Rule: "Array Contains" 
    #@Condition eventPlayer.A < len(A) - 1
    @Condition distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= 2

    if eventPlayer.WallclimbUsed == 1:
        checkpointFailReset()
        smallMessage(eventPlayer, "Climb is banned!")


rule "Ban | Bhop for specific CPs      <---- EDIT ME":
    # Credit: TITANXPASCAL#5554
    @Event eachPlayer
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Bhop for specific CPs", false, 3) == true
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    # Change "-1" to certain Checkpoints' number
    @Condition eventPlayer.CurrentCheckpoint in [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] == true
    # If all checkpoints need this function, enable this rule and disable Rule: "Array Contains" 
    #@Condition eventPlayer.A < len(A) - 1
    @Condition distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= 2

    if eventPlayer.BhopUsed == 1:
        checkpointFailReset()
        smallMessage(eventPlayer, "Bhop is banned!")


rule "Ban | Triple Jump":
    @Event eachPlayer
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Triple Jump", false, 0) == true
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.getVerticalSpeed() >= 5.8
    @Condition eventPlayer.JumpCount == 1
    @Condition eventPlayer.isUsingAbility1() == false
    
    if eventPlayer.isOnWall():
        return
    smallMessage(eventPlayer, "Triple Jump is banned!")
    checkpointFailReset()


rule "Ban | Multiclimb":
    @Event eachPlayer
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Multiclimb", false, 1) == true
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.MultiClimbCount > 0
    # @Condition eventPlayer.isOnWall() == true
    # @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    # @Condition eventPlayer.WallclimbUsed == 2
    
    # eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    smallMessage(eventPlayer, "Multiclimb is banned!")
    checkpointFailReset() 
    
rule "Ban | Emote Savehop":
    @Event eachPlayer
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Emote Savehop", false, 3) == true
    @Condition eventPlayer.InvincibleToggle == 0
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition eventPlayer.isCommunicatingEmote() == true
    
    smallMessage(eventPlayer, "Emote Savehop is banned!")
    checkpointFailReset()
        
rule "Ban | Create Bhop":
    wait(1)
    BhopBanToggle = createWorkshopSetting(bool, "Ban Switch", "Ban Create Bhop", false, 2)

rule "Ban | Deathbhop":
    wait(1)
    DeathBhopBan = createWorkshopSetting(bool, "Ban Switch", "Ban Deathbhop", false, 4)

rule "Ban | Dash Start":
    wait(1)
    DashExploitToggle = createWorkshopSetting(bool, "Ban Switch", "Ban Dash Start", false, 4)