#!mainFile "genji.opy"
rule "<tx0C00000000001344> Parkour Editor <tx0C00000000001344>":
    @Delimiter

def RebuildBounceOrbs(): # triggers in editor. delets the current orbs to place ones that can be modified. orginal orbs in "SUB | Bounce Ball Effects" 
    @Name "SUB | Rebuild Bounce Orbs"
    destroyEffect(BounceEffects)
    BounceEffects = [] 
    for TempIterator1 in range(0, len(BouncePadCheckpoints)):
        createEffect(
            [x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)] and not BouncePositions[evalOnce(TempIterator1)] in x.LockCollected], 
            Effect.ORB, 
            ColorConfig[customize.orb_lock] if BounceToggleLock[evalOnce(TempIterator1)] else ColorConfig[customize.orb_normal], 
            BouncePositions[evalOnce(TempIterator1)], 
            1, 
            EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
        BounceEffects.append(getLastCreatedEntity())
        #wait()
        if TempIterator1 % 5 == 0:
            wait()

def RebuildKillOrbs(): # triggers in editor. delets the current orbs to place ones that can be modified. orginal orbs in "SUB | Kill Orb Effects" 
    @Name "SUB | Rebuild Kill Orbs"
    destroyEffect(KillBallEffects)
    KillBallEffects = []  
    for TempIterator1 in range(0, len(KillballCheckpoints)):
        createEffect([x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == KillballCheckpoints[evalOnce(TempIterator1)]], Effect.SPHERE, ColorConfig[customize.killorb], KillBallPositions[evalOnce(TempIterator1)], KillBallRadii[evalOnce(TempIterator1)], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        KillBallEffects.append(getLastCreatedEntity())
        if TempIterator1 % 5 == 0:
            wait()

def RebuildPortals():
    @Name "SUB | Rebuild Portals"
    destroyEffect(PortalEffects)
    PortalEffects = [] 
    if len(CustomPortalCP) < 1:
        return
    
    for TempIterator1 in range(0, len(CustomPortalCP)):
        createEffect(
            [i for i in getAllPlayers() if i.CurrentCheckpoint == CustomPortalCP[evalOnce(TempIterator1)] or CustomPortalCP[evalOnce(TempIterator1)] == Math.INFINITY],
            Effect.GOOD_AURA, 
            ColorConfig[customize.portal],
            CustomPortalStart[evalOnce(TempIterator1)], 
            0.6,
            EffectReeval.VISIBILITY_POSITION_AND_RADIUS
        )
        PortalEffects.append(getLastCreatedEntity())
        if TempIterator1 % 5 == 0:
            wait()

rule "Editor | Clear Excess Data to Save Map":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    #@Condition eventPlayer.LockEditor == false # !!! don't lock. always be sure data can be exported incase of a perma lock situation
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.LockEditor = true # doesnt matter thats its in pasta's because it wil be fixed on spawning
    async(CheckMap, AsyncBehavior.NOOP)
    CheckpointRings_Editing = 0
    KillBallEffects = 0
    TempIterator1 = 0
    BounceEffects = 0

    SaveName = []
    SaveCp = []
    SaveTimer = []
    SaveEnt = []
    SavePauseTime = []
    SavePauseEnabled = []
    SaveElapsed = []

    LeaderBoardFull = []
    LeaderBoardHuds = []
    PortalOn = false
    TitleData = null
    CpHudText = null
    CpHudCp = null
    HintText = null
    HintCp = null
    CpIwtText = null
    CpIwtCp = null
    CpIwtPos = null
    CpIwtColor = null
    PortalNames = []
    PortalLoc = []
    PortalDest  = []
    PortalEffects = null

    hudText(eventPlayer,  
        " ",
        null,
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "   0. 清理无用数据:\n"
        " (此窗口打开时将自动完成)\n\n"
        
        "   1. 复制数据:\n"
        " Esc → 打开地图工坊查看器 → 右下角'变量目标'改为全局\n"
        " 点击窗口下方图标 (X) 复制作图数据\n\n"

        "   2. 录入数据:\n"
        " Esc → 打开地图工坊编辑器 → 规则第(2/2)页 → 展开规则'Map data - 数据录入'\n"
        " 点击'动作'一栏右侧橙色粘贴图标 录入数据\n\n"
        
        "   3. 地图工坊设置:\n"
        " ESC → 显示大厅 → 设置 → 地图工坊设置→\n"
        " 拉至底部 关闭'作图模式'\n 选择地图难度\n"
        checkCN
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "   0. clear excess data:\n"
        " Automatically done when opening this window\n\n"

        "   1. Copy data:\n" 
        " Open Workshop Inspector → Set variable target as global\n"
        " click the [x]\n\n"

        "   2. Insert data:\n"
        " Paste the data in the rule named 'map data pasta' (first rule)\n\n" 

        "   3. Workshop settings:\n"
        " ESC→SHOW LOBBY→SETTINGS→ workshop settings →\n"
        " toggle 'Editor mode' off\n"
        " Select display difficulty\n", 
       HudPosition.TOP, HO.edit_clearec1, Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.STRING, SpecVisibility.DEFAULT
    )
    eventPlayer.savemaphud[0] = getLastCreatedText()
        
    hudText(eventPlayer,  
        " ",
        null,
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "   4. 创建初始地图代码:\n"
        " Esc → 显示大厅 → 设置 → 分享代码 →\n"
        " 创建新的代码 → 复制并记下代码\n\n"
  
        "   5. 添加作者信息:\n"
        " Esc → 打开地图工坊编辑器 → 规则第(2/2)页 → 展开规则'Credits here - 作者名字'\n"
        " 修改自定义字符串文本框中的内容\n\n"
     
        "   6. 更新地图及作者信息:\n"
        " Esc → 显示大厅 → 设置 → 共享代码 →\n"
        " 上传至现有代码 → 粘贴步骤4中获得的代码\n"

        checkCN
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "   4. Create initial sharecode:\n" 
        " ESC→SHOW LOBBY→SETTINGS→SHARE CODE→\n"
        " CREATE NEW CODE→COPY CODE\n\n"

        "   5. Add credits:\n" 
        " Enter your name & map code in the 'Credits here' rule\n"
        " (second rule) \n\n"

        "   6. Update for credits:\n"
        " ESC→SHOW LOBBY→SETTINGS→SHARE CODE→\n"
        " UPLOAD TO EXISTING CODE→ PASTE THE CODE YOU CREATED IN STEP 4\n",
        HudPosition.TOP, HO.edit_clearec2, Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.STRING, SpecVisibility.DEFAULT
    )
    eventPlayer.savemaphud[1] = getLastCreatedText()

    hudHeader(eventPlayer, 
        "    > 按互动键关闭当前窗口 <    "
        checkCN
        "    > Press Interact to close this window <    "
        , HudPosition.TOP, HO.edit_clearec3, Color.LIME_GREEN, HudReeval.STRING
    )
    eventPlayer.savemaphud[2] = getLastCreatedText()

    enableInspector()
    disableInspector()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), Math.INFINITY)
    waitUntil(eventPlayer.isHoldingButton(Button.INTERACT), Math.INFINITY)
    destroyHudText(eventPlayer.savemaphud[0])
    destroyHudText(eventPlayer.savemaphud[1])
    destroyHudText(eventPlayer.savemaphud[2])
    eventPlayer.savemaphud = null
    eventPlayer.LockEditor = false

