#!mainFile "framework.opy"

/*
huds outside this file:
    - custom difficulty (map data)
    - display author time (addons pg2)
    - editor huds (editor)
*/
rule "<tx0C00000000001344> Huds <tx0C00000000001344>":
    @Delimiter

rule "Huds | Global Localplayer":
    wait(1)

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

    hudSubtext(true[0],
        "作者: {}".format(Name)
        checkCN
        "Made by: {}".format(Name)
        , HudPosition.LEFT, HO.data_name, ColorConfig[customize.credit_name] , HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())
    hudSubtext(true[0],
        "代码: {}".format(Code)
        checkCN
        "Map code: {}".format(Code)
        , HudPosition.LEFT, HO.data_code, ColorConfig[customize.credit_code] , HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())
    hudSubtext(localPlayer.toggle_guide, "Discord: dsc.gg/genjiparkour", HudPosition.LEFT, HO.data_dsc, ColorConfig[customize.dsc], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)

    # global huds
    hudSubheader(true[0],
        "房间将在 {0} 分钟后重启 - {1}{2}".format(
            TimeRemaining, versionhere,
            "\n错误: 已达到最大HUD数量上限" if getNumberOfTextIds() >= 128 else []
        )
        checkCN
        "Server Restart in {0} Min - {1}{2}".format(
            TimeRemaining, versionhere,
            "\nerror: max hud count reached" if getNumberOfTextIds() >= 128 else []
        )
        , HudPosition.RIGHT, HO.data_remaingtime, ColorConfig[customize.servertime] , HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS
    )

    # padding for custom hud display
    hudSubtext(localPlayer, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nv", HudPosition.TOP, HO.fillermain, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)

    hudSubtext(localPlayer.toggle_guide,
        "{0} {1} | {2}快速回点".format([] if localPlayer.toggle_quickRestart else "长按",buttonString(Button.RELOAD),[] if localPlayer.toggle_quickRestart else "启用")
        checkCN
        "{0} {1} |{2} quick reset".format([] if localPlayer.toggle_quickRestart else "Hold", buttonString(Button.RELOAD), [] if localPlayer.toggle_quickRestart else " Enable")
        , HudPosition.RIGHT, HO.com_quickres, ColorConfig[customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(localPlayer.toggle_guide,
        "{0} + {1} | 探点模式{2}".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)," | 启用" if localPlayer.toggle_invincible else [])
        checkCN
        "{0} + {1} | Invincible{2}".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)," | ON" if localPlayer.toggle_invincible else [])
        ,HudPosition.RIGHT, HO.com_invincible, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.toggle_invincible else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    hudText(true[0],
        null,
        [] if localPlayer.toggle_guide else "{0}{1}{2}".format(
            abilityIconString(Hero.BAPTISTE, Button.ABILITY_2) if localPlayer.toggle_invincible else [],
            abilityIconString(Hero.DVA, Button.ULTIMATE) if localPlayer.toggle_practice else [],
            abilityIconString(Hero.SOMBRA, Button.ABILITY_1) if localPlayer.toggle_invisible else []),
        "长按 {0} | 切换显示HUD".format(buttonString(Button.SECONDARY_FIRE))
        checkCN
        "Hold {0} | toggle hud".format(buttonString(Button.SECONDARY_FIRE))
        ,HudPosition.RIGHT, HO.com_displaytoggle, ColorConfig[customize.command_normal], ColorConfig[customize.command_normal], ColorConfig[customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(localPlayer.toggle_guide,
        "长按 {0} + {1} | 预览关卡".format(buttonString(Button.PRIMARY_FIRE),buttonString(Button.SECONDARY_FIRE))
        checkCN
        "Hold {0} + {1} | Preview cp".format(buttonString(Button.PRIMARY_FIRE),buttonString(Button.SECONDARY_FIRE))
        ,HudPosition.RIGHT, HO.com_preview, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.preview_array1 else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())

    hudSubheader(localPlayer if localPlayer.preview_array1 and localPlayer.toggle_guide else null,
        "移动键 ◀ ▶ | 预览其他\n移动键 ◀ ▶ | 修改间距 \n视角移动 | 调整浏览视角"
        checkCN
        "Walk ◀ ▶ | preview others\nWalk ▲ ▼ | modify zoom\nAim | change preview angle"
        ,HudPosition.TOP, HO.com_previewsub, ColorConfig[customize.command_highlight], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())


    hudSubtext(localPlayer,
        [] if localPlayer.timer_splitDisplay == -Math.INFINITY or localPlayer.toggle_spectate else(
            ("单关用时 {0}".format(localPlayer.timer_splitDisplay)
            checkCN
            "Split: {0}".format(localPlayer.timer_splitDisplay))),
        HudPosition.LEFT, HO.game_split_display, ColorConfig[customize.time], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())

    LeaderBoardRemake = true #CreateLeaderboard()

    if len(CpHudText): # text per checkpoint  text per cp each
        hudText(localPlayer,
            CpHudText[CpHudCp.index(localPlayer.checkpoint_current)]
            if localPlayer.checkpoint_current in CpHudCp and localPlayer.toggle_guide else [],
            ("(文本已隐藏)" checkCN "(text hidden)" if localPlayer.checkpoint_current in CpHudCp and not localPlayer.toggle_guide else []),
            null
            , HudPosition.TOP, HO.add_custommsg1, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
        )

    if len(CpIwtText):
        createInWorldText(
            localPlayer,
            CpIwtText[CpIwtCp.index(localPlayer.checkpoint_current)]
            if localPlayer.checkpoint_current in CpIwtCp else [],
            CpIwtPos[CpIwtCp.index(localPlayer.checkpoint_current)],
            2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, CpIwtColor, SpecVisibility.DEFAULT)

    if len(HintText): #Remove no hints - visual and element bloat
        hudText((localPlayer.toggle_guide and localPlayer.checkpoint_current in HintCp)[0], null,
            ("― ― ― ― ― 提示 ― ― ― ― ―\n {} ".format(HintText[HintCp.index(localPlayer.checkpoint_current)])
            if localPlayer.toggle_hints else "――――――  有可用提示 ――――――")
            checkCN
            ("― ― ― ― ― Hint ― ― ― ― ―\n {} ".format(HintText[HintCp.index(localPlayer.checkpoint_current)])
            if localPlayer.toggle_hints else "― ― ― hint available ― ― ―"),
            "{} + {} | {}".format(buttonString(Button.ABILITY_2), buttonString(Button.MELEE),
                ("隐藏提示" if localPlayer.toggle_hints else "获取提示")
                checkCN
                "hide hint" if localPlayer.toggle_hints else "show hint")
            #"{} + {} | hide hint".format(buttonString(Button.ABILITY_2), buttonString(Button.MELEE)) if localPlayer.toggle_hints else
            #"{} + {} | show hint".format(buttonString(Button.ABILITY_2), buttonString(Button.MELEE))
            , HudPosition.RIGHT, HO.com_hints,
            Color.BLUE,
            Color.GREEN if localPlayer.toggle_hints else
            Color.ORANGE,
            evalOnce(ColorConfig[customize.command_normal]) if localPlayer.checkpoint_current in HintCp else Color.GRAY,
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

    if CompMode:
        hudHeader([i for i in getAllPlayers() if i.comp_instructionHud],"                                                                                                                           ", HudPosition.TOP, HO.comp_instructtop, Color.WHITE, HudReeval.VISIBILITY,SpecVisibility.DEFAULT)
        if InstructionText[0]:
            hudSubtext([i for i in getAllPlayers() if i.comp_instructionHud], InstructionText[0], HudPosition.TOP, HO.comp_instruct1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if InstructionText[1]:
            hudSubtext([i for i in getAllPlayers() if i.comp_instructionHud], InstructionText[1], HudPosition.TOP, HO.comp_instruct2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if InstructionText[2]:
            hudSubtext([i for i in getAllPlayers() if i.comp_instructionHud], InstructionText[2], HudPosition.TOP, HO.comp_instruct3, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if InstructionText[3]:
            hudSubtext([i for i in getAllPlayers() if i.comp_instructionHud], InstructionText[3], HudPosition.TOP, HO.comp_instruct4, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        hudHeader([i for i in getAllPlayers() if i.comp_instructionHud],"                                   Press {0} to start                                ".format(buttonString(Button.INTERACT)), HudPosition.TOP, HO.comp_instructbottom, Color.WHITE, HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    else:
        hudSubtext(localPlayer.toggle_guide,
            "长按 {0} | 观战模式{1}".format(buttonString(Button.INTERACT)," | 启用" if localPlayer.toggle_spectate else [])
            checkCN
            "Hold {0} | Spectate{1}".format(buttonString(Button.INTERACT)," | ON" if localPlayer.toggle_spectate else [])
            , HudPosition.RIGHT, HO.com_spec, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.toggle_spectate else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        hudSubtext(localPlayer.toggle_guide,
            "长按 {0} | 隐身模式{1}".format(buttonString(Button.ABILITY_2)," | 启用" if localPlayer.toggle_invisible else [])
            checkCN
            "Hold {0} | invisible{1}".format(buttonString(Button.ABILITY_2)," | ON" if localPlayer.toggle_invisible else [])
            , HudPosition.RIGHT, HO.com_invis, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.toggle_invisible else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

        hudSubtext(localPlayer.toggle_guide,
            "{0} + {1} | 练习模式{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.checkpoint_practice) if localPlayer.toggle_practice else [])
            checkCN
            "{0} + {1} | Practice{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.checkpoint_practice) if localPlayer.toggle_practice else [])
            ,HudPosition.RIGHT, HO.com_practice, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.toggle_practice else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

        hudSubheader([i for i in getAllPlayers() if i.toggle_practice and i.toggle_guide],
            "{0} + {1} | 下一关\n{0} + {2} | 上一关\n{3} | 回到练习模式起点 ".format(
                buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT) )
            checkCN
            "{0} + {1} | Next level\n{0} + {2} | Previous level\n{3} | Start from practice cp ".format(
                buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT) )
            , HudPosition.RIGHT, HO.com_practicesub, evalOnce(ColorConfig[customize.command_highlight]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

    #if not hostPlayer.editor_on:
        # find the value
    Difficultyhud = [
        createWorkshopSetting(enum[ "<fg27AAFFFF>playtest - 游戏测试", "<fgA0E81BFF>easy-", "<fgA0E81BFF>easy", "<fgA0E81BFF>easy+", "<fge0e000FF>medium-", "<fge0e000FF>medium", "<fge0e000FF>medium+", "<fgEC9900FF>hard-", "<fgEC9900FF>hard", "<fgEC9900FF>hard+", "<fgFF4500FF>very hard-", "<fgFF4500FF>very hard", "<fgFF4500FF>very hard+", "<fgC80013FF>extreme-", "<fgC80013FF>extreme", "<fgC80013FF>extreme+", "<fg960000FF>hell", "don't display - 不显示"],"map settings \n地图设置","difficulty (display hud) - 难度 (顶部hud)",0, 0),
        createWorkshopSetting(bool,"map settings \n地图设置","Playtest display - 游戏测试", false, 1)]
    # display
    if Difficultyhud[0] != 17: # 17th entry is 'dont display'
        hudText(localPlayer if localPlayer.toggle_guide and not localPlayer.toggle_leaderboard else null,
            ("游戏测试" checkCN "Playtest") if Difficultyhud.last() else [],
            ["playtest", "easy -", "easy", "easy +","medium -","medium","medium +","hard -","hard","hard +","very hard -","very hard","very hard +","extreme -","extreme","extreme +","hell",null][Difficultyhud[0]],
            null,
            HudPosition.TOP, HO.data_dif,
            Color.BLUE,
            [Color.BLUE,Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN,Color.YELLOW,Color.YELLOW,Color.YELLOW, Color.ORANGE,Color.ORANGE,Color.ORANGE,rgb(255, 69, 0), rgb(255, 69, 0), rgb(255, 69, 0), Color.RED, Color.RED, Color.RED, rgb(150, 0, 0),null][Difficultyhud[0]],
            Color.BLUE,
            HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

    # restart + leaderboard
    # this is remade in editor to not include leaderboard
    hudSubtext(localPlayer.toggle_guide,
        "{0} + {1} + {2} | 重新开始\n长按 {3} | 完整成绩排名".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT),buttonString(Button.MELEE))
        checkCN
        "{0} + {1} + {2} | Restart\nHold {3} | leaderboard".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT),buttonString(Button.MELEE))
        , HudPosition.RIGHT, HO.com_restart_n_board, ColorConfig[customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())
    #else:
        # restart without leaderboard if editor on

rule "Huds | Leaderboard": # for global instead of tied to player
    @Condition LeaderBoardRemake
    wait() # account for delay in completion
    LeaderBoardRemake = null

    while len(LeaderBoardHuds):
        destroyHudText(LeaderBoardHuds[0])
        del LeaderBoardHuds[0]

    # top 5
    LeaderBoardFull = sorted(LeaderBoardFull, lambda i: i[1])
    if LeaderBoardFull[0]:
        hudSubtext(true[0], " \n{0} 排名前5 {0}".format(iconString(Icon.FLAG)) checkCN " \n{0} Top 5 {0}".format(iconString(Icon.FLAG)),
            HudPosition.RIGHT, HO.board_top5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        LeaderBoardHuds.append(getLastCreatedText())
        hudText(localPlayer, heroIcon(Hero.GENJI), LeaderBoardFull[0][0], LeaderBoardFull[0].last(), HudPosition.RIGHT, HO.board_top5+1, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        LeaderBoardHuds.append(getLastCreatedText())
        if LeaderBoardFull[1]:
            hudText(localPlayer, heroIcon(Hero.GENJI), LeaderBoardFull[1][0], LeaderBoardFull[1].last(), HudPosition.RIGHT, HO.board_top5+2, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
            LeaderBoardHuds.append(getLastCreatedText())
            if LeaderBoardFull[2]:
                hudText(localPlayer, heroIcon(Hero.GENJI), LeaderBoardFull[2][0], LeaderBoardFull[2].last(), HudPosition.RIGHT, HO.board_top5+3, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
                LeaderBoardHuds.append(getLastCreatedText())
                if LeaderBoardFull[3]:
                    hudText(localPlayer, heroIcon(Hero.GENJI), LeaderBoardFull[3][0], LeaderBoardFull[3].last(), HudPosition.RIGHT, HO.board_top5+4, Color.LIME_GREEN, Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
                    LeaderBoardHuds.append(getLastCreatedText())
                    if LeaderBoardFull[4]:
                        hudText(localPlayer, heroIcon(Hero.GENJI), LeaderBoardFull[4][0], LeaderBoardFull[4].last(), HudPosition.RIGHT, HO.board_top5+5, Color.GREEN, Color.GREEN, Color.GREEN,HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
                        LeaderBoardHuds.append(getLastCreatedText())

    hudHeader(localPlayer if evalOnce(CompMode and not CompTime) else localPlayer.toggle_leaderboard,
        "　　　　 {0} {1} {0} 　　　".format(iconString(Icon.FLAG), "成绩排名" checkCN "Leaderboard"),
        HudPosition.TOP, HO.board_header, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    LeaderBoardHuds.append(getLastCreatedText())

    hudHeader(
        localPlayer if evalOnce(CompMode and not CompTime) else localPlayer.toggle_leaderboard,
        "　　　　　　　　　　　　　　　　　　\n"
        "　 1:　{0} - {5}　\n"
        "　 2:　{1} - {6}　\n"
        "　 3:　{2} - {7}　\n"
        "　 4:　{3} - {8}　\n"
        "　 5:　{4} - {9}\n".format(
        LeaderBoardFull[0][0] if LeaderBoardFull[0] else [],
        LeaderBoardFull[1][0] if LeaderBoardFull[1] else [],
        LeaderBoardFull[2][0] if LeaderBoardFull[2] else [],
        LeaderBoardFull[3][0] if LeaderBoardFull[3] else [],
        LeaderBoardFull[4][0] if LeaderBoardFull[4] else [],

        LeaderBoardFull[0].last() if LeaderBoardFull[0] else [],
        LeaderBoardFull[1].last() if LeaderBoardFull[1] else [],
        LeaderBoardFull[2].last() if LeaderBoardFull[2] else [],
        LeaderBoardFull[3].last() if LeaderBoardFull[3] else [],
        LeaderBoardFull[4].last() if LeaderBoardFull[4] else []
        ),HudPosition.TOP, HO.board_display1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
    )
    LeaderBoardHuds.append(getLastCreatedText())

    if LeaderBoardFull[5]:
        hudHeader(
            localPlayer if evalOnce(CompMode and not CompTime) else localPlayer.toggle_leaderboard,
            "　　　　　　　　　　　　　　　　　　\n"
            "　 6:　{0} - {5}　\n"
            "　 7:　{1} - {6}　\n"
            "　 8:　{2} - {7}　\n"
            "　 9:　{3} - {8}　\n"
            "　10:　{4} - {9}\n".format(
            LeaderBoardFull[5][0] if LeaderBoardFull[5] else [],
            LeaderBoardFull[6][0] if LeaderBoardFull[6] else [],
            LeaderBoardFull[7][0] if LeaderBoardFull[7] else [],
            LeaderBoardFull[8][0] if LeaderBoardFull[8] else [],
            LeaderBoardFull[9][0] if LeaderBoardFull[9] else [],

            LeaderBoardFull[5].last() if LeaderBoardFull[5] else [],
            LeaderBoardFull[6].last() if LeaderBoardFull[6] else [],
            LeaderBoardFull[7].last() if LeaderBoardFull[7] else [],
            LeaderBoardFull[8].last() if LeaderBoardFull[8] else [],
            LeaderBoardFull[9].last() if LeaderBoardFull[9] else []
            ),HudPosition.TOP, HO.board_display2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
        )
        LeaderBoardHuds.append(getLastCreatedText())

    if LeaderBoardFull[10]:
        hudHeader(
            localPlayer if evalOnce(CompMode and not CompTime) else localPlayer.toggle_leaderboard,
            "　　　　　　　　　　　　　　　　　　\n"
            "　11:　{0} - {5}　\n"
            "　12:　{1} - {6}　\n"
            "　13:　{2} - {7}　\n"
            "　14:　{3} - {8}　\n"
            "　15:　{4} - {9}\n".format(
            LeaderBoardFull[10][0] if LeaderBoardFull[10] else [],
            LeaderBoardFull[11][0] if LeaderBoardFull[11] else [],
            LeaderBoardFull[12][0] if LeaderBoardFull[12] else [],
            LeaderBoardFull[13][0] if LeaderBoardFull[13] else [],
            LeaderBoardFull[14][0] if LeaderBoardFull[14] else [],

            LeaderBoardFull[10].last() if LeaderBoardFull[10] else [],
            LeaderBoardFull[11].last() if LeaderBoardFull[11] else [],
            LeaderBoardFull[12].last() if LeaderBoardFull[12] else [],
            LeaderBoardFull[13].last() if LeaderBoardFull[13] else [],
            LeaderBoardFull[14].last() if LeaderBoardFull[14] else []
            ),HudPosition.TOP, HO.board_display3, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
        )
        LeaderBoardHuds.append(getLastCreatedText())

    if LeaderBoardFull[15]:
        hudHeader(
            localPlayer if evalOnce(CompMode and not CompTime) else localPlayer.toggle_leaderboard,
            "　　　　　　　　　　　　　　　　　　\n"
            "　16:　{0} - {5}　\n"
            "　17:　{1} - {6}　\n"
            "　18:　{2} - {7}　\n"
            "　19:　{3} - {8}　\n"
            "　20:　{4} - {9}\n".format(
            LeaderBoardFull[15][0] if LeaderBoardFull[15] else [],
            LeaderBoardFull[16][0] if LeaderBoardFull[16] else [],
            LeaderBoardFull[17][0] if LeaderBoardFull[17] else [],
            LeaderBoardFull[18][0] if LeaderBoardFull[18] else [],
            LeaderBoardFull.last()[0] if LeaderBoardFull.last() else [],

            LeaderBoardFull[15].last() if LeaderBoardFull[15] else [],
            LeaderBoardFull[16].last() if LeaderBoardFull[16] else [],
            LeaderBoardFull[17].last() if LeaderBoardFull[17] else [],
            LeaderBoardFull[18].last() if LeaderBoardFull[18] else [],
            LeaderBoardFull.last().last() if LeaderBoardFull.last() else []
            ),HudPosition.TOP, HO.board_display4, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
        )
        LeaderBoardHuds.append(getLastCreatedText())

rule "Huds | Each Player":
    @Event playerJoined
    wait(0.5)

    hudText(eventPlayer, null,
        /*
        ("练习用时 {0}".format(prettyTime(eventPlayer.timer_practice)) if eventPlayer.toggle_practice else [])
        checkCN
        ("Practice Time {0}".format(prettyTime(eventPlayer.timer_practice)) if eventPlayer.toggle_practice else [])
        */
        "{} {}".format("练习用时" checkCN "Practice Time",prettyTime(eventPlayer.timer_practice)) if eventPlayer.toggle_practice else [],
        # 19191
        "{} {}".format("用时" checkCN "Time", prettyTime(eventPlayer.timer_normal)),
        #checkCN
        #"Time {0}".format(prettyTime(eventPlayer.timer_normal)) ,
        #"用时 {0}".format(prettyTime(eventPlayer.timer_normal))
        #checkCN
        #"Time {0}".format(prettyTime(eventPlayer.timer_normal)) ,
        HudPosition.LEFT, HO.game_timer, ColorConfig[customize.time], Color.GRAY, ColorConfig[customize.time], HudReeval.STRING, SpecVisibility.DEFAULT
    )

    #$$ not eventPlayer.preview_i
    #$$ eventPlayer.preview_i < len(eventPlayer.cache_bouncePosition) + 1
    #$$ eventPlayer.preview_i > 0
    #$$ information wrong
    hudText(
        null if eventPlayer.toggle_leaderboard else eventPlayer,
        " {0} ({1}/{2})\n―――――――――――\n {3}\n".format(
            (("弹球" if eventPlayer.preview_i <= len(eventPlayer.cache_bouncePosition) else "自定义传送门" if eventPlayer.preview_i else "检查点")
            checkCN
            "orb" if eventPlayer.preview_i <= len(eventPlayer.cache_bouncePosition) else "portal" if eventPlayer.preview_i else "checkpoint"),
            eventPlayer.preview_i + 1,
            len(eventPlayer.preview_array1),
            ("{} {} {} {}".format(
                abilityIconString(Hero.GENJI, Button.ULTIMATE) if BounceToggleUlt[eventPlayer.preview_array2[eventPlayer.preview_i]] else [],
                abilityIconString(Hero.GENJI, Button.ABILITY_1) if BounceToggleDash[eventPlayer.preview_array2[eventPlayer.preview_i]] else [],
                iconString(Icon.WARNING) if BounceToggleLock[eventPlayer.preview_array2[eventPlayer.preview_i]] else [],
                iconString(Icon.ARROW_UP) if BounceStrength[eventPlayer.preview_array2[eventPlayer.preview_i]] > 0 else
                iconString(Icon.ARROW_DOWN) if BounceStrength[eventPlayer.preview_array2[eventPlayer.preview_i]] < 0 else [])
            if eventPlayer.preview_i <= len(eventPlayer.cache_bouncePosition) and eventPlayer.preview_i else

            (("传送门 {} 出口 ".format(eventPlayer.preview_array2[eventPlayer.preview_i])
            if eventPlayer.preview_array2[eventPlayer.preview_i].last() else
            "传送门 {} 入口 ".format(eventPlayer.preview_array2[eventPlayer.preview_i])
            ) checkCN
            "portal {} destination ".format(eventPlayer.preview_array2[eventPlayer.preview_i])
            if eventPlayer.preview_array2[eventPlayer.preview_i].last() else
            "portal {} start ".format(eventPlayer.preview_array2[eventPlayer.preview_i]))
            if eventPlayer.preview_i else eventPlayer.banString)
        ) if eventPlayer.preview_array1 else [],
        
        "{} {} / {}".format(
            #eventPlayer.banString,
            "关卡" checkCN "Level",
            eventPlayer.checkpoint_current,
            len(CheckpointPositions) - 1),

        "{0}{1} {2} / {3}".format(
            ColorConfig[customize.orb_lock],
            "球" checkCN " orbs",
            len(eventPlayer.cache_collectedLocks),
            eventPlayer.cache_bounceMaxLocks
            #"收集球" checkCN "{0} orbs".format(ColorConfig[customize.orb_lock])
        ) if eventPlayer.cache_bounceMaxLocks and not eventPlayer.preview_array1 else [],

        HudPosition.TOP, HO.game_level_orb, ColorConfig[customize.level], ColorConfig[customize.level], ColorConfig[customize.orb_lock], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(eventPlayer,"{0}{1}{2}\n{3}{4}{5}".format(
        "■" if eventPlayer.cache_inputs.x else "□",
        "▲" if eventPlayer.getThrottle().z > null else "△",
        "●" if eventPlayer.cache_inputs.y else "○",
        "◀" if eventPlayer.getThrottle().x > null else "◁",
        "▼" if eventPlayer.getThrottle().z < null else "∇",
        "▶" if eventPlayer.getThrottle().x < null else "▷"),
        HudPosition.LEFT, HO.game_input, evalOnce(ColorConfig[customize.time]),HudReeval.STRING, SpecVisibility.DEFAULT)

    # climb/bhop indicators
    hudHeader(eventPlayer,
        #"爬墙已用{0}".format([] if eventPlayer.skill_countMulti < 1 else " ({0})".format(eventPlayer.skill_countMulti))
        "{1}{0}".format(" ({0})".format(eventPlayer.skill_countMulti) if eventPlayer.skill_countMulti else [],
            "爬墙已用" if eventPlayer.skill_usedClimb else "爬墙未用") # cn version text updates to say the status, unlike en
        checkCN
        "Climb{0}".format(" ({0})".format(eventPlayer.skill_countMulti) if eventPlayer.skill_countMulti else [])
        , HudPosition.LEFT, HO.game_climb,
        evalOnce(ColorConfig[customize.bhopclimb_used]) if eventPlayer.skill_usedClimb else evalOnce(ColorConfig[customize.bhopclimb_available]),
        HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    hudHeader(eventPlayer,
        # cn version text updates to say the status, unlike en version
        ("{0}{1}".format(
            "小跳已用" if eventPlayer.skill_usedBhop else "小跳未用",
            " ({0})".format(eventPlayer.skill_countCreates) if eventPlayer.skill_countCreates else []))
        checkCN
        "Bhop{0}".format(" ({0})".format(eventPlayer.skill_countCreates) if eventPlayer.skill_countCreates else [])
        , HudPosition.LEFT, HO.game_bhop,
        evalOnce(ColorConfig[customize.bhopclimb_used]) if eventPlayer.skill_usedBhop else evalOnce(ColorConfig[customize.bhopclimb_available]),
        HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    createInWorldText(
        #eventPlayer if eventPlayer.checkpoint_notLast else null,
        eventPlayer if eventPlayer.checkpoint_notLast and eventPlayer.toggle_guide else null,
        "{0} {1}".format(
            iconString(Icon.WARNING),
            "先收集橙球" checkCN "collect orbs first"
        ) if eventPlayer.cache_bounceMaxLocks and len(eventPlayer.cache_collectedLocks) < eventPlayer.cache_bounceMaxLocks else
        "到这里来" checkCN "come here",
        CheckpointPositions[eventPlayer.checkpoint_current + 1],
        1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING,  ColorConfig[customize.cometext], SpecVisibility.DEFAULT
    )

    wait(2.5)
    if CompMode:
        hudText(
            eventPlayer,
            " ",
            (
                "! 比赛结束 !" if not CompTime else
                "剩余时间: {0} 分钟{1}".format(
                    CompTime,
                    "\n你没有尝试过" if eventPlayer.comp_countAttempts < 0 else
                    "\n尝试 {0} / {1}".format(eventPlayer.comp_countAttempts, CompAtmpNum) if CompAtmpNum else []
                )
            )
            checkCN
            (
                "! competition is over !" if not CompTime else
                "time left: {0} min{1}".format(
                    CompTime,
                    "\nYou are out of attempts" if eventPlayer.comp_countAttempts < 0 else
                    "\nAttempt {0} / {1}".format(eventPlayer.comp_countAttempts, CompAtmpNum) if CompAtmpNum else []
                )
            ),
            ("竞赛模式" if CompTime else "竞赛模式\n\n\n")
            checkCN
            ("competitive mode" if CompTime else "competitive mode\n\n\n")
            , HudPosition.TOP, HO.comp_info, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.STRING, SpecVisibility.DEFAULT
        )

def UpdateTitle():
    @Name "Huds | SUB Update Title"
    if CompMode or eventPlayer.editor_on or not (len(TitleData) and eventPlayer.checkpoint_current in TitleData[0]) or eventPlayer.toggle_practice:
        return
    destroyInWorldText(eventPlayer.cache_titleHud)
    createInWorldText((not eventPlayer.toggle_invisible)[0],TitleData[1][TitleData[0].index(eventPlayer.checkpoint_current)], eventPlayer,1.1,Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, TitleData.last()[TitleData[0].index(eventPlayer.checkpoint_current)], SpecVisibility.DEFAULT)
    eventPlayer.cache_titleHud = getLastCreatedText()

rule "Huds | Addons":
    waitUntil(getNumberOfPlayers(Team.ALL) > 0, Math.INFINITY)
    wait()
    if getAllPlayers().addon_toggle3rdPov <= true:
        hudSubtext(localPlayer.toggle_guide,
            "长按 {0} + {1} | 第三人称{2}".format(buttonString(Button.CROUCH), buttonString(Button.JUMP)," | 启用" if localPlayer.addon_toggle3rdPov else [])
            checkCN
            "Hold {0} + {1} | 3rd Person{2}".format(buttonString(Button.CROUCH), buttonString(Button.JUMP)," | ON" if localPlayer.addon_toggle3rdPov else []),
            HudPosition.RIGHT,HO.com_3rd,evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.addon_toggle3rdPov else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)