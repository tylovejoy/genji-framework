#!mainFile "genji.opy"

/*
translated file
this gets put on page 2
this should be parts of addons that get toggled by turning on rules
*/

rule "<tx0C00000000001344> Addons Settings & Data - 附加组件 <tx0C00000000001344>":
    @Delimiter

rule "Comp Mode instruction message - 竞赛模式指引消息 <---- INSERT HERE / 在这输入":
    wait(0.4)
    # Instructions that show when you start comp mode.
    # Due to the hud text limit, you there is 4 huds available.
    # If you dont need a field just empty the textfield.
    return
    # 竞赛模式 指引消息
    # 指引消息将 会在竞赛模 式开始时 显示
    # 由于 hud 文本限制，你有 4 个hud可用
    # 如果你不需 要一个字段 只是空文 本字段
    InstructionText[0] = "Change in Comp Mode instruction message hud 1"
    InstructionText[1] = "Change in Comp Mode instruction message hud 2"
    InstructionText[2] = "Change in Comp Mode instruction message hud 3"
    InstructionText[3] = "Change in Comp Mode instruction message hud 4"

rule "Custom difficulty hud  - 自定义难度hud <---- INSERT HERE / 在这输入":
    @Disabled
    @Delimiter
    #1) workshop settings > difficulty > set to "dont display"
    #2) enable this rule
    #3) type your difficulty in the hud below
    wait(2.5)
    #1) 地图工坊设 置难度改为 “不显示”
    #2) 勾选此规则 点击上方的 开启/关闭 开启此规则
    #3) 修改下面的 创建hud文本 中的“enter custom difficulty here”
    hudText(localPlayer,
        ("游戏测试" checkCN "Playtest") if Difficultyhud[1] else [],
        "enter custom difficulty here",
        null,
        HudPosition.TOP, HO.data_dif,
        Color.BLUE, Color.GREEN, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())

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
    @Event playerJoined

    # "your nickname" your friends ingame name
    # "display title" fill in the custom title
    # 修改字符串 "your nickname <-------" 为好友名字 区分大小写
    # 修改字符串 "display title" 为好友头顶 显示的称号
    waitUntil(eventPlayer.hasSpawned(), Math.INFINITY)
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(true[0], "Message to the whole room")
        createInWorldText(localPlayer, "display title", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(true[0], "Message to the whole room")
        createInWorldText(localPlayer, "display title", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(true[0], "Message to the whole room")
        createInWorldText(localPlayer, "display title", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)

rule "Display Author Time - 展示世界纪录 <---- EDIT ME / 在此处编辑":
    @Disabled #$$ Fix CN Translation
    # type your entry in the textfield that says "name and time here"
    # 在文本框 中输入“名称和时间”
    hudText(localPlayer, null," \n{0} author time {0}".format(iconString(Icon.FIRE)),"name and time here", HudPosition.RIGHT, HO.wr, Color.ROSE, Color.ROSE, Color.ROSE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
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

rule "Togglable 3rd Person Camera Mode (Hold Crouch + Hold Jump)":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.lockState == false
    @Condition eventPlayer.editor_lock == false
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.addon_toggle3rdPov = not eventPlayer.addon_toggle3rdPov
    if eventPlayer.addon_toggle3rdPov:
        eventPlayer.startCamera(updateEveryTick(
            raycast(0.5 * Vector.UP + eventPlayer.getEyePosition(),
            0.5 * Vector.UP + eventPlayer.getEyePosition() + -3.5 * eventPlayer.getFacingDirection(), [], [], false).getHitPosition() + 0.5 * eventPlayer.getFacingDirection()),
            updateEveryTick(0.5 * Vector.UP + eventPlayer.getEyePosition()), false)
    else:
        eventPlayer.stopCamera()

rule "<tx0C00000000001344> Addons Skills - 附加组件技能 <tx0C00000000001344>":
    @Delimiter

# keeps you still shortly after getting in a stall
# makes it much easier to get in one
rule "Stall enhancer - 增强系統跳的判定":
    @Event eachPlayer
    #原作：家里有妖怪#5202(国服)
    @Disabled
    @Condition eventPlayer.hasSpawned() == true
    @Condition (eventPlayer.getVerticalSpeed() >= -0.2 and eventPlayer.getVerticalSpeed() <= 0.05) == true
    @Condition eventPlayer.getHorizontalSpeed() <= 1.3
    @Condition eventPlayer.isInAir() == true
    @Condition eventPlayer.isOnWall() == false
    @Condition eventPlayer.isOnGround() == false
    @Condition not (eventPlayer.editor_on and eventPlayer.editor_fly)
    #@Condition createWorkshopSetting(bool, "map settings \n地图设置"," Autobounce enhancer - 增强系統跳的判定", false, 3)

    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    waitUntil(not eventPlayer.isMoving(), 1)
    eventPlayer.stopForcingPosition()
    eventPlayer.setMoveSpeed(0)
    eventPlayer.setGravity(0)

    waitUntil(
        eventPlayer.isHoldingButton(Button.RELOAD) or
        eventPlayer.editor_fly or eventPlayer.isDead() or
        eventPlayer.isUsingAbility1() or
        eventPlayer.getSpeed() > 3 , 3) # double jump catch
    #wait(3)
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)
    if not eventPlayer.editor_fly and eventPlayer.isAlive() and not eventPlayer.isHoldingButton(Button.RELOAD):
        eventPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        if RULE_CONDITION:
            goto RULE_START

# dash after ledge grab
# stores speed and launches you after dash if you done it during climb
# LedgeDash var 0 count - 1 eventPlayer.addon_ledgeDash[1] 1 stored speed
# based on code taken: wzr31 and S7DR0 and simplified
rule "Fake Ledge Dash - 超级跳":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()
    #climb / ledge > hold jump > hands on the ledge > dash  > wait for launch > release jump
    #爬墙/扒 > 长按跳 > 抓住窗台 > SHIFT > 等待发射 > 释放跳跃

    eventPlayer.addon_ledgeDash[0] = 0
    waitUntil(eventPlayer.getSpeed() >= 45, 0.4)

    while eventPlayer.isUsingAbility1() and eventPlayer.addon_ledgeDash[0] <= 12:
        eventPlayer.addon_ledgeDash[1] = eventPlayer.getFacingDirection()
        eventPlayer.addon_ledgeDash[2] = eventPlayer.getSpeed()
        if eventPlayer.getSpeed() < 45: # dashed into air or object = end
            goto lbla
        else:
            eventPlayer.addon_ledgeDash[0] ++
        if eventPlayer.addon_ledgeDash[0] == 12: # stop storing, we keep this speed/direction
            waitUntil(eventPlayer.getSpeed() < 40, 0.4) # wait for dash to finish to execute
        wait()

    if eventPlayer.addon_ledgeDash[0] >= 5: #and eventPlayer.addon_ledgeDash[0] <= 12: # ledge dash execute
        eventPlayer.applyImpulse(eventPlayer.addon_ledgeDash[1], eventPlayer.addon_ledgeDash[2], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    # above 12 - climbed to long
    # below 5 - dashed into object

    lbla:
    eventPlayer.addon_ledgeDash[0] = null
    eventPlayer.addon_ledgeDash[1] = null
    eventPlayer.addon_ledgeDash[2] = null

rule "Grup up | text/effect":
    @Disabled
    # replace 777 with checkpoint number
    # replace vector 0,0,0 with orb position
    createInWorldText(
        [i for i in getAllPlayers() if i.checkpoint_current == 777],
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
        [i for i in getAllPlayers() if i.checkpoint_current == 777],
        Effect.SPHERE, Color.ORANGE, vect(0,0,0),  3.5, EffectReeval.VISIBILITY
    )

rule "Grup up | function":
    @Disabled
    @Event eachPlayer
    # replace 777 with checkpoint number
    @Condition eventPlayer.checkpoint_current == 777
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.toggle_invincible == false
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

    eventPlayer.startForcingPosition(CheckpointPositions[eventPlayer.checkpoint_current +1] + vect(0,0.1,0), true)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.3)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.skill_usedDouble = null
    wait(0.16)
    eventPlayer.stopForcingPosition()

def TriggerOnFailSuccesReset():
    @Name "Custom script on fail, succes, reset, skip"
    @Disabled
    # This subroutine triggers on failing, arriving, reseting, skipping etc
    # example: reset gravity and movespeed after being changed by custom orbs
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)

rule "Custom Orb Script":
    @Disabled
    @Event eachPlayer
    #don't edit this condition !!!!!!!!!!!!!!!!!
    @Condition eventPlayer.cache_bounceTouched > -1
    #Enable this rule and find the ID number of the bounce orbs via the editor display.
    #Note that the ID can change if you place or delete orbs infront of that orb.
    #Do NOT edit the next 2 actions.
    eventPlayer.addon_bounceId = [i for i in [i for _, i in BouncePadCheckpoints] if BouncePadCheckpoints[i] == eventPlayer.checkpoint_current and  BouncePositions[i] == eventPlayer.cache_bouncePosition[eventPlayer.cache_bounceTouched]][0]
    #Add the desired ID numbers for the bounces in the array
    #add the script after it
    #you can use the trigger sub above this rule to reset the effects
    if eventPlayer.addon_bounceId in [2]:
        # example gravity (should be reset to 100 in trigger on fail)
        eventPlayer.setGravity(25)
        smallMessage(eventPlayer," you feel light")
        wait(2)
        eventPlayer.setGravity(100)

    if eventPlayer.addon_bounceId in [2,3]:
       # example canceling primary makes double jump recover
       eventPlayer.cancelPrimaryAction()
       eventPlayer.skill_usedDouble = null
       smallMessage(eventPlayer," double jump recovered")

    if eventPlayer.addon_bounceId in [4]:
        # example move speed
        eventPlayer.setMoveSpeed(250)
        smallMessage(eventPlayer," zooom")

rule "Fake Triple Jump - 假三段跳":
    @Disabled
    @Event eachPlayer
    @Hero genji
    #Method D
    #Updated Script by LulledLion 9-1-24
    @Condition BanTriple == false
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.skill_usedDouble == false #Double cannot be used already
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false #Don't trigger on reset
    eventPlayer.addon_enableDoubleChecks = true #Enable checking double jump
    wait()
    if RULE_CONDITION:
        goto RULE_START
    if eventPlayer.skill_usedDouble:
        return
    #Input window to Triple
    waitUntil(eventPlayer.isJumping() and eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnWall() or eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.RELOAD), 0.048)
    #Cancel Triple
    if eventPlayer.isOnWall() or eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.hasStatusEffect(Status.ROOTED):
        return
    #Apply fake triple jump
    if eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.isJumping():
        eventPlayer.applyImpulse(Vector.UP, 9, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

rule "fisho cp cheat for overpy toggle":
    @Event eachPlayer
    @Condition cpCheat
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.checkpoint_notLast) or (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.checkpoint_current != 0)
    @Condition eventPlayer.editor_on == false
    @Condition eventPlayer.toggle_practice == false

    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.teleport(CheckpointPositions[eventPlayer.checkpoint_current - 1])
        eventPlayer.checkpoint_current -= 1
    else:
        eventPlayer.checkpoint_current += 1
        eventPlayer.teleport(CheckpointPositions[eventPlayer.checkpoint_current])