rule "Editor | Hud and Effects":
    waitUntil(hostPlayer.hasSpawned(), 90)  # cant be condition because host player can leaves, removing the rule fx
    EditorMoveItem = false
    wait(1)
    if not hostPlayer.EditorOn:
        # clear variables if not in editor mode
        HudStoreEdit = null 
        return
    wait(2)
    #hostPlayer.LockEditor = true
    while len(HudStoreEdit) > 0: # remove unnesesary huds
        destroyHudText(HudStoreEdit[0])
        destroyInWorldText(HudStoreEdit[0])
        del HudStoreEdit[0]
    wait()

    if CompMode: # infinite time and atemps
        CompAtmpNum = 0 
        CompTime = Math.INFINITY
        getAllPlayers().AttemptCount = null
        getAllPlayers().CompDone = false

    #CustomPortalStart = CustomPortalStart if len(CustomPortalStart) > 0 else [] 
    #CustomPortalEndpoint = CustomPortalEndpoint if len(CustomPortalEndpoint) > 0 else [] 
    #CustomPortalCP = CustomPortalCP if len(CustomPortalCP) > 0 else [] 

    # huds ==========================================================================================================================================================================
    
    # restart without leaderboard (old one deleted)
    hudSubtext(localPlayer if localPlayer.GuideToggle else null,  # restart without leadwerboard
        "{0}+{1}+{2} | 重新开始".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT)) 
        checkCN
        "{0}+{1}+{2} | Restart".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT))
        , HudPosition.RIGHT, HO.com_restart_n_board, ColorConfig[customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    
    # hud 1
    hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
        (
            [
            "{0} + {1} | 新建检查点\n"
            "{0} + {2} | 删除选中的检查点"

            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE) ),
            
            "{0} + {1} | 新建击杀球\n"
            "{0} + {1} (长按) | 在准心位置新建"
            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE) ),

            "{0} + {1} | 新建弹球\n"
            "{0} + {1} (长按) | 在准心位置新建"
            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE) ),

            "{0} + {1} | 蹭留\n"
            "{0} + {2} | 卡小"
            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE) ),

            "{0} + {1} | 新建传送门\n"
            "{0} + {1} (长按) | 在准心位置新建"
            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),
            ][hostPlayer.EditModeSelection] if EditorMoveItem == false else
                "方向键 | 移动实体 \n"
                "{0} | 向上移动 \n"
                "{1} | 向下移动 \n"
                "{2} (长按) | 快速移动"
                "".format(  buttonString(Button.JUMP), buttonString(Button.CROUCH),  buttonString(Button.SECONDARY_FIRE))
            
        ) checkCN
        (
            [
            "{0} + {1} | Create New\n"
            "{0} + {2} | Delete selected"
            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE) ),
            
            "{0} + {1} | Create new\n"
            "{0} + {1} (hold)| raycast new"
            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE) ),

            "{0} + {1} | Create new\n"
            "{0} + {1} (hold)| raycast new"
            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE) ),

            "{0} + {1} | multiclimb\n"
            "{0} + {2} | createbhop"
            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE) ),

            "{0} + {1} | create new\n"
            "{0} + {1} (hold)| raycast new"
            "".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),
            ][hostPlayer.EditModeSelection] if EditorMoveItem == false else
                "walk | move selected \n"  
                "{0} | move up\n" 
                "{1} | move down\n" 
                "{2} (hold) | move faster" 
                "".format(  buttonString(Button.JUMP), buttonString(Button.CROUCH),  buttonString(Button.SECONDARY_FIRE))
            
        )
        , HudPosition.RIGHT, HO.edit_instructions_edit, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    
    # hud 1-5
    hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
        (
            [
            "",
            
            "{0} + {1} | 删除选中的击杀球"
            "".format(buttonString(Button.INTERACT), buttonString(Button.SECONDARY_FIRE) ),

            "{0} + {1} | 删除选中的弹球"
            "".format(buttonString(Button.INTERACT), buttonString(Button.SECONDARY_FIRE) ),

            "",

            "{0} + {1} | 删除选中的传送门"
            "".format(buttonString(Button.INTERACT), buttonString(Button.SECONDARY_FIRE)),
            ][hostPlayer.EditModeSelection] 
            
        ) checkCN
        (
            
            [
            "",
            
            "{0} + {1} | Delete selected"
            "".format(buttonString(Button.INTERACT),  buttonString(Button.SECONDARY_FIRE) ),

            "{0} + {1} | Delete selected"
            "".format(buttonString(Button.INTERACT),  buttonString(Button.SECONDARY_FIRE) ),

            "",

            "{0} + {1} | delete selected"
            "".format(buttonString(Button.INTERACT), buttonString(Button.SECONDARY_FIRE)),
            ][hostPlayer.EditModeSelection]             
        )
    
        , HudPosition.RIGHT, HO.edit_instructions_edit1, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    # hud 2
    hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
      (
            [
            "{0} + {1} | 移除/新建传送点\n"
            "{0} + {2} | 检查点碰撞模型\n"
            "".format(buttonString(Button.INTERACT) , buttonString(Button.RELOAD), buttonString(Button.ABILITY_1) ),
            
            "{0} + {1} | 选择上一个击杀球\n"
            "{0} + {2} | 选择下一个击杀球\n"
            "".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP) ),

                        
            "{0} + {1} | 选择上一个弹球\n"
            "{0} + {2} | 选择下一个弹球\n"
            "".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

            "{0} + {1} | 爬墙\n"
            "".format(buttonString(Button.INTERACT), buttonString(Button.JUMP) ),
            
            "{0} + {1} | 选择下一个传送门\n"
            "{0} + {2} | 选择上一个传送门\n"
            "".format( buttonString(Button.INTERACT), buttonString(Button.JUMP), buttonString(Button.CROUCH))


            ][hostPlayer.EditModeSelection] if EditorMoveItem == false else
                #"{0} (长按) | 快速移动"
                "{0} | 放置实体"
                "".format( buttonString(Button.PRIMARY_FIRE) )
                
        ) checkCN
        (
            [
            "{0} + {1} | Remove/Add teleport\n"
            "{0} + {2} | Toggle Hitbox\n"
            "".format(buttonString(Button.INTERACT) , buttonString(Button.RELOAD), buttonString(Button.ABILITY_1) ),
            
            "{0} + {1} | Select previous\n"
            "{0} + {2} | Select next\n"
            "".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP) ),

            "{0} + {1} | Select previous\n"
            "{0} + {2} | Select next\n"
            "".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

            "{0} + {1} | wallclimb\n"
            "".format(buttonString(Button.INTERACT), buttonString(Button.JUMP) ),
            
            "{0} + {1} | select next\n"
            "{0} + {2} | select previous\n"
            "".format( buttonString(Button.INTERACT), buttonString(Button.JUMP), buttonString(Button.CROUCH))


            ][hostPlayer.EditModeSelection] if EditorMoveItem == false else
                "{0} | confirm placement" 
                "".format( buttonString(Button.PRIMARY_FIRE) )
                
        )
        ,HudPosition.RIGHT, HO.edit_instructions_edit2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    # hud3
    hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
        (
            [
            "{0} (长按) | 移动检查点"
            "".format(buttonString(Button.ABILITY_2) ),

            "{0} + {1} | 增大击杀球\n"
            "{0} + {2} | 缩小击杀球"
            "".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP), buttonString(Button.CROUCH) ),

            "{0} + {1} | 增加弹球弹力\n"
            "{0} + {2} | 减少弹球弹力"
            "".format(  buttonString(Button.ABILITY_2), buttonString(Button.JUMP),buttonString(Button.CROUCH) ),

            "{0} + {1} | 死小\n"
            "{0} + {2} | 表情留小"
            "".format( buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE) ),

            "{0} + {1} | 移动选中的实体\n"
            "{0} + {2} | 应用到当前/所有关卡(开关)"
            "".format(  buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.JUMP) )

            ][hostPlayer.EditModeSelection] if EditorMoveItem == false else ""
        ) checkCN
        (
            [
            "{0} (hold) | Move"
            "".format(buttonString(Button.ABILITY_2) ),

            "{0} + {1} | Increase size\n"
            "{0} + {2} | Decrease size"
            "".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP), buttonString(Button.CROUCH) ),

            "{0} + {1} | Increase strength\n"
            "{0} + {2} | Decrease strength"
            "".format(  buttonString(Button.ABILITY_2), buttonString(Button.JUMP),buttonString(Button.CROUCH) ),

            "{0} + {1} | deadhop\n"
            "{0} + {2} | emote"
            "".format( buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE) ),

            "{0} + {1} | move\n"
            "{0} + {2} | cp/map (toggle)"
            "".format(  buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.JUMP) )

            ][hostPlayer.EditModeSelection] if EditorMoveItem == false else ""
        )
        ,HudPosition.RIGHT, HO.edit_instructions_edit3, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    # hud4
    hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
        (
            [
            "",
            "{0} + {1} | 移动选中的实体"
            "".format( buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE)  ),
            "{0} + {1} | 移动选中的实体"
            "".format( buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE) ),
            "{0} + {1} |  留小跳进点\n"
            "{0} + {2} | 站卡"
            "".format( buttonString(Button.ABILITY_2) , buttonString(Button.JUMP), buttonString(Button.CROUCH)),
            ""
            ][hostPlayer.EditModeSelection] if EditorMoveItem == false else ""
        ) checkCN
        (
        [
        "",
        "{0} + {1} | Move"
        "".format( buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE)  ),
        "{0} + {1} | Move"
        "".format( buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE) ),
        "{0} + {1} | require bhop\n"
        "{0} + {2} | stand create"
        "".format( buttonString(Button.ABILITY_2) , buttonString(Button.JUMP), buttonString(Button.CROUCH)),
        ""
        ][hostPlayer.EditModeSelection] if EditorMoveItem == false else ""
        )
        ,HudPosition.RIGHT, HO.edit_instructions_edit4, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    # ==
    /*
    hudSubtext(
        hostPlayer if hostPlayer.GuideToggle else null, 
        " \n{0} + {1} | 下一关\n"
        "{0} + {2} | 上一关\n"
        "{3} (长按) | 飞行\n"
        "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_1))
        checkCN
        " \n{0} + {1} | Next checkpoint\n"
        "{0} + {2} | Prev checkpoint\n"
        "{3} (hold)| Fly\n"
        "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_1))
        ,HudPosition.RIGHT, HO.edit_instructions_general, Color.GREEN if hostPlayer.GuideToggle else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    */
    hudSubtext(
        hostPlayer if hostPlayer.GuideToggle else null, 
        " \n{0} + {1} | 下一关"
        #"{0} + {2} | 上一关"
        "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE))
        checkCN
        " \n{0} + {1} | Next checkpoint"
        #"{0} + {2} | Prev checkpoint"
        "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE))
        ,HudPosition.RIGHT, HO.edit_instructions_general, Color.GREEN if hostPlayer.GuideToggle else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    hudSubtext(
        hostPlayer if hostPlayer.GuideToggle else null, 
        "{1} + {2} | 上一关\n"
        "{0} (长按) | 飞行\n"
        "".format( buttonString(Button.ABILITY_1), buttonString(Button.CROUCH),buttonString(Button.SECONDARY_FIRE))
        checkCN
        "{1} + {2} | Prev checkpoint\n"
        "{0} (hold)| Fly\n"

        "".format(buttonString(Button.ABILITY_1), buttonString(Button.CROUCH),buttonString(Button.SECONDARY_FIRE))
        ,HudPosition.RIGHT, HO.edit_instructions_general1, Color.GREEN if hostPlayer.GuideToggle else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    
    hudSubheader(hostPlayer if hostPlayer.GuideToggle else null, 
        "保存地图长按 {0} + {1} + {2} 后按弹出窗口的提示进行操作".format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD))
        checkCN
        "to save map hold {0} + {1} + {2} and follow instructions".format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD))
        ,HudPosition.LEFT, HO.edit_savemap, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    
    hudText(localPlayer if not localPlayer.savemaphud else null,
        (
        "{0} 检查点模式 \n"  
        "{1} 击杀球模式 \n" 
        "{2} 弹球模式 \n" 
        "{3} 封禁(单关) \n" 
        "{4} 自定义传送门 "
        "".format(
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 0 else "     ",
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 1 else "     ",
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 2 else "     ",
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 3 else "     ",
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 4 else "     "
        )
        if hostPlayer.isHoldingButton(Button.MELEE) else
        " {1} {0} ".format(
            ["检查点模式" ,"击杀球模式","弹球模式","封禁(单关)","自定义传送门"][ hostPlayer.EditModeSelection],
            [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON), iconString(Icon.STOP),iconString(Icon.SPIRAL)][ hostPlayer.EditModeSelection]
        )  if localPlayer == hostPlayer else 
        " {0} 源氏 编辑者 {0} ".format( iconString(Icon.BOLT) )
        )
        checkCN
        "{0} Checkpoints \n" 
        "{1} Kills orbs \n"
        "{2} Bounce Orb \n"
        "{3} checkpoint bans\n"
        "{4} portals "
        "".format(
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 0 else "     ",
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 1 else "     ",
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 2 else "     ",
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 3 else "     ",
        iconString(Icon.ARROW_RIGHT) if hostPlayer.EditModeSelection == 4 else "     "
        )
        if hostPlayer.isHoldingButton(Button.MELEE) else
        " {1} {0} ".format(
            ["Checkpoints" ,"Kill orbs","Function Orb","checkpoint bans","portals"][ hostPlayer.EditModeSelection],
            [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON), iconString(Icon.STOP),iconString(Icon.SPIRAL)][ hostPlayer.EditModeSelection]
       )  if localPlayer == hostPlayer else 
        " {0} Genji editor {0} ".format( iconString(Icon.BOLT) ),

        null,
        null,   
       HudPosition.TOP, HO.edit_host_mode, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    
    hudText(
        getAllPlayers(),
        null,  # original part of the one ontop of it
        (
        "{0} + 射击 | 切换作图模式".format(buttonString(Button.MELEE)) if localPlayer == hostPlayer else 
        "房主/编辑者 {0}".format(hostPlayer) 
        )
        checkCN
        (
        "{0} + shoot | change mode".format(buttonString(Button.MELEE)) if localPlayer == hostPlayer else 
        "Current host/editor: {0}".format(hostPlayer)
        )
        , null, HudPosition.TOP, HO.edit_changemode, 
            Color.SKY_BLUE, 
            Color.GRAY if localPlayer.LockEditor else Color.WHITE, 
            Color.WHITE, 
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer if hostPlayer.GuideToggle and (hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0) else null, #if hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and hostPlayer.GuideToggle and len(hostPlayer.BounceIndex_Cache) > 0 else null, 
        "{0} + {1} | {4} {3} | {2}".format(              
            buttonString(Button.ULTIMATE), 
            buttonString(Button.PRIMARY_FIRE), 
            ("启用" if BounceToggleUlt[EditSelected] != 0 else "关闭") if  hostPlayer.EditModeSelection == 2 else
            ("启用" if hostPlayer.CurrentCheckpoint in BladeEnabledCheckpoints else "关闭"),
            abilityIconString(Hero.GENJI, Button.ULTIMATE),
            "检查点给刀"  if hostPlayer.EditModeSelection == 0 else "弹球给刀"
        )        
        checkCN
        "{0} + {1} | {4} give ult {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.PRIMARY_FIRE), 
            ("on" if BounceToggleUlt[EditSelected] != 0 else "off") if  hostPlayer.EditModeSelection == 2 else
            ("on" if hostPlayer.CurrentCheckpoint in BladeEnabledCheckpoints else "off"),
            abilityIconString(Hero.GENJI, Button.ULTIMATE),
            "Level" if hostPlayer.EditModeSelection == 0  else "Orb"
        )        
        , HudPosition.LEFT, HO.edit_orb_ult, 
        Color.GREEN if BounceToggleUlt[EditSelected] != 0 and hostPlayer.EditModeSelection == 2 else
        Color.GREEN if hostPlayer.CurrentCheckpoint in BladeEnabledCheckpoints and hostPlayer.EditModeSelection == 0 else
        Color.ORANGE
        , HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer if hostPlayer.GuideToggle and (hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0) else null, #if hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and hostPlayer.GuideToggle and len(hostPlayer.BounceIndex_Cache) > 0 else null, 
        "{0} + {1} | {4} {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.SECONDARY_FIRE), 
            ("启用" if BounceToggleDash[EditSelected] != 0 else "关闭") if  hostPlayer.EditModeSelection == 2 else
            ("启用" if hostPlayer.CurrentCheckpoint in DashEnabledCheckpoints else "关闭"),
            abilityIconString(Hero.GENJI, Button.ABILITY_1),
           "检查点给Shift" if hostPlayer.EditModeSelection == 0 else "弹球给Shift"
        )   
        checkCN
        "{0} + {1} | {4} give dash {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.SECONDARY_FIRE), 
            ("on" if BounceToggleDash[EditSelected] != 0 else "off") if  hostPlayer.EditModeSelection == 2 else
            ("on" if hostPlayer.CurrentCheckpoint in DashEnabledCheckpoints else "off"),
            abilityIconString(Hero.GENJI, Button.ABILITY_1),
            "Level" if hostPlayer.EditModeSelection == 0
            else "Orb"
        )        
        , HudPosition.LEFT, HO.edit_orb_dash, 
        Color.GREEN if BounceToggleDash[EditSelected] != 0 and hostPlayer.EditModeSelection == 2 else
        Color.GREEN if hostPlayer.CurrentCheckpoint in DashEnabledCheckpoints and hostPlayer.EditModeSelection == 0 else
        Color.ORANGE
        , HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer if hostPlayer.EditModeSelection == 2 and hostPlayer.GuideToggle and len(hostPlayer.BounceIndex_Cache) > 0 else null,
        "{0} + {1} |  收集球(进点前必须集齐) {3} | {2}\n".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.ABILITY_2),
            "启用" if BounceToggleLock[EditSelected] != 0 else "关闭",
            iconString(Icon.ASTERISK)
        )
        checkCN
        "{0} + {1} | unlocks checkpoint {3} | {2}\n".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.ABILITY_2),
            "on" if BounceToggleLock[EditSelected] != 0 else "off",
            iconString(Icon.ASTERISK)
        )
        , HudPosition.LEFT, HO.edit_orb_lock, Color.GREEN if BounceToggleLock[EditSelected] != 0 else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    hudText(hostPlayer if hostPlayer.GuideToggle else null,
        "球体/传送门上限: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxLimit)
        checkCN
        "orb/portal limit: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxLimit),
        null, null, HudPosition.LEFT, HO.edit_orblimit, Color.BLUE, Color.SKY_BLUE,Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    
    # display selected cc/orb info
    hudText(hostPlayer if hostPlayer.GuideToggle else null, 
        (
            "\n 选中的检查点 \n 矢量: {0}{1} \n".format(
                CheckpointPositions[hostPlayer.CurrentCheckpoint],
                "" if len(CheckpointPositions[hostPlayer.CurrentCheckpoint]) < 2 else
                "\n 传送点: {0}".format(CheckpointPositions[hostPlayer.CurrentCheckpoint][1])
            ) 
            if hostPlayer.EditModeSelection == 0 and len(CheckpointPositions) > 0 else  
            "\n 选中的击杀球 \n 矢量: {1} \n 半径: {0} \n".format(
                KillBallRadii[EditSelected],
                KillBallPositions[EditSelected]      
            ) 
            if hostPlayer.EditModeSelection == 1 and len(hostPlayer.KillIndex_Cache) > 0 else             
            "\n 选中的弹球 \n 矢量: {1} \n 弹力: {0} \n 序号: {2} \n".format(
                BounceStrength[EditSelected],
                BouncePositions[EditSelected],
                EditSelected
            )
            if hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0  else  
            "\n 封禁(单关)\n"
            "――――――――――――\n"
            " {} 蹭留\n"
            " {} 卡小\n"
            " {} 站卡\n"
            " {} 爬墙\n"
            " {} 死小\n"
            " {} 表情留小\n"
            "――――――――――――\n"
            " {} 留小跳进点\n"
            "".format(
                "√" if hostPlayer.CurrentCheckpoint in BanMulti else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanCreate else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanStand else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanClimb else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanDead else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanEmote else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanBhop else " " 
            ) 
            if hostPlayer.EditModeSelection == 3 else
                "\n 入口矢量: {} \n"
                " 出口矢量: {} \n"
                " 应用关卡: {} \n"
                "".format(
                CustomPortalStart[EditSelected],
                CustomPortalEndpoint[EditSelected],
                "所有" if CustomPortalCP[EditSelected] == Math.INFINITY else hostPlayer.CurrentCheckpoint
                )
            if hostPlayer.EditModeSelection == 4 and CustomPortalCP[EditSelected] in [hostPlayer.CurrentCheckpoint, Math.INFINITY] and len(CustomPortalCP) > 0 else
            "\n   当前无数据选中   \n"
        )         
        checkCN
        (
            "\n Selected Checkpoint \n Vector: {0}{1} \n".format(
                CheckpointPositions[hostPlayer.CurrentCheckpoint],
                "" if len(CheckpointPositions[hostPlayer.CurrentCheckpoint]) < 2 else
                "\n Teleport: {0}".format(CheckpointPositions[hostPlayer.CurrentCheckpoint][1])
            ) 
            if hostPlayer.EditModeSelection == 0 and len(CheckpointPositions) > 0 else  
            "\n Selected Kill Orb \n Vector: {1} \n radius: {0} \n".format(
                KillBallRadii[EditSelected],
                KillBallPositions[EditSelected]      
            ) 
            if hostPlayer.EditModeSelection == 1 and len(hostPlayer.KillIndex_Cache) > 0 else             
            "\n Selected Bounce Orb \n Vector: {1} \n strength: {0} \n ID: {2} \n".format(
                BounceStrength[EditSelected],
                BouncePositions[EditSelected],
                EditSelected
            )
            if hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0  else   
            "\n bans\n"
            "――――――――――――\n"
            " {} multi\n"
            " {} create\n"
            " {} Stand\n"
            " {} climb\n"
            " {} dead\n"
            " {} emote\n"
            "――――――――――――\n"
            " {} require bhop\n"
            "".format(
                "√" if hostPlayer.CurrentCheckpoint in BanMulti else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanCreate else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanStand else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanClimb else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanDead else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanEmote else " ",
                "√" if hostPlayer.CurrentCheckpoint in BanBhop else " " 
            ) 
            if hostPlayer.EditModeSelection == 3 else
                "\n Start: {} \n"
                " End: {} \n"
                " CP: {} \n"
                "".format(
                CustomPortalStart[EditSelected],
                CustomPortalEndpoint[EditSelected],
                "All" if CustomPortalCP[EditSelected] == Math.INFINITY else hostPlayer.CurrentCheckpoint
                )
            if hostPlayer.EditModeSelection == 4 and CustomPortalCP[EditSelected] in [hostPlayer.CurrentCheckpoint, Math.INFINITY] and len(CustomPortalCP) > 0 else

            "\n   No data selected   \n"
            

        )
        , null, null, HudPosition.LEFT, HO.edit_selecteddata, Color.WHITE, Color.ORANGE,Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    wait(1)
    # effects ==========================================================================================================================================================================   
    createInWorldText(
        getAllPlayers() if len(EditSelectIdArray) > 0 else null,     
        "选中的实体" checkCN "selected"
        , 
        KillBallPositions[EditSelected] if hostPlayer.EditModeSelection == 1 else
        BouncePositions[EditSelected] if hostPlayer.EditModeSelection == 2 else
        CustomPortalStart[EditSelected] if hostPlayer.EditModeSelection == 4 else
        null,
        1.2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT
    )

    createIcon(
        getAllPlayers() if len(EditSelectIdArray) > 0 else null,     
        KillBallPositions[EditSelected] if hostPlayer.EditModeSelection == 1 else
        BouncePositions[EditSelected] if hostPlayer.EditModeSelection == 2 else
        CustomPortalStart[EditSelected] if hostPlayer.EditModeSelection == 4 else
        null, 
        Icon.ARROW_DOWN, 
        IconReeval.VISIBILITY_AND_POSITION, Color.WHITE, true
    )

    # Purple sphere for teleport location
    createEffect(getAllPlayers() if len(CheckpointPositions[hostPlayer.CurrentCheckpoint] ) > 1 and hostPlayer.EditModeSelection == 0 else null, Effect.SPHERE, Color.PURPLE, CheckpointPositions[hostPlayer.CurrentCheckpoint][1]-vect(0,0.1,0), 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  
    # Teleport text
    createInWorldText(getAllPlayers() if len(CheckpointPositions[hostPlayer.CurrentCheckpoint] ) > 1 and hostPlayer.EditModeSelection == 0 else null, "传送点位置" checkCN "teleporter location", CheckpointPositions[hostPlayer.CurrentCheckpoint][1], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
        
    # normal cp if teleport
    createEffect(hostPlayer if CheckpointPositions[hostPlayer.CurrentCheckpoint][1] and hostPlayer.EditModeSelection == 0 else null, Effect.RING, Color.ORANGE, CheckpointPositions[hostPlayer.CurrentCheckpoint][0], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(hostPlayer if CheckpointPositions[hostPlayer.CurrentCheckpoint][1] and hostPlayer.EditModeSelection == 0 else null, "检查点位置" checkCN "level location", CheckpointPositions[hostPlayer.CurrentCheckpoint][0], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    
    # portal fx
    createEffect(hostPlayer if len(EditSelectIdArray) > 0 and hostPlayer.EditModeSelection == 4 else null, Effect.SPARKLES, Color.PURPLE, CustomPortalEndpoint[EditSelected], 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

# global functions ==============================================================
rule "Editor |  Fly/Noclip Toggle":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) 
    @Condition eventPlayer.flytoggle == null
    @Condition EditorMoveItem == false
    waitUntil(eventPlayer.isHoldingButton(Button.RELOAD) or not eventPlayer.isHoldingButton(Button.ABILITY_1), 0.7)
    if eventPlayer.isHoldingButton(Button.RELOAD) or not eventPlayer.isHoldingButton(Button.ABILITY_1):
        wait()
        return 

    eventPlayer.flytoggle = eventPlayer.getPosition() + Vector.UP
    eventPlayer.startForcingPosition(eventPlayer.flytoggle, true)
    eventPlayer.disableEnvironmentCollision(true)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), 1)

    while eventPlayer.isAlive() and eventPlayer.flytoggle != null and not eventPlayer.isHoldingButton(Button.ABILITY_1):
        if not (eventPlayer == hostPlayer and EditorMoveItem):
            eventPlayer.flytoggle += (0.25 + eventPlayer.isHoldingButton(Button.JUMP) - 0.24 * eventPlayer.isHoldingButton(Button.CROUCH)) * (
                eventPlayer.getFacingDirection() * eventPlayer.getThrottle().z +
                worldVector(eventPlayer.getThrottle() * Vector.LEFT, eventPlayer, Transform.ROTATION))
        wait()

    eventPlayer.enableEnvironmentCollision()
    eventPlayer.flytoggle = null
    eventPlayer.stopForcingPosition()
    wait(1)

rule "Editor | change mode":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)    
    @Condition eventPlayer.LockEditor == false

    eventPlayer.LockEditor = true
    EditorMoveItem = false
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        while eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            eventPlayer.EditModeSelection = eventPlayer.EditModeSelection - 1 if eventPlayer.EditModeSelection > 0 else 4
            waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 0.1)
            wait(0.1)
    else:
        while eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
            eventPlayer.EditModeSelection = (eventPlayer.EditModeSelection  + 1) % 5  
            waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 0.1)
            wait(0.1)

    wait()
    editupdateselectedids() 
    EditorSelectLast()
    wait()
    eventPlayer.LockEditor = false
  
def editupdateselectedids():
    @Name "Editor | update selected id"
    
    if hostPlayer.EditModeSelection == 1:
        EditSelectIdArray  = [i for _, i in KillballCheckpoints]
        EditSelectIdArray = [ i for i in EditSelectIdArray if KillballCheckpoints[i] == hostPlayer.CurrentCheckpoint ]
    elif hostPlayer.EditModeSelection == 2:
        EditSelectIdArray  = [i for _, i in BouncePadCheckpoints]
        EditSelectIdArray = [ i for i in EditSelectIdArray if BouncePadCheckpoints[i] == hostPlayer.CurrentCheckpoint ]
    elif hostPlayer.EditModeSelection == 4:
        EditSelectIdArray  = [i for _, i in CustomPortalCP]
        EditSelectIdArray = [i for i in EditSelectIdArray if CustomPortalCP[i] == Math.INFINITY or CustomPortalCP[i] == hostPlayer.CurrentCheckpoint ]
    else:
        EditSelectIdArray  = []

def EditorSelectLast():
    @Name "Editor | select last"
    EditSelected = EditSelectIdArray.last()

rule "Editor | create cp/orb":
    @Event eachPlayer
    @Condition eventPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.LockEditor == false
    @Condition hostPlayer.EditModeSelection in [0,1,2,4]

    eventPlayer.LockEditor = true
    if eventPlayer.EditModeSelection == 0:
        if len(CheckpointPositions) > 1 and distance(eventPlayer, CheckpointPositions[hostPlayer.CurrentCheckpoint]) <= cpcircleradius:
            smallMessage(eventPlayer, "   放置的检查点距离太近" checkCN "   Cannot place checkpoints too close.")
            goto endlbl

        if eventPlayer.CurrentCheckpoint > len(CheckpointPositions) - 1:
            eventPlayer.CurrentCheckpoint = len(CheckpointPositions) - 1

        if hostPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1:
            CheckpointPositions.append(eventPlayer.getPosition() )
            eventPlayer.CurrentCheckpoint ++
            UpdateCache()
        else:
            insert(CheckpointPositions, hostPlayer.CurrentCheckpoint + 1, eventPlayer.getPosition())
            hostPlayer.CurrentCheckpoint ++           
            
            KillballCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in KillballCheckpoints]
            BouncePadCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BouncePadCheckpoints]
            CustomPortalCP = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in CustomPortalCP]
            BladeEnabledCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BladeEnabledCheckpoints]
            DashEnabledCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in DashEnabledCheckpoints]

            BanMulti = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BanMulti]
            BanCreate = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BanCreate]
            BanStand = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BanStand]
            BanDead = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BanDead]
            BanEmote = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BanEmote]
            BanClimb = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BanClimb]
            BanSaveDouble = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BanSaveDouble]
            BanBhop = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BanBhop]
            BanDjump = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BanDjump]
            
        smallMessage(getAllPlayers(), "   新检查点已创建" checkCN "   New Checkpoint has been created")
    
    elif len(CheckpointPositions) < 1:
        smallMessage(eventPlayer, "   请先放置检查点" checkCN "   You first have to make a checkpoint")
        goto endlbl
    elif len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart) >= fxLimit:
        bigMessage(eventPlayer, "当前地图弹球/传送门数量已达上限" checkCN "Orb/portal limit reached for this map")
        goto endlbl

    elif eventPlayer.EditModeSelection == 1:
        KillBallPositions.append(eventPlayer.getPosition())
        KillballCheckpoints.append(eventPlayer.CurrentCheckpoint)
        KillBallRadii.append(5)
        editupdateselectedids() # to create the fx properly
        EditorSelectLast()
        createEffect(
            [i for i in getAllPlayers() if i.CurrentCheckpoint == KillballCheckpoints[evalOnce(EditSelected)]],
            Effect.SPHERE, ColorConfig[customize.killorb], 
            KillBallPositions[evalOnce(EditSelected)], 
            KillBallRadii[evalOnce(EditSelected)], 
            EffectReeval.VISIBILITY_POSITION_AND_RADIUS
        )
        KillBallEffects.append(getLastCreatedEntity())
        bigMessage(getAllPlayers(), "{1} {0}".format(eventPlayer.CurrentCheckpoint, "新击杀球已创建! \r\n仅生效于检查点" checkCN "New Kill Orb has been created! \r\nIt's only valid for checkpoint"))
        waitUntil(not (eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)), 1)
        #editupdateselectedids() # to arrow during the placement properly
        while eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            KillBallPositions[EditSelected] = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition()+eventPlayer.getFacingDirection() * 8, null, null, false).getHitPosition()
            wait()

    elif eventPlayer.EditModeSelection == 2: 
        BouncePositions.append(eventPlayer.getPosition())
        BouncePadCheckpoints.append(eventPlayer.CurrentCheckpoint)
        BounceStrength.append(10)
        BounceToggleUlt.append(false)
        BounceToggleDash.append(false)
        BounceToggleLock.append(false)
        editupdateselectedids()
        EditorSelectLast()
        createEffect(
            [x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(EditSelected)] and not BouncePositions[evalOnce(EditSelected)]  in x.LockCollected], 
            Effect.ORB, ColorConfig[customize.orb_lock] if BounceToggleLock[evalOnce(EditSelected)] else ColorConfig[customize.orb_normal], 
            BouncePositions[evalOnce(EditSelected)], 1, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
        BounceEffects.append(getLastCreatedEntity())
        bigMessage(getAllPlayers(), "{1} {0}".format(eventPlayer.CurrentCheckpoint, "新弹球已创建! \r\n仅生效于检查点" checkCN "New Bounce Orb has been created! \r\nIt's only valid for checkpoint"))
        waitUntil(not (eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)), 1)
        while eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            BouncePositions[EditSelected] = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition()+eventPlayer.getFacingDirection() * 7, null, null, false).getHitPosition()
            wait()

    elif eventPlayer.EditModeSelection == 4:
        CustomPortalStart.append(eventPlayer.getPosition())
        CustomPortalEndpoint.append(eventPlayer.getPosition()+vect(0,10,0))
        CustomPortalCP.append(eventPlayer.CurrentCheckpoint)
        editupdateselectedids()
        EditorSelectLast()
        createEffect(
            [i for i in getAllPlayers() if i.CurrentCheckpoint == CustomPortalCP[evalOnce(EditSelected)] or CustomPortalCP[evalOnce(EditSelected)] == Math.INFINITY],
            Effect.GOOD_AURA, ColorConfig[customize.portal], CustomPortalStart[evalOnce(EditSelected)], 0.6,  EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
        PortalEffects.append(getLastCreatedEntity())
        EditSelected = len(CustomPortalStart) - 1
        waitUntil(not (eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)), 1)
        #editupdateselectedids()
        while eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            CustomPortalStart[EditSelected] = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition()+eventPlayer.getFacingDirection() * 6, null, null, false).getHitPosition()
            wait()

        bigMessage(getAllPlayers(), "新传送门已创建!\n生效于当前检查点" checkCN "Portal created \r\nIt's only valid for checkpoint")  
        EditorMoveItem = true
        return
    else:
        goto endlbl

    UpdateCache()
    
    endlbl:
    eventPlayer.LockEditor = false
    wait(0.64)

