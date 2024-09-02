#!mainFile "genji.opy"

/*
translated file
this gets put on page 2
this should be parts of addons that get toggled by turning on rules
*/

rule "------------------------------------------------------------------------ Addons Settings and data - 附加组件 ------------------------------------------------------------------------":
    @Delimiter
    @Disabled

rule "Title Data - 标题数据 <---- EDIT ME / 在此处编辑":
    @Disabled
    # enable this rule and fill in the title data below.
    # 启用此规则 并填写下面 的标题数据
    wait(1)
    # checkpoint number 
    # 每关数量
    TitleData[0] = [
        0,  
        10,
        20,
        30,
        40,
        50
    ]
    # title 
    # 标题文本
    TitleData[1] = [
        "Bunny",
        "Jumper",
        "Ninja",
        "Pro",
        "Expert",
        "Master"
    ]
    # color
    # 颜色
    TitleData[2] = [
        Color.LIME_GREEN,
        Color.WHITE,
        Color.YELLOW,
        Color.ORANGE,
        Color.PURPLE,
        Color.RED
    ]

rule "Friend Title - 朋友称号 <---- DISPLAY MESSAGE HERE (ON PLAYER)":
    @Disabled
    @Delimiter
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()

    # "your nickname" your friends ingame name
    # "display title" fill in the custom title
    # 修改字符串 "your nickname <-------" 为好友名字 区分大小写
    # 修改字符串 "display title" 为好友头顶 显示的称号

    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(getAllPlayers(), "Message to the whole room")
        createInWorldText(getAllPlayers(), "display title", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(getAllPlayers(), "Message to the whole room")
        createInWorldText(getAllPlayers(), "display title", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(getAllPlayers(), "Message to the whole room")
        createInWorldText(getAllPlayers(), "display title", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)


rule "Display World Record - 展示世界纪录 <---- EDIT ME / 在此处编辑": 
    @Disabled
    @Delimiter
    # type your entry in the textfield that says "name and time here"
    # 在文本框 中输入“名称和时间”
    hudText(getAllPlayers(), null," \n{0} world record {0}".format(iconString(Icon.FIRE)),"name and time here", HudPosition.RIGHT, HO.wr, Color.ROSE, Color.ROSE, Color.ROSE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    HudStoreEdit.append(getLastCreatedText())

rule "HUD text for certain Checkpoints - 特定关卡显示的HUD文本 <---- EDIT ME / 在此处编辑":
    @Disabled
    # the example fill shows a text for cp 1 and cp 3
    # 示例已填写 关卡1和3 的hud文本
    wait(1)
    # in CpHudText fill in text
    # 修改字符串 “CpHudText” 为顶部显示 的hud文本
    CpHudText = ["text cp 1","text cp 3"]
    # in CpHudCp fill in the at wich to display
    # 修改数组 “CpHudCp” 为hud文本 显示的关卡
    CpHudCp = [1, 3]
    
rule "Inworld text for certain Checkpoints - 特定关卡显示的地图文本 <---- EDIT ME / 在此处编辑":
    @Disabled
    # the example fill shows a text for cp 1 and cp 3
    # 示例已填写 关卡1和3 的地图文本
    wait(1)
    # in CpIwtText fill in text 
    # 修改字符串 “CpIwtText” 为关卡显示 的地图文本
    CpIwtText = ["text cp 1","text cp 3"]
    # in CpIwtCp fill in cp at wich to display
    # 修改数组 “CpIwtCp” 为显示地图 文本的关卡
    CpIwtCp = [1, 3]
    # in CpIwtPos fill in the vector 
    # 修改数组 “CpIwtPos” 为地图文本 的矢量位置
    CpIwtPos = [vect(0,0,0), vect(0,0,0)]
    # color applies to all 
    # 选择应用到 所有地图文 本的颜色
    CpIwtColor = Color.LIME_GREEN

rule "Hint text for certain Checkpoints - 特定关卡的提示文本 <---- EDIT ME / 在此处编辑":
    @Disabled
    # the example fill shows a text for cp 1 and cp 3
    # 示例已填写 关卡1和3 的提示文本
    wait(1)
    # in HintText fill in text
    # 修改字符串 “HintText” 为关卡显示 的提示文本
    HintText = ["text cp 1","text cp 3"]
    # in HintCp fill in the at wich to display
    # 修改数组 “HintCp” 为提示文本 显示的关卡
    HintCp = [1, 3]


rule "------------------------------------------------------------------------ Addons skills - 附加组件技能 ------------------------------------------------------------------------":
    @Delimiter
    @Disabled

rule "Fake Triple Jump - enable rule - 启用此规则 - 假三段跳": # method c
    @Disabled
    @Event eachPlayer
    @Hero genji
    # check starts in air when not double jumping, this is to detect double jumping
    @Condition eventPlayer.isOnGround() == false 
    @Condition eventPlayer.isJumping() # false when double jumping

    @Condition eventPlayer.getAltitude() < 0.5 # prevent rest of code from runing if you are not gona be close to ground
    @Condition eventPlayer.getVerticalSpeed() < 0 # avoid trigering on start of jump, only when u go downwards
    
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false # don't triger on reset
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isOnWall() == false

    waitUntil(
        eventPlayer.isOnGround() or 
        eventPlayer.isJumping() == false or 
        eventPlayer.isOnWall() or  
        eventPlayer.isUsingAbility1() or 
        eventPlayer.isHoldingButton(Button.RELOAD)
        , 999
    ) # if you double jump or climb etc before touching ground, reset
    
    if eventPlayer.isOnGround() == false and eventPlayer.isJumping() == false or eventPlayer.isOnWall() or eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.RELOAD) : # 
        return
    
    waitUntil(
        (eventPlayer.isJumping() and eventPlayer.isHoldingButton(Button.JUMP)) or
        eventPlayer.isOnWall() or  
        eventPlayer.isUsingAbility1() or 
        eventPlayer.isHoldingButton(Button.RELOAD),
        0.048
    ) # window on the ground were you can press jump

    if eventPlayer.isOnWall() or eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.hasStatusEffect(Status.ROOTED):
        return

    if eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.isJumping() :
        # ban goes here if it was on
        eventPlayer.applyImpulse(Vector.UP, 9, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)

# keeps you still shortly after getting in a stall
# makes it much easier to get in one
rule "Stall enhancer - 增强系統跳的判定 - 启用此规则":
    @Event eachPlayer
    #原作：家里有妖怪#5202(国服)
    @Disabled
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.getVerticalSpeed() >= -0.2 and eventPlayer.getVerticalSpeed() <= 0.05) == true
    @Condition eventPlayer.getHorizontalSpeed() <= 1.3
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isOnGround() == false
    @Condition not (eventPlayer.EditorOn and eventPlayer.flytoggle != null)
    #@Condition createWorkshopSetting(bool, "map settings \n地图设置"," Autobounce enhancer - 增强系統跳的判定",false,3)
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    waitUntil(eventPlayer.isMoving() == false, 1)
    eventPlayer.stopForcingPosition()
    eventPlayer.setMoveSpeed(0)
    eventPlayer.setGravity(0)
    waitUntil(
        eventPlayer.isHoldingButton(Button.RELOAD) or
        eventPlayer.flytoggle != null or
        eventPlayer.isDead() or
        eventPlayer.isUsingAbility1() or
        eventPlayer.getSpeed() > 3 # double jump catch
        , 3
    )
    #wait(3)
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)
    if (
        eventPlayer.flytoggle == null and
        eventPlayer.isAlive() and
        not eventPlayer.isHoldingButton(Button.RELOAD)
        ):
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        if RULE_CONDITION:
            goto RULE_START


