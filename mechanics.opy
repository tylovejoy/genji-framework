#!mainFile "genji.opy"

rule "------------------------------------------------------------------------ Checks ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled

rule "Checking | ult combined rule":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()
    wait(1.8, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.NotOnLastCp and (not eventPlayer.InvincibleToggle):
        eventPlayer.disallowButton(Button.PRIMARY_FIRE) # disable primary fire because of slash exploit
    waitUntil(not eventPlayer.isUsingUltimate(),2)
    wait()
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    async(CheckUlt(), AsyncBehavior.RESTART) # sets ult charge back if done with map etc
        
rule "Checking | Dash combined rule":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()
    async(CheckDash(), AsyncBehavior.RESTART)


def CheckUlt(): # checks if ult should be turned on
    if eventPlayer.LockState:
        eventPlayer.setUltCharge(0) # for dash start etc you can be away from cp so the keep charge triggers
    waitUntil(not eventPlayer.isUsingUltimate(), 2)
    if eventPlayer.InvincibleToggle or (not eventPlayer.NotOnLastCp):
        goto lbl_a #skip msg if these
    elif eventPlayer.CurrentCheckpoint in BladeEnabledCheckpoints and distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint].last() ) <= 1.4: 
        smallMessage(eventPlayer, "   Ultimate is ready") 
        lbl_a:
        wait()        
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        
    elif eventPlayer.EditorOn:
        wait()        
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)

    elif distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint].last() ) <= 2 or eventPlayer.getUltCharge() < 100: # used to be just else, but have to deal with multi ult orbs
        eventPlayer.setUltEnabled(false)
        eventPlayer.setUltCharge(0)


def CheckDash(): # checks if dash should be  turned on
    waitUntil(not eventPlayer.isUsingAbility1(), 2)
    if eventPlayer.InvincibleToggle or (not eventPlayer.NotOnLastCp):
        goto lbl_a #skip msg if these
    elif eventPlayer.CurrentCheckpoint in DashEnabledCheckpoints and distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint].last() ) <= 1.4: 
        smallMessage(eventPlayer, "   Dash is ready") 
        lbl_a:
        wait()        
        eventPlayer.setAbility1Enabled(true)
    elif eventPlayer.EditorOn: # seeprate so msg stil plays
        eventPlayer.setAbility1Enabled(true)
    else:
        eventPlayer.setAbility1Enabled(false)

rule "Checking | Jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    @Condition eventPlayer.JumpCount != 2
    eventPlayer.JumpCount += 1

rule "Checking | Bhop in the air":
    @Event eachPlayer
    @Condition eventPlayer.JumpCount == 0
    @Condition eventPlayer.isInAir() 
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false #?????? why wasnt this as fales
    eventPlayer.BhopUsed = false

rule "Checking | In the air":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.JumpCount == 0
    @Condition eventPlayer.isInAir() 
    
    eventPlayer.JumpCount = 1

rule "Checking | Triple jump":
    @Event eachPlayer
    @Condition eventPlayer.JumpCount == 1
    # actualy just checks if you been in the air for atleast 0.1 seconds
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.JumpCount = 2

rule "Checking | Player on the wall":
    @Event eachPlayer
    #This rule is also linked to the determination of wall climbing, please do not close/delete
    @Condition eventPlayer.isOnWall()
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    eventPlayer.JumpCount = 2
    eventPlayer.WallclimbUsed = true

rule "Checking | Using Emote":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicatingEmote() == true
    eventPlayer.BhopUsed = false

rule "Checking | Bhop":
    @Event eachPlayer
    @Condition not eventPlayer.BhopUsed
    @Condition eventPlayer.isJumping()
    eventPlayer.BhopUsed = true
    smallMessage(eventPlayer, "   Bhop")

rule "Checking | Create Bhop":
    # Credit: Githuboy#5249
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isCrouching()
    @Condition eventPlayer.isInAir()
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isJumping() == false
    @Condition eventPlayer.isOnGround() == false
    eventPlayer.BhopUsed = false
    if eventPlayer.ban_create and eventPlayer.InvincibleToggle == false and eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1:
        smallMessage(eventPlayer, "   Create Bhop ♂ is banned!")
        checkpointFailReset()
        return
    smallMessage(eventPlayer, "   Bhop has been created!")    

rule "Checking | Double jump, initialized with small jump":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround()
    eventPlayer.JumpCount = 0
    eventPlayer.WallclimbUsed = false
    eventPlayer.MultiClimbCount = 0
    wait(0)
    if (eventPlayer.JumpCount != 0 or eventPlayer.WallclimbUsed) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = true
    #if (eventPlayer.JumpCount != 0 or eventPlayer.WallclimbUsed) and eventPlayer.isOnGround():

rule "HUD | Multiclimb Counter":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition not eventPlayer.WallclimbUsed
    eventPlayer.MultiClimbCount += 1

rule "HUD | Bhop Indicator | Unused | Green":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    eventPlayer.BhopHUDColor = Color.GREEN

rule "HUD | Bhop Indicator | Used | Red":
    @Event eachPlayer
    @Condition eventPlayer.isJumping()
    eventPlayer.BhopHUDColor = Color.RED

rule "-------------------------------------------------------------------------- Bans --------------------------------------------------------------------------":
    @Delimiter
    @Disabled

rule "Ban | Wallclimb for specific CPs":
    # Credit: TITANXPASCAL#5554
    @Event eachPlayer
    @Condition eventPlayer.ban_climb
    @Condition not eventPlayer.InvincibleToggle
    @Condition eventPlayer.NotOnLastCp
    @Condition eventPlayer.WallclimbUsed
    #checkpointFailReset()
    #eventPlayer.setStatusEffect(null,Status.BURNING, 0.1)
    smallMessage(eventPlayer, "   Climb ↑ is banned!")

rule "Ban | Triple Jump":
    @Event eachPlayer
    @Condition eventPlayer.ban_triple
    @Condition not eventPlayer.InvincibleToggle
    @Condition eventPlayer.NotOnLastCp
    @Condition eventPlayer.getVerticalSpeed() >= 5.8
    @Condition eventPlayer.JumpCount == 1
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition not eventPlayer.isOnWall()
    smallMessage(eventPlayer, "   Triple Jump ▲ is banned!")
    checkpointFailReset()

rule "Ban | Multiclimb":
    @Event eachPlayer
    @Condition eventPlayer.ban_multi
    @Condition not eventPlayer.InvincibleToggle
    @Condition eventPlayer.NotOnLastCp
    @Condition eventPlayer.MultiClimbCount > 0
    smallMessage(eventPlayer, "   Multiclimb ∞ is banned!")
    checkpointFailReset() 

rule "Ban | Emote Savehop":
    @Event eachPlayer
    @Condition eventPlayer.ban_emote
    @Condition not eventPlayer.InvincibleToggle
    @Condition eventPlayer.NotOnLastCp
    @Condition eventPlayer.isCommunicatingEmote() == true
    smallMessage(eventPlayer, "   Emote Savehop ♥ is banned!")
    checkpointFailReset()