rule "Editor | delete cp/orb/portal":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) 
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer == hostPlayer
    #@Condition EditorMoveItem == false
    #@Condition len(EditSelectIdArray) > 0
    @Condition eventPlayer.LockEditor == false

    eventPlayer.LockEditor = true
    if eventPlayer.EditModeSelection == 0 and len(CheckpointPositions) > 0:
        # Resync Kill Orbs ==================
        eventPlayer.Temp = []
        eventPlayer.Temp = [e for e in [(i if e2 == hostPlayer.CurrentCheckpoint else -1) for e2, i in KillballCheckpoints] if  e >=0]
        # eventPlayer.Temp = [i for e, i in KillballCheckpoints if e == hostPlayer.CurrentCheckpoint]
        for TempIterator1 in range(len(eventPlayer.Temp)):
            destroyEffect(KillBallEffects[eventPlayer.Temp[TempIterator1]])
            del KillBallEffects[eventPlayer.Temp[TempIterator1]]
            wait()
        # Remove specified checkpoint
        KillballCheckpoints = [x for x in KillballCheckpoints if x != hostPlayer.CurrentCheckpoint]
        # Decrement checkpoints after removed one
        KillballCheckpoints = [x - (1 if x > hostPlayer.CurrentCheckpoint else 0) for x in KillballCheckpoints]
        # Remove Radii at Checkpoint indexes (temp)
        KillBallRadii = [x for x, i in KillBallRadii if i not in eventPlayer.Temp]
        KillBallPositions = [x for x, i in KillBallPositions if i not in eventPlayer.Temp]
        eventPlayer.Temp = []
        # Resync Bounce Orbs ==============
        eventPlayer.Temp = [e for e in [(i if e2 == hostPlayer.CurrentCheckpoint else -1) for e2, i in BouncePadCheckpoints] if  e >= 0]
        # eventPlayer.Temp = [i for e, i in BouncePadCheckpoints if e == hostPlayer.CurrentCheckpoint]
        for TempIterator1 in range(len(eventPlayer.Temp)):
            destroyEffect(BounceEffects[eventPlayer.Temp[TempIterator1]])
            del BounceEffects[eventPlayer.Temp[TempIterator1]]
            wait()      
        
        BouncePadCheckpoints = [x for x in BouncePadCheckpoints if x != hostPlayer.CurrentCheckpoint]
        # Decrement checkpoints after removed one
        BouncePadCheckpoints = [x - (1 if x > hostPlayer.CurrentCheckpoint else 0) for x in BouncePadCheckpoints]
        BouncePositions = [x for x, i in BouncePositions if i not in eventPlayer.Temp]
        BounceStrength = [x for x, i in BounceStrength if i not in eventPlayer.Temp]
        BounceToggleUlt = [x for x, i in BounceToggleUlt if i not in eventPlayer.Temp]
        BounceToggleDash = [x for x, i in BounceToggleDash if i not in eventPlayer.Temp]
        BounceToggleLock = [x for x, i in BounceToggleLock if i not in eventPlayer.Temp]    

        # Resync custom portals ==================
        eventPlayer.Temp = []
        eventPlayer.Temp = [e for e in [(i if e2 == hostPlayer.CurrentCheckpoint else -1) for e2, i in CustomPortalCP] if  e >=0]
        for TempIterator1 in range(len(eventPlayer.Temp)):
            destroyEffect(PortalEffects[eventPlayer.Temp[TempIterator1]])
            del PortalEffects[eventPlayer.Temp[TempIterator1]]
            wait()
        # Remove specified checkpoint
        CustomPortalCP = [x for x in CustomPortalCP if x != hostPlayer.CurrentCheckpoint]
        # Decrement checkpoints after removed one
        CustomPortalCP = [x - (1 if x > hostPlayer.CurrentCheckpoint else 0) for x in CustomPortalCP]
        # Remove Radii at Checkpoint indexes (temp)
        CustomPortalStart = [x for x, i in CustomPortalStart if i not in eventPlayer.Temp]
        CustomPortalEndpoint = [x for x, i in CustomPortalEndpoint if i not in eventPlayer.Temp]
        eventPlayer.Temp = []

        # ult/dash/ban remove and lower the cp number of rest
        removeCPandLower(BladeEnabledCheckpoints)
        removeCPandLower(DashEnabledCheckpoints)
        removeCPandLower(BanMulti)
        removeCPandLower(BanCreate)
        removeCPandLower(BanStand)
        removeCPandLower(BanDead)
        removeCPandLower(BanEmote)
        removeCPandLower(BanClimb)
        removeCPandLower(BanSaveDouble)
        removeCPandLower(BanBhop)
        removeCPandLower(BanDjump)

        # Remove specified checkpoint =====================
        del CheckpointPositions[hostPlayer.CurrentCheckpoint]
        del CheckpointRings_Editing[hostPlayer.CurrentCheckpoint]
        
        if hostPlayer.CurrentCheckpoint < 1 and len(CheckpointPositions) > 0 or CheckpointPositions == []:
            hostPlayer.CurrentCheckpoint = 0
            goto lbl_a

        hostPlayer.CurrentCheckpoint -= 1
        lbl_a:
        RebuildKillOrbs()
        RebuildBounceOrbs()
        RebuildPortals()
        smallMessage(getAllPlayers(), "   检查点已删除" checkCN "   Checkpoint has been deleted")
    elif eventPlayer.EditModeSelection == 1 and len(EditSelectIdArray) > 0:
        del KillBallPositions[EditSelected]
        del KillBallRadii[EditSelected]
        del KillballCheckpoints[EditSelected]
        destroyEffect(KillBallEffects[EditSelected])
        del KillBallEffects[EditSelected]
        RebuildKillOrbs()
    elif eventPlayer.EditModeSelection == 2 and len(EditSelectIdArray) > 0:
        del BouncePositions[EditSelected]
        del BounceStrength[EditSelected]
        del BounceToggleUlt[EditSelected]
        del BounceToggleDash[EditSelected]
        del BounceToggleLock[EditSelected]
        destroyEffect(BounceEffects[EditSelected])
        del BounceEffects[EditSelected]
        del BouncePadCheckpoints[EditSelected]
        RebuildBounceOrbs()
    elif eventPlayer.EditModeSelection == 4 and len(EditSelectIdArray) > 0: 
        destroyEffect(PortalEffects[EditSelected])
        wait()
        del CustomPortalStart[EditSelected]
        del CustomPortalEndpoint[EditSelected]
        del CustomPortalCP[EditSelected]
        del PortalEffects[EditSelected]
        RebuildPortals()
    else:
        eventPlayer.LockEditor = false
        wait()
        return

    UpdateCache()
    EditorSelectLast()
    eventPlayer.LockEditor = false
    wait(0.16 + (getNumberOfEntityIds()*0.007))