# dash after ledge grab
# stores speed and launches you after dash if you done it during climb
# LedgeDash var 0 count - 1 eventPlayer.LedgeDash[1] 1 stored speed
# based on code taken: wzr31 and S7DR0 and simplified
rule "Fake Ledge Dash - enable rule - 超级跳 - 启用此规则":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()
    #climb / ledge > hold jump > hands on the ledge > dash  > wait for launch > release jump
    #爬墙/扒 > 长按跳 > 抓住窗台 > SHIFT > 等待发射 > 释放跳跃

    eventPlayer.LedgeDash[0] = 0
    waitUntil(eventPlayer.getSpeed() >= 45, 0.4)

    while eventPlayer.isUsingAbility1() and eventPlayer.LedgeDash[0] <= 12:
        eventPlayer.LedgeDash[1] = eventPlayer.getFacingDirection()
        eventPlayer.LedgeDash[2] = eventPlayer.getSpeed()
        if eventPlayer.getSpeed() < 45: # dashed into air or object = end
            goto lbla 
        else: 
            eventPlayer.LedgeDash[0] ++
        if eventPlayer.LedgeDash[0] == 12: # stop storing, we keep this speed/direction 
            waitUntil(eventPlayer.getSpeed() < 40, 0.4) # wait for dash to finish to execute
        wait()

    if eventPlayer.LedgeDash[0] >= 5: #and eventPlayer.LedgeDash[0] <= 12: # ledge dash execute
        eventPlayer.applyImpulse(eventPlayer.LedgeDash[1], eventPlayer.LedgeDash[2], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    # above 12 - climbed to long
    # below 5 - dashed into object

    lbla:
    eventPlayer.LedgeDash[0] = null
    eventPlayer.LedgeDash[1] = null
    eventPlayer.LedgeDash[2] = null



rule "Grup up | text/effect -":
    @Disabled
    # replace 777 with checkpoint number
    # replace vector 0,0,0 with orb position
    createInWorldText(
        [i for i in getAllPlayers() if i.CurrentCheckpoint == 777],
        "{0} {1} {0}".format(
            abilityIconString(Hero.GENJI, Button.ULTIMATE),
            "待在这里" checkCN "grup up"
            ), 
        vect(0,0,0), 
        1.5, 
        Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT
    )
    # replace 777 with checkpoint number
    # replace vector 0,0,0 with orb position
    # 3.5 is the radius
    createEffect(
        [i for i in getAllPlayers() if i.A == 777], 
        Effect.SPHERE, Color.ORANGE, vect(0,0,0),  3.5, EffectReeval.VISIBILITY
    )

rule "Grup up | function": 
    @Disabled
    @Event eachPlayer
    # replace 777 with checkpoint number
    @Condition eventPlayer.CurrentCheckpoint == 777
    @Condition eventPlayer.isAlive()
    @Condition not eventPlayer.isOnGround()
    @Condition eventPlayer.InvincibleToggle == false
    # replace vector 0,0,0 with orb position
    # 3.5 is the radius
    @Condition distance(eventPlayer,  vect(0,0,0)) < 3.5 
    
    smallMessage(eventPlayer, "   stay in the bubble")
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "   9")
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "   8")
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "   7")
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "   6")
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "   5")
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "   4")
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "   3")
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "   2")
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "   1")
    wait(1, Wait.ABORT_WHEN_FALSE)

    eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.CurrentCheckpoint +1] + vect(0,0.1,0), true)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.3)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.DoubleUsed = null
    wait(0.16)
    eventPlayer.stopForcingPosition()



def TriggerOnFailSuccesReset():
    @Name "Custom script on fail, succes, reset, skip"
    @Disabled
    # This subroutine triggers on failing, arriving, reseting, skipping etc
    printLog("------------")
    # example: reset gravity and movespeed after being changed by custom orbs
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)

playervar BounceTrueId
rule "Custom Orb Script":
    @Disabled
    @Event eachPlayer
    #don't edit this condition !!!!!!!!!!!!!!!!!
    @Condition eventPlayer.bouncetouched > -1
    #Enable this rule and find the ID number of the bounce orbs via the editor display.
    #Note that the ID can change if you place or delete orbs infront of that orb.
    #Do NOT edit the next 2 actions.
    eventPlayer.BounceTrueId   = [i for _, i in BouncePadCheckpoints]
    eventPlayer.BounceTrueId  = [ i for i in eventPlayer.BounceTrueId if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint and  BouncePositions[i] == eventPlayer.BouncePosition_Cache[eventPlayer.bouncetouched]][0]
    #Add the desired ID numbers for the bounces in the array
    #add the script after it
    #you can use the trigger sub above this rule to reset the effects
    if eventPlayer.BounceTrueId in [2]:
        # example gravity (should be reset to 100 in trigger on fail)
        eventPlayer.setGravity(25)
        smallMessage(eventPlayer," you feel light")
        wait(2)
        eventPlayer.setGravity(100)
                   
    if eventPlayer.BounceTrueId in [2,3]:
       # example canceling primary makes double jump recover
       eventPlayer.cancelPrimaryAction()
       eventPlayer.DoubleUsed = null
       smallMessage(eventPlayer," double jump recovered")
                
    if eventPlayer.BounceTrueId in [4]:
        # example move speed
        eventPlayer.setMoveSpeed(250)
        smallMessage(eventPlayer," zooom")

rule "Ledge Grab Patch 1.5":
    @Disabled
    @Event eachPlayer
    #Script by LulledLion 9-1-24
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.getCurrentHero() == Hero.GENJI == eventPlayer.DoubleUsed
    @Condition eventPlayer.getCurrentHero() == Hero.HANZO == eventPlayer.getAbilityCooldown(Button.JUMP)
    @Condition (eventPlayer.getCurrentHero() == Hero.KIRIKO and eventPlayer.isHoldingButton(Button.JUMP)) == (eventPlayer.getCurrentHero() == Hero.KIRIKO)
    
    #Directly after Double Jumping
    eventPlayer.stopForcingButton(Button.JUMP)
    wait(false)
    eventPlayer.startForcingButton(Button.JUMP)
    wait(false)
    eventPlayer.stopForcingButton(Button.JUMP)
    wait(false)
    eventPlayer.startForcingButton(Button.JUMP)
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.JUMP), 9999)
    eventPlayer.stopForcingButton(Button.JUMP)
    #Ledge Grab loop
    while not eventPlayer.isOnGround():
        #Hero Swap
        if not RULE_CONDITION:
            return
        #Multi-Climb
        if eventPlayer.isOnWall():
            wait(false)
        else:
            eventPlayer.startForcingButton(Button.JUMP)
            wait(false)
            eventPlayer.stopForcingButton(Button.JUMP)
        waitUntil(eventPlayer.isOnGround() or eventPlayer.isOnWall() or eventPlayer.isHoldingButton(Button.JUMP), 9999)
        waitUntil(eventPlayer.isOnGround() or eventPlayer.isOnWall() or not eventPlayer.isHoldingButton(Button.JUMP), 9999)
        #Create cBhop
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.CROUCH), 0.064)