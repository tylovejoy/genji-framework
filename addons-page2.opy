#!mainFile "genji.opy"

/*
this gets put on page 2
this should be parts of addons that get toggled by turning on rules
*/

rule "------------------------------------------------------------------------ Addons Settings and data - 附加组件 ------------------------------------------------------------------------":
    @Delimiter
    @Disabled

rule "Dash/Blade | DEPRICATED, instructions inside - 刀/Shift | 已弃用, 内含指引":
    @Delimiter
    @Disabled
    # -
    # >>> this rule should no longer be used <<<
    # >>> 这条规则本版本已弃用 <<<
    # -
    printLog("----------------")
    # you can add ult/dash via checkpoint mode in the ingame editor
    # existing map data should be updated to include this in map data
    # Paste the blade and ult variable from the dash/ult rules old into the map pasta rule.
    printLog("----------------")
    # 可通过游戏 内编辑器在 检查点模式 下添加刀 / Shift
    # 过去的地图 数据需 要更新，以便在 地图 数据包含刀 / Shift 数据
    printLog("----------------")


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

rule "Custom portals data - 自定义传送门数据  <---- EDIT ME / 在此处编辑":
    @Disabled
    #warning: This can cause you to exceed global orb/portal limit. 
    #make sure portal + orbs do not go past the limit.
    #请先确保传 送门+球体 总数不会超 过可添加数 量上限.
    wait(1)
    #Portal start position
    #传送门起点 位置
    CustomPortalStart = [vect(0,0,0)]
    #Portal end position (on same number as start position)
  #  传送门终点 位置 (顺序与传 送门起点位 置保持一致)
    CustomPortalEndpoint = [vect(0,10,0)]
    #Portal checkpoint (on same number as start position) 
    #999 = apply portal to entire map
    #启用传送门 检查点 (顺序与传 送门起点位 置保持一致) 
    #999 = 传送门在全 部检查点启用
    CustomPortalCP = [999]

rule "Fake Triple Jump - enable rule - 启用此规则 - 假三级跳": # method c
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
        if eventPlayer.ban_triple and eventPlayer.InvincibleToggle == false and eventPlayer.NotOnLastCp: # handle bans and invincible
            smallMessage(eventPlayer,"  三段跳 ▲ 已禁用!" checkCN "   Triple Jump ▲ is banned!")
            return
        eventPlayer.applyImpulse(Vector.UP, 9, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)


rule "Friend Title - 朋友称号 <---- DISPLAY MESSAGE HERE (ON PLAYER)":
    @Disabled
    @Delimiter
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()

    # "your nickname" your friends ingame name
    # "display title" fill in the custom title
    # "your nickname" 填入球员 的名字 
    # "display title" 习俗标题

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

rule "HUD text for certain Checkpoints - 某些检查点的HUD文本 <---- EDIT ME / 在此处编辑":
    @Disabled
    # the example fill shows a text for cp 1 and cp 3
    # 示例填充 显示了cp 1和cp 3的文本
    wait(1)
    # in CpHudText fill in text
    # 在 “CpHudText” 中填写文本
    CpHudText = ["text cp 1","text cp 3"]
    # in CpHudCp fill in the at wich to display
    # 在 “CpHudCp” 中填写要显 示的位置
    CpHudCp = [1, 3]
    
rule "Inworld text for certain Checkpoints - 在世界文本中为某些检查点 <---- EDIT ME / 在此处编辑":
    @Disabled
    # the example fill shows a text for cp 1 and cp 3
    # 示例填充 显示了cp 1和cp 3的文本
    wait(1)
    # in CpIwtText fill in text 
    # 在 “CpIwtText” 中填写文本
    CpIwtText = ["text cp 1","text cp 3"]
    # in CpIwtCp fill in cp at wich to display
    # 在 “CpIwtCp” 中填写 要显示的cp
    CpIwtCp = [1, 3]
    # in CpIwtPos fill in the vector 
    # 在 “CpIwtPos” 中填充向量
    CpIwtPos = [vect(0,0,0), vect(0,0,0)]
    # color applies to all 
    # 色彩运 用于全部
    CpIwtColor = Color.LIME_GREEN


rule "stall enhancer - 增强系統跳的判定 - 启用此规则":
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




#!define storespeed eventPlayer.LedgeDash[0]
#!define storedirection eventPlayer.LedgeDash[1]
#!define counting eventPlayer.LedgeDash[2]

rule "Ledge Dash - enable rule - 启用此规则 - 超级跳":
    @Disabled
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1()
    counting = 0
    waitUntil(eventPlayer.getSpeed() >= 45, 0.4)
    while eventPlayer.isUsingAbility1() and counting <= 12:
        storespeed = eventPlayer.getSpeed()
        storedirection = eventPlayer.getFacingDirection()
        if eventPlayer.getSpeed() < 45:
            #counting = -1 # dont count anymore, you dashed in an object
            smallMessage(eventPlayer,"dashed into air or object") #disable
            goto lbla
        else: 
            counting ++
        if counting == 12:
            waitUntil(eventPlayer.getSpeed() < 40, 0.4)
        wait()

    if counting >= 5: #and counting <= 12:
        smallMessage(eventPlayer,"ledge dash")
        eventPlayer.applyImpulse(storedirection, storespeed, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        #eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    elif counting > 12: #disable
        smallMessage(eventPlayer,"above 12 - climbed to long") #disable
    elif counting < 5: #disable
        smallMessage(eventPlayer,"below 5 - into object") #disable

    lbla:
    eventPlayer.LedgeDash = null
    #storespeed = null
    #storedirection = null
    #counting = null
