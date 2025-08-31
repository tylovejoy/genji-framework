#!mainFile "framework.opy"
/*
huds outside this file:
    - custom difficulty (map data)
    - display author time (addons pg2)
    - editor huds (editor)
*/
rule "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Huds ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒":
    @Delimiter

rule "Huds | Global Localplayer":
    wait(LoadOrder.hudsGlobal)

    # name/credit construction
    # note on changing default name/credit
    # if you change it, also change it in the credits rule
    # the old credits should always remain valid here to keep old data valid
    if Name == "name here - 作者":
        Name = Cachedcredits[0] #Legacy Credits
    if not Name:
        Name = "name here - 作者"
    if Code == "code here - 代码":
        Code = Cachedcredits.last() #Legacy Credits
    if not Code:
        Code = "code here - 代码"
    Cachedcredits = null

    if not EditorOn:
        hudText(true[0], null, "Discord: dsc.gg/genjiparkour" if localPlayer.toggle_guide else [],
            f"{t'Made By'}: {Name}{LeftAlign96}",
            #"作者: {}" LeftAlign96.format(Name)
            #checkCN
            #"Made by: {}" LeftAlign96.format(Name),
            HudPosition.LEFT, HO.data_name, null, ColorConfig[Customize.dsc], ColorConfig[Customize.credit_name], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

        hudSubtext(true[0],
            f"{t'Map Code'}: {Code}{LeftAlign96}",
            #"代码: {}" LeftAlign96.format(Code)
            #checkCN
            #"Map code: {}" LeftAlign96.format(Code),
            HudPosition.LEFT, HO.data_code, ColorConfig[Customize.credit_code], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

        hudSubtext(localPlayer.toggle_guide,
            f"{t'Hold'} {buttonString(Button.PRIMARY_FIRE)} + {buttonString(Button.SECONDARY_FIRE)} | {t'Preview CP'}",
            #"长按 {0} + {1} | 预览关卡".format(buttonString(Button.PRIMARY_FIRE),buttonString(Button.SECONDARY_FIRE))
            #checkCN
            #"Hold {0} + {1} | Preview cp".format(buttonString(Button.PRIMARY_FIRE),buttonString(Button.SECONDARY_FIRE)),
            HudPosition.RIGHT, HO.com_preview,
            evalOnce(ColorConfig[Customize.command_highlight]) if localPlayer.preview_array1 else evalOnce(ColorConfig[Customize.command_normal]),
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

        hudSubheader((localPlayer.preview_array1 and localPlayer.toggle_guide)[0],
            t"Walk ◀ ▶ | Preview Others\nWalk ▲ ▼ | Modify Zoom\nAim | Change Preview Angle",
            #"移动键 ◀ ▶ | 预览其他\n移动键 ▲ ▼ | 修改间距 \n视角移动 | 调整浏览视角"
            #checkCN
            #"Walk ◀ ▶ | Preview Others\nWalk ▲ ▼ | Modify Zoom\nAim | Change Preview Angle",
            HudPosition.TOP, HO.com_previewsub, ColorConfig[Customize.command_highlight], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

        hudSubtext(localPlayer,
            [] if localPlayer.timer_splitDisplay <= -Math.INFINITY or localPlayer.toggle_spectate else
                f"{t'Split: '}{localPlayer.timer_splitDisplay}{LeftAlign96}",
                #("单关用时 {0}" LeftAlign96.format(localPlayer.timer_splitDisplay)
                #checkCN
                #"Split: {0}" LeftAlign96.format(localPlayer.timer_splitDisplay))),
            HudPosition.LEFT, HO.game_split_display, ColorConfig[Customize.time], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

        if len(HintText): #Remove no hints - visual and element bloat
            hudText((localPlayer.toggle_guide and localPlayer.checkpoint_current in HintCp)[0],
                null,
                f"{t'― ― ― ― ― Hint ― ― ― ― ―\n' if localPlayer.toggle_hints else t'― ― ― Hint Available ― ― ―'}{
                HintText[HintCp.index(localPlayer.checkpoint_current)] if localPlayer.toggle_hints else []}",
                #("― ― ― ― ― 提示 ― ― ― ― ―\n {} ".format(HintText[HintCp.index(localPlayer.checkpoint_current)])
                #if localPlayer.toggle_hints else "――――――  有可用提示 ――――――")
                #checkCN
                #("― ― ― ― ― Hint ― ― ― ― ―\n {} ".format(HintText[HintCp.index(localPlayer.checkpoint_current)])
                #if localPlayer.toggle_hints else "― ― ― Hint Available ― ― ―"),
                f"{buttonString(Button.ABILITY_2)} + {buttonString(Button.MELEE)} | {t'Hide Hint' if localPlayer.toggle_hints else t'Show Hint'}",
                #"{} + {} | {}".format(buttonString(Button.ABILITY_2), buttonString(Button.MELEE),
                #    ("隐藏提示" if localPlayer.toggle_hints else "获取提示")
                #    checkCN
                #    "Hide Hint" if localPlayer.toggle_hints else "Show Hint"),
                HudPosition.RIGHT, HO.com_hints,
                null, Color.GREEN if localPlayer.toggle_hints else Color.ORANGE, evalOnce(ColorConfig[Customize.command_normal]) if localPlayer.checkpoint_current in HintCp else Color.GRAY,
                HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

        # this is remade in editor to not include leaderboard
        hudSubtext(localPlayer.toggle_guide,
            f"{buttonString(Button.CROUCH)} + {buttonString(Button.ABILITY_2)} + {buttonString(Button.INTERACT)} | {t'Restart'}\n{
            t'Hold'} {buttonString(Button.MELEE)} | {t'Leaderboard'}",
            #"{0} + {1} + {2} | 重新开始\n长按 {3} | 完整成绩排名".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT),buttonString(Button.MELEE))
            #checkCN
            #"{0} + {1} + {2} | Restart\nHold {3} | leaderboard".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT),buttonString(Button.MELEE)),
            HudPosition.RIGHT, HO.com_restart_n_board, ColorConfig[Customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        
        Difficultyhud = [
            createWorkshopSetting(enum[
                "<fg27AAFFFF>Playtest ◆ 游戏测试 ◆ 플레이테스트", "<fgA0E81BFF>Easy-", "<fgA0E81BFF>Easy", "<fgA0E81BFF>Easy+",
                "<fge0e000FF>Medium-", "<fge0e000FF>Medium", "<fge0e000FF>Medium+", "<fgEC9900FF>Hard-", "<fgEC9900FF>Hard",
                "<fgEC9900FF>Hard+", "<fgFF4500FF>Very Hard-", "<fgFF4500FF>Very Hard", "<fgFF4500FF>Very Hard+",
                "<fgC80013FF>Extreme-", "<fgC80013FF>Extreme", "<fgC80013FF>Extreme+", "<fg960000FF>Hell", "Do Not Display ◆ 不显示 ◆ 표시 X"],
                "Map Settings ◆ 地图设置 ◆ 맵 설정", "Difficulty (Display Hud) ◆ 难度 (顶部hud) ◆ 난이도 (HUD 디스플레이)", 0, 1),
            createWorkshopSetting(bool, "Map Settings ◆ 地图设置 ◆ 맵 설정", "Playtest Display ◆ 游戏测试 ◆ 플레이테스트 디스플레이", false, 2)]
        # display
        if Difficultyhud[0] != 17: # 17th entry is 'dont display'
            hudText((localPlayer.toggle_guide and not localPlayer.toggle_leaderboard)[0],
                t"Playtest"
                #("游戏测试" checkCN "Playtest")
                if Difficultyhud.last() else [],
                ["Playtest", "Easy -", "Easy", "Easy +","Medium -","Medium","Medium +","Hard -","Hard","Hard +","Very Hard -","Very Hard","Very Hard +","Extreme -","Extreme","Extreme +","Hell",null][Difficultyhud[0]],
                null,
                HudPosition.TOP, HO.data_dif,
                Color.BLUE,
                [Color.BLUE, Color.LIME_GREEN, Color.LIME_GREEN, Color.LIME_GREEN, Color.YELLOW, Color.YELLOW, Color.YELLOW, Color.ORANGE, Color.ORANGE, Color.ORANGE,
                rgb(255, 69, 0), rgb(255, 69, 0), rgb(255, 69, 0), Color.RED, Color.RED, Color.RED, rgb(150, 0, 0), null][Difficultyhud[0]],
                null,
                HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    # global huds
    hudSubheader(true[0],
        f"{t'Server Restart In '}{TimeRemaining}{t' Min - '}{LobbyID}{versionhere}{t'\nError: Max HUD Count Reached' if getNumberOfTextIds() >= 128 else []}",
        #"房间将在 {0} 分钟后重启 - {1}{2}".format(
        #    TimeRemaining, versionhere, "\n错误: 已达到最大HUD数量上限" if getNumberOfTextIds() >= 128 else [])
        #checkCN
        #"Server Restart in {0} Min - {1}{2}".format(
        #    TimeRemaining, versionhere, "\nerror: max hud count reached" if getNumberOfTextIds() >= 128 else []),
        HudPosition.RIGHT, HO.data_remaingtime, ColorConfig[Customize.servertime], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    # padding for custom hud display
    hudSubtext(true[0], "­\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, HO.fillermain, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)

    hudSubtext(localPlayer.toggle_guide,
        f"{buttonString(Button.RELOAD)} | {t'Quick Reset'}" if localPlayer.toggle_quickRestart else f"{t'Hold'} {buttonString(Button.RELOAD)} | {t'Enable Quick Reset'}",
        #f"{[] if localPlayer.toggle_quickRestart else t'Hold'} {buttonString(Button.RELOAD)} | {[] if localPlayer.toggle_quickRestart else t'Enable'} {t'Quick Reset'}",

        #"{0} {1} | {2}快速回点".format([] if localPlayer.toggle_quickRestart else "长按",buttonString(Button.RELOAD),[] if localPlayer.toggle_quickRestart else "启用")
        #checkCN
        #"{0} {1} | {2} quick reset".format([] if localPlayer.toggle_quickRestart else "Hold", buttonString(Button.RELOAD), [] if localPlayer.toggle_quickRestart else " Enable"),
        HudPosition.RIGHT, HO.com_quickres, ColorConfig[Customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudSubtext(localPlayer.toggle_guide,
        f"{buttonString(Button.RELOAD)} + {buttonString(Button.MELEE)} | {t'Invincible'}{t' | On' if localPlayer.toggle_invincible else []}",
        #"{0} + {1} | 探点模式{2}".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)," | 启用" if localPlayer.toggle_invincible else [])
        #checkCN
        #"{0} + {1} | Invincible{2}".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)," | On" if localPlayer.toggle_invincible else []),
        HudPosition.RIGHT, HO.com_invincible, evalOnce(ColorConfig[Customize.command_highlight]) if localPlayer.toggle_invincible else evalOnce(ColorConfig[Customize.command_normal]),
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

    hudText(true[0],
        null,
        [] if localPlayer.toggle_guide else "{0}{1}{2}".format(
            abilityIconString(Hero.BAPTISTE, Button.ABILITY_2) if localPlayer.toggle_invincible else [],
            abilityIconString(Hero.DVA, Button.ULTIMATE) if localPlayer.toggle_practice else [],
            abilityIconString(Hero.SOMBRA, Button.ABILITY_1) if localPlayer.toggle_invisible else []),
        f"{t'Hold'} {buttonString(Button.SECONDARY_FIRE)} | {t'Toggle'} HUD",
        #"长按 {0} | 切换显示HUD".format(buttonString(Button.SECONDARY_FIRE))
        #checkCN
        #"Hold {0} | toggle hud".format(buttonString(Button.SECONDARY_FIRE)),
        HudPosition.RIGHT, HO.com_displaytoggle, null, ColorConfig[Customize.command_normal], ColorConfig[Customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    if len(CpHudText): # text per checkpoint  text per cp each
        hudText((localPlayer.checkpoint_current in CpHudCp and localPlayer.toggle_guide)[0],
            CpHudText[CpHudCp.index(localPlayer.checkpoint_current)],
            null, null,
            HudPosition.TOP, HO.add_custommsg1, Color.BLUE, null, null, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    if len(CpIwtText):
        createInWorldText(localPlayer.checkpoint_current in CpIwtCp,
            CpIwtText[CpIwtCp.index(localPlayer.checkpoint_current)],
            CpIwtPos[CpIwtCp.index(localPlayer.checkpoint_current)],
            2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, CpIwtColor, SpecVisibility.DEFAULT)

    if CompMode:
        hudHeader([i for i in getAllPlayers() if i.comp_instructionHud],"                                                                                                                           ",
            HudPosition.TOP, HO.comp_instructtop, Color.WHITE, HudReeval.VISIBILITY,SpecVisibility.DEFAULT)
        if InstructionText[0]:
            hudSubtext([i for i in getAllPlayers() if i.comp_instructionHud], InstructionText[0], HudPosition.TOP, HO.comp_instruct1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if InstructionText[1]:
            hudSubtext([i for i in getAllPlayers() if i.comp_instructionHud], InstructionText[1], HudPosition.TOP, HO.comp_instruct2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if InstructionText[2]:
            hudSubtext([i for i in getAllPlayers() if i.comp_instructionHud], InstructionText[2], HudPosition.TOP, HO.comp_instruct3, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if InstructionText[3]:
            hudSubtext([i for i in getAllPlayers() if i.comp_instructionHud], InstructionText[3], HudPosition.TOP, HO.comp_instruct4, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        hudHeader([i for i in getAllPlayers() if i.comp_instructionHud],"                                   Press {0} to start                                ".format(buttonString(Button.INTERACT)),
            HudPosition.TOP, HO.comp_instructbottom, Color.WHITE, HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    elif not EditorOn:
        hudSubtext(localPlayer.toggle_guide,
            f"{t'Hold'} {buttonString(Button.ABILITY_2)} | {t'Invisible'}{t' | On' if localPlayer.toggle_invisible else []}",
            #"长按 {0} | 隐身模式{1}".format(buttonString(Button.ABILITY_2)," | 启用" if localPlayer.toggle_invisible else [])
            #checkCN
            #"Hold {0} | invisible{1}".format(buttonString(Button.ABILITY_2)," | On" if localPlayer.toggle_invisible else []),
            HudPosition.RIGHT, HO.com_invis, evalOnce(ColorConfig[Customize.command_highlight]) if localPlayer.toggle_invisible else evalOnce(ColorConfig[Customize.command_normal]),
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

        hudSubtext(localPlayer.toggle_guide,
            "{0} + {1} | {2}{3}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), t"Practice", f" | ({localPlayer.checkpoint_practice})" if localPlayer.toggle_practice else []),
            #"{0} + {1} | 练习模式{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.checkpoint_practice) if localPlayer.toggle_practice else [])
            #checkCN
            #"{0} + {1} | Practice{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.checkpoint_practice) if localPlayer.toggle_practice else []),
            HudPosition.RIGHT, HO.com_practice, evalOnce(ColorConfig[Customize.command_highlight]) if localPlayer.toggle_practice else evalOnce(ColorConfig[Customize.command_normal]),
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

        hudSubheader((localPlayer.toggle_practice and localPlayer.toggle_guide)[0],
            f"{buttonString(Button.CROUCH)} + {buttonString(Button.PRIMARY_FIRE)} | {t'Next Level'}\n{
            buttonString(Button.CROUCH)} + {buttonString(Button.SECONDARY_FIRE)} | {t'Previous Level'}\n{
            buttonString(Button.INTERACT)} | {t'Restart Practice'}",
            #"{0} + {1} | 下一关\n{0} + {2} | 上一关\n{3} | 回到练习模式起点 ".format(
            #    buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT))
            #checkCN
            #"{0} + {1} | Next level\n{0} + {2} | Previous level\n{3} | Start from practice cp ".format(
            #    buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT)),
            HudPosition.RIGHT, HO.com_practicesub, evalOnce(ColorConfig[Customize.command_highlight]),
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
            goto spectateHud
    else:
        spectateHud:
        hudSubtext(localPlayer.toggle_guide,
            f"{t'Hold'} {buttonString(Button.INTERACT)} | {t'Spectate'}{t' | On' if localPlayer.toggle_spectate else []}",
            #"长按 {0} | 观战模式{1}".format(buttonString(Button.INTERACT)," | 启用" if localPlayer.toggle_spectate else [])
            #checkCN
            #"Hold {0} | Spectate{1}".format(buttonString(Button.INTERACT)," | On" if localPlayer.toggle_spectate else []),
            HudPosition.RIGHT, HO.com_spec, evalOnce(ColorConfig[Customize.command_highlight]) if localPlayer.toggle_spectate else evalOnce(ColorConfig[Customize.command_normal]),
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)

rule "Huds | Leaderboard": # for global instead of tied to player
    @Condition LeaderBoardRemake
    @Condition LeaderBoardFull != []
    wait() # account for delay in completion
    while len(LeaderBoardHuds):
        destroyHudText(LeaderBoardHuds[0])
        del LeaderBoardHuds[0]

    # top 5
    LeaderBoardFull = sorted(LeaderBoardFull, lambda i: i[1])
    LeaderBoardRemake = []
    LeaderBoardHuds = ["　 {}:　{} - {}".format(i+1, e[0], e.last()) for e, i in LeaderBoardFull]
    while len(LeaderBoardHuds):
        LeaderBoardRemake = "{}\n{}".format(LeaderBoardRemake, LeaderBoardHuds[0])
        del LeaderBoardHuds[0]
    LeaderBoardRemake = "{}\n".format(LeaderBoardRemake)

    #if LeaderBoardFull[0]:
    hudSubheader(localPlayer.toggle_guide,
        f" \n{iconString(Icon.FLAG)} {t'Top 5'} {iconString(Icon.FLAG)}",
        #" \n{0} 排名前5 {0}".format(iconString(Icon.FLAG)) checkCN " \n{0} Top 5 {0}".format(iconString(Icon.FLAG)),
        HudPosition.RIGHT, HO.board_top5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    LeaderBoardHuds = getLastCreatedText()
    hudText(true[0], heroIcon(Hero.GENJI), LeaderBoardFull[0][0], LeaderBoardFull[0].last(), HudPosition.RIGHT, HO.board_top5+1,
        Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
    LeaderBoardHuds.append(getLastCreatedText())
    if LeaderBoardFull[1]:
        hudText(true[0], heroIcon(Hero.GENJI), LeaderBoardFull[1][0], LeaderBoardFull[1].last(), HudPosition.RIGHT, HO.board_top5+2,
            Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
        LeaderBoardHuds.append(getLastCreatedText())
        if LeaderBoardFull[2]:
            hudText(true[0], heroIcon(Hero.GENJI), LeaderBoardFull[2][0], LeaderBoardFull[2].last(), HudPosition.RIGHT, HO.board_top5+3,
                Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
            LeaderBoardHuds.append(getLastCreatedText())
            if LeaderBoardFull[3]:
                hudText(true[0], heroIcon(Hero.GENJI), LeaderBoardFull[3][0], LeaderBoardFull[3].last(), HudPosition.RIGHT, HO.board_top5+4,
                    Color.LIME_GREEN, Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
                LeaderBoardHuds.append(getLastCreatedText())
                if LeaderBoardFull[4]:
                    hudText(true[0], heroIcon(Hero.GENJI), LeaderBoardFull[4][0], LeaderBoardFull[4].last(), HudPosition.RIGHT, HO.board_top5+5,
                        Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
                    LeaderBoardHuds.append(getLastCreatedText())

    hudHeader(true if evalOnce(CompMode and not CompTime) else localPlayer.toggle_leaderboard,
        "　　　　 {0} {1} {0} 　　　　\n　　　　　　　　　　　　　　　　　　{2}".format(iconString(Icon.FLAG), t"Leaderboard", evalOnce(LeaderBoardRemake)),
        #"　　　　 {0} {1} {0} 　　　　\n　　　　　　　　　　　　　　　　　　{2}".format(iconString(Icon.FLAG), "成绩排名" checkCN "Leaderboard", evalOnce(LeaderBoardRemake)),
        HudPosition.TOP, HO.board_display1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    LeaderBoardHuds.append(getLastCreatedText())
    LeaderBoardRemake = null
    wait()

rule "Huds | Each Player":
    @Event playerJoined
    wait(LoadOrder.hudsPlayer)

    hudText(eventPlayer, null,
        "{0} {1} sec".format(t"Practice Time:", eventPlayer.timer_practice) if eventPlayer.toggle_practice else [],
        #"{0} {1} sec".format("练习用时" checkCN "Practice Time:", eventPlayer.timer_practice) if eventPlayer.toggle_practice else [],
        "{0} {1} sec" LeftAlign96.format(t"Time:", eventPlayer.timer_normal),
        #"{0} {1} sec" LeftAlign96.format("用时" checkCN "Time:", eventPlayer.timer_normal),
        HudPosition.LEFT, HO.game_timer, null, Color.GRAY, ColorConfig[Customize.time], HudReeval.STRING, SpecVisibility.DEFAULT)

    hudText(null if eventPlayer.toggle_leaderboard else eventPlayer,
        #Header: Preview
        " {0} ({1}/{2})\n―――――――――――\n {3}\n".format(
            #("弹球" if eventPlayer.preview_i <= len(eventPlayer.cache_bouncePosition) else "自定义传送门") if eventPlayer.preview_i else "检查点"
            (t"Orb" if eventPlayer.preview_i <= len(eventPlayer.cache_bouncePosition) else t"Portal") if eventPlayer.preview_i else t"Checkpoint", #0
            eventPlayer.preview_i + 1, #1
            len(eventPlayer.preview_array1), #2
            #3
            ("{0} {1} {2} {3}".format(
                abilityIconString(Hero.GENJI, Button.ULTIMATE) if BounceToggleUlt[eventPlayer.preview_array2[eventPlayer.preview_i]] else [],
                abilityIconString(Hero.GENJI, Button.ABILITY_1) if BounceToggleDash[eventPlayer.preview_array2[eventPlayer.preview_i]] else [],
                iconString(Icon.WARNING) if BounceToggleLock[eventPlayer.preview_array2[eventPlayer.preview_i]] else [],
                iconString(Icon.ARROW_UP) if BounceStrength[eventPlayer.preview_array2[eventPlayer.preview_i]] > 0 else
                iconString(Icon.ARROW_DOWN) if BounceStrength[eventPlayer.preview_array2[eventPlayer.preview_i]] < 0 else [])
            if eventPlayer.preview_i <= len(eventPlayer.cache_bouncePosition) and eventPlayer.preview_i else
            (#(f"传送门 {eventPlayer.preview_array2[eventPlayer.preview_i]} 出口 "
            #if eventPlayer.preview_array2[eventPlayer.preview_i].last() else
            #f"传送门 {eventPlayer.preview_array2[eventPlayer.preview_i]} 入口 "
            #) checkCN
            f"{t'Portal Exit'} {eventPlayer.preview_array2[eventPlayer.preview_i]}"
            if eventPlayer.preview_array2[eventPlayer.preview_i].last() else
            f"{t'Portal Start'} {eventPlayer.preview_array2[eventPlayer.preview_i]}")
            if eventPlayer.preview_i else eventPlayer.banString)
            ) if eventPlayer.preview_array1 else [],
        #SubHeader: Level
        [] if eventPlayer.preview_array1 else "{0}{1} {2} / {3}".format(
            f"{eventPlayer.banString}\n" if eventPlayer.toggle_guide and eventPlayer.banString else [],
            t"Level", eventPlayer.checkpoint_current, len(CheckpointPositions) - 1),
            #"关卡" checkCN "Level",
        #Text: Lock Orbs
        "{0} {1} / {2}".format(ft"{ColorConfig[Customize.orb_lock]} Orbs", len(eventPlayer.cache_collectedLocks), eventPlayer.cache_bounceMaxLocks)
        #f"{ColorConfig[Customize.orb_lock]} {t'{0} Orbs'} {len(eventPlayer.cache_collectedLocks)} / {eventPlayer.cache_bounceMaxLocks}"
        #"{0}{1} {2} / {3}".format(
        #    ColorConfig[Customize.orb_lock],
        #    "球" checkCN " orbs",
        #    len(eventPlayer.cache_collectedLocks),
        #    eventPlayer.cache_bounceMaxLocks
        #    "收集球" checkCN "{0} orbs".format(ColorConfig[Customize.orb_lock]))
        if eventPlayer.cache_bounceMaxLocks and not eventPlayer.preview_array1 else [],
        HudPosition.TOP, HO.game_level_orb, ColorConfig[Customize.level], ColorConfig[Customize.level], ColorConfig[Customize.orb_lock],
        HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudSubtext(eventPlayer,"{0}{1}{2}\n{3}{4}{5}" LeftAlign96.format(
        "◆" if eventPlayer.cache_inputs.x else "□",
        "▲" if eventPlayer.getThrottle().z > null else "△",
        "●" if eventPlayer.cache_inputs.y else "○",
        "◀" if eventPlayer.getThrottle().x > null else "◁",
        "▼" if eventPlayer.getThrottle().z < null else "∇",
        "▶" if eventPlayer.getThrottle().x < null else "▷"),
        HudPosition.LEFT, HO.game_input, evalOnce(ColorConfig[Customize.time]),HudReeval.STRING, SpecVisibility.DEFAULT)

    # climb/bhop indicators
    hudText(eventPlayer,
        "{0}{1}".format(t"Climb"," ({0})".format(eventPlayer.skill_countMulti) if eventPlayer.skill_countMulti else []),
        ##"爬墙已用{0}".format([] if eventPlayer.skill_countMulti < 1 else " ({0})".format(eventPlayer.skill_countMulti))
        #"{1}{0}".format(" ({0})".format(eventPlayer.skill_countMulti) if eventPlayer.skill_countMulti else [],
        #    "爬墙已用" if eventPlayer.skill_usedClimb else "爬墙未用") # cn version text updates to say the status, unlike en
        #checkCN
        #"Climb{0}".format(" ({0})".format(eventPlayer.skill_countMulti) if eventPlayer.skill_countMulti else []),
        null, LeftAlign128, HudPosition.LEFT, HO.game_climb,
        evalOnce(ColorConfig[Customize.bhopclimb_used]) if eventPlayer.skill_usedClimb else evalOnce(ColorConfig[Customize.bhopclimb_available]),
        null, null, HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT)

    hudText(eventPlayer,
        "{0}{1}".format(t"Bhop"," ({0})".format(eventPlayer.skill_countCreates) if eventPlayer.skill_countCreates else []),
        # cn version text updates to say the status, unlike en version
        #("{0}{1}".format(
        #    "小跳已用" if eventPlayer.skill_usedBhop else "小跳未用",
        #    " ({0})".format(eventPlayer.skill_countCreates) if eventPlayer.skill_countCreates else []))
        #checkCN
        #"Bhop{0}".format(" ({0})".format(eventPlayer.skill_countCreates) if eventPlayer.skill_countCreates else []),
        null, LeftAlign128, HudPosition.LEFT, HO.game_bhop,
        evalOnce(ColorConfig[Customize.bhopclimb_used]) if eventPlayer.skill_usedBhop else evalOnce(ColorConfig[Customize.bhopclimb_available]),
        null, null, HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT)

    createInWorldText(
        eventPlayer if eventPlayer.checkpoint_notLast and eventPlayer.toggle_guide else null,
        f"{iconString(Icon.WARNING)}{t'Collect Orbs First'}"
        if eventPlayer.cache_bounceMaxLocks and len(eventPlayer.cache_collectedLocks) < eventPlayer.cache_bounceMaxLocks else
        t"Come Here",
        #"{0} {1}".format(
        #    iconString(Icon.WARNING),
        #    "先收集橙球" checkCN "collect orbs first"
        #) if eventPlayer.cache_bounceMaxLocks and len(eventPlayer.cache_collectedLocks) < eventPlayer.cache_bounceMaxLocks else
        #"到这里来" checkCN "come here",
        CheckpointPositions[eventPlayer.checkpoint_current + 1],
        1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING,  ColorConfig[Customize.cometext], SpecVisibility.DEFAULT)

    wait(2.5)
    if CompMode:
        hudText(eventPlayer, null,
            ("! 比赛结束 !" if not CompTime else
            "剩余时间: {0} 分钟{1}".format(
                CompTime,
                "\n你没有尝试过" if eventPlayer.comp_countAttempts < 0 else
                "\n尝试 {0} / {1}".format(eventPlayer.comp_countAttempts, CompAtmpNum) if CompAtmpNum else [])
            ) checkCN (
            "! Competition Is Over !" if not CompTime else
            "Time Left: {0} Min{1}".format(
                CompTime,
                "\nYou Are Out Of Attempts" if eventPlayer.comp_countAttempts < 0 else
                "\nAttempt {0} / {1}".format(eventPlayer.comp_countAttempts, CompAtmpNum) if CompAtmpNum else [])),
            ("竞赛模式" if CompTime else "竞赛模式\n\n\n")
            checkCN
            ("Tournament Mode" if CompTime else "Tournament Mode\n\n\n"),
            HudPosition.TOP, HO.comp_info, null, Color.YELLOW, Color.YELLOW, HudReeval.STRING, SpecVisibility.DEFAULT)

def UpdateTitle():
    @Name "Huds | SUB Update Title"
    if CompMode or EditorOn or not (len(TitleData) and eventPlayer.checkpoint_current in TitleData[0]):# or eventPlayer.toggle_practice:
        return
    destroyInWorldText(eventPlayer.cache_titleHud)
    createInWorldText((not eventPlayer.toggle_invisible)[0],TitleData[1][TitleData[0].index(eventPlayer.checkpoint_current)], eventPlayer, 1.1,
        Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, TitleData.last()[TitleData[0].index(eventPlayer.checkpoint_current)], SpecVisibility.DEFAULT)
    eventPlayer.cache_titleHud = getLastCreatedText()

rule "Huds | Addons":
    wait(LoadOrder.hudsGlobal)
    waitUntil(entityExists(getAllPlayers()), Math.INFINITY)
    wait()
    if getAllPlayers().addon_toggle3rdPov <= true:
        hudSubtext(localPlayer.toggle_guide,
            f"{t'Hold'} {buttonString(Button.CROUCH)} + {buttonString(Button.JUMP)} | {t'3rd Person'}{t' | On' if localPlayer.addon_toggle3rdPov else []}",
            #"长按 {0} + {1} | 第三人称{2}".format(buttonString(Button.CROUCH), buttonString(Button.JUMP)," | 启用" if localPlayer.addon_toggle3rdPov else [])
            #checkCN
            #"Hold {0} + {1} | 3rd Person{2}".format(buttonString(Button.CROUCH), buttonString(Button.JUMP)," | On" if localPlayer.addon_toggle3rdPov else []),
            HudPosition.RIGHT, HO.com_3rd,evalOnce(ColorConfig[Customize.command_highlight]) if localPlayer.addon_toggle3rdPov else evalOnce(ColorConfig[Customize.command_normal]),
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)