#!mainFile "genji.opy"

rule "------------------------------------------------------------------------ Checks ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled

    /*
    todos

    account for climbing and abilities during the actions
    think of other scenarios were it might need to nto apply or even cancel midway
    tune height
    tune triger time
    deal with reload button causing triple

    make note of what bhop used and jumpcount should be in old implementations
    */

rule "Fake | Triple Jump | altitude": # can it triger without touching ground? maybe this can bypas ground check
    @Disabled
    
    @Event eachPlayer
    #@Condition eventPlayer.JumpCount == 1
    #@Condition eventPlayer.isJumping()  == false
    #@Condition eventPlayer.isUsingAbility1() == false
    #@Condition not eventPlayer.isOnWall()

    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false# not jumping, force to time it
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.getAltitude() < 0.4 # low to ground
    @Condition eventPlayer.getVerticalSpeed() <= 0 # faling, not jumping up
    
    #waitUntil(eventPlayer.isOnGround(), 1)
    #if not eventPlayer.isOnGround():
    #    return
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround(), 0.3)
    if not eventPlayer.isOnGround():
        smallMessage(eventPlayer, "on ground")
        return
    if eventPlayer.isHoldingButton(Button.JUMP): #and eventPlayer.isOnGround():
        smallMessage(eventPlayer, "   triple jump ▲")
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        smallMessage(eventPlayer, "missed")


rule "Fake | Triple Jump | is on ground check first. jump window after":
    @Disabled
    @Event eachPlayer
    #@Condition eventPlayer.JumpCount == 1

    @Condition eventPlayer.isJumping() # this is only true during normnal jump, not double jump

    #@Condition not eventPlayer.isHoldingButton(Button.JUMP) # not jumping, force to time it
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.getAltitude() < 0.25 # low to ground
    @Condition eventPlayer.getVerticalSpeed() <= 0 # faling, not jumping up
    @Condition eventPlayer.BhopUsed # can leave ground with skills so chekc bhop
    # note bhopused has changed in 1.7 so isnt backwards competable unles you change it to the right number
    
    waitUntil(eventPlayer.isOnGround(), 0.3)
    if not eventPlayer.isOnGround():
        smallMessage(eventPlayer, "ground check fail")
        return
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP), 0.64)
    
    if eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.isOnGround():
        smallMessage(eventPlayer, "   triple jump ▲")
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
   
    else:
        smallMessage(eventPlayer, "missed")
    # problem to solve: on ground shouldnt be needed


rule "Fake | Triple Jump | jump count check":
    @Disabled
    @Event eachPlayer
    
    @Condition eventPlayer.JumpCount == 0
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false

    waitUntil(eventPlayer.JumpCount == 1 and eventPlayer.isHoldingButton(Button.JUMP), 0.3)

    if eventPlayer.JumpCount != 1 or not eventPlayer.isHoldingButton(Button.JUMP):
        return
   
    smallMessage(eventPlayer, "   triple jump ▲")
    eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)


    # jump count 0 it also trigers when nromaly jumping
    # jump count 1 is to late to pres again

    
rule "Fake | Triple Jump | jump count check + ground checks": # method B
    @Disabled
    @Event eachPlayer
 
    #@Condition eventPlayer.JumpCount > 0
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.isJumping() # goe false during double jump
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
        
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isUsingAbility1()  == false  
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false # catch reset button
    @Condition not eventPlayer.hasStatusEffect(Status.ROOTED) # catch failreset sub

    # problem, now it auto counts when u hold jump again
    # and it doesnt when you actual want to

    waitUntil(eventPlayer.JumpCount == 0 or eventPlayer.isOnWall() or eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.hasStatusEffect(Status.ROOTED), 999)
    if eventPlayer.isOnWall() or eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.hasStatusEffect(Status.ROOTED) or eventPlayer.isHoldingButton(Button.JUMP):
        return
    if eventPlayer.JumpCount == 0 and eventPlayer.isHoldingButton(Button.JUMP):
        return
    waitUntil((eventPlayer.JumpCount == 1 and eventPlayer.isHoldingButton(Button.JUMP)) or eventPlayer.JumpCount == 2, 0.32)
    if eventPlayer.JumpCount == 1 and eventPlayer.isHoldingButton(Button.JUMP):
        if eventPlayer.ban_triple and eventPlayer.InvincibleToggle == false and eventPlayer.NotOnLastCp:
            smallMessage(eventPlayer, "   Triple Jump ▲ is banned!")
            return
        smallMessage(eventPlayer, "   triple jump ▲")
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)



