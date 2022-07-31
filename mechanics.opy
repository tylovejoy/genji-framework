#!mainFile "genji.opy"

rule "------------------------------------------------------------------------ Checks ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled


rule "Bhop Green":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    
    eventPlayer.BhopHUDColor = Color.GREEN


rule "Bhop Red":
    @Event eachPlayer
    @Condition eventPlayer.isJumping() == true
    
    eventPlayer.BhopHUDColor = Color.RED

rule "Checking | Jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.JumpCount != 2
    
    #The number "-1" after the variable A is the number of levels. For details, please refer to "Give the knife". 
    #When this rule is turned on, the effect is "open three stages for a specific level", 
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
    #When this rule is turned on, the effect is "open three stages for a specific level", 
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


rule "Checking | Double bhop | thank for Githuboy#5249":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isJumping() == false
    @Condition eventPlayer.isCrouching() == true
    
    smallMessage(eventPlayer, "Success")
    eventPlayer.BhopUsed = 0
    if BhopBanToggle == true:
        kill(eventPlayer, null)
        smallMessage(eventPlayer, "{0} {1}".format(heroIcon(Hero.GENJI), ": Double Bhop is disabled"))


rule "wall climbing unused HUD Counter multiclimb hud":
    @Event eachPlayer
    @Condition eventPlayer.WallclimbUsed == 2
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb{0}".format("({0})".format(eventPlayer.MultiClimbCount) if eventPlayer.MultiClimbCount > 0 else ""), HudPosition.LEFT, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()


rule "wall climbing used HUD Counter multicimb hud":
    @Event eachPlayer
    @Condition eventPlayer.WallclimbUsed == 1
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb", HudPosition.LEFT, 2, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()


rule "Wall climb count multiclimb counting":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.WallclimbUsed == 2
    @Condition eventPlayer.InvincibleToggle == 0
    
    eventPlayer.MultiClimbCount += 1


rule "Double jump, initialized with small jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true
    
    #The number "-1" after the variable A is the number of levels. For details, please refer to "Give the knife". 
    #When this rule is turned on, the effect is "open three stages for a specific level", 
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


rule "Extended function | Strengthen stall (家里有妖怪#5202 | Easier to stall | Jump farther)":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getVerticalSpeed() >= -0.2
    @Condition eventPlayer.getVerticalSpeed() <= 0.05
    @Condition eventPlayer.getHorizontalSpeed() <= 1.3
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isOnGround() == false
    @Condition createWorkshopSetting(bool, "Extended function", "Strengthen stall", false, 0) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    waitUntil(not eventPlayer.isMoving(), 10)
    eventPlayer.stopForcingPosition()
    eventPlayer.flytoggle = null
    eventPlayer.setMoveSpeed(0)
    eventPlayer.setGravity(0)
    wait(3)
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if RULE_CONDITION:
        goto RULE_START


rule "Extended function | Climb the wall to refresh double jump(喵喵酱#51379 | Touch and Multi will not trigger)":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition createWorkshopSetting(bool, "Extended function", "Climb the wall to refresh double jump", false, 1) == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    waitUntil(not eventPlayer.isOnWall(), 1)
    eventPlayer.setStatusEffect(null, Status.HACKED, 0.1)
    wait(0.1)
    eventPlayer.clearStatusEffect(Status.HACKED)


rule "Force Saveclimb":
    @Event eachPlayer
    # Extended function | Save climb into the checkpoint(TITANXPASCAL#5554 *Remember to create text to prompt players)
    @Condition distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= 2
    @Condition createWorkshopSetting(bool, "Extended function", "Save climb into the checkpoint", false, 2) == true
    #Change "-1" to certain Checkpoints' number
    @Condition eventPlayer.CurrentCheckpoint in [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] == true
    
    #If all checkpoints need this function, enable this rule and disable Rule: "Array Contains" 
    #@Condition eventPlayer.A < len(A) - 1
    if eventPlayer.WallclimbUsed == 1:
        # kill(eventPlayer, null)
        checkpointFailReset()
        smallMessage(eventPlayer, "Fail to meet clear condition: Save climb")


rule "Extended function | Save Bhop into the checkpoint(TITANXPASCAL#5554 *Remember to create text to prompt players)":
    @Event eachPlayer
    @Condition distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= 2
    @Condition createWorkshopSetting(bool, "Extended function", "Save Bhop into the checkpoint", false, 3) == true
    #Change "-1" to certain Checkpoints' number
    @Condition eventPlayer.CurrentCheckpoint in [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] == true
    
    #If all checkpoints need this function, enable this rule and disable Rule: "Array Contains" 
    #@Condition eventPlayer.A < len(A) - 1
    if eventPlayer.BhopUsed == 1:
        # kill(eventPlayer, null)
        checkpointFailReset()
        smallMessage(eventPlayer, "Fail to meet clear condition: Save bhop")

rule "-------------------------------------------------------------------------- Bans --------------------------------------------------------------------------":
    @Delimiter
    @Disabled


rule "Ban | Triple Jump":
    @Event eachPlayer
    @Condition eventPlayer.getVerticalSpeed() >= 5.8
    @Condition eventPlayer.JumpCount == 1
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Triple Jump", false, 0) == true
    
    if eventPlayer.isOnWall():
        return
    # eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    checkpointFailReset()


rule "Ban | Multiclimb":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.WallclimbUsed == 2
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Multiclimb", false, 1) == true
    
    # eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    checkpointFailReset()
    smallMessage(eventPlayer, "{0} {1}".format(heroIcon(Hero.GENJI), ": Multiclimb is Disabled"))


rule "Ban | Double Bhop":
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Double Bhop", false, 2) == true
    
    BhopBanToggle = true


rule "Ban | Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    @Condition eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1
    @Condition createWorkshopSetting(bool, "Ban Switch", "Ban Emote", false, 3) == true
    
    # kill(eventPlayer, null)
    checkpointFailReset()
    smallMessage(eventPlayer, "{0} {1}".format(heroIcon(Hero.GENJI), ": Emote jumping is disabled"))


rule "Ban | Deathbhop":
    @Condition createWorkshopSetting(bool, "Ban Switch", "Deathbhop", false, 4) == true
    
    DeathBhopBan = true


rule "Ban | Dash Exploit":
    @Condition createWorkshopSetting(bool, "Ban Switch", "Dash Exploit", false, 4) == true
    
    DashExploitToggle = true