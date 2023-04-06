#!mainFile "genji.opy"

rule "------------------------------------------------------------------------ Addon functions  ------------------------------------------------------------------------":
    @Delimiter
    @Disabled

rule "Pre-set control map portal | function | toggled via workshop":
    @Event eachPlayer
    @Condition PortalOn
    @Condition eventPlayer.InvincibleToggle or not eventPlayer.NotOnLastCp
    @Condition len(PortalLoc) != null
    @Condition any([distance(eventPlayer.getPosition() + vect(0,0.2,0),i) < 1.4 for i in PortalLoc])
    if PortalDest[PortalLoc.index(sorted(PortalLoc, lambda i: distance(eventPlayer, i))[0])] != vect(0,0,0):
        eventPlayer.teleport(
            PortalDest[PortalLoc.index(sorted(PortalLoc, lambda i: distance(eventPlayer, i))[0])] 
        )

rule "Custom portals | function":
    @Event eachPlayer
    @Condition len(CustomPortalStart) > 0

    @Condition (any([
        distance(eventPlayer.getPosition() + vect(0, 0.2, 0), ent) < portaldistance and 
        CustomPortalCP[i] in [999, eventPlayer.CurrentCheckpoint]
        for ent, i in CustomPortalStart
        ])) == true

    eventPlayer.PortalLoop = 0
    for eventPlayer.PortalLoop in range(len(CustomPortalStart)):
        if (
            distance(
                eventPlayer.getPosition() + vect(0, 0.2, 0), 
                CustomPortalStart[eventPlayer.PortalLoop]
            ) < portaldistance and 
            CustomPortalCP[eventPlayer.PortalLoop] in [999, eventPlayer.CurrentCheckpoint]
            ):
            eventPlayer.teleport(CustomPortalEndpoint[eventPlayer.PortalLoop])
            return

    wait(1)

rule "Pre-set control map portal | toggled on via workshop settings":
    @Condition PortalOn
    wait(2, Wait.ABORT_WHEN_FALSE) # overwrite pasta
    if getCurrentMap() == Map.BUSAN:
        #"down > sanc","down > meka","sanc > down","sanc > meka","meka > sanc","meka > down"
        PortalNames = ["Sanctuary","MEKA base","Downtown","MEKA base","Sanctuary","Downtown"]
        PortalLoc = [vect(47.946, 7.248, -93.922), vect(55.921, 6.998, -94.024), vect(-326.382, 10.81, 117.261), vect(-330.96, 10.81, 117.416), vect(219.567, 10.215, 243.653), vect(225.976, 10.227, 240.799)]
        PortalDest = [vect(-328.552, 10.01, 120.82), vect(221.152, 9.376, 238.765), vect(52.197, 6.301, -97.513), vect(221.271, 9.431, 238.978), vect(-328.601, 10.01, 120.823), vect(52.197, 6.299, -97.513)]
    
    elif getCurrentMap() == Map.ILIOS:
        #"light > ruin","light > well","ruin > light","ruin > well","well > light","well > ruin"
        PortalNames = ["Ruins","Well","Lighthouse","Well","Lighthouse","Ruins"]
        PortalLoc = [vect(325.722, -22.665, -40.401), vect(327.43, -22.665, -36.089), vect(26.176, 58.367, -156.415), vect(30.472, 58.367, -156.307), vect(-199.945, 2.015, -2.918), vect(-194.93, 2.015, -8.054)]
        PortalDest = [vect(28.375, 57.659, -161.195), vect(-200.464, 1.306, -8.604), vect(333.088, -23.389, -40.933), vect(-200.464, 1.306, -8.604), vect(333.088, -23.389, -40.933), vect(28.375, 57.829, -161.195)]

    elif getCurrentMap() == Map.LIJIANG_TOWER or getCurrentMap() == Map.LIJIANG_TOWER_LNY:
        #"control > garden","control > market","garden > control","garden > market","market > control","market > garden"
        PortalNames = ["Garden","Night Market","Control Center","Night Market","Control Center","Garden"]
        PortalLoc = [vect(-2.815, 271, 295.373), vect(2.905, 271, 295.052), vect(5.788, 95.056, 135.298), vect(-5.343, 95.05, 134.638), vect(-2.738, 0, -61.911), vect(5.043, 0, -61.879)]
        PortalDest = [vect(0.286, 94.292, 140.396), vect(0.584, -0.709, -54.469), vect(0.245, 270.292, 301.428), vect(0.773, -0.708, -54.361), vect(0.245, 270.292, 301.428), vect(0.286, 94.292, 140.396)]

    elif getCurrentMap() == Map.NEPAL:
        #"vil > shrine","vil > sanc", "shrine > vil","shrine > sanc",#"sanc > vil","sanc > shrine"
        PortalNames = ["Shrine","Sanctum","Village", "Sanctum",  "Village",  "Shrine"]
        PortalLoc = [vect(-194.732, -92.86, -3.802), vect(-194.585, -92.86, 4.187), vect(-33.165, 14, 5.212), vect(-33.058, 14, -5.55), vect(84.75, 129.008, -3.624), vect(84.534, 129, 4.032)]
        PortalDest = [vect(-40.19, 13.292, -0.105), vect(78.43, 128.292, 0.149), vect(-190.54, -93.569, 0.122), vect(78.43, 128.292, 0.149), vect(-190.54, -93.569, 0.122), vect(-40.19, 13.292, -0.105)]

    elif getCurrentMap() == Map.OASIS:
        #"uni > garden","uni > city","garden > uni","garden > city","city > garden","city > uni"
        PortalNames = ["Gardens","City Center","University","City Center","Gardens","University"]
        PortalLoc = [vect(-211.137, 20, -5.084), vect(-211.346, 20, 5.029), vect(143.061, 8.377, -245.04), vect(139.333, 8.377, -249.964), vect(157.297, 12.522, 255.759), vect(151.452, 12.522, 261.099)]
        PortalDest = [vect(134.366, 7.829, -240.53), vect(158.27, 11.814, 262.272), vect(-206.269, 19.292, 0.103), vect(158.283, 11.814, 262.283), vect(134.318, 7.829, -240.667), vect(-206.269, 19.292, 0.103)]

    elif getCurrentMap() == Map.ANTARCTIC_PENINSULA:
        PortalNames = ["labs", "icebreaker", "Sublevel", "icebreaker", "labs", "Sublevel"]
        PortalLoc = [vect(280.66, -12.15, -223.65), vect(273.27, 42.74, 198.15), vect(266.58, 42.74, 198.17), vect(-58.29, -154, 63.03), vect(-58.36, -154, 56.47), vect(287.08, -12.15, -223.59)]
        PortalDest = [vect(270, 42.7, 190.44), vect(284.07, -12.75, -216.15), vect(-53.51, -154.5, 60.08), vect(284.07, -12.75, -216.15), vect(270, 42.7, 190.44), vect(-53.51, -154.5, 60.08)]

    else:
        PortalDest = null
        PortalLoc = null
        PortalNames = null
        return
        
rule "Ms. Destructo | Destroys Breakable Objects On All Maps":
    # Credit: nebula#11571
    @Condition isGameInProgress()
    
    MsDestructo = []  # Multiple bots
    waitUntil(any([x.hasSpawned() for x in getAllPlayers()]), 99999)

    switch getCurrentMap():
        case Map.ILIOS:
            MapVectorArray = [vect(322.988, 40, -37.732), vect(27.711, 100, -161.298), vect(-223.895, 50, 0.89)]
            break
        case Map.BUSAN:
            MapVectorArray = [vect(51.885, 37.172, -113.654), vect(-329.934, 56.136, 149.839), vect(227.21, 43.353, 252.64)]
            break
        case Map.LIJIANG_TOWER:
            MapVectorArray = [vect(-5.808, 324.398, 282.523), vect(-0.414, 156.197, 148.681), vect(-0.381, 53.736, -33.335)]
            break
        case Map.NEPAL:
            MapVectorArray = [vect(83.1, 178.926, 0.593), vect(-49.803, 63.29, -0.413), vect(-184.659, -38.73, -0.783)]
            break
        case Map.OASIS:
            MapVectorArray = [vect(150.125, 30.619, 251.966), vect(134.888, 36.76, -240.736), vect(-195.549, 60.35, -0.098)]
            break
        case Map.NEW_QUEEN_STREET:
            MapVectorArray = [vect(-13.79, 1.96, 15.92), vect(0,35,25), vect(0,8, 23.77), vect(13.28, 2, 15)]
            break
        case Map.ANTARCTIC_PENINSULA:
            MapVectorArray = [vect(-86, -110, 59), vect(277, 132, 170), vect(283, 57, -235)]
            break
        default: 
       
            if strContains( "{}".format(getCurrentMap()) , "{}".format(Map.LIJIANG_TOWER)): # lunar new year catch
                MapVectorArray = [vect(-5.808, 324.398, 282.523), vect(-0.414, 156.197, 148.681), vect(-0.381, 53.736, -33.335)]
            elif strContains( "{}".format(getCurrentMap()) ,"{}".format(Map.BUSAN)): # lunar new year catch
                MapVectorArray = [vect(51.885, 37.172, -113.654), vect(-329.934, 56.136, 149.839), vect(227.21, 43.353, 252.64)]
            else:  # This default covers almost every map
                MapVectorArray = [
                    vect(73, 62, -17),
                    vect(169, 62, 82),
                    vect(-23, 62, -124), 
                    vect(-23, 62, 100)
                ]

            break

    for DestructoIter in range(len(MapVectorArray)):
        createDummy(Hero.DVA, [player for player in getAllPlayers() if player.hasSpawned() and not player.isDummy()][0].getTeam(), 20 - evalOnce(DestructoIter), evalOnce(MapVectorArray[evalOnce(DestructoIter)]), vect(0, 0, 0))
        MsDestructo[evalOnce(DestructoIter)] = getLastCreatedEntity()
        MsDestructo[evalOnce(DestructoIter)].startScalingSize(20, true)
        wait()
        MsDestructo[evalOnce(DestructoIter)].setGravity(0)
        MsDestructo[evalOnce(DestructoIter)].applyImpulse(Vector.UP, 1, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        MsDestructo[evalOnce(DestructoIter)].teleport(evalOnce(MapVectorArray[evalOnce(DestructoIter)]))
        wait(1)
        MsDestructo[evalOnce(DestructoIter)].disableEnvironmentCollision(true)
        wait()
        MsDestructo[evalOnce(DestructoIter)].setUltEnabled(true)
        wait()
        MsDestructo[evalOnce(DestructoIter)].setUltCharge(100)
        wait()

    wait(1)
    for DestructoIter in range(len(MapVectorArray)):
        MsDestructo[evalOnce(DestructoIter)].startForcingButton(Button.ULTIMATE)

    wait(5)
    for DestructoIter in range(len(MapVectorArray)):
        destroyDummy(MsDestructo[evalOnce(DestructoIter)].getTeam(), MsDestructo[evalOnce(DestructoIter)].getSlot())

    # Remove MsDestructo data when done
    MapVectorArray = null
    DestructoIter = null
    MsDestructo = null

FILLER
FILLER
FILLER
FILLER
FILLER
FILLER
FILLER
FILLER
FILLER
FILLER
FILLER
FILLER

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
    storespeed = null
    storedirection = null
    counting = null
