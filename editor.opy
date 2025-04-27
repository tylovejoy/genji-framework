#!mainFile "framework.opy"
rule "<tx0C00000000001344> Editor <tx0C00000000001344>":
    @Delimiter

rule "Editor | Clear Excess Data to Save Map":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    #@Condition eventPlayer.editor_lock == false # !!! don't lock. always be sure data can be exported incase of a perma lock situation
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.editor_lock = true # doesnt matter thats its in pasta's because it wil be fixed on spawning
    eventPlayer.editor_saveHud = TimeRemaining
    TimeRemaining = null
    CheckpointRings_Editing = null
    KillBallEffects = null
    TempIterator1 = null
    BounceEffects = null

    SaveName = null
    SaveCp = null
    SaveTimer = null
    SaveEnt = null
    #SavePauseTime = null
    #SavePauseEnabled = null
    SaveElapsed = null
    ColorConfig = null
    CompMode = null
    LeaderBoardFull = null
    LeaderBoardHuds = null
    PortalOn = null
    TitleData = null
    CpHudText = null
    CpHudCp = null
    HintText = null
    HintCp = null
    CpIwtText = null
    CpIwtCp = null
    CpIwtPos = null
    CpIwtColor = null
    PortalNames = null
    PortalLoc = null
    PortalDest  = null
    PortalEffects = null
    if Name == "name here - 作者":
        Name = "{}".format(eventPlayer)
    Cachedcredits = [Name, Code]
    Name = null
    Code = null
    async(AddonCheckMap, AsyncBehavior.NOOP)
    hudText(eventPlayer,
        "­",
        null,
        "   0. 清理无用数据:\n"
        " (此窗口打开时将自动完成)\n\n"

        "   1. 复制数据:\n"
        " Esc → 打开地图工坊查看器 → 右下角'变量目标'改为全局\n"
        " 点击窗口下方图标 (X) 复制作图数据\n\n"

        "   2. 录入数据:\n"
        " Esc → 打开地图工坊编辑器 → 规则第(2/2)页 → 展开规则'数据录入 <---- 在这输入'\n"
        " 点击'动作'一栏右侧橙色粘贴图标 录入数据\n\n"

        "   3. 地图工坊设置:\n"
        " ESC → 显示大厅 → 设置 → 地图工坊设置→\n"
        " 拉至底部 关闭'作图模式'\n 选择地图难度\n\n"

        "   4. 创建初始地图代码:\n"
        " Esc → 显示大厅 → 设置 → 分享代码 →\n"
        " 创建新的代码 → 复制并记下代码\n\n"

        "   5. 添加作者信息:\n"
        " Esc → 打开地图工坊编辑器 → 规则第(2/2)页 → 展开规则'Credits here - 作者名字'\n"
        " 修改自定义字符串文本框中的内容\n\n"

        "   6. 更新地图及作者信息:\n"
        " Esc → 显示大厅 → 设置 → 共享代码 →\n"
        " 上传至现有代码 → 粘贴步骤4中获得的代码"
        checkCN
        "   0. clear excess data:\n"
        " Already done when opening this window\n\n"

        "   1. Copy data:\n"
        " Open Workshop Inspector → Set variable target as global\n"
        " click the [x]\n\n"

        "   2. Insert data:\n"
        " Paste the data into rule named 'Map Data <---- INSERT HERE'\n\n"

        "   3. Workshop settings:\n"
        " ESC → SHOW LOBBY → SETTINGS → workshop settings →\n"
        " toggle 'Editor mode' off\n"
        " Select display difficulty\n\n"
        
        "   4. Create initial sharecode:\n"
        " ESC → SHOW LOBBY → SETTINGS → SHARE CODE →\n"
        " CREATE NEW CODE → COPY CODE\n\n"

        "   5. Add credits:\n"
        " Enter your name & map code in the 'Credits here' rule\n\n"

        "   6. Update for credits:\n"
        " ESC → SHOW LOBBY → SETTINGS → SHARE CODE →\n"
        " UPLOAD TO EXISTING CODE → PASTE THE CODE YOU CREATED IN STEP 4",
       HudPosition.TOP, HO.edit_clearec1, Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.STRING, SpecVisibility.DEFAULT)
    eventPlayer.editor_saveHud.append(getLastCreatedText())

    hudHeader(eventPlayer,
        "    > 按互动键关闭当前窗口 <    "
        checkCN
        "    > Press Interact to close this window <    "
        , HudPosition.TOP, HO.edit_clearec3, Color.LIME_GREEN, HudReeval.STRING)
    eventPlayer.editor_saveHud.append(getLastCreatedText())

    enableInspector()
    disableInspector()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), Math.INFINITY)
    waitUntil(eventPlayer.isHoldingButton(Button.INTERACT), Math.INFINITY)
    TimeRemaining = eventPlayer.editor_saveHud[0]
    destroyHudText(eventPlayer.editor_saveHud[1])
    destroyHudText(eventPlayer.editor_saveHud.last())
    eventPlayer.editor_saveHud = null
    eventPlayer.editor_lock = false

rule "Editor | Hud and Effects":
    waitUntil(entityExists(hostPlayer), Math.INFINITY)  # cant be condition because host player can leaves, removing the rule fx
    wait(1)
    if not hostPlayer.editor_on:
        # clear variables if not in editor mode
        HudStoreEdit = null
        return
    wait(2)
    #hostPlayer.editor_lock = true
    while len(HudStoreEdit): # remove unnesesary huds
        destroyHudText(HudStoreEdit[0])
        destroyInWorldText(HudStoreEdit[0])
        del HudStoreEdit[0]
    wait()

    if CompMode: # infinite time and attempts
        CompAtmpNum = null
        CompTime = Math.INFINITY
        getAllPlayers().comp_countAttempts = null
        getAllPlayers().comp_done = false

    #CustomPortalStart = CustomPortalStart if len(CustomPortalStart) else []
    #CustomPortalEndpoint = CustomPortalEndpoint if len(CustomPortalEndpoint) else []
    #CustomPortalCP = CustomPortalCP if len(CustomPortalCP) else []

    # huds ==========================================================================================================================================================================

    # restart without leaderboard (old one deleted)
    hudSubtext(localPlayer.toggle_guide,  # restart without leadwerboard
        "{0}+{1}+{2} | 重新开始".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT))
        checkCN
        "{0}+{1}+{2} | Restart".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT)),
        HudPosition.RIGHT, HO.com_restart_n_board, ColorConfig[Customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    # hud 1
    hudSubtext(hostPlayer if hostPlayer.toggle_guide else null,
        ([  "{0} + {1} | 新建检查点\n"
            "{0} + {2} | 删除选中的检查点".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)),

            "{0} + {1} | 新建击杀球\n"
            "{0} + {1} (长按) | 在准心位置新建".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),

            "{0} + {1} | 新建弹球\n"
            "{0} + {1} (长按) | 在准心位置新建".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),

            "{0} + {1} | 蹭留\n"
            "{0} + {2} | 卡小".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)),

            "{0} + {1} | 新建传送门\n"
            "{0} + {1} (长按) | 在准心位置新建".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),
        ][EditorMode.current] if not EditorMoveItem else
            "方向键 | 移动实体 \n"
            "{0} | 向上移动 \n"
            "{1} | 向下移动 \n"
            "{2} (长按) | 快速移动".format(buttonString(Button.ABILITY_2), buttonString(Button.ULTIMATE),  buttonString(Button.JUMP))
        ) checkCN
        ([
            "{0} + {1} | Create New\n"
            "{0} + {2} | Delete selected".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)),

            "{0} + {1} | Create new\n"
            "{0} + {1} (hold)| raycast new".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),

            "{0} + {1} | Create new\n"
            "{0} + {1} (hold)| raycast new".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),

            "{0} + {1} | multiclimb\n"
            "{0} + {2} | createbhop".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)
            ),
            "{0} + {1} | create new\n"
            "{0} + {1} (hold)| raycast new".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),
        ][EditorMode.current] if not EditorMoveItem else
            "walk | move selected\n"
            "{0} | move up\n"
            "{1} | move down\n"
            "{2} (hold) | move faster".format(buttonString(Button.ABILITY_2), buttonString(Button.ULTIMATE), buttonString(Button.JUMP))),
        HudPosition.RIGHT, HO.edit_instructions_edit, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    # hud 1-5
    hudSubtext(hostPlayer if hostPlayer.toggle_guide and not EditorMoveItem else null,
        ([
            [],
            "{0} + {1} | 删除选中的击杀球".format(buttonString(Button.INTERACT), buttonString(Button.SECONDARY_FIRE)),
            "{0} + {1} | 删除选中的弹球".format(buttonString(Button.INTERACT), buttonString(Button.SECONDARY_FIRE)),
            [],
            "{0} + {1} | 删除选中的传送门".format(buttonString(Button.INTERACT), buttonString(Button.SECONDARY_FIRE))
        ][EditorMode.current]
        ) checkCN
        ([
            [],
            "{0} + {1} | delete selected".format(buttonString(Button.INTERACT),  buttonString(Button.SECONDARY_FIRE)),
            "{0} + {1} | delete selected".format(buttonString(Button.INTERACT),  buttonString(Button.SECONDARY_FIRE)),
            [],
            "{0} + {1} | delete selected".format(buttonString(Button.INTERACT), buttonString(Button.SECONDARY_FIRE)),
        ][EditorMode.current]),
        HudPosition.RIGHT, HO.edit_instructions_edit1, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    # hud 2
    hudSubtext(hostPlayer if hostPlayer.toggle_guide else null,
      ([
            "{0} + {1} | 移除/新建传送点\n"
            "{0} + {2} | 检查点碰撞模型\n".format(buttonString(Button.INTERACT) , buttonString(Button.RELOAD), buttonString(Button.ABILITY_1)),

            "{0} + {1} | 选择上一个击杀球\n"
            "{0} + {2} | 选择下一个击杀球\n".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

            "{0} + {1} | 选择上一个弹球\n"
            "{0} + {2} | 选择下一个弹球\n".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

            "{0} + {1} | 爬墙\n"
            "{0} + {2} | 延二段跳".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

            "{0} + {1} | 选择下一个传送门\n"
            "{0} + {2} | 选择上一个传送门\n".format(buttonString(Button.INTERACT), buttonString(Button.JUMP), buttonString(Button.CROUCH))
        ][EditorMode.current] if not EditorMoveItem else
            #"{0} (长按) | 快速移动"
            "{0} | 放置实体"
            "{1} | cancel placement\n".format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE))
        ) checkCN
        ([
            "{0} + {1} | Remove/Add teleport\n"
            "{0} + {2} | Toggle Hitbox\n".format(buttonString(Button.INTERACT) , buttonString(Button.RELOAD), buttonString(Button.ABILITY_1)),

            "{0} + {1} | Select previous\n"
            "{0} + {2} | Select next\n".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

            "{0} + {1} | Select previous\n"
            "{0} + {2} | Select next\n".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

            "{0} + {1} | wallclimb\n"
            "{0} + {2} | save double".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

            "{0} + {1} | select next\n"
            "{0} + {2} | select previous\n".format(buttonString(Button.INTERACT), buttonString(Button.JUMP), buttonString(Button.CROUCH))
        ][EditorMode.current] if not EditorMoveItem else
            "{0} | confirm placement\n"
            "{1} | cancel placement".format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE))),
        HudPosition.RIGHT, HO.edit_instructions_edit2, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    # hud3
    hudSubtext(hostPlayer if hostPlayer.toggle_guide and not EditorMoveItem else null,
        ([
            "{0} (长按) | 移动检查点".format(buttonString(Button.ABILITY_2)),
            "{0} + {1} | 增大击杀球\n"
            "{0} + {2} | 缩小击杀球".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP), buttonString(Button.CROUCH)),

            "{0} + {1} | 增加弹球弹力\n"
            "{0} + {2} | 减少弹球弹力".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP),buttonString(Button.CROUCH)),

            "{0} + {1} | 死小\n"
            "{0} + {2} | 表情留小".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)),

            "{0} + {1} | 移动选中的实体\n"
            "{0} + {2} | 应用到当前/所有关卡(开关)".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.JUMP))
        ][EditorMode.current]
        ) checkCN
        ([
            "{0} (hold) | Move".format(buttonString(Button.ABILITY_2)),
            "{0} + {1} | Increase size\n"
            "{0} + {2} | Decrease size".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP), buttonString(Button.CROUCH)),

            "{0} + {1} | Increase strength\n"
            "{0} + {2} | Decrease strength".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP),buttonString(Button.CROUCH)),

            "{0} + {1} | death hop\n"
            "{0} + {2} | emote".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)),

            "{0} + {1} | move\n"
            "{0} + {2} | cp/map (toggle)".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.JUMP))
        ][EditorMode.current]),
        HudPosition.RIGHT, HO.edit_instructions_edit3, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    # hud4
    hudSubtext(hostPlayer if hostPlayer.toggle_guide and not EditorMoveItem else null,
        ([
            [],
            "{0} + {1} | 移动选中的实体".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE)),
            "{0} + {1} | 移动选中的实体".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE)),
            "{0} + {1} | 留小跳进点\n"
            "{0} + {2} | 站卡".format(buttonString(Button.ABILITY_2) , buttonString(Button.JUMP), buttonString(Button.CROUCH)),
            []
        ][EditorMode.current]
        ) checkCN
        ([
            [],
            "{0} + {1} | Move".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE)  ),
            "{0} + {1} | Move".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE) ),
            "{0} + {1} | require bhop\n"
            "{0} + {2} | stand create".format(buttonString(Button.ABILITY_2) , buttonString(Button.JUMP), buttonString(Button.CROUCH)),
            []
        ][EditorMode.current]),
        HudPosition.RIGHT, HO.edit_instructions_edit4, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    # ==
    /*
    hudSubtext(
        hostPlayer if hostPlayer.toggle_guide else null,
        " \n{0} + {1} | 下一关\n"
        "{0} + {2} | 上一关\n"
        "{3} (长按) | 飞行\n".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_1))
        checkCN
        " \n{0} + {1} | Next checkpoint\n"
        "{0} + {2} | Prev checkpoint\n"
        "{3} (hold)| Fly\n".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_1))
        ,HudPosition.RIGHT, HO.edit_instructions_general, Color.GREEN if hostPlayer.toggle_guide else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    */
    hudSubtext(
        hostPlayer if hostPlayer.toggle_guide else null,
        " \n{0} + {1} | 下一关".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE))
        #"{0} + {2} | 上一关"
        checkCN
        " \n{0} + {1} | Next checkpoint".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE)),
        #"{0} + {2} | Prev checkpoint"
        HudPosition.RIGHT, HO.edit_instructions_general, Color.GREEN if hostPlayer.toggle_guide else Color.ORANGE,
        HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

    hudSubtext(
        hostPlayer if hostPlayer.toggle_guide else null,
        "{1} + {2} | 上一关\n"
        "{0} (长按) | 飞行\n".format(buttonString(Button.ABILITY_1), buttonString(Button.CROUCH),buttonString(Button.SECONDARY_FIRE))
        checkCN
        "{1} + {2} | Prev checkpoint\n"
        "{0} (hold)| Fly\n".format(buttonString(Button.ABILITY_1), buttonString(Button.CROUCH),buttonString(Button.SECONDARY_FIRE)),
        HudPosition.RIGHT, HO.edit_instructions_general1, Color.GREEN if hostPlayer.toggle_guide else Color.ORANGE,
        HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

    hudSubheader(hostPlayer if hostPlayer.toggle_guide else null,
        "保存地图长按 {0} + {1} + {2} 后按弹出窗口的提示进行操作" LeftAlign96.format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD))
        checkCN
        "to save map, hold {0} + {1} + {2} then follow instructions" LeftAlign96.format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD)),
        HudPosition.LEFT, HO.edit_savemap, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudText(localPlayer if not localPlayer.editor_saveHud else null,
        (   "{0} 检查点模式\n"
            "{1} 击杀球模式\n"
            "{2} 弹球模式\n"
            "{3} 封禁(单关)\n"
            "{4} 自定义传送门 ".format(
                iconString(Icon.ARROW_RIGHT) if EditorMode.checkpoint else "     ",
                iconString(Icon.ARROW_RIGHT) if EditorMode.killBall else "     ",
                iconString(Icon.ARROW_RIGHT) if EditorMode.functionOrb else "     ",
                iconString(Icon.ARROW_RIGHT) if EditorMode.skillBan else "     ",
                iconString(Icon.ARROW_RIGHT) if EditorMode.portal else "     ")
        if hostPlayer.isHoldingButton(Button.MELEE) else
            " {1} {0} ".format(
                ["检查点模式" ,"击杀球模式","弹球模式","封禁(单关)","自定义传送门"][EditorMode.current],
                [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON), iconString(Icon.STOP), iconString(Icon.SPIRAL)][EditorMode.current])
        if localPlayer == hostPlayer else
            " {0} 源氏 编辑者 {0} ".format( iconString(Icon.BOLT))
        ) checkCN
            "{0} checkpoints\n"
            "{1} boundary spheres\n"
            "{2} function orbs\n"
            "{3} skill bans\n"
            "{4} portals".format(
                iconString(Icon.ARROW_RIGHT) if EditorMode.checkpoint else "     ",
                iconString(Icon.ARROW_RIGHT) if EditorMode.killBall else "     ",
                iconString(Icon.ARROW_RIGHT) if EditorMode.functionOrb else "     ",
                iconString(Icon.ARROW_RIGHT) if EditorMode.skillBan else "     ",
                iconString(Icon.ARROW_RIGHT) if EditorMode.portal else "     ")
        if hostPlayer.isHoldingButton(Button.MELEE) else
            " {1} {0} ".format(
                ["checkpoints" ,"boundary sphere","function orbs","skill bans","portals"][EditorMode.current],
                [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON), iconString(Icon.STOP),iconString(Icon.SPIRAL)][EditorMode.current])
        if localPlayer == hostPlayer else
            " {0} Genji editor {0} ".format(iconString(Icon.BOLT)),
        null,
        null,
        HudPosition.TOP, HO.edit_host_mode, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudText(true[0],
        null,  # original part of the one ontop of it
        ("{0} + 射击 | 切换作图模式".format(buttonString(Button.MELEE)) if localPlayer == hostPlayer else
        "房主/编辑者 {0}".format(hostPlayer))
        checkCN
        ("{0} + shoot | change mode".format(buttonString(Button.MELEE)) if localPlayer == hostPlayer else
        "Current host/editor: {0}".format(hostPlayer)),
        null,
        HudPosition.TOP,
        HO.edit_changemode,
        Color.SKY_BLUE,
        Color.GRAY if localPlayer.editor_lock else Color.WHITE,
        Color.WHITE,
        HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

    hudSubtext(hostPlayer if hostPlayer.toggle_guide and (EditorMode.checkpoint or EditorMode.functionOrb and len(hostPlayer.editor_bounceIndex)) else null, #if EditorMode.checkpoint or EditorMode.functionOrb and hostPlayer.toggle_guide and len(hostPlayer.editor_bounceIndex) else null,
        "{0} + {1} | {4} {3} | {2}" LeftAlign96.format(
            buttonString(Button.ULTIMATE),
            buttonString(Button.PRIMARY_FIRE),
            (BounceToggleUlt[EditSelected]) if EditorMode.functionOrb else
            (hostPlayer.checkpoint_current in BladeEnabledCheckpoints),
            abilityIconString(Hero.GENJI, Button.ULTIMATE),
            "检查点给刀"  if EditorMode.checkpoint else "弹球给刀"
        )
        checkCN
        "{0} + {1} | {4} give ult {3} | {2}" LeftAlign96.format(
            buttonString(Button.ULTIMATE),
            buttonString(Button.PRIMARY_FIRE),
            (BounceToggleUlt[EditSelected]) if EditorMode.functionOrb else
            (hostPlayer.checkpoint_current in BladeEnabledCheckpoints),
            abilityIconString(Hero.GENJI, Button.ULTIMATE),
            "Level" if EditorMode.checkpoint  else "Orb"),
        HudPosition.LEFT, HO.edit_orb_ult,
        Color.GREEN if BounceToggleUlt[EditSelected] and EditorMode.functionOrb else
        Color.GREEN if hostPlayer.checkpoint_current in BladeEnabledCheckpoints and EditorMode.checkpoint else Color.ORANGE,
        HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer if hostPlayer.toggle_guide and (EditorMode.checkpoint or EditorMode.functionOrb and len(hostPlayer.editor_bounceIndex)) else null, #if EditorMode.checkpoint or EditorMode.functionOrb and hostPlayer.toggle_guide and len(hostPlayer.editor_bounceIndex) else null,
        "{0} + {1} | {4} {3} | {2}" LeftAlign96.format(
            buttonString(Button.ULTIMATE),
            buttonString(Button.SECONDARY_FIRE),
            BounceToggleDash[EditSelected] if EditorMode.functionOrb else
            hostPlayer.checkpoint_current in DashEnabledCheckpoints,
            abilityIconString(Hero.GENJI, Button.ABILITY_1),
           "检查点给Shift" if EditorMode.checkpoint else "弹球给Shift")
        checkCN
        "{0} + {1} | {4} give dash {3} | {2}" LeftAlign96.format(
            buttonString(Button.ULTIMATE),
            buttonString(Button.SECONDARY_FIRE),
            BounceToggleDash[EditSelected] if EditorMode.functionOrb else
            hostPlayer.checkpoint_current in DashEnabledCheckpoints,
            abilityIconString(Hero.GENJI, Button.ABILITY_1),
            "Level" if EditorMode.checkpoint else "Orb")
        , HudPosition.LEFT, HO.edit_orb_dash,
        Color.GREEN if BounceToggleDash[EditSelected] and EditorMode.functionOrb else
        Color.GREEN if hostPlayer.checkpoint_current in DashEnabledCheckpoints and EditorMode.checkpoint else Color.ORANGE,
        HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer if EditorMode.functionOrb and hostPlayer.toggle_guide and len(hostPlayer.editor_bounceIndex) else null,
        "{0} + {1} |  收集球(进点前必须集齐) {3} | {2}\n" LeftAlign96.format(
            buttonString(Button.ULTIMATE),
            buttonString(Button.ABILITY_2),
            BounceToggleLock[EditSelected],
            iconString(Icon.ASTERISK))
        checkCN
        "{0} + {1} | unlocks checkpoint {3} | {2}\n" LeftAlign96.format(
            buttonString(Button.ULTIMATE),
            buttonString(Button.ABILITY_2),
            BounceToggleLock[EditSelected],
            iconString(Icon.ASTERISK)),
        HudPosition.LEFT, HO.edit_orb_lock, Color.GREEN if BounceToggleLock[EditSelected] else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    hudText(hostPlayer if hostPlayer.toggle_guide else null,
        "球体/传送门上限: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxLimit)
        checkCN
        "orb/portal limit: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxLimit),
        null, LeftAlign128, HudPosition.LEFT, HO.edit_orblimit, Color.BLUE, null, null, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    # display selected cc/orb info
    hudText(hostPlayer if hostPlayer.toggle_guide else null,
        (
            "\n 选中的检查点 \n 矢量: {0}{1} \n".format(
                CheckpointPositions[hostPlayer.checkpoint_current],
                [] if len(CheckpointPositions[hostPlayer.checkpoint_current]) < 2 else
                "\n 传送点: {0}".format(CheckpointPositions[hostPlayer.checkpoint_current][1]))
            if EditorMode.checkpoint and len(CheckpointPositions) else
            "\n 选中的击杀球"
            "\n 矢量: {}"
            "\n 半径: {}"
            "\n  + 進不去"
            "\n  - 出不來"
            "\n".format(
                KillBallPositions[EditSelected],
                KillBallRadii[EditSelected])
            if EditorMode.killBall and len(hostPlayer.editor_killIndex) else
            "\n 选中的弹球"
            "\n 矢量: {1}"
            "\n 弹力: {0}"
            "\n 序号: {2}\n".format(
                BounceStrength[EditSelected],
                BouncePositions[EditSelected],
                EditSelected)
            if EditorMode.functionOrb and len(hostPlayer.editor_bounceIndex) else
            "\n 封禁(单关)\n"
            "――――――――――――\n"
            " {} 蹭留 ∞\n"
            " {} 卡小 ♂\n"
            " {} 站卡 ♠\n"
            " {} 爬墙 ↑\n"
            " {} 死小 X\n"
            " {} 表情留小 ♥\n"
            " {} 延二段跳 △\n"
            "――――――――――――\n"
            " {} 留小跳进点 ≥\n".format(
                "√" if hostPlayer.checkpoint_current in BanMulti else [],
                "√" if hostPlayer.checkpoint_current in BanCreate else [],
                "√" if hostPlayer.checkpoint_current in BanStand else [],
                "√" if hostPlayer.checkpoint_current in BanClimb else [],
                "√" if hostPlayer.checkpoint_current in BanDead else [],
                "√" if hostPlayer.checkpoint_current in BanEmote else [],
                "√" if hostPlayer.checkpoint_current in BanSaveDouble else [],
                "√" if hostPlayer.checkpoint_current in BanBhop else []
            )
            if EditorMode.skillBan else
                "\n 入口矢量: {}\n"
                " 出口矢量: {}\n"
                " 应用关卡: {}\n".format(
                CustomPortalStart[EditSelected],
                CustomPortalEndpoint[EditSelected],
                "所有" if CustomPortalCP[EditSelected] < 0 else hostPlayer.checkpoint_current)
            if EditorMode.portal and CustomPortalCP[EditSelected] in [hostPlayer.checkpoint_current, -1] and len(CustomPortalCP) else
            "\n   当前无数据选中   \n"
        ) checkCN
        (
            "\n Selected Checkpoint\n Vector: {0}{1} \n".format(
                CheckpointPositions[hostPlayer.checkpoint_current],
                [] if len(CheckpointPositions[hostPlayer.checkpoint_current]) < 2 else
                "\n Teleport: {0}".format(CheckpointPositions[hostPlayer.checkpoint_current][1]))
            if EditorMode.checkpoint and len(CheckpointPositions) else
            "\n Selected boundary sphere"
            "\n Vector: {}"
            "\n radius: {}"
            "\n  + keep out"
            "\n  - stay in\n".format(KillBallPositions[EditSelected], KillBallRadii[EditSelected])
            if EditorMode.killBall and len(hostPlayer.editor_killIndex) else
            "\n Selected Bounce Orb\n Vector: {1}\n strength: {0} \n ID: {2}\n".format(
                BounceStrength[EditSelected],
                BouncePositions[EditSelected],
                EditSelected)
            if EditorMode.functionOrb and len(hostPlayer.editor_bounceIndex)  else
            "\n skill bans\n"
            "――――――――――――\n"
            " {} multi-climb ∞\n"
            " {} create ♂\n"
            " {} stand ♠\n"
            " {} climb ↑\n"
            " {} dead X\n"
            " {} emote ♥\n"
            " {} save double △\n"
            "――――――――――――\n"
            " {} require bhop ≥\n".format(
                "√" if hostPlayer.checkpoint_current in BanMulti else [],
                "√" if hostPlayer.checkpoint_current in BanCreate else [],
                "√" if hostPlayer.checkpoint_current in BanStand else [],
                "√" if hostPlayer.checkpoint_current in BanClimb else [],
                "√" if hostPlayer.checkpoint_current in BanDead else [],
                "√" if hostPlayer.checkpoint_current in BanEmote else [],
                "√" if hostPlayer.checkpoint_current in BanSaveDouble else [],
                "√" if hostPlayer.checkpoint_current in BanBhop else [])
            if EditorMode.skillBan else
                "\n Start: {} \n"
                " End: {} \n"
                " CP: {} \n".format(
                CustomPortalStart[EditSelected],
                CustomPortalEndpoint[EditSelected],
                "All" if CustomPortalCP[EditSelected] < 0 else hostPlayer.checkpoint_current)
            if EditorMode.portal and CustomPortalCP[EditSelected] in [hostPlayer.checkpoint_current, -1] and len(CustomPortalCP) else
            "\n   No data selected   \n"
        )
        , null, LeftAlign128, HudPosition.LEFT, HO.edit_selecteddata, Color.WHITE, Color.ORANGE,Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    wait(1)
    # effects ==========================================================================================================================================================================
    createInWorldText(
        localPlayer if len(EditSelectIdArray) else null,
        "选中的实体" checkCN "selected",
        KillBallPositions[EditSelected] if EditorMode.killBall else
        BouncePositions[EditSelected] if EditorMode.functionOrb else
        CustomPortalStart[EditSelected] if EditorMode.portal else
        null,
        1.2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT
    )

    createIcon(
        localPlayer if len(EditSelectIdArray) else null,
        KillBallPositions[EditSelected] if EditorMode.killBall else
        BouncePositions[EditSelected] if EditorMode.functionOrb else
        CustomPortalStart[EditSelected] if EditorMode.portal else
        null,
        Icon.ARROW_DOWN,
        IconReeval.VISIBILITY_AND_POSITION, Color.WHITE, true
    )

    # Purple sphere for teleport location
    createEffect(localPlayer if len(CheckpointPositions[hostPlayer.checkpoint_current] ) > 1 and EditorMode.checkpoint else null, Effect.SPHERE, Color.PURPLE, CheckpointPositions[hostPlayer.checkpoint_current][1]-vect(0,0.1,0), 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    # Teleport text
    createInWorldText(localPlayer if len(CheckpointPositions[hostPlayer.checkpoint_current] ) > 1 and EditorMode.checkpoint else null, "传送点位置" checkCN "teleporter location", CheckpointPositions[hostPlayer.checkpoint_current][1], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)

    # normal cp if teleport
    createEffect(hostPlayer if CheckpointPositions[hostPlayer.checkpoint_current][1] and EditorMode.checkpoint else null, Effect.RING, Color.ORANGE, CheckpointPositions[hostPlayer.checkpoint_current][0], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(hostPlayer if CheckpointPositions[hostPlayer.checkpoint_current][1] and EditorMode.checkpoint else null, "检查点位置" checkCN "level location", CheckpointPositions[hostPlayer.checkpoint_current][0], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)

    # portal fx
    createEffect(hostPlayer if len(EditSelectIdArray) and EditorMode.portal else null, Effect.SPARKLES, Color.PURPLE, CustomPortalEndpoint[EditSelected], 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

# global functions ==============================================================
rule "Editor |  Fly/Noclip Toggle":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.editor_fly == null
    @Condition EditorMoveItem == false
    waitUntil(eventPlayer.isHoldingButton(Button.RELOAD) or not eventPlayer.isHoldingButton(Button.ABILITY_1), 0.7)
    if eventPlayer.isHoldingButton(Button.RELOAD) or not eventPlayer.isHoldingButton(Button.ABILITY_1):
        wait()
        return

    eventPlayer.editor_fly = eventPlayer.getPosition() + Vector.UP
    eventPlayer.startForcingPosition(eventPlayer.editor_fly, true)
    eventPlayer.disableEnvironmentCollision(true)
    eventPlayer.disallowButton(Button.ULTIMATE)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), true)

    while eventPlayer.isAlive() and eventPlayer.editor_fly and not eventPlayer.isHoldingButton(Button.ABILITY_1):
        if not (eventPlayer == hostPlayer and EditorMoveItem):
            eventPlayer.editor_fly += flyMovementDelta
        wait()
    
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.editor_fly = null
    eventPlayer.stopForcingPosition()
    wait(1)

rule "Editor | change mode":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) != eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.editor_lock == false

    eventPlayer.editor_lock = true

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.editor_modeSelect += (5 - 1)
    else:
        eventPlayer.editor_modeSelect += 1
    eventPlayer.editor_modeSelect %= 5

    EditUpdateSelectedIds()
    EditorSelectLast()
    wait()
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 0.1)
    eventPlayer.editor_lock = false

def EditUpdateSelectedIds():
    @Name "Editor | update selected id"

    if EditorMode.killBall:
        EditSelectIdArray  = [i for _, i in KillballCheckpoints]
        EditSelectIdArray = [ i for i in EditSelectIdArray if KillballCheckpoints[i] == hostPlayer.checkpoint_current ]
    elif EditorMode.functionOrb:
        EditSelectIdArray  = [i for _, i in BouncePadCheckpoints]
        EditSelectIdArray = [ i for i in EditSelectIdArray if BouncePadCheckpoints[i] == hostPlayer.checkpoint_current ]
    elif EditorMode.portal:
        EditSelectIdArray  = [i for _, i in CustomPortalCP]
        EditSelectIdArray = [i for i in EditSelectIdArray if CustomPortalCP[i] < 0 or CustomPortalCP[i] == hostPlayer.checkpoint_current]
    else:
        EditSelectIdArray  = []

def EditorSelectLast():
    @Name "Editor | select last"
    EditSelected = EditSelectIdArray.last()

rule "Editor | create cp/orb":
    @Event eachPlayer
    @Condition eventPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.editor_lock == false
    @Condition EditorMode.current in [0,1,2,4]

    eventPlayer.editor_lock = true
    if EditorMode.checkpoint:
        if len(CheckpointPositions) and distance(eventPlayer, CheckpointPositions[hostPlayer.checkpoint_current]) <= cpcircleradius:
            smallMessage(eventPlayer, "   放置的检查点距离太近" checkCN "   Cannot place checkpoint too close.")
            goto lbl_a

        if eventPlayer.checkpoint_current >= len(CheckpointPositions) - 1:
            eventPlayer.checkpoint_current = len(CheckpointPositions) - 1

        if hostPlayer.checkpoint_current == len(CheckpointPositions) - 1:
            CheckpointPositions.append(eventPlayer.getPosition() )
            eventPlayer.checkpoint_current++
            UpdateCache()
        else:
            insert(CheckpointPositions, hostPlayer.checkpoint_current + 1, eventPlayer.getPosition())
            hostPlayer.checkpoint_current++

            KillballCheckpoints = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in KillballCheckpoints]
            BouncePadCheckpoints = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BouncePadCheckpoints]
            CustomPortalCP = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in CustomPortalCP]
            BladeEnabledCheckpoints = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BladeEnabledCheckpoints]
            DashEnabledCheckpoints = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in DashEnabledCheckpoints]

            BanMulti = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BanMulti]
            BanCreate = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BanCreate]
            BanStand = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BanStand]
            BanDead = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BanDead]
            BanEmote = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BanEmote]
            BanClimb = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BanClimb]
            BanSaveDouble = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BanSaveDouble]
            BanBhop = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BanBhop]
            BanDjump = [x + (1 if x >= hostPlayer.checkpoint_current else 0) for x in BanDjump]

        smallMessage(localPlayer, "   新检查点已创建" checkCN "   New checkpoint created")

    elif not len(CheckpointPositions):
        smallMessage(eventPlayer, "   请先放置检查点" checkCN "   You first have to make a checkpoint")
        goto lbl_a
    elif len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart) >= fxLimit:
        bigMessage(eventPlayer, "当前地图弹球/传送门数量已达上限" checkCN "Orb/portal limit reached for this map")
        goto lbl_a

    elif EditorMode.killBall:
        KillBallPositions.append(eventPlayer.getPosition())
        KillballCheckpoints.append(eventPlayer.checkpoint_current)
        KillBallRadii.append(5)
        EditUpdateSelectedIds() # to create the fx properly
        EditorSelectLast()
        createEffect(
            [i for i in getAllPlayers() if i.checkpoint_current == KillballCheckpoints[evalOnce(EditSelected)]],
            Effect.SPHERE, ColorConfig[Customize.killorb],
            KillBallPositions[evalOnce(EditSelected)],
            abs(KillBallRadii[evalOnce(EditSelected)]),
            EffectReeval.VISIBILITY_POSITION_AND_RADIUS
        )
        KillBallEffects.append(getLastCreatedEntity())
        bigMessage(true[0], "{1} {0}".format(eventPlayer.checkpoint_current, "新击杀球已创建! \n仅生效于检查点" checkCN "New boundary sphere has been created! \nOnly valid for this checkpoint"))
        waitUntil(not (eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)), true)
        #EditUpdateSelectedIds() # to arrow during the placement properly
        while eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            KillBallPositions[EditSelected] = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition()+eventPlayer.getFacingDirection() * 8, null, null, false).getHitPosition()
            wait()

    elif EditorMode.functionOrb:
        BouncePositions.append(eventPlayer.getPosition())
        BouncePadCheckpoints.append(eventPlayer.checkpoint_current)
        BounceStrength.append(10)
        BounceToggleUlt.append(false)
        BounceToggleDash.append(false)
        BounceToggleLock.append(false)
        EditUpdateSelectedIds()
        EditorSelectLast()
        createEffect(
            [x for x in getAllPlayers().concat(null) if x.checkpoint_current == BouncePadCheckpoints[evalOnce(EditSelected)] and not (evalOnce(EditSelected) in x.cache_collectedLocks)],
            Effect.ORB, ColorConfig[Customize.orb_lock] if BounceToggleLock[evalOnce(EditSelected)] else ColorConfig[Customize.orb_normal],
            BouncePositions[evalOnce(EditSelected)], 1, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
        BounceEffects.append(getLastCreatedEntity())
        bigMessage(true[0], "{1} {0}".format(eventPlayer.checkpoint_current, "新弹球已创建! \n仅生效于检查点" checkCN "New Bounce Orb has been created! \nOnly valid for this checkpoint"))
        waitUntil(not (eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)), true)
        while eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            BouncePositions[EditSelected] = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition()+eventPlayer.getFacingDirection() * 7, null, null, false).getHitPosition()
            wait()

    elif EditorMode.portal:
        CustomPortalStart.append(eventPlayer.getPosition())
        CustomPortalEndpoint.append(eventPlayer.getPosition() + 10 * Vector.UP)
        CustomPortalCP.append(eventPlayer.checkpoint_current)
        EditUpdateSelectedIds()
        EditorSelectLast()
        createEffect(
            [i for i in getAllPlayers() if CustomPortalCP[evalOnce(EditSelected)] == i.checkpoint_current or CustomPortalCP[evalOnce(EditSelected)] < 0 ],
            Effect.GOOD_AURA, ColorConfig[Customize.portal], CustomPortalStart[evalOnce(EditSelected)], 0.6,  EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
        PortalEffects.append(getLastCreatedEntity())
        EditSelected = len(CustomPortalStart) - 1
        waitUntil(not (eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)), true)
        #EditUpdateSelectedIds()
        while eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            CustomPortalStart[EditSelected] = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition()+eventPlayer.getFacingDirection() * 6, null, null, false).getHitPosition()
            wait()

        bigMessage(true[0], "新传送门已创建!\n生效于当前检查点" checkCN "Portal created \nOnly valid for this checkpoint")
        EditorMoveItem = true
        return
    else:
        goto lbl_a

    UpdateCache()

    lbl_a:
    eventPlayer.editor_lock = false
    wait(0.64)

rule "Editor | delete cp/orb/portal":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer == hostPlayer
    #@Condition EditorMoveItem == false
    #@Condition len(EditSelectIdArray) > 0
    @Condition eventPlayer.editor_lock == false

    eventPlayer.editor_lock = true
    if EditorMode.checkpoint and len(CheckpointPositions):
        # Resync Kill Orbs ==================
        eventPlayer.editor_temp = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in KillballCheckpoints] if  e >= 0]
        # eventPlayer.editor_temp = [i for e, i in KillballCheckpoints if e == hostPlayer.checkpoint_current]
        for TempIterator1 in range(len(eventPlayer.editor_temp)):
            destroyEffect(KillBallEffects[eventPlayer.editor_temp[TempIterator1]])
            del KillBallEffects[eventPlayer.editor_temp[TempIterator1]]
            wait()
        # Remove specified checkpoint
        KillballCheckpoints = [x for x in KillballCheckpoints if x != hostPlayer.checkpoint_current]
        # Decrement checkpoints after removed one
        KillballCheckpoints = [x - (1 if x > hostPlayer.checkpoint_current else 0) for x in KillballCheckpoints]
        # Remove Radii at Checkpoint indexes (temp)
        KillBallRadii = [x for x, i in KillBallRadii if i not in eventPlayer.editor_temp]
        KillBallPositions = [x for x, i in KillBallPositions if i not in eventPlayer.editor_temp]
        # Resync Bounce Orbs ==============
        eventPlayer.editor_temp = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in BouncePadCheckpoints] if  e >= 0]
        # eventPlayer.editor_temp = [i for e, i in BouncePadCheckpoints if e == hostPlayer.checkpoint_current]
        for TempIterator1 in range(len(eventPlayer.editor_temp)):
            destroyEffect(BounceEffects[eventPlayer.editor_temp[TempIterator1]])
            del BounceEffects[eventPlayer.editor_temp[TempIterator1]]
            wait()

        BouncePadCheckpoints = [x for x in BouncePadCheckpoints if x != hostPlayer.checkpoint_current]
        # Decrement checkpoints after removed one
        BouncePadCheckpoints = [x - (1 if x > hostPlayer.checkpoint_current else 0) for x in BouncePadCheckpoints]
        BouncePositions = [x for x, i in BouncePositions if i not in eventPlayer.editor_temp]
        BounceStrength = [x for x, i in BounceStrength if i not in eventPlayer.editor_temp]
        BounceToggleUlt = [x for x, i in BounceToggleUlt if i not in eventPlayer.editor_temp]
        BounceToggleDash = [x for x, i in BounceToggleDash if i not in eventPlayer.editor_temp]
        BounceToggleLock = [x for x, i in BounceToggleLock if i not in eventPlayer.editor_temp]

        # Resync custom portals ==================
        eventPlayer.editor_temp = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in CustomPortalCP] if  e >=0]
        for TempIterator1 in range(len(eventPlayer.editor_temp)):
            destroyEffect(PortalEffects[eventPlayer.editor_temp[TempIterator1]])
            del PortalEffects[eventPlayer.editor_temp[TempIterator1]]
            wait()
        # Remove specified checkpoint
        CustomPortalCP = [x for x in CustomPortalCP if x != hostPlayer.checkpoint_current]
        # Decrement checkpoints after removed one
        CustomPortalCP = [x - (1 if x > hostPlayer.checkpoint_current else 0) for x in CustomPortalCP]
        # Remove Radii at Checkpoint indexes (temp)
        CustomPortalStart = [x for x, i in CustomPortalStart if i not in eventPlayer.editor_temp]
        CustomPortalEndpoint = [x for x, i in CustomPortalEndpoint if i not in eventPlayer.editor_temp]
        eventPlayer.editor_temp = null

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
        del CheckpointPositions[hostPlayer.checkpoint_current]
        del CheckpointRings_Editing[hostPlayer.checkpoint_current]

        if hostPlayer.checkpoint_current < 1:
            hostPlayer.checkpoint_current = 0
        else:
            hostPlayer.checkpoint_current -= 1

        RebuildKillOrbs()
        RebuildBounceOrbs()
        RebuildPortals()
        smallMessage(localPlayer, "   检查点已删除" checkCN "   Checkpoint has been deleted")
    elif EditorMode.killBall and len(EditSelectIdArray):
        del KillBallPositions[EditSelected]
        del KillBallRadii[EditSelected]
        del KillballCheckpoints[EditSelected]
        destroyEffect(KillBallEffects[EditSelected])
        del KillBallEffects[EditSelected]
        RebuildKillOrbs()
    elif EditorMode.functionOrb and len(EditSelectIdArray):
        del BouncePositions[EditSelected]
        del BounceStrength[EditSelected]
        del BounceToggleUlt[EditSelected]
        del BounceToggleDash[EditSelected]
        del BounceToggleLock[EditSelected]
        destroyEffect(BounceEffects[EditSelected])
        del BounceEffects[EditSelected]
        del BouncePadCheckpoints[EditSelected]
        RebuildBounceOrbs()
    elif EditorMode.portal and len(EditSelectIdArray):
        destroyEffect(PortalEffects[EditSelected])
        wait()
        del CustomPortalStart[EditSelected]
        del CustomPortalEndpoint[EditSelected]
        del CustomPortalCP[EditSelected]
        del PortalEffects[EditSelected]
        RebuildPortals()
    else:
        eventPlayer.editor_lock = false
        wait()
        return

    UpdateCache()
    EditorSelectLast()
    eventPlayer.editor_lock = false
    wait(0.16 + (getNumberOfEntityIds()*0.007))

# orb functions ==============================================================

rule "Editor | toggle orb functions":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition EditorMode.functionOrb
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition len(EditSelectIdArray) > 0
    @Condition eventPlayer.editor_lock == false

    eventPlayer.editor_lock = true
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        BounceToggleUlt[EditSelected] = not BounceToggleUlt[EditSelected]
    elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        BounceToggleDash[EditSelected] = not BounceToggleDash[EditSelected]
    else:
        BounceToggleLock[EditSelected] = not BounceToggleLock[EditSelected]
        BounceStrength[EditSelected] = 0 if BounceToggleLock[EditSelected] else 10

    UpdateCache()
    eventPlayer.editor_lock = false
    wait()

rule "Editor | orb radi/strength":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition EditorMode.current in [1,2]
    @Condition len(EditSelectIdArray) > 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.isHoldingButton(Button.JUMP) != eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    @Condition eventPlayer.editor_lock == false

    eventPlayer.editor_lock = true
    while eventPlayer.isHoldingButton(Button.ABILITY_2) and (eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH)) :
        if EditorMode.functionOrb and len(eventPlayer.editor_bounceIndex):
            BounceStrength[EditSelected] += 0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1
        elif EditorMode.killBall and len(eventPlayer.editor_killIndex):
            KillBallRadii[EditSelected] +=  0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1
        wait(0.1)
    UpdateCache()
    eventPlayer.editor_lock = false

rule "Editor | select orb/portal":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition EditorMode.current in [1,2,4]
    @Condition len(EditSelectIdArray) > 0
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.JUMP)
    #@Condition EditorMoveItem == false
    @Condition eventPlayer.editor_lock == false

    eventPlayer.editor_lock = true
    if eventPlayer.isHoldingButton(Button.CROUCH):
        EditSelected = EditSelectIdArray.last() if EditSelectIdArray.index(EditSelected) == 0 else EditSelectIdArray[EditSelectIdArray.index(EditSelected) - 1]
    else:
        EditSelected = EditSelectIdArray[0] if EditSelectIdArray.index(EditSelected) == len(EditSelectIdArray) - 1 else EditSelectIdArray[EditSelectIdArray.index(EditSelected) + 1]

    wait()
    eventPlayer.editor_lock = false
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or not (eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.JUMP)), 0.24)

# checkpoint functions ==============================================================

rule "Editor | cp size hitbox display":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition EditorMode.current == 0
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    eventPlayer.editor_hitboxToggle = not eventPlayer.editor_hitboxToggle
    wait()

rule "Editor | cp add/remove teleport":
    @Condition hostPlayer.editor_on
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.RELOAD)
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == false
    @Condition len(CheckpointPositions) > 1
    @Condition EditorMode.current == 0
    @Condition hostPlayer.editor_lock == false
    waitUntil(hostPlayer.isHoldingButton(Button.MELEE) or not (hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD)), true) # prevent overlap with save map
    if hostPlayer.isHoldingButton(Button.MELEE) or hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD):
      return

    hostPlayer.editor_lock = true
    if not hostPlayer.checkpoint_current:
        smallMessage(hostPlayer,"   不能在第一个检查点设置传送门" checkCN "   Can't place a teleport on first checkpoint")
        hostPlayer.editor_lock = false
        return

    if len(CheckpointPositions[hostPlayer.checkpoint_current]) > 1: # remove
        CheckpointPositions[hostPlayer.checkpoint_current] = CheckpointPositions[hostPlayer.checkpoint_current][0]
        smallMessage(hostPlayer,"   关卡{0}的传送点已移除".format(hostPlayer.checkpoint_current) checkCN "   Teleport for level {0} has been removed".format(hostPlayer.checkpoint_current))
    else: # add
        CheckpointPositions[hostPlayer.checkpoint_current] = [
            CheckpointPositions[hostPlayer.checkpoint_current][0] if len(CheckpointPositions[hostPlayer.checkpoint_current]) else CheckpointPositions[hostPlayer.checkpoint_current],
            hostPlayer.getPosition()
        ]
        smallMessage(hostPlayer, "{1} {0}".format(hostPlayer.checkpoint_current,"   传送点已添加到当前关卡" checkCN "   Teleport has been added for level"))

    hostPlayer.editor_lock = false
    wait()

rule "Editor | moving checkpoint":
    @Event eachPlayer
    @Condition eventPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition EditorMode.current == 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    @Condition len(CheckpointPositions) > 0
    @Condition eventPlayer.editor_lock == false
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.addon_toggle3rdPov:
        eventPlayer.addon_toggle3rdPov = false
    eventPlayer.editor_lock = true
    eventPlayer.editor_undo = CheckpointPositions[eventPlayer.checkpoint_current]
    eventPlayer.startCamera(eventPlayer.getEyePosition() + 0.5 * Vector.UP - 2.5 * eventPlayer.getFacingDirection(), eventPlayer.getEyePosition(), 15)
    while eventPlayer.isHoldingButton(Button.ABILITY_2) and eventPlayer.isAlive() and not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            eventPlayer.setMoveSpeed(100)
        else:
            eventPlayer.setMoveSpeed(3)
        if len(CheckpointPositions[eventPlayer.checkpoint_current]):
            CheckpointPositions[eventPlayer.checkpoint_current] = [eventPlayer.getPosition(), CheckpointPositions[eventPlayer.checkpoint_current][1] ]
        else:
            CheckpointPositions[eventPlayer.checkpoint_current] = eventPlayer.getPosition()
        wait()

    eventPlayer.stopCamera()
    eventPlayer.setMoveSpeed(100)
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        CheckpointPositions[eventPlayer.checkpoint_current] = eventPlayer.editor_undo
        waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2), Math.INFINITY)

    eventPlayer.editor_lock = false

rule "Editor | add ult/dash":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition EditorMode.current == 0
    @Condition len(CheckpointPositions) > 0
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) != eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.editor_lock == false

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        toggleCpInArray(BladeEnabledCheckpoints)
    else:
        toggleCpInArray(DashEnabledCheckpoints)
    wait()

rule "Editor | toggle bans":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition EditorMode.skillBan
    @Condition len(CheckpointPositions) > 0
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.editor_lock == false

    eventPlayer.editor_lock = true
    if eventPlayer.isHoldingButton(Button.INTERACT):
        if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            toggleCpInArray(BanMulti)
        elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
            toggleCpInArray(BanCreate)
        elif eventPlayer.isHoldingButton(Button.CROUCH):
            toggleCpInArray(BanClimb)
        else:
            toggleCpInArray(BanSaveDouble)

    else:
        if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            toggleCpInArray(BanDead)
            #toggleCpInArray(BanSaveDouble)
        elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
            toggleCpInArray(BanEmote)
        elif eventPlayer.isHoldingButton(Button.CROUCH):
            toggleCpInArray(BanStand)
        else:
            toggleCpInArray(BanBhop)

    # BanStand

    wait(0.3)
    UpdateCache()
    eventPlayer.editor_lock = false


rule "Editor | portal cp change":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition EditorMode.portal
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition len(EditSelectIdArray) > 0
    #@Condition EditorMoveItem == false
    @Condition eventPlayer.editor_lock == false

    CustomPortalCP[EditSelected] = eventPlayer.checkpoint_current if CustomPortalCP[EditSelected] < 0 else -1
    wait(0.3)

rule "Editor | move object":
    @Event eachPlayer
    @Condition hostPlayer.editor_on
    @Condition eventPlayer == hostPlayer
    @Condition EditorMode.current in [1, 2, 4]
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    @Condition EditorMoveItem or (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.ABILITY_2) and eventPlayer.editor_lock == false)
    @Condition len(EditSelectIdArray) > 0

    eventPlayer.editor_lock = true
    EditorMoveItem = true
    if eventPlayer.addon_toggle3rdPov:
        eventPlayer.addon_toggle3rdPov = false
    eventPlayer.editor_fly = null

    waitUntil(not (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.ABILITY_2)), true)
    #eventPlayer.disallowButton(Button.ULTIMATE)
    #eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.setStatusEffect(null, Status.HACKED, Math.INFINITY)
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    
    if EditorMode.killBall:
        eventPlayer.editor_undo = KillBallPositions[EditSelected]
        eventPlayer.startCamera(KillBallPositions[EditSelected] + eventPlayer.getFacingDirection() * (abs(KillBallRadii[EditSelected]) * -1.5),
            KillBallPositions[EditSelected], 30)
        while not (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            KillBallPositions[EditSelected] += flyMovementDelta
            wait()

    elif EditorMode.functionOrb:
        eventPlayer.editor_undo = BouncePositions[EditSelected]
        eventPlayer.startCamera(BouncePositions[EditSelected] + eventPlayer.getFacingDirection() * -4,
            BouncePositions[EditSelected], 30)
        while not (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            BouncePositions[EditSelected] += flyMovementDelta
            wait()

    elif EditorMode.portal:
        eventPlayer.editor_undo = [CustomPortalStart[EditSelected], CustomPortalEndpoint[EditSelected]]
        # move start position
        eventPlayer.startCamera(CustomPortalStart[EditSelected] + eventPlayer.getFacingDirection() * -4,
            CustomPortalStart[EditSelected], 30)
        while not (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            CustomPortalStart[EditSelected] += flyMovementDelta
            wait()

        # move destination
        eventPlayer.startCamera(CustomPortalEndpoint[EditSelected] + eventPlayer.getFacingDirection() * -4,
            CustomPortalEndpoint[EditSelected], 30)
        waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), true)
        while not (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            CustomPortalEndpoint[EditSelected] += flyMovementDelta
            wait()

  /*if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        KillBallPositions[EditSelected] = eventPlayer.editor_undo[0]
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        BouncePositions[EditSelected] = eventPlayer.editor_undo[1]
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        CustomPortalStart[EditSelected] = eventPlayer.editor_undo[2]
        if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        CustomPortalEndpoint[EditSelected] = eventPlayer.editor_undo[3]*/
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        goto loc + 2 * EditorMode.current
    else:
    else:
        KillBallPositions[EditSelected] = eventPlayer.editor_undo
    else:
        BouncePositions[EditSelected] = eventPlayer.editor_undo
    else:
    else:
    else:
        CustomPortalStart[EditSelected] = eventPlayer.editor_undo[0]
        CustomPortalEndpoint[EditSelected] = eventPlayer.editor_undo.last()
    
    eventPlayer.editor_undo = null
    #eventPlayer.allowButton(Button.ULTIMATE)
    #eventPlayer.allowButton(Button.JUMP)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.stopCamera()
    eventPlayer.stopForcingPosition()
    EditorMoveItem = null
    UpdateCache()
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), true)
    eventPlayer.editor_lock = false