rule "Fake | Triple Jump | basic jumpcount check":
    @Disabled
    @Event eachPlayer
 
    @Condition eventPlayer.JumpCount == 0
    #@Condition not eventPlayer.isHoldingButton(Button.JUMP) 

    waitUntil( eventPlayer.JumpCount == 1 and eventPlayer.isHoldingButton(Button.JUMP), 0.064)
    if eventPlayer.isOnWall() or eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.hasStatusEffect(Status.ROOTED) :
        return
    if eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.JumpCount == 1:
        if eventPlayer.ban_triple and eventPlayer.InvincibleToggle == false and eventPlayer.NotOnLastCp:
            smallMessage(eventPlayer, "   Triple Jump ▲ is banned!")
            return
        smallMessage(eventPlayer, "   triple jump ▲")
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)


rule "Fake | Triple Jump | most basic ground check": # method A
    #@Disabled
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()

    waitUntil(eventPlayer.isJumping() and eventPlayer.isHoldingButton(Button.JUMP), 0.064)
    if eventPlayer.isOnWall() or eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.hasStatusEffect(Status.ROOTED) :
        return
    if eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.isJumping() :
        if eventPlayer.ban_triple and eventPlayer.InvincibleToggle == false and eventPlayer.NotOnLastCp:
            smallMessage(eventPlayer, "   Triple Jump ▲ is banned!")
            return
        smallMessage(eventPlayer, "   triple jump ▲")
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)

    # what stops it from trigering from ground? it doesnt becuse ground only became true recently
    # perhaps altiude > 0.1 and < 0.3 with waituntil?




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

rule "Ban | Wallclimb for specific CPs <---- EDIT ME":
    # Credit: TITANXPASCAL#5554
    @Event eachPlayer
    @Condition eventPlayer.ban_climb
    @Condition not eventPlayer.InvincibleToggle
    @Condition eventPlayer.NotOnLastCp
    @Condition eventPlayer.WallclimbUsed
    checkpointFailReset()
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







/*
old multi hud
rule "HUD | Multiclimbs Used":
    @Event eachPlayer
    @Condition not eventPlayer.WallclimbUsed
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb{0}".format("({0})".format(eventPlayer.MultiClimbCount) if eventPlayer.MultiClimbCount > 0 else ""), HudPosition.LEFT, HO.game_climb, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()
 

rule "HUD | Wallclimb Used":
    @Event eachPlayer
    @Condition eventPlayer.WallclimbUsed
    @Condition eventPlayer.hasSpawned() == true

    destroyHudText(eventPlayer.MultiClimbCountHUD)
    hudHeader(eventPlayer, "Climb", HudPosition.LEFT, HO.game_climb, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.MultiClimbCountHUD = getLastCreatedText()
*/

/*
# bricked because u can fallbhop, and it can triger on usign double
rule "Ban | Bhop for specific CPs      <---- EDIT ME":
    # Credit: TITANXPASCAL#5554
    @Event eachPlayer
    @Condition eventPlayer.ban_bhop
    @Condition not eventPlayer.InvincibleToggle
    @Condition eventPlayer.NotOnLastCp
    #@Condition 
    @Condition not eventPlayer.LockState
    @Condition distance(eventPlayer,CheckpointPositions[eventPlayer.CurrentCheckpoint].last()) > 1.4
    #@Condition distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= 2
    if eventPlayer.BhopUsed == 1: 
        checkpointFailReset()
        smallMessage(eventPlayer, "   Bhop is banned!")
*/

/*
# removed coz duplicatewith "Checking | Double jump, initialized with small jump"
rule "Checking | Bhop/Double Jump Initialization":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround() == true

    eventPlayer.JumpCount = 0
    eventPlayer.WallclimbUsed = false
    wait(0)
    if (eventPlayer.JumpCount != 0 or eventPlayer.WallclimbUsed) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = true
*/