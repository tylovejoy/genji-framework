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
    
    eventPlayer.disallowButton(Button.ULTIMATE) # make sure the button cant be pressed until the entire rule ends even if it restarts
    if eventPlayer.ult_cd_global > 0: # global cooldown construction that works even when rule is reset
        waitUntil(eventPlayer.ult_cd_global == 0, 4)
        wait()
    else:
        eventPlayer.ult_cd_global = 1 # this number doesnt matter because its a duration chase
        chase(eventPlayer.ult_cd_global, 0, duration=0.36, ChaseReeval.NONE) # duration = the cooldown

    if eventPlayer.isUsingUltimate():
        waitUntil(not eventPlayer.isUsingUltimate(), 2)
        wait()
    if eventPlayer.isHoldingButton(Button.ULTIMATE): # incase spaming the button
        wait()

    if eventPlayer.InvincibleToggle or (not eventPlayer.NotOnLastCp):
        goto lbl_a #skip msg if these
    elif eventPlayer.CurrentCheckpoint in BladeEnabledCheckpoints and distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint].last() ) <= cpcircleradius: 
        smallMessage(eventPlayer, "   {0} {1} ".format(abilityIconString(Hero.GENJI, Button.ULTIMATE),"终极技能已就绪" checkCN "Ultimate is ready")) 
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

    eventPlayer.allowButton(Button.ULTIMATE)

def CheckDash(): # checks if dash should be  turned on
    waitUntil(not eventPlayer.isUsingAbility1(), 2)
    if eventPlayer.InvincibleToggle or (not eventPlayer.NotOnLastCp):
        goto lbl_a #skip msg if these
    elif eventPlayer.CurrentCheckpoint in DashEnabledCheckpoints and distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint].last() ) <= cpcircleradius: 
        smallMessage(eventPlayer, "   {0} {1}".format(abilityIconString(Hero.GENJI, Button.ABILITY_1),"技能1影已就绪" checkCN "Dash is ready")) 
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

/* Remove this rule? */
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
    if eventPlayer.ban_emote:
        waitUntil(not eventPlayer.isCommunicatingEmote() == true, 9999)
        waitUntil(eventPlayer.isOnWall(), 1)
        if eventPlayer.isOnWall():
            eventPlayer.cancelPrimaryAction()
            eventPlayer.DoubleUsed = null

rule "Checking | Bhop":
    @Event eachPlayer
    @Condition not eventPlayer.BhopUsed
    @Condition eventPlayer.isJumping()
    eventPlayer.BhopUsed = true
    smallMessage(eventPlayer,"   小跳已用" checkCN "   Bhop")

rule "Checking | Bhop count for stand ban":
    @Event eachPlayer
    @Condition eventPlayer.isJumping()
    @Condition eventPlayer.ban_standcreate
    eventPlayer.Bhopcount ++
    if eventPlayer.Bhopcount > 1 and eventPlayer.InvincibleToggle == false and eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1:   
        smallMessage(eventPlayer, "   站卡 ♠ 已禁用!" checkCN "   Stand createBhop ♠ is banned!")
        checkpointFailReset()
        return

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
    if eventPlayer.LockState: # prevent restart from giving messsage, but stil alow it to become green
        return

    if eventPlayer.ban_create and eventPlayer.InvincibleToggle == false and eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1:
        smallMessage(eventPlayer, "   卡小 ♂ 已禁用!" checkCN "   Create Bhop ♂ is banned!")
        checkpointFailReset()
        return
    
    if eventPlayer.ban_standcreate and eventPlayer.Bhopcount > 0:
        eventPlayer.Bhopcount --

    eventPlayer.CreateCounter ++
    smallMessage(eventPlayer, "   succes!" checkCN "   Bhop has been created!")    

rule "Checking | standing resets variables":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround()
    eventPlayer.JumpCount = 0
    eventPlayer.WallclimbUsed = false
    eventPlayer.MultiClimbCount = 0
    eventPlayer.CreateCounter = 0
    eventPlayer.Bhopcount = 0
    eventPlayer.DoubleUsed = null
    wait(0)
    if (eventPlayer.JumpCount != 0 or eventPlayer.WallclimbUsed) and eventPlayer.isOnGround():
        goto RULE_START
    eventPlayer.BhopUsed = true

rule "Checking | Double Jump":
    @Event eachPlayer
    @Hero genji
    @Condition evalOnce(len(BanDjump)) or eventPlayer.ban_djump
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == false
    #Saved Double Jump
    waitUntil(eventPlayer.isOnGround() or eventPlayer.isJumping() or eventPlayer.isHoldingButton(Button.JUMP), 0.096)
    if not RULE_CONDITION: return
    while true:
        #Released Jump
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.JUMP), 9999)
        if not RULE_CONDITION: return
        #Double Jumped
        waitUntil(eventPlayer.isOnGround() or eventPlayer.isHoldingButton(Button.JUMP), 9999)
        if not RULE_CONDITION: return
        eventPlayer.DoubleUsed = true
        #Reset
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.DoubleUsed, 9999)
        if not RULE_CONDITION: return

rule "HUD | Multiclimb Counter":
    @Event eachPlayer
    @Condition eventPlayer.isOnWall()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition not eventPlayer.WallclimbUsed
    
    if eventPlayer.ban_multi and eventPlayer.NotOnLastCp and not eventPlayer.InvincibleToggle:
        smallMessage(eventPlayer, "    蹭留 ∞ 已禁用!" checkCN "   Multiclimb ∞ is banned!")
        checkpointFailReset() 
    else:
        eventPlayer.MultiClimbCount += 1

rule "HUD | Bhop Indicator | Unused | Green":
    @Event eachPlayer
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    eventPlayer.BhopHUDColor = ColorConfig[customize.bhopclimb_available]

rule "HUD | Bhop Indicator | Used | Red":
    @Event eachPlayer
    @Condition eventPlayer.isJumping()
    eventPlayer.BhopHUDColor = ColorConfig[customize.bhopclimb_used]

rule "-------------------------------------------------------------------------- Bans --------------------------------------------------------------------------":
    @Delimiter
    @Disabled

rule "Ban | Wallclimb - indicator ":
    # Credit: TITANXPASCAL#5554
    @Event eachPlayer
    @Condition eventPlayer.ban_climb
    @Condition not eventPlayer.InvincibleToggle
    @Condition eventPlayer.NotOnLastCp
    @Condition eventPlayer.WallclimbUsed
    #checkpointFailReset()
    #eventPlayer.setStatusEffect(null,Status.BURNING, 0.1)
    smallMessage(eventPlayer, "   爬墙 ↑ 已禁用!" checkCN "   Climb ↑ is banned!")

rule "Ban | Emote Savehop":
    @Event eachPlayer
    @Condition eventPlayer.ban_emote
    @Condition not eventPlayer.InvincibleToggle
    @Condition eventPlayer.NotOnLastCp
    @Condition eventPlayer.isCommunicatingEmote() == true
    smallMessage(eventPlayer, "   表情留小 ♥ 已禁用!" checkCN "   Emote Savehop ♥ is banned!")
    checkpointFailReset()