# orb functions ==============================================================

rule "Editor | toggle orb functions":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 2
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition len(EditSelectIdArray) > 0
    @Condition eventPlayer.LockEditor == false

    eventPlayer.LockEditor = true
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        BounceToggleUlt[EditSelected] = not BounceToggleUlt[EditSelected]
    elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        BounceToggleDash[EditSelected] = not BounceToggleDash[EditSelected] 
    else: 
        BounceToggleLock[EditSelected] = not BounceToggleLock[EditSelected] 
        BounceStrength[EditSelected] = 0 if BounceToggleLock[EditSelected] else 10

    UpdateCache()
    eventPlayer.LockEditor = false
    wait()

rule "Editor | orb radi/strength":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer 
    @Condition eventPlayer.EditModeSelection in [1,2]
    @Condition len(EditSelectIdArray) > 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH) 
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    @Condition eventPlayer.LockEditor == false
    
    eventPlayer.LockEditor = true
    while eventPlayer.isHoldingButton(Button.ABILITY_2) and (eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH)) :
        if eventPlayer.EditModeSelection == 2 and len(eventPlayer.BounceIndex_Cache) > 0:
            BounceStrength[EditSelected] += 0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1    
        elif eventPlayer.EditModeSelection == 1 and len(eventPlayer.KillIndex_Cache) > 0:
            KillBallRadii[EditSelected] +=  0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1
        wait(0.1)
    UpdateCache()
    eventPlayer.LockEditor = false