rule "Ledge Grab Patch v1.5":
    # Obsolete for OW v2.12
    @Event eachPlayer
    @Condition false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.getCurrentHero() == Hero.GENJI == eventPlayer.skill_usedDouble
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
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    eventPlayer.stopForcingButton(Button.JUMP)
    #Ledge Grab loop
    while not eventPlayer.isOnGround():
        #Multi-Climb
        if eventPlayer.isOnWall():
            wait(false)
        else:
            eventPlayer.startForcingButton(Button.JUMP)
            wait(false)
            eventPlayer.stopForcingButton(Button.JUMP)
        waitUntil(eventPlayer.isOnGround() or eventPlayer.isOnWall() or eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
        waitUntil(eventPlayer.isOnGround() or eventPlayer.isOnWall() or not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
        #Create cBhop
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.CROUCH), 0.064)

rule "Save Double - enable rule - 二段跳":
    # Obsoleted by hero settings.
    @Event eachPlayer
    @Condition false
    @Condition eventPlayer.isOnGround() == false
    @Condition eventPlayer.skill_usedDouble == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    waitUntil(eventPlayer.getThrottle().z > null or eventPlayer.isOnGround() or eventPlayer.skill_usedDouble or not eventPlayer.isHoldingButton(Button.JUMP), 100000000)
    if not RULE_CONDITION: return
    waitUntil(eventPlayer.getThrottle().z <= null or eventPlayer.isOnGround() or eventPlayer.skill_usedDouble or not eventPlayer.isHoldingButton(Button.JUMP), 100000000)
    if not RULE_CONDITION: return
    eventPlayer.cancelPrimaryAction()
    if RULE_CONDITION: goto RULE_START