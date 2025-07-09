#!mainFile "framework.opy"
rule "<tx0C00000000001344> Editor <tx0C00000000001344>":
    @Delimiter

rule "Editor | Export Map":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition EditorOn
    @Condition hostPlayer.isHoldingButton(Button.MELEE)
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.RELOAD)
    #@Condition hostPlayer.editor_lock == false # !!! don't lock. always be sure data can be exported incase of a perma lock situation
    wait(1, Wait.ABORT_WHEN_FALSE)
    hostPlayer.editor_lock = true # doesnt matter thats its in pasta's because it wil be fixed on spawning
    hostPlayer.editor_saveCache = [TimeRemaining, ColorConfig]
    TimeRemaining = null
    ColorConfig = null
    EditorOn = null

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
    CompMode = null
    #LeaderBoardFull = null
    #LeaderBoardHuds = null
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
        Name = "{}".format(hostPlayer)
    Cachedcredits = [Name, Code]
    Name = null
    Code = null

    hudText(hostPlayer,
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
        " Esc → 打开地图工坊编辑器 → 规则第(2/2)页 → 展开规则'Credits Here - 作者名字'\n"
        " 修改自定义字符串文本框中的内容\n\n"

        "   6. 更新地图及作者信息:\n"
        " Esc → 显示大厅 → 设置 → 共享代码 →\n"
        " 上传至现有代码 → 粘贴步骤4中获得的代码"
        checkCN
        "   0. Clear Extra Data:\n"
        " Already Done Upon Opening This Window\n\n"

        "   1. Copy Data:\n"
        " Open Workshop Inspector → Set Variable Target To Global\n"
        " Click The [X]\n\n"

        "   2. Insert Data:\n"
        " Paste The Data Into Rule Named 'Map Data <---- Insert Here'\n\n"

        "   3. Workshop Settings:\n"
        " Esc → Show Lobby → Settings → Workshop Settings →\n"
        " Toggle 'Editor Mode' Off\n"
        " Select Display Difficulty\n\n"
        
        "   4. Create Initial Sharecode:\n"
        " Esc → Show Lobby → Settings → Share Code →\n"
        " Create New Code → Copy Code\n\n"

        "   5. Add Credits:\n"
        " Enter Your Name & Map Code In The 'Credits Here' Rule\n\n"

        "   6. Update For Credits:\n"
        " Esc → Show Lobby → Settings → Share Code →\n"
        " Upload To Existing Code → Paste The Code You Created In Step 4",
       HudPosition.TOP, HO.edit_clearec1, null, null, Color.LIME_GREEN, HudReeval.STRING, SpecVisibility.DEFAULT)
    hostPlayer.editor_saveCache[2] = getLastCreatedText()

    AddonCheckMap()

    enableInspector()
    disableInspector()

    EditorOn = true
    TimeRemaining = hostPlayer.editor_saveCache[0]
    ColorConfig = hostPlayer.editor_saveCache[1]

    hudHeader(hostPlayer,
        "    > 按互动键关闭当前窗口 <    "
        checkCN
        "    > Press Interact To Close This Window <    ",
        HudPosition.TOP, HO.edit_clearec3, Color.LIME_GREEN, HudReeval.STRING)
    hostPlayer.editor_saveCache[0] = getLastCreatedText()

    waitUntil(not hostPlayer.isHoldingButton(Button.INTERACT), Math.INFINITY)
    waitUntil(hostPlayer.isHoldingButton(Button.INTERACT), Math.INFINITY)
    destroyHudText(hostPlayer.editor_saveCache[0]) # Close Window
    destroyHudText(hostPlayer.editor_saveCache.last()) #Instructions
    hostPlayer.editor_saveCache = null
    hostPlayer.editor_lock = false

rule "Editor | Hud & Effects":
    wait(LoadOrder.hudsEditor)
    #waitUntil(entityExists(getAllPlayers()), Math.INFINITY)  # cant be condition because host player can leaves, removing the rule fx
    #wait()
    if EditorOn:
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
                "{0} + {2} | Delete Selected".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)),

                "{0} + {1} | Create New\n"
                "{0} + {1} (Hold)| Raycast New".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),

                "{0} + {1} | Create New\n"
                "{0} + {1} (Hold)| Raycast New".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),

                "{0} + {1} | Multi-Climb\n"
                "{0} + {2} | Createbhop".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)
                ),
                "{0} + {1} | Create New\n"
                "{0} + {1} (Hold)| Raycast New".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE)),
            ][EditorMode.current] if not EditorMoveItem else
                "Walk | Move Selected\n"
                "{0} | Move Up\n"
                "{1} | Move Down\n"
                "{2} (Hold) | Move Faster".format(buttonString(Button.ABILITY_2), buttonString(Button.ULTIMATE), buttonString(Button.JUMP))),
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
                "{0} + {1} | Delete Selected".format(buttonString(Button.INTERACT),  buttonString(Button.SECONDARY_FIRE)),
                "{0} + {1} | Delete Selected".format(buttonString(Button.INTERACT),  buttonString(Button.SECONDARY_FIRE)),
                [],
                "{0} + {1} | Delete Selected".format(buttonString(Button.INTERACT), buttonString(Button.SECONDARY_FIRE)),
            ][EditorMode.current]),
            HudPosition.RIGHT, HO.edit_instructions_edit1, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

        # hud 2
        hudSubtext(hostPlayer if hostPlayer.toggle_guide else null,
        ([
                "{0} + {1} | 移除/新建传送点\n"
                "{0} + {2} | 检查点碰撞模型\n".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD), buttonString(Button.ABILITY_1)),

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
                "{1} | Cancel Placement\n".format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE))
            ) checkCN
            ([
                "{0} + {1} | Remove/Add Teleport\n"
                "{0} + {2} | Toggle Hitbox\n".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD), buttonString(Button.ABILITY_1)),

                "{0} + {1} | Select Previous\n"
                "{0} + {2} | Select Next\n".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

                "{0} + {1} | Select Previous\n"
                "{0} + {2} | Select Next\n".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

                "{0} + {1} | Wallclimb\n"
                "{0} + {2} | Save Double".format(buttonString(Button.INTERACT), buttonString(Button.CROUCH), buttonString(Button.JUMP)),

                "{0} + {1} | Select Next\n"
                "{0} + {2} | Select Previous\n".format(buttonString(Button.INTERACT), buttonString(Button.JUMP), buttonString(Button.CROUCH))
            ][EditorMode.current] if not EditorMoveItem else
                "{0} | Confirm Placement\n"
                "{1} | Cancel Placement".format(buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE))),
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
                "{0} (Hold) | Move".format(buttonString(Button.ABILITY_2)),
                "{0} + {1} | Increase Size\n"
                "{0} + {2} | Decrease Size".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP), buttonString(Button.CROUCH)),

                "{0} + {1} | Increase Strength\n"
                "{0} + {2} | Decrease Strength".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP),buttonString(Button.CROUCH)),

                "{0} + {1} | Death Hop\n"
                "{0} + {2} | Emote".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE)),

                "{0} + {1} | Move\n"
                "{0} + {2} | Cp/Map (Toggle)".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE), buttonString(Button.JUMP))
            ][EditorMode.current]),
            HudPosition.RIGHT, HO.edit_instructions_edit3, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        # hud4
        hudSubtext(hostPlayer if hostPlayer.toggle_guide and not EditorMoveItem else null,
            ([
                [],
                "{0} + {1} | 移动选中的实体".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE)),
                "{0} + {1} | 移动选中的实体".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE)),
                "{0} + {1} | 留小跳进点\n"
                "{0} + {2} | 站卡".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP), buttonString(Button.CROUCH)),
                []
            ][EditorMode.current]
            ) checkCN
            ([
                [],
                "{0} + {1} | Move".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE)  ),
                "{0} + {1} | Move".format(buttonString(Button.ABILITY_2), buttonString(Button.PRIMARY_FIRE) ),
                "{0} + {1} | Require Bhop\n"
                "{0} + {2} | Stand Create".format(buttonString(Button.ABILITY_2), buttonString(Button.JUMP), buttonString(Button.CROUCH)),
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
            "{3} (hold)| Fly\n".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_1)),
            HudPosition.RIGHT, HO.edit_instructions_general, Color.GREEN if hostPlayer.toggle_guide else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        */
        hudSubtext(
            hostPlayer if hostPlayer.toggle_guide else null,
            " \n{0} + {1} | 下一关".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE))
            #"{0} + {2} | 上一关"
            checkCN
            " \n{0} + {1} | Next Checkpoint".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE)),
            #"{0} + {2} | Prev checkpoint"
            HudPosition.RIGHT, HO.edit_instructions_general, Color.GREEN if hostPlayer.toggle_guide else Color.ORANGE,
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

        hudSubtext(
            hostPlayer if hostPlayer.toggle_guide else null,
            "{1} + {2} | 上一关\n"
            "{0} (长按) | 飞行\n".format(buttonString(Button.ABILITY_1), buttonString(Button.CROUCH),buttonString(Button.SECONDARY_FIRE))
            checkCN
            "{1} + {2} | Prev Checkpoint\n"
            "{0} (hold)| Fly\n".format(buttonString(Button.ABILITY_1), buttonString(Button.CROUCH),buttonString(Button.SECONDARY_FIRE)),
            HudPosition.RIGHT, HO.edit_instructions_general1, Color.GREEN if hostPlayer.toggle_guide else Color.ORANGE,
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

        hudSubheader(hostPlayer if hostPlayer.toggle_guide else null,
            "保存地图长按 {0} + {1} + {2} 后按弹出窗口的提示进行操作" LeftAlign96.format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD))
            checkCN
            "To Save Map, Hold {0} + {1} + {2} Then Follow Instructions" LeftAlign96.format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD)),
            HudPosition.LEFT, HO.edit_savemap, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

        hudText(localPlayer if not localPlayer.editor_saveCache else null,
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
                    ["检查点模式", "击杀球模式","弹球模式","封禁(单关)","自定义传送门"][EditorMode.current],
                    [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON), iconString(Icon.STOP), iconString(Icon.SPIRAL)][EditorMode.current])
            if localPlayer == hostPlayer else
                " {0} 源氏 编辑者 {0} ".format( iconString(Icon.BOLT))
            ) checkCN
                "{0} Checkpoints\n"
                "{1} Boundary Spheres\n"
                "{2} Function Orbs\n"
                "{3} Skill Bans\n"
                "{4} Portals".format(
                    iconString(Icon.ARROW_RIGHT) if EditorMode.checkpoint else "     ",
                    iconString(Icon.ARROW_RIGHT) if EditorMode.killBall else "     ",
                    iconString(Icon.ARROW_RIGHT) if EditorMode.functionOrb else "     ",
                    iconString(Icon.ARROW_RIGHT) if EditorMode.skillBan else "     ",
                    iconString(Icon.ARROW_RIGHT) if EditorMode.portal else "     ")
            if hostPlayer.isHoldingButton(Button.MELEE) else
                " {1} {0} ".format(
                    ["Checkpoints", "Boundary Spheres","Function Orbs","Skill Bans","Portals"][EditorMode.current],
                    [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON), iconString(Icon.STOP),iconString(Icon.SPIRAL)][EditorMode.current])
            if localPlayer == hostPlayer else
                " {0} Genji Editor {0} ".format(iconString(Icon.BOLT)),
            null,
            null,
            HudPosition.TOP, HO.edit_host_mode, Color.BLUE, null, null, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

        hudText(true[0],
            null,  # original part of the one ontop of it
            ("{0} + 射击 | 切换作图模式".format(buttonString(Button.MELEE)) if localPlayer == hostPlayer else
            "房主/编辑者 {0}".format(hostPlayer))
            checkCN
            ("{0} + Shoot | Change Mode".format(buttonString(Button.MELEE)) if localPlayer == hostPlayer else
            "Current Host/Editor: {0}".format(hostPlayer)),
            null,
            HudPosition.TOP,
            HO.edit_changemode,
            null,
            Color.GRAY if localPlayer.editor_lock else Color.WHITE,
            null,
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
            "{0} + {1} | {4} Give Ult {3} | {2}" LeftAlign96.format(
                buttonString(Button.ULTIMATE),
                buttonString(Button.PRIMARY_FIRE),
                (BounceToggleUlt[EditSelected]) if EditorMode.functionOrb else
                (hostPlayer.checkpoint_current in BladeEnabledCheckpoints),
                abilityIconString(Hero.GENJI, Button.ULTIMATE),
                "Level" if EditorMode.checkpoint  else "Orb"),
            HudPosition.LEFT, HO.edit_orb_ult,
            Color.GREEN if BounceToggleUlt[EditSelected] and EditorMode.functionOrb else
            Color.GREEN if hostPlayer.checkpoint_current in BladeEnabledCheckpoints and EditorMode.checkpoint else Color.ORANGE,
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

        hudSubtext(hostPlayer if hostPlayer.toggle_guide and (EditorMode.checkpoint or EditorMode.functionOrb and len(hostPlayer.editor_bounceIndex)) else null, #if EditorMode.checkpoint or EditorMode.functionOrb and hostPlayer.toggle_guide and len(hostPlayer.editor_bounceIndex) else null,
            "{0} + {1} | {4} {3} | {2}" LeftAlign96.format(
                buttonString(Button.ULTIMATE),
                buttonString(Button.SECONDARY_FIRE),
                BounceToggleDash[EditSelected] if EditorMode.functionOrb else
                hostPlayer.checkpoint_current in DashEnabledCheckpoints,
                abilityIconString(Hero.GENJI, Button.ABILITY_1),
            "检查点给Shift" if EditorMode.checkpoint else "弹球给Shift")
            checkCN
            "{0} + {1} | {4} Give Dash {3} | {2}" LeftAlign96.format(
                buttonString(Button.ULTIMATE),
                buttonString(Button.SECONDARY_FIRE),
                BounceToggleDash[EditSelected] if EditorMode.functionOrb else
                hostPlayer.checkpoint_current in DashEnabledCheckpoints,
                abilityIconString(Hero.GENJI, Button.ABILITY_1),
                "Level" if EditorMode.checkpoint else "Orb"),
            HudPosition.LEFT, HO.edit_orb_dash,
            Color.GREEN if BounceToggleDash[EditSelected] and EditorMode.functionOrb else
            Color.GREEN if hostPlayer.checkpoint_current in DashEnabledCheckpoints and EditorMode.checkpoint else Color.ORANGE,
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

        hudSubtext(hostPlayer if EditorMode.functionOrb and hostPlayer.toggle_guide and len(hostPlayer.editor_bounceIndex) else null,
            "{0} + {1} |  收集球(进点前必须集齐) {3} | {2}\n" LeftAlign96.format(
                buttonString(Button.ULTIMATE),
                buttonString(Button.ABILITY_2),
                BounceToggleLock[EditSelected],
                iconString(Icon.ASTERISK))
            checkCN
            "{0} + {1} | Unlocks Checkpoint {3} | {2}\n" LeftAlign96.format(
                buttonString(Button.ULTIMATE),
                buttonString(Button.ABILITY_2),
                BounceToggleLock[EditSelected],
                iconString(Icon.ASTERISK)),
            HudPosition.LEFT, HO.edit_orb_lock, Color.GREEN if BounceToggleLock[EditSelected] else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

        hudText(hostPlayer if hostPlayer.toggle_guide else null,
            "球体/传送门上限: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxLimit)
            checkCN
            "Orb/Portal Limit: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxLimit),
            null, LeftAlign128, HudPosition.LEFT, HO.edit_orblimit, Color.BLUE, null, null, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

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
            ) checkCN (
                "\n Selected Checkpoint\n Vector: {0}{1} \n".format(
                    CheckpointPositions[hostPlayer.checkpoint_current],
                    [] if len(CheckpointPositions[hostPlayer.checkpoint_current]) < 2 else
                    "\n Teleport: {0}".format(CheckpointPositions[hostPlayer.checkpoint_current][1]))
                if EditorMode.checkpoint and len(CheckpointPositions) else
                "\n Selected Boundary Sphere"
                "\n Vector: {}"
                "\n Radius: {}"
                "\n  + Keep Out"
                "\n  - Stay In\n".format(KillBallPositions[EditSelected], KillBallRadii[EditSelected])
                if EditorMode.killBall and len(hostPlayer.editor_killIndex) else
                "\n Selected Bounce Orb\n Vector: {1}\n Strength: {0} \n ID: {2}\n".format(
                    BounceStrength[EditSelected],
                    BouncePositions[EditSelected],
                    EditSelected)
                if EditorMode.functionOrb and len(hostPlayer.editor_bounceIndex)  else
                "\n Skill Bans\n"
                "――――――――――――\n"
                " {} Multi-Climb ∞\n"
                " {} Create ♂\n"
                " {} Stand ♠\n"
                " {} Climb ↑\n"
                " {} Dead X\n"
                " {} Emote ♥\n"
                " {} Save Double △\n"
                "――――――――――――\n"
                " {} Require Bhop ≥\n".format(
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
                "\n   No Data Selected   \n"),
            null,
            LeftAlign128, HudPosition.LEFT, HO.edit_selecteddata, Color.WHITE, null, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

        # effects ==========================================================================================================================================================================
        createInWorldText(
            true if len(EditSelectIdArray) else null,
            "选中的实体" checkCN "Selected",
            KillBallPositions[EditSelected] if EditorMode.killBall else
            BouncePositions[EditSelected] if EditorMode.functionOrb else
            CustomPortalStart[EditSelected] if EditorMode.portal else
            null,
            1.2, Clip.NONE, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.DEFAULT)

        createIcon(
            true if len(EditSelectIdArray) else null,
            KillBallPositions[EditSelected] if EditorMode.killBall else
            BouncePositions[EditSelected] if EditorMode.functionOrb else
            CustomPortalStart[EditSelected] if EditorMode.portal else
            null,
            Icon.ARROW_DOWN,
            IconReeval.VISIBILITY_AND_POSITION, Color.WHITE, true)

        # Purple sphere for teleport location
        createEffect(hostPlayer if len(CheckpointPositions[hostPlayer.checkpoint_current]) > 1 and EditorMode.checkpoint else null, Effect.SPHERE, Color.PURPLE, CheckpointPositions[hostPlayer.checkpoint_current][1] - 0.1 * Vector.UP, 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

        # Teleport text
        createInWorldText(hostPlayer if len(CheckpointPositions[hostPlayer.checkpoint_current]) > 1 and EditorMode.checkpoint else null, "传送点位置" checkCN "teleporter location", CheckpointPositions[hostPlayer.checkpoint_current][1], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)

        # normal cp if teleport
        createEffect(hostPlayer if CheckpointPositions[hostPlayer.checkpoint_current][1] and EditorMode.checkpoint else null, Effect.RING, Color.ORANGE, CheckpointPositions[hostPlayer.checkpoint_current][0], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createInWorldText(hostPlayer if CheckpointPositions[hostPlayer.checkpoint_current][1] and EditorMode.checkpoint else null, "检查点位置" checkCN "level location", CheckpointPositions[hostPlayer.checkpoint_current][0], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)

        # portal fx
        createEffect(hostPlayer if len(EditSelectIdArray) and EditorMode.portal else null, Effect.SPARKLES, Color.PURPLE, CustomPortalEndpoint[EditSelected], 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

# global functions ==============================================================
rule "Editor | Toggle Fly & Noclip":
    @Event eachPlayer
    @Condition EditorOn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.editor_fly == null
    @Condition (EditorMoveItem and eventPlayer == hostPlayer) == false
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
        if eventPlayer != hostPlayer or not eventPlayer.editor_lock:
            eventPlayer.editor_fly += flyMovementDelta
        elif EditorMode.checkpoint:
            #$$ Due to moving checkpoint holding Ability 2
            eventPlayer.editor_fly += ((0.00288 + 0.09312 * eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)) * \
                (eventPlayer.getFacingDirection() * eventPlayer.getThrottle().z + \
                worldVector(eventPlayer.getThrottle() * Vector.LEFT, eventPlayer, Transform.ROTATION) + \
                Vector.UP * (eventPlayer.isHoldingButton(Button.JUMP) - eventPlayer.isHoldingButton(Button.CROUCH))))
        wait()
    
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.editor_fly = null
    eventPlayer.stopForcingPosition()
    wait(1)

rule "Editor | Change Mode":
    #@Event eachPlayer
    #@Condition eventPlayer == hostPlayer
    @Condition EditorOn
    @Condition hostPlayer.editor_lock == false
    @Condition hostPlayer.isHoldingButton(Button.MELEE)
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) != hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    hostPlayer.editor_lock = true
    if hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        hostPlayer.editor_modeSelect += (5 - 1)
    else:
        hostPlayer.editor_modeSelect += 1
    hostPlayer.editor_modeSelect %= 5
    EditUpdateSelectedIds()
    EditorSelectLast()
    wait()
    waitUntil(hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) == hostPlayer.isHoldingButton(Button.SECONDARY_FIRE), 0.1)
    hostPlayer.editor_lock = false

def EditUpdateSelectedIds():
    @Name "Editor | Update Selected Id"
    if EditorMode.killBall:
        EditSelectIdArray = [i for _, i in KillballCheckpoints]
        EditSelectIdArray = [i for i in EditSelectIdArray if KillballCheckpoints[i] == hostPlayer.checkpoint_current ]
    elif EditorMode.functionOrb:
        EditSelectIdArray = [i for _, i in BouncePadCheckpoints]
        EditSelectIdArray = [i for i in EditSelectIdArray if BouncePadCheckpoints[i] == hostPlayer.checkpoint_current ]
    elif EditorMode.portal:
        EditSelectIdArray = [i for _, i in CustomPortalCP]
        EditSelectIdArray = [i for i in EditSelectIdArray if CustomPortalCP[i] < 0 or CustomPortalCP[i] == hostPlayer.checkpoint_current]
    else:
        EditSelectIdArray = []

def EditorSelectLast():
    @Name "Editor | Select Last"
    EditSelected = EditSelectIdArray.last()

rule "Editor | Create Cp/Orb":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer #Required for UpdateCache()
    @Condition EditorOn
    @Condition hostPlayer.editor_lock == false
    @Condition EditorMode.current in [0,1,2,4]
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    hostPlayer.editor_lock = true
    if EditorMode.checkpoint:
        if len(CheckpointPositions) and distance(hostPlayer, CheckpointPositions[hostPlayer.checkpoint_current]) <= cpcircleradius:
            smallMessage(hostPlayer, "   放置的检查点距离太近" checkCN "   Cannot Place Checkpoint Too Close.")
        else:
            #$$
            if hostPlayer.checkpoint_current >= len(CheckpointPositions) - 1:
                hostPlayer.checkpoint_current = len(CheckpointPositions) - 1

            if hostPlayer.checkpoint_current == len(CheckpointPositions) - 1:
                CheckpointPositions.append(hostPlayer.getPosition())
                hostPlayer.checkpoint_current++ 
            else:
                insert(CheckpointPositions, hostPlayer.checkpoint_current + 1, hostPlayer.getPosition())
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
            UpdateCache()
            smallMessage(hostPlayer, "   新检查点已创建" checkCN "   New Checkpoint Created")
    elif not len(CheckpointPositions):
        smallMessage(hostPlayer, "   请先放置检查点" checkCN "   Make A Checkpoint First")
    elif len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart) >= fxLimit:
        bigMessage(hostPlayer, "当前地图弹球/传送门数量已达上限" checkCN "Orb/Portal Limit Reached For This Map")

    elif EditorMode.killBall:
        KillBallPositions.append(hostPlayer.getPosition())
        KillballCheckpoints.append(hostPlayer.checkpoint_current)
        KillBallRadii.append(5)
        EditUpdateSelectedIds() # to create the fx properly
        EditorSelectLast()
        createEffect(
            [i for i in getAllPlayers() if i.checkpoint_current == KillballCheckpoints[evalOnce(EditSelected)]],
            Effect.SPHERE, ColorConfig[Customize.killorb],
            KillBallPositions[evalOnce(EditSelected)],
            abs(KillBallRadii[evalOnce(EditSelected)]),
            EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        KillBallEffects.append(getLastCreatedEntity())
        bigMessage(true[0], "{1} {0}".format(hostPlayer.checkpoint_current, "新击杀球已创建! \n仅生效于检查点" checkCN "New boundary Sphere Created! \nOnly Valid For This Checkpoint"))
        waitUntil(not(hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.PRIMARY_FIRE)), true)
        #EditUpdateSelectedIds() # to arrow during the placement properly
        while hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            KillBallPositions[EditSelected] = raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition()+hostPlayer.getFacingDirection() * 8, null, null, false).getHitPosition()
            wait()
        EditorMoveItem = true #UpdateCache()

    elif EditorMode.functionOrb:
        BouncePositions.append(hostPlayer.getPosition())
        BouncePadCheckpoints.append(hostPlayer.checkpoint_current)
        BounceStrength.append(10)
        BounceToggleUlt.append(false)
        BounceToggleDash.append(false)
        BounceToggleLock.append(false)
        EditUpdateSelectedIds()
        EditorSelectLast()
        createEffect(
            [x for x in getAllPlayers().concat(null) if x.checkpoint_current == BouncePadCheckpoints[evalOnce(EditSelected)] and not (evalOnce(EditSelected) in x.cache_collectedLocks)],
            Effect.ORB, ColorConfig[Customize.orb_lock] if BounceToggleLock[evalOnce(EditSelected)] else ColorConfig[Customize.orb_normal],
            BouncePositions[evalOnce(EditSelected)], 1, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        BounceEffects.append(getLastCreatedEntity())
        bigMessage(true[0], "{1} {0}".format(hostPlayer.checkpoint_current, "新弹球已创建! \n仅生效于检查点" checkCN "New Bounce Orb Created! \nOnly Valid For This Checkpoint"))
        waitUntil(not(hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.PRIMARY_FIRE)), true)
        while hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            BouncePositions[EditSelected] = raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection() * 7, null, null, false).getHitPosition()
            wait()
        EditorMoveItem = true #UpdateCache()

    elif EditorMode.portal:
        CustomPortalStart.append(hostPlayer.getPosition())
        CustomPortalEndpoint.append(hostPlayer.getPosition() + 10 * Vector.UP)
        CustomPortalCP.append(hostPlayer.checkpoint_current)
        EditUpdateSelectedIds()
        EditorSelectLast()
        createEffect([i for i in getAllPlayers() if CustomPortalCP[evalOnce(EditSelected)] == i.checkpoint_current or CustomPortalCP[evalOnce(EditSelected)] < 0],
            Effect.GOOD_AURA, ColorConfig[Customize.portal], CustomPortalStart[evalOnce(EditSelected)], 0.6,  EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        PortalEffects.append(getLastCreatedEntity())
        EditSelected = len(CustomPortalStart) - 1
        waitUntil(not(hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.PRIMARY_FIRE)), true)
        #EditUpdateSelectedIds()
        while hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            CustomPortalStart[EditSelected] = raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection() * 6, null, null, false).getHitPosition()
            wait()

        bigMessage(true[0], "新传送门已创建!\n生效于当前检查点" checkCN "Portal Created \nOnly Valid For This Checkpoint")
        EditorMoveItem = true

    hostPlayer.editor_lock = false
    wait(0.64)

rule "Editor | Delete Cp/Orb/Portal":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer #Required for UpdateCache()
    @Condition EditorOn
    @Condition hostPlayer.editor_lock == false
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    #@Condition EditorMoveItem == false
    #@Condition len(EditSelectIdArray) > 0

    hostPlayer.editor_lock = true
    if EditorMode.checkpoint and len(CheckpointPositions):
        # Resync Kill Orbs ==================
        hostPlayer.editor_temp = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in KillballCheckpoints] if  e >= 0]
        # hostPlayer.editor_temp = [i for e, i in KillballCheckpoints if e == hostPlayer.checkpoint_current]
        for TempIterator1 in range(len(hostPlayer.editor_temp)):
            destroyEffect(KillBallEffects[hostPlayer.editor_temp[TempIterator1]])
            del KillBallEffects[hostPlayer.editor_temp[TempIterator1]]
            wait()
        # Remove specified checkpoint
        KillballCheckpoints = [x for x in KillballCheckpoints if x != hostPlayer.checkpoint_current]
        # Decrement checkpoints after removed one
        KillballCheckpoints = [x - (1 if x > hostPlayer.checkpoint_current else 0) for x in KillballCheckpoints]
        # Remove Radii at Checkpoint indexes (temp)
        KillBallRadii = [x for x, i in KillBallRadii if i not in hostPlayer.editor_temp]
        KillBallPositions = [x for x, i in KillBallPositions if i not in hostPlayer.editor_temp]
        # Resync Bounce Orbs ==============
        hostPlayer.editor_temp = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in BouncePadCheckpoints] if  e >= 0]
        # hostPlayer.editor_temp = [i for e, i in BouncePadCheckpoints if e == hostPlayer.checkpoint_current]
        for TempIterator1 in range(len(hostPlayer.editor_temp)):
            destroyEffect(BounceEffects[hostPlayer.editor_temp[TempIterator1]])
            del BounceEffects[hostPlayer.editor_temp[TempIterator1]]
            wait()

        BouncePadCheckpoints = [x for x in BouncePadCheckpoints if x != hostPlayer.checkpoint_current]
        # Decrement checkpoints after removed one
        BouncePadCheckpoints = [x - (1 if x > hostPlayer.checkpoint_current else 0) for x in BouncePadCheckpoints]
        BouncePositions = [x for x, i in BouncePositions if i not in hostPlayer.editor_temp]
        BounceStrength = [x for x, i in BounceStrength if i not in hostPlayer.editor_temp]
        BounceToggleUlt = [x for x, i in BounceToggleUlt if i not in hostPlayer.editor_temp]
        BounceToggleDash = [x for x, i in BounceToggleDash if i not in hostPlayer.editor_temp]
        BounceToggleLock = [x for x, i in BounceToggleLock if i not in hostPlayer.editor_temp]

        # Resync custom portals ==================
        hostPlayer.editor_temp = [e for e in [(i if e2 == hostPlayer.checkpoint_current else -1) for e2, i in CustomPortalCP] if  e >=0]
        for TempIterator1 in range(len(hostPlayer.editor_temp)):
            destroyEffect(PortalEffects[hostPlayer.editor_temp[TempIterator1]])
            del PortalEffects[hostPlayer.editor_temp[TempIterator1]]
            wait()
        # Remove specified checkpoint
        CustomPortalCP = [x for x in CustomPortalCP if x != hostPlayer.checkpoint_current]
        # Decrement checkpoints after removed one
        CustomPortalCP = [x - (1 if x > hostPlayer.checkpoint_current else 0) for x in CustomPortalCP]
        # Remove Radii at Checkpoint indexes (temp)
        CustomPortalStart = [x for x, i in CustomPortalStart if i not in hostPlayer.editor_temp]
        CustomPortalEndpoint = [x for x, i in CustomPortalEndpoint if i not in hostPlayer.editor_temp]
        hostPlayer.editor_temp = null

        # ult/dash/ban remove and lower the cp number of rest
        removeCpAndShift(BladeEnabledCheckpoints)
        removeCpAndShift(DashEnabledCheckpoints)
        removeCpAndShift(BanMulti)
        removeCpAndShift(BanCreate)
        removeCpAndShift(BanStand)
        removeCpAndShift(BanDead)
        removeCpAndShift(BanEmote)
        removeCpAndShift(BanClimb)
        removeCpAndShift(BanSaveDouble)
        removeCpAndShift(BanBhop)
        removeCpAndShift(BanDjump)

        # Remove specified checkpoint =====================
        del CheckpointPositions[hostPlayer.checkpoint_current]
        del CheckpointRings_Editing[hostPlayer.checkpoint_current]
        hostPlayer.checkpoint_current = max(hostPlayer.checkpoint_current - 1, 0)

        RebuildKillOrbs()
        RebuildBounceOrbs()
        RebuildPortals()
        smallMessage(hostPlayer, "   检查点已删除" checkCN "   Checkpoint Has Been Deleted")
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
        hostPlayer.editor_lock = false
        wait()
        return

    UpdateCache()
    EditorSelectLast()
    hostPlayer.editor_lock = false
    wait(0.16 + (getNumberOfEntityIds() * 0.007))

# orb functions ==============================================================

rule "Editor | Toggle Orb Functions":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer #Required for UpdateCache()
    @Condition EditorOn
    @Condition EditorMode.functionOrb
    @Condition hostPlayer.editor_lock == false
    @Condition len(EditSelectIdArray) > 0
    @Condition hostPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) or hostPlayer.isHoldingButton(Button.SECONDARY_FIRE) or hostPlayer.isHoldingButton(Button.ABILITY_2)

    hostPlayer.editor_lock = true
    if hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        BounceToggleUlt[EditSelected] = not BounceToggleUlt[EditSelected]
    elif hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        BounceToggleDash[EditSelected] = not BounceToggleDash[EditSelected]
    else:
        BounceToggleLock[EditSelected] = not BounceToggleLock[EditSelected]
        BounceStrength[EditSelected] = 10 * not BounceToggleLock[EditSelected]

    UpdateCache()
    hostPlayer.editor_lock = false
    wait()

rule "Editor | Orb Radii/Strength":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer #Required for UpdateCache()
    @Condition EditorOn
    @Condition EditorMode.current in [1,2]
    @Condition hostPlayer.editor_lock == false
    @Condition len(EditSelectIdArray) > 0
    @Condition hostPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition hostPlayer.isHoldingButton(Button.JUMP) != hostPlayer.isHoldingButton(Button.CROUCH)
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == false

    hostPlayer.editor_lock = true
    while hostPlayer.isHoldingButton(Button.ABILITY_2) and (hostPlayer.isHoldingButton(Button.JUMP) or hostPlayer.isHoldingButton(Button.CROUCH)) :
        if EditorMode.functionOrb and len(hostPlayer.editor_bounceIndex):
            BounceStrength[EditSelected] += 0.1 if hostPlayer.isHoldingButton(Button.JUMP) else -0.1
        elif EditorMode.killBall and len(hostPlayer.editor_killIndex):
            KillBallRadii[EditSelected] += 0.1 if hostPlayer.isHoldingButton(Button.JUMP) else -0.1
        wait(0.1)
    UpdateCache()
    hostPlayer.editor_lock = false

rule "Editor | Select Orb/Portal":
    #@Event eachPlayer
    #@Condition eventPlayer == hostPlayer
    @Condition EditorOn
    @Condition EditorMode.current in [1,2,4]
    @Condition hostPlayer.editor_lock == false
    @Condition len(EditSelectIdArray) > 0
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.CROUCH) or hostPlayer.isHoldingButton(Button.JUMP)

    hostPlayer.editor_lock = true
    if hostPlayer.isHoldingButton(Button.CROUCH):
        EditSelected = EditSelectIdArray.last() if not EditSelectIdArray.index(EditSelected) else EditSelectIdArray[EditSelectIdArray.index(EditSelected) - 1]
    else:
        EditSelected = EditSelectIdArray[0] if EditSelectIdArray.index(EditSelected) == len(EditSelectIdArray) - 1 else EditSelectIdArray[EditSelectIdArray.index(EditSelected) + 1]
    wait()
    hostPlayer.editor_lock = false
    waitUntil(not(hostPlayer.isHoldingButton(Button.INTERACT) and (hostPlayer.isHoldingButton(Button.CROUCH) or hostPlayer.isHoldingButton(Button.JUMP))), 0.24)

# checkpoint functions ==============================================================

rule "Editor | Cp Size Hitbox Display":
    #@Event eachPlayer
    #@Condition eventPlayer == hostPlayer
    @Condition EditorOn
    @Condition EditorMode.current == 0
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.ABILITY_1)
    hostPlayer.editor_hitboxToggle = not hostPlayer.editor_hitboxToggle
    wait()