rule "Editor | select orb/portal":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection in [1,2,4]
    @Condition len(EditSelectIdArray) > 0
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.JUMP)
    #@Condition EditorMoveItem == false
    @Condition eventPlayer.LockEditor == false

    eventPlayer.LockEditor = true
    if eventPlayer.isHoldingButton(Button.CROUCH):
        EditSelected = EditSelectIdArray.last() if EditSelectIdArray.index(EditSelected) == 0 else EditSelectIdArray[EditSelectIdArray.index(EditSelected) - 1]           
    else:
        EditSelected = EditSelectIdArray[0] if EditSelectIdArray.index(EditSelected) == len(EditSelectIdArray) - 1 else EditSelectIdArray[EditSelectIdArray.index(EditSelected) + 1]
    
    wait()
    eventPlayer.LockEditor = false
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or not (eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.JUMP)), 0.24)

# checkpoint functions ==============================================================

rule "Editor | cp size hitbox display":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition hostPlayer.EditModeSelection == 0
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    eventPlayer.EffectSizeToggle = not eventPlayer.EffectSizeToggle
    wait()

rule "Editor | cp add/remove teleport":
    @Condition hostPlayer.EditorOn
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.RELOAD)
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == false
    @Condition len(CheckpointPositions) > 1
    @Condition hostPlayer.EditModeSelection == 0
    @Condition hostPlayer.LockEditor == false
    waitUntil(hostPlayer.isHoldingButton(Button.MELEE) or not (hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD)), 1) # prevent overlap with save map
    if hostPlayer.isHoldingButton(Button.MELEE) or hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD):
      return

    hostPlayer.LockEditor = true
    if hostPlayer.CurrentCheckpoint == 0:
        smallMessage(hostPlayer,"   不能在第一个检查点设置传送门" checkCN "   Can't place a teleport on first checkpoint")
        hostPlayer.LockEditor = false
        return

    if len(CheckpointPositions[hostPlayer.CurrentCheckpoint]) > 1: # remove
        CheckpointPositions[hostPlayer.CurrentCheckpoint] = CheckpointPositions[hostPlayer.CurrentCheckpoint][0]
        smallMessage(hostPlayer,"   关卡{0}的传送点已移除".format(hostPlayer.CurrentCheckpoint) checkCN "   Teleport for level {0} has been removed".format(hostPlayer.CurrentCheckpoint))
    else: # add
        CheckpointPositions[hostPlayer.CurrentCheckpoint] = [
            CheckpointPositions[hostPlayer.CurrentCheckpoint][0] if len(CheckpointPositions[hostPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[hostPlayer.CurrentCheckpoint], 
            hostPlayer.getPosition()
        ]
        smallMessage(hostPlayer, "{1} {0}".format(hostPlayer.CurrentCheckpoint,"   传送点已添加到当前关卡" checkCN "   Teleport has been added for level"))
    
    hostPlayer.LockEditor = false
    wait()

rule "Editor | moving checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition len(CheckpointPositions) > 0
    @Condition eventPlayer.LockEditor == false
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    
    eventPlayer.LockEditor = true
    eventPlayer.setMoveSpeed(3)
    eventPlayer.startCamera( eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * -2.5) + vect(0,0.5,0), eventPlayer.getEyePosition(), 15)
    while eventPlayer.isHoldingButton(Button.ABILITY_2) and eventPlayer.isAlive() and not eventPlayer.isHoldingButton(Button.INTERACT):
        if len(CheckpointPositions[hostPlayer.CurrentCheckpoint]):
            CheckpointPositions[hostPlayer.CurrentCheckpoint] = [eventPlayer.getPosition(), CheckpointPositions[hostPlayer.CurrentCheckpoint][1] ]
        else:
            CheckpointPositions[hostPlayer.CurrentCheckpoint] = eventPlayer.getPosition() 
        wait()
        
    eventPlayer.stopCamera()
    eventPlayer.setMoveSpeed(100)
    eventPlayer.LockEditor = false

rule "Editor | add ult/dash":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer    
    @Condition hostPlayer.EditModeSelection == 0
    @Condition len(CheckpointPositions) > 0
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.LockEditor == false
    
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        toggleCpInArray(BladeEnabledCheckpoints)
    else:
        toggleCpInArray(DashEnabledCheckpoints)
    wait()


rule "Editor | toggle bans":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer    
    @Condition hostPlayer.EditModeSelection == 3
    @Condition len(CheckpointPositions) > 0
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.LockEditor == false
    
    eventPlayer.LockEditor = true
    if eventPlayer.isHoldingButton(Button.INTERACT):
        if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            toggleCpInArray(BanMulti)
        elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
            toggleCpInArray(BanCreate)
        else:
            toggleCpInArray(BanClimb)

    else:
        if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            toggleCpInArray(BanDead)
        elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
            toggleCpInArray(BanEmote)     
        elif eventPlayer.isHoldingButton(Button.CROUCH):
            toggleCpInArray(BanStand) 
        else:
            toggleCpInArray(BanBhop)

    # BanStand

    wait(0.3)
    UpdateCache()
    eventPlayer.LockEditor = false


rule "Editor | portal cp change":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer    
    @Condition hostPlayer.EditModeSelection == 4
    @Condition eventPlayer.isHoldingButton(Button.JUMP) 
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition len(EditSelectIdArray) > 0
    #@Condition EditorMoveItem == false
    @Condition eventPlayer.LockEditor == false

    CustomPortalCP[EditSelected] = eventPlayer.CurrentCheckpoint if CustomPortalCP[EditSelected] == Math.INFINITY else Math.INFINITY
    wait(0.3)


rule "Editor | move object":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer    
    @Condition eventPlayer.EditModeSelection in [1,2,4]
    @Condition EditorMoveItem or (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.ABILITY_2) and eventPlayer.LockEditor == false)
    @Condition len(EditSelectIdArray) > 0
    eventPlayer.LockEditor = true
    EditorMoveItem = true
    if eventPlayer.flytoggle == null:
        eventPlayer.startForcingPosition(eventPlayer.getPosition(),false)    

    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 1)
    if eventPlayer.EditModeSelection == 1:
        eventPlayer.startCamera(
            KillBallPositions[EditSelected] + eventPlayer.getFacingDirection() * ((KillBallRadii[EditSelected]) * -1.2),
            KillBallPositions[EditSelected],
            30
        )
        
        while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false:       
            KillBallPositions[EditSelected] += vect(0, 0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1 if eventPlayer.isHoldingButton(Button.CROUCH) else 0, 0) * (1 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 0.3)
            KillBallPositions[EditSelected] += worldVector(eventPlayer.getThrottle() * (0.25 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 0.08) ,eventPlayer, Transform.ROTATION) 
            wait()

    elif eventPlayer.EditModeSelection == 2:
        eventPlayer.startCamera(
            BouncePositions[EditSelected] + eventPlayer.getFacingDirection() * -4,
            BouncePositions[EditSelected],
            30
        )
        while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false:       
            BouncePositions[EditSelected] += vect(0, 0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1 if eventPlayer.isHoldingButton(Button.CROUCH) else 0, 0) * (1 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 0.3)
            BouncePositions[EditSelected] += worldVector(eventPlayer.getThrottle() * (0.25 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 0.08) ,eventPlayer, Transform.ROTATION) 
            wait()

    elif eventPlayer.EditModeSelection == 4:
        # move start position
        eventPlayer.startCamera(
            CustomPortalStart[EditSelected] + eventPlayer.getFacingDirection() * -3,
            CustomPortalStart[EditSelected],
            30
        )
       
        while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false:       
            CustomPortalStart[EditSelected] += vect(0, 0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1 if eventPlayer.isHoldingButton(Button.CROUCH) else 0, 0) * (1 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 0.3)
            CustomPortalStart[EditSelected] += worldVector(eventPlayer.getThrottle() * (0.25 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 0.08) ,eventPlayer, Transform.ROTATION) 
            wait()

        # move destination
        eventPlayer.startCamera(
            CustomPortalEndpoint[EditSelected] + eventPlayer.getFacingDirection() * -3,
            CustomPortalEndpoint[EditSelected],
            30
        )
        waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 1)
        while eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false:
            CustomPortalEndpoint[EditSelected] += vect(0, 0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1 if eventPlayer.isHoldingButton(Button.CROUCH) else 0, 0) * (1 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 0.3)
            CustomPortalEndpoint[EditSelected] += worldVector(eventPlayer.getThrottle() * (0.25 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 0.08) ,eventPlayer, Transform.ROTATION) 
            wait()

    eventPlayer.stopCamera()
    EditorMoveItem = false
    if eventPlayer.flytoggle == null:
        eventPlayer.stopForcingPosition()

    UpdateCache()
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE),1)
    eventPlayer.LockEditor = false