rule "Editor | Cp Add/Remove Teleport":
    @Condition EditorOn
    @Condition EditorMode.current == 0
    @Condition hostPlayer.editor_lock == false
    @Condition len(CheckpointPositions) > 1
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.RELOAD)
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == false

    waitUntil(hostPlayer.isHoldingButton(Button.MELEE) or not (hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD)), true) # prevent overlap with save map
    if hostPlayer.isHoldingButton(Button.MELEE) or hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD):
      return

    hostPlayer.editor_lock = true
    if not hostPlayer.checkpoint_current:
        smallMessage(hostPlayer,"   不能在第一个检查点设置传送门" checkCN "   Cannot Place A Teleport On First Checkpoint")
        hostPlayer.editor_lock = false
        return

    if len(CheckpointPositions[hostPlayer.checkpoint_current]) > 1: # remove
        CheckpointPositions[hostPlayer.checkpoint_current] = CheckpointPositions[hostPlayer.checkpoint_current][0]
        smallMessage(hostPlayer,"   关卡{0}的传送点已移除".format(hostPlayer.checkpoint_current) checkCN "   Teleport For Level {0} Has Been Removed".format(hostPlayer.checkpoint_current))
    else: # add
        CheckpointPositions[hostPlayer.checkpoint_current] = [
            CheckpointPositions[hostPlayer.checkpoint_current][0] if len(CheckpointPositions[hostPlayer.checkpoint_current]) else CheckpointPositions[hostPlayer.checkpoint_current],
            hostPlayer.getPosition()]
        smallMessage(hostPlayer, "{1} {0}".format(hostPlayer.checkpoint_current,"   传送点已添加到当前关卡" checkCN "   Teleport Has Been Added For Level"))

    hostPlayer.editor_lock = false
    wait()

rule "Editor | Moving Checkpoint":
    #@Event eachPlayer
    #@Condition eventPlayer == hostPlayer
    @Condition EditorOn
    @Condition EditorMode.current == 0
    @Condition hostPlayer.editor_lock == false
    @Condition len(CheckpointPositions) > 0
    @Condition hostPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition hostPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    if hostPlayer.addon_toggle3rdPov:
        hostPlayer.addon_toggle3rdPov = false
    hostPlayer.editor_lock = true
    hostPlayer.editor_undo = CheckpointPositions[hostPlayer.checkpoint_current]
    hostPlayer.startCamera(hostPlayer.getEyePosition() + 0.5 * Vector.UP - 2.5 * hostPlayer.getFacingDirection(), hostPlayer.getEyePosition(), 15)
    while hostPlayer.isHoldingButton(Button.ABILITY_2) and hostPlayer.isAlive() and not hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        if hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            hostPlayer.setMoveSpeed(100)
        else:
            hostPlayer.setMoveSpeed(3)
        if len(CheckpointPositions[hostPlayer.checkpoint_current]):
            CheckpointPositions[hostPlayer.checkpoint_current] = [hostPlayer.getPosition(), CheckpointPositions[hostPlayer.checkpoint_current][1] ]
        else:
            CheckpointPositions[hostPlayer.checkpoint_current] = hostPlayer.getPosition()
        wait()

    hostPlayer.stopCamera()
    hostPlayer.setMoveSpeed(100)
    if hostPlayer.isHoldingButton(Button.ABILITY_2):
        CheckpointPositions[hostPlayer.checkpoint_current] = hostPlayer.editor_undo
        waitUntil(not hostPlayer.isHoldingButton(Button.ABILITY_2), Math.INFINITY)

    hostPlayer.editor_lock = false

rule "Editor | Toggle Ult/Dash":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition EditorOn
    @Condition EditorMode.current == 0
    @Condition hostPlayer.editor_lock == false
    @Condition len(CheckpointPositions) > 0
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) != hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition hostPlayer.isHoldingButton(Button.ULTIMATE)

    if hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        toggleCpInArray(BladeEnabledCheckpoints)
    else:
        toggleCpInArray(DashEnabledCheckpoints)
    wait()

rule "Editor | Toggle Bans":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer #Required for UpdateCache()
    @Condition EditorOn
    @Condition EditorMode.skillBan
    @Condition hostPlayer.editor_lock == false
    @Condition len(CheckpointPositions) > 0
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) or hostPlayer.isHoldingButton(Button.SECONDARY_FIRE) or hostPlayer.isHoldingButton(Button.JUMP) or hostPlayer.isHoldingButton(Button.CROUCH)
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) or hostPlayer.isHoldingButton(Button.ABILITY_2)

    hostPlayer.editor_lock = true
    if hostPlayer.isHoldingButton(Button.INTERACT):
        if hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            toggleCpInArray(BanMulti)
        elif hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
            toggleCpInArray(BanCreate)
        elif hostPlayer.isHoldingButton(Button.CROUCH):
            toggleCpInArray(BanClimb)
        else:
            toggleCpInArray(BanSaveDouble)

    else:
        if hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
            toggleCpInArray(BanDead)
            #toggleCpInArray(BanSaveDouble)
        elif hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
            toggleCpInArray(BanEmote)
        elif hostPlayer.isHoldingButton(Button.CROUCH):
            toggleCpInArray(BanStand)
        else:
            toggleCpInArray(BanBhop)
    # BanStand
    wait(0.3)
    UpdateCache()
    hostPlayer.editor_lock = false

rule "Editor | Change Portal Cp":
    #@Event eachPlayer
    #@Condition eventPlayer == hostPlayer
    @Condition EditorOn
    @Condition EditorMode.portal
    @Condition hostPlayer.editor_lock == false
    @Condition len(EditSelectIdArray) > 0
    @Condition hostPlayer.isHoldingButton(Button.JUMP)
    @Condition hostPlayer.isHoldingButton(Button.ABILITY_2)

    CustomPortalCP[EditSelected] = hostPlayer.checkpoint_current if CustomPortalCP[EditSelected] < 0 else -1
    wait(0.3)

rule "Editor | Move Object":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer #Required for UpdateCache()
    @Condition EditorOn
    @Condition EditorMode.current in [1, 2, 4]
    @Condition hostPlayer.editor_lock == false
    @Condition len(EditSelectIdArray) > 0
    @Condition hostPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    @Condition EditorMoveItem or (hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) and hostPlayer.isHoldingButton(Button.ABILITY_2))

    hostPlayer.editor_lock = true
    EditorMoveItem = true
    if hostPlayer.addon_toggle3rdPov:
        hostPlayer.addon_toggle3rdPov = false
    #hostPlayer.editor_fly = null

    waitUntil(not(hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) or hostPlayer.isHoldingButton(Button.ABILITY_2)), Math.INFINITY)

    #hostPlayer.disallowButton(Button.ULTIMATE)
    #hostPlayer.disallowButton(Button.JUMP)
    hostPlayer.setStatusEffect(null, Status.HACKED, Math.INFINITY)
    hostPlayer.setMoveSpeed(false)
    #hostPlayer.startForcingPosition(hostPlayer.getPosition(), false)
    
    if EditorMode.killBall:
        hostPlayer.editor_undo = KillBallPositions[EditSelected]
        hostPlayer.startCamera(KillBallPositions[EditSelected] + hostPlayer.getFacingDirection() * (abs(KillBallRadii[EditSelected]) * -1.5),
            KillBallPositions[EditSelected], 30)
        while not (hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) or hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            KillBallPositions[EditSelected] += flyMovementDelta
            wait()
    elif EditorMode.functionOrb:
        hostPlayer.editor_undo = BouncePositions[EditSelected]
        hostPlayer.startCamera(BouncePositions[EditSelected] + hostPlayer.getFacingDirection() * -4,
            BouncePositions[EditSelected], 30)
        while not (hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) or hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            BouncePositions[EditSelected] += flyMovementDelta
            wait()
    elif EditorMode.portal:
        hostPlayer.editor_undo = [CustomPortalStart[EditSelected], CustomPortalEndpoint[EditSelected]]
        # move start position
        hostPlayer.startCamera(CustomPortalStart[EditSelected] + hostPlayer.getFacingDirection() * -4,
            CustomPortalStart[EditSelected], 30)
        while not (hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) or hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            CustomPortalStart[EditSelected] += flyMovementDelta
            wait()

        # move destination
        hostPlayer.startCamera(CustomPortalEndpoint[EditSelected] + hostPlayer.getFacingDirection() * -4,
            CustomPortalEndpoint[EditSelected], 30)
        waitUntil(not hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) or hostPlayer.isHoldingButton(Button.SECONDARY_FIRE), true)
        while not (hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) or hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            CustomPortalEndpoint[EditSelected] += flyMovementDelta
            wait()
/*  
    if hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        KillBallPositions[EditSelected] = hostPlayer.editor_undo[0]
    if hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        BouncePositions[EditSelected] = hostPlayer.editor_undo[1]
    if hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        CustomPortalStart[EditSelected] = hostPlayer.editor_undo[2]
    if hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        CustomPortalEndpoint[EditSelected] = hostPlayer.editor_undo[3]
*/
    if hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        goto loc + 2 * EditorMode.current
    else:
    else:
        KillBallPositions[EditSelected] = hostPlayer.editor_undo
    else:
        BouncePositions[EditSelected] = hostPlayer.editor_undo
    else:
    else:
    else:
        CustomPortalStart[EditSelected] = hostPlayer.editor_undo[0]
        CustomPortalEndpoint[EditSelected] = hostPlayer.editor_undo.last()
    
    hostPlayer.editor_undo = null
    #hostPlayer.allowButton(Button.ULTIMATE)
    #hostPlayer.allowButton(Button.JUMP)
    hostPlayer.clearStatusEffect(Status.HACKED)
    hostPlayer.stopCamera()
    hostPlayer.setMoveSpeed(100)
    #hostPlayer.stopForcingPosition()
    EditorMoveItem = null
    UpdateCache()
    waitUntil(not hostPlayer.isHoldingButton(Button.PRIMARY_FIRE), true)
    hostPlayer.editor_lock = false
