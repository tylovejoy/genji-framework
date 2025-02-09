#!mainFile "genji.opy"

/*
huds outside this file:
    - custom diffiuclty (map data)
    - display world record (addons p2)
    - editor huds ( editor)

*/

rule "Huds: Global/Localplayer":
    wait(2)

    # name/credit construction
    # note on changing default name/credit
    # if you change it, also change it in the credits rule
    # the old credits should always remain valid here to keep old data valid
    
    if Name != "name here - 作者" and Name != null:
        Cachedcredits[0] = Name
    elif Cachedcredits[0] == null:
        Cachedcredits[0] = "name here - 作者" 
    
    if Code != "code here - 代码" and Code != null:
        Cachedcredits[1] = Code
    elif Cachedcredits[1] == null:
        Cachedcredits[1] = "code here - 代码" 

    Name = null
    Code = null

    #  if Code != "code here - 代码" or Cachedcredits[1] == null::


    hudSubtext(localPlayer, 
        "作者: {}".format( Cachedcredits[0] )
        checkCN
        "Made by: {}".format( Cachedcredits[0] )
        , HudPosition.LEFT, HO.data_name, ColorConfig[customize.credit_name] , HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())
    hudSubtext(getAllPlayers(), 
        "代码: {}".format( Cachedcredits[1] )
        checkCN
        "Map code: {}".format( Cachedcredits[1] )
        , HudPosition.LEFT, HO.data_code, ColorConfig[customize.credit_code] , HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())
    hudSubtext(localPlayer.GuideToggle, "Discord: dsc.gg/genjiparkour", HudPosition.LEFT, HO.data_dsc, ColorConfig[customize.dsc], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)   
   
    # global huds
    hudSubheader(localPlayer,
        "房间将在 {0} 分钟后重启 - V{1}{2}".format(
            TimeRemaining, versionhere,
            "\n错误: 已达到最大HUD数量上限" if getNumberOfTextIds() >= 128 else ""  
        ) 
        checkCN 
        "Server Restarts In {0} Min - V{1}{2}".format(
            TimeRemaining,versionhere,
            "\nerror: max hud count reached" if getNumberOfTextIds() >= 128 else ""       
        )
        , HudPosition.RIGHT, HO.data_remaingtime, ColorConfig[customize.servertime] , HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS
    )
    
    # padding for custom hud display
    hudSubtext(localPlayer, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nv", HudPosition.TOP, HO.fillermain, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    
    hudSubtext(localPlayer.GuideToggle, 
        "{0} {1} | {2}".format( "" if localPlayer.QuickRestartToggle else "长按",buttonString(Button.RELOAD),"快速回点 | 启用" if localPlayer.QuickRestartToggle else "启用快速回点")
        checkCN
        "{0} {1} | {2}".format( "" if localPlayer.QuickRestartToggle else "Hold",buttonString(Button.RELOAD),"Quick reset" if localPlayer.QuickRestartToggle else "Enable Quick reset")
        , HudPosition.RIGHT, HO.com_quickres, ColorConfig[customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(localPlayer.GuideToggle, 
        "{0} + {1} | 探点模式{2}".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)," | 启用" if localPlayer.InvincibleToggle else "") 
        checkCN
        "{0} + {1} | Invincible{2}".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)," | ON" if localPlayer.InvincibleToggle else "") 
        ,HudPosition.RIGHT, HO.com_invincible, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.InvincibleToggle else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    hudText(localPlayer,
        null,
        "{0}{1}{2}".format(
            abilityIconString(Hero.BAPTISTE, Button.ABILITY_2) if localPlayer.InvincibleToggle else "",
            abilityIconString(Hero.DVA, Button.ULTIMATE) if localPlayer.PracticeToggle else "",
            abilityIconString(Hero.SOMBRA, Button.ABILITY_1) if localPlayer.invis else ""
        ) if not localPlayer.GuideToggle else "", 
        "长按 {0} | 切换显示HUD".format(buttonString(Button.SECONDARY_FIRE))
        checkCN
        "Hold {0} | toggle hud".format(buttonString(Button.SECONDARY_FIRE))
        ,HudPosition.RIGHT, HO.com_displaytoggle, ColorConfig[customize.command_normal], ColorConfig[customize.command_normal], ColorConfig[customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(localPlayer.GuideToggle,  
        "长按 {0} + {1} | 预览关卡".format(buttonString(Button.PRIMARY_FIRE),buttonString(Button.SECONDARY_FIRE))
        checkCN
        "Hold {0} + {1} | Preview cp".format(buttonString(Button.PRIMARY_FIRE),buttonString(Button.SECONDARY_FIRE))
        ,HudPosition.RIGHT, HO.com_preview, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.PreviewsArray else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())

    hudSubheader(localPlayer if localPlayer.PreviewsArray and localPlayer.GuideToggle else null,
        "移动键 左/右 ↔| 预览其他\n视角移动 | 调整浏览视角"
        checkCN
        "Walk left/right ↔| preview others\nAim | change preview angle"
        ,HudPosition.TOP, HO.com_previewsub, ColorConfig[customize.command_highlight], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())


    hudSubtext(localPlayer, 
        "" if localPlayer.splitdisplay == -999 else
        ("单关用时 {0}".format(localPlayer.splitdisplay) if not localPlayer.SpectateToggle else "")
        checkCN
        ("Split: {0}".format(localPlayer.splitdisplay) if not localPlayer.SpectateToggle else "")
        ,HudPosition.LEFT, HO.game_split_display, ColorConfig[customize.time], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )  
    HudStoreEdit.append(getLastCreatedText())

    CreateLeaderBoard()

    if CpHudText != null: # text per checkpoint  text per cp each
        hudText(localPlayer,
            CpHudText[CpHudCp.index(localPlayer.CurrentCheckpoint)]
            if localPlayer.CurrentCheckpoint in CpHudCp and localPlayer.GuideToggle else "",
            ("(文本已隐藏)" if localPlayer.CurrentCheckpoint in CpHudCp and not localPlayer.GuideToggle else "")
            checkCN
            ("(text hidden)" if localPlayer.CurrentCheckpoint in CpHudCp and not localPlayer.GuideToggle else ""),
            null
            , HudPosition.TOP, HO.add_custommsg1, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
        )
     
  
    if CpIwtText != null:
        createInWorldText(
            localPlayer, 
            CpIwtText[CpIwtCp.index(localPlayer.CurrentCheckpoint)]
            if localPlayer.CurrentCheckpoint in CpIwtCp else "",
            CpIwtPos[CpIwtCp.index(localPlayer.CurrentCheckpoint)], 
            2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, CpIwtColor, SpecVisibility.DEFAULT)

    if len(HintText) > 0:
        hudText(localPlayer.GuideToggle,
            null, 
            (
            "{0} ――  有可用提示―― {0}".format(iconString(Icon.HAPPY)) if localPlayer.CurrentCheckpoint in HintCp and localPlayer.HintsOn == false else 
            "― ― ― ― ― 提示 ― ― ― ― ―\n {} ".format(HintText[HintCp.index(localPlayer.CurrentCheckpoint)]) if localPlayer.CurrentCheckpoint in HintCp else   
            "(当前关卡无可用提示)"
            ) checkCN
            "{0} ―― hint available ―― {0}".format(iconString(Icon.HAPPY)) if localPlayer.CurrentCheckpoint in HintCp and localPlayer.HintsOn == false else 
            #" ――――――― \n {} \n ――――――― ".format(HintText[HintCp.index(localPlayer.CurrentCheckpoint)]) if localPlayer.CurrentCheckpoint in HintCp else   # and true is implied from last if
            "― ― ― ― ― Hint ― ― ― ― ―\n {} ".format(HintText[HintCp.index(localPlayer.CurrentCheckpoint)]) if localPlayer.CurrentCheckpoint in HintCp else   # and true is implied from last if
            "(no hint on this level)"
            ,
            
            "{} + {} | {}".format(
                buttonString(Button.ABILITY_2), 
                buttonString(Button.MELEE),
                ("隐藏提示" if localPlayer.HintsOn else "获取提示") checkCN
                "hide hint" if localPlayer.HintsOn else "show hint"
                
            )
            
            #"{} + {} | hide hint".format(buttonString(Button.ABILITY_2), buttonString(Button.MELEE)) if localPlayer.HintsOn else 
            #"{} + {} | show hint".format(buttonString(Button.ABILITY_2), buttonString(Button.MELEE))
            , 
            HudPosition.RIGHT, HO.com_hints, 
            Color.BLUE, 
            Color.ORANGE if localPlayer.CurrentCheckpoint in HintCp and localPlayer.HintsOn == false else 
            Color.GREEN if localPlayer.CurrentCheckpoint in HintCp else 
            Color.GRAY, 
            evalOnce(ColorConfig[customize.command_normal]) if localPlayer.CurrentCheckpoint in HintCp else Color.GRAY, 
            HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

    if CompMode:
        hudHeader([i for i in getAllPlayers() if i.instructionhud],"                                                                                                                           ", HudPosition.TOP, HO.comp_instructtop, Color.WHITE, HudReeval.VISIBILITY,SpecVisibility.DEFAULT)
        if instructiontext[0]:
            hudSubtext([i for i in getAllPlayers() if i.instructionhud], instructiontext[0], HudPosition.TOP, HO.comp_instruct1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if instructiontext[1]:
            hudSubtext([i for i in getAllPlayers() if i.instructionhud], instructiontext[1], HudPosition.TOP, HO.comp_instruct2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if instructiontext[2]:
            hudSubtext([i for i in getAllPlayers() if i.instructionhud], instructiontext[2], HudPosition.TOP, HO.comp_instruct3, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if instructiontext[3]:
            hudSubtext([i for i in getAllPlayers() if i.instructionhud], instructiontext[3], HudPosition.TOP, HO.comp_instruct4, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        hudHeader([i for i in getAllPlayers() if i.instructionhud],"                                   Press {0} to start                                ".format(buttonString(Button.INTERACT)), HudPosition.TOP, HO.comp_instructbottom, Color.WHITE, HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
                
    elif not CompMode:
        hudSubtext(localPlayer.GuideToggle, 
            "长按 {0} | 观战模式{1}".format(buttonString(Button.INTERACT)," | 启用" if localPlayer.SpectateToggle else "")
            checkCN
            "Hold {0} | Spectate{1}".format(buttonString(Button.INTERACT)," | ON" if localPlayer.SpectateToggle else "")
            , HudPosition.RIGHT, HO.com_spec, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.SpectateToggle else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        hudSubtext(localPlayer.GuideToggle, 
            "长按 {0} | 隐身模式{1}".format(buttonString(Button.ABILITY_2)," | 启用" if localPlayer.invis else "")
            checkCN
            "Hold {0} | invisible{1}".format(buttonString(Button.ABILITY_2)," | ON" if localPlayer.invis else "")
            , HudPosition.RIGHT, HO.com_invis, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.invis else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

        hudSubtext(localPlayer.GuideToggle,
            "{0} + {1} | 练习模式{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.PracticeCheckpoint) if localPlayer.PracticeToggle else "")
            checkCN
            "{0} + {1} | Practice{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.PracticeCheckpoint) if localPlayer.PracticeToggle else "")
            ,HudPosition.RIGHT, HO.com_practice, evalOnce(ColorConfig[customize.command_highlight]) if localPlayer.PracticeToggle else Color.GRAY if localPlayer.InvincibleToggle else evalOnce(ColorConfig[customize.command_normal]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

        hudSubheader([i for i in getAllPlayers() if i.PracticeToggle and i.GuideToggle],
            "{0} + {1} | 下一关\n{0} + {2} | 上一关\n{3} | 回到练习模式起点 "
            "".format( buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT) )    
            checkCN
            "{0} + {1} | Next level\n{0} + {2} | Previous level\n{3} | Start from practice cp "
            "".format( buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT) )          
            , HudPosition.RIGHT, HO.com_practicesub, evalOnce(ColorConfig[customize.command_highlight]), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

    #if not hostPlayer.EditorOn:
        # find the value
    Difficultyhud = [
        createWorkshopSetting(enum[ "<fg27AAFFFF>playtest - 游戏测试", "<fgA0E81BFF>easy-", "<fgA0E81BFF>easy", "<fgA0E81BFF>easy+", "<fge0e000FF>medium-", "<fge0e000FF>medium", "<fge0e000FF>medium+", "<fgEC9900FF>hard-", "<fgEC9900FF>hard", "<fgEC9900FF>hard+", "<fgFF4500FF>very hard-", "<fgFF4500FF>very hard", "<fgFF4500FF>very hard+", "<fgC80013FF>extreme-", "<fgC80013FF>extreme", "<fgC80013FF>extreme+", "<fg960000FF>hell", "don't display - 不显示"],"map settings \n地图设置","difficulty (display hud) - 难度 (顶部hud)",0, 0)
        , createWorkshopSetting(bool,"map settings \n地图设置","Playtest display - 游戏测试",false,1) 
        ] 
    # display
    if Difficultyhud[0] != 17: # 17th entry is 'dont display'
        hudText(localPlayer if localPlayer.GuideToggle and not localPlayer.LeaderboardToggle else null, 
            ("游戏测试" checkCN "Playtest") if Difficultyhud[1] else "",
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
    hudSubtext(localPlayer.GuideToggle, 
        "{0} + {1} + {2} | 重新开始\n长按 {3} | 完整成绩排名".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT),buttonString(Button.MELEE)) 
        checkCN
        "{0} + {1} + {2} | Restart\nHold {3} | leaderboard".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT),buttonString(Button.MELEE))
        , HudPosition.RIGHT, HO.com_restart_n_board, ColorConfig[customize.command_normal], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())
    #else:
        # restart without leaderboard if editor on
 
rule "Huds: remake leaderboard": # for global isntead of tied to player
    @Condition LeaderBoardRemake   
    wait() # account for delay in completion
    LeaderBoardFull = sorted(LeaderBoardFull, lambda i: i[1])
    
    while len(LeaderBoardHuds) > 0: 
        destroyHudText(LeaderBoardHuds[0])
        del LeaderBoardHuds[0]
    
    # top 5
    if LeaderBoardFull[0]:
        hudSubtext(localPlayer,
            " \n{0} 排名前5 {0}".format(abilityIconString(Hero.GENJI,Button.PRIMARY_FIRE))
            checkCN
            " \n{0} Top 5 {0}".format(abilityIconString(Hero.GENJI,Button.PRIMARY_FIRE))
            , HudPosition.RIGHT, HO.board_top5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
        )
        LeaderBoardHuds.append(getLastCreatedText())
        hudText(getAllPlayers(), heroIcon(Hero.GENJI), LeaderBoardFull[0][0], LeaderBoardFull[0][2], HudPosition.RIGHT, HO.board_top5+1, Color.RED, Color.RED, Color.RED, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        LeaderBoardHuds.append(getLastCreatedText())
    if LeaderBoardFull[1]:
        hudText(getAllPlayers(), heroIcon(Hero.GENJI), LeaderBoardFull[1][0], LeaderBoardFull[1][2], HudPosition.RIGHT, HO.board_top5+2, Color.ORANGE, Color.ORANGE, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        LeaderBoardHuds.append(getLastCreatedText())
    if LeaderBoardFull[2]:
        hudText(getAllPlayers(), heroIcon(Hero.GENJI), LeaderBoardFull[2][0], LeaderBoardFull[2][2], HudPosition.RIGHT, HO.board_top5+3, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        LeaderBoardHuds.append(getLastCreatedText())
    if LeaderBoardFull[3]:
        hudText(getAllPlayers(), heroIcon(Hero.GENJI), LeaderBoardFull[3][0], LeaderBoardFull[3][2], HudPosition.RIGHT, HO.board_top5+4, Color.LIME_GREEN, Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        LeaderBoardHuds.append(getLastCreatedText())
    if LeaderBoardFull[4]:
        hudText(getAllPlayers(), heroIcon(Hero.GENJI), LeaderBoardFull[4][0], LeaderBoardFull[4][2], HudPosition.RIGHT, HO.board_top5+5, Color.GREEN, Color.GREEN, Color.GREEN,HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        LeaderBoardHuds.append(getLastCreatedText())

    hudHeader(getAllPlayers() if evalOnce(CompMode and CompTime == 0) else localPlayer.LeaderboardToggle, 
        "　　　　 {0} {1} {0} 　　　".format(
            iconString(Icon.FLAG),
            "成绩排名" checkCN "Leaderboard"
        ), HudPosition.TOP, HO.board_header, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    LeaderBoardHuds.append(getLastCreatedText())

    hudHeader(
        getAllPlayers() if evalOnce(CompMode and CompTime == 0) else localPlayer.LeaderboardToggle,
        "　　　　　　　　　　　　　　　　　　\n"
        "　 1:　{0} - {5}　\n"
        "　 2:　{1} - {6}　\n"
        "　 3:　{2} - {7}　\n"
        "　 4:　{3} - {8}　\n"
        "　 5:　{4} - {9}\n".format(
        LeaderBoardFull[0][0] if LeaderBoardFull[0] else "",
        LeaderBoardFull[1][0] if LeaderBoardFull[1] else "",
        LeaderBoardFull[2][0] if LeaderBoardFull[2] else "",
        LeaderBoardFull[3][0] if LeaderBoardFull[3] else "",
        LeaderBoardFull[4][0] if LeaderBoardFull[4] else "",
        LeaderBoardFull[0][2] if LeaderBoardFull[0] else "",
        LeaderBoardFull[1][2] if LeaderBoardFull[1] else "",
        LeaderBoardFull[2][2] if LeaderBoardFull[2] else "",
        LeaderBoardFull[3][2] if LeaderBoardFull[3] else "",
        LeaderBoardFull[4][2] if LeaderBoardFull[4] else ""
        ),HudPosition.TOP, HO.board_display1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
    )
    LeaderBoardHuds.append(getLastCreatedText())

    if LeaderBoardFull[5]:
        hudHeader(
            getAllPlayers() if evalOnce(CompMode and CompTime == 0) else localPlayer.LeaderboardToggle,
            "　　　　　　　　　　　　　　　　　　\n"
            "　 6:　{0} - {5}　\n"
            "　 7:　{1} - {6}　\n"
            "　 8:　{2} - {7}　\n"
            "　 9:　{3} - {8}　\n"
            "　10:　{4} - {9}\n".format(
            LeaderBoardFull[5][0] if LeaderBoardFull[5] else "",
            LeaderBoardFull[6][0] if LeaderBoardFull[6] else "",
            LeaderBoardFull[7][0] if LeaderBoardFull[7] else "",
            LeaderBoardFull[8][0] if LeaderBoardFull[8] else "",
            LeaderBoardFull[9][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[5][2] if LeaderBoardFull[5] else "",
            LeaderBoardFull[6][2] if LeaderBoardFull[6] else "",
            LeaderBoardFull[7][2] if LeaderBoardFull[7] else "",
            LeaderBoardFull[8][2] if LeaderBoardFull[8] else "",
            LeaderBoardFull[9][2] if LeaderBoardFull[9] else ""
            ),HudPosition.TOP, HO.board_display2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
        )
        LeaderBoardHuds.append(getLastCreatedText())

    if LeaderBoardFull[10]:
        hudHeader( 
        getAllPlayers() if evalOnce(CompMode and CompTime == 0) else localPlayer.LeaderboardToggle,
            "　　　　　　　　　　　　　　　　　　\n"
            "　11:　{0} - {5}　\n"
            "　12:　{1} - {6}　\n"
            "　13:　{2} - {7}　\n"
            "　14:　{3} - {8}　\n"
            "　15:　{4} - {9}\n".format(
            LeaderBoardFull[10][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[11][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[12][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[13][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[14][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[10][2] if LeaderBoardFull[9] else "",
            LeaderBoardFull[11][2] if LeaderBoardFull[9] else "",
            LeaderBoardFull[12][2] if LeaderBoardFull[9] else "",
            LeaderBoardFull[13][2] if LeaderBoardFull[9] else "",
            LeaderBoardFull[14][2] if LeaderBoardFull[9] else ""
            ),HudPosition.TOP, HO.board_display3, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
        )
        LeaderBoardHuds.append(getLastCreatedText())

    if LeaderBoardFull[15]:
        hudHeader(
            getAllPlayers() if evalOnce(CompMode and CompTime == 0) else localPlayer.LeaderboardToggle,
            "　　　　　　　　　　　　　　　　　　\n"
            "　16:　{0} - {5}　\n"
            "　17:　{1} - {6}　\n"
            "　18:　{2} - {7}　\n"
            "　19:　{3} - {8}　\n"
            "　20:　{4} - {9}\n".format(
            LeaderBoardFull[15][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[16][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[17][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[18][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[19][0] if LeaderBoardFull[9] else "",
            LeaderBoardFull[15][2] if LeaderBoardFull[9] else "",
            LeaderBoardFull[16][2] if LeaderBoardFull[9] else "",
            LeaderBoardFull[17][2] if LeaderBoardFull[9] else "",
            LeaderBoardFull[18][2] if LeaderBoardFull[9] else "",
            LeaderBoardFull[19][2] if LeaderBoardFull[9] else ""
            ),HudPosition.TOP, HO.board_display4, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT
        )
        LeaderBoardHuds.append(getLastCreatedText())

def EffectsCreate():
    @Name "Effects Create"
    if CustomPortalStart:
        for TempIterator1 in range(len(CustomPortalStart)):
            createEffect(
                [i for i in getAllPlayers() if i.CurrentCheckpoint == CustomPortalCP[evalOnce(TempIterator1)] or CustomPortalCP[evalOnce(TempIterator1)] == 999],
                Effect.GOOD_AURA, ColorConfig[customize.portal],
                CustomPortalStart[evalOnce(TempIterator1)], 
                0.6,
                EffectReeval.VISIBILITY
            )
            wait()
        wait(0.5)
        
    if KillBallPositions != []:
        for TempIterator1 in range(0, len(KillBallPositions)):
            createEffect([x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == KillballCheckpoints[evalOnce(TempIterator1)]], Effect.SPHERE, ColorConfig[customize.killorb] , KillBallPositions[evalOnce(TempIterator1)], KillBallRadii[evalOnce(TempIterator1)], EffectReeval.VISIBILITY)
            wait()
        wait(0.5)

    if BouncePositions != []:
        for TempIterator1 in range(0, len(BouncePositions)):
            createEffect(
                [x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)] and not BouncePositions[evalOnce(TempIterator1)] in x.LockCollected], 
                Effect.ORB, 
                ColorConfig[customize.orb_lock] if BounceToggleLock[TempIterator1] else ColorConfig[customize.orb_normal] , 
                BouncePositions[evalOnce(TempIterator1)], 
                1, 
                EffectReeval.VISIBILITY
            )
            wait()

    createEffect( # portal preview
        localPlayer
            if 
            localPlayer.PreviewsI >= len(localPlayer.BouncePosition_Cache) + 1 and 
            localPlayer.PreviewsI > 0 and
            localPlayer.PreviewsArray2[localPlayer.PreviewsI][0] == 1 
        else null
        , 
        Effect.SPARKLES,
        Color.PURPLE,
        localPlayer.PreviewsArray[localPlayer.PreviewsI], 
        0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS
    )

##############################################################################

rule "Huds: each player":
    @Event playerJoined
    wait(0.5)
    
    # ban icons in level
    hudText(eventPlayer, null, 
        /*
        ("练习用时 {0}".format(prettyTime(eventPlayer.practicetimer)) if eventPlayer.PracticeToggle else "")
        checkCN  
        ("Practice Time {0}".format(prettyTime(eventPlayer.practicetimer)) if eventPlayer.PracticeToggle else "")
        */
        "{} {}".format("练习用时" checkCN "Practice Time",prettyTime(eventPlayer.practicetimer)) if eventPlayer.PracticeToggle else "",
        # 19191
        "{} {}".format("用时" checkCN "Time",prettyTime(eventPlayer.Timer)),
        #checkCN  
        #"Time {0}".format(prettyTime(eventPlayer.Timer)) ,
        #"用时 {0}".format(prettyTime(eventPlayer.Timer))
        #checkCN  
        #"Time {0}".format(prettyTime(eventPlayer.Timer)) ,
        HudPosition.LEFT, HO.game_timer, ColorConfig[customize.time], Color.GRAY, ColorConfig[customize.time], HudReeval.STRING, SpecVisibility.DEFAULT
    )
    

    hudText(
        eventPlayer if not eventPlayer.LeaderboardToggle else null,  
        " {0} ({2}/{3})\n―――――――――――\n {1}\n"
        "".format(
            ("检查点" if eventPlayer.PreviewsI == 0 else "弹球" if eventPlayer.PreviewsI < len(eventPlayer.BouncePosition_Cache) + 1  else "自定义传送门") checkCN
            "checkpoint" if eventPlayer.PreviewsI == 0 else "orb" if eventPlayer.PreviewsI < len(eventPlayer.BouncePosition_Cache) + 1  else "portal",
            "{} {} {} {}".format(
                abilityIconString(Hero.GENJI, Button.ULTIMATE) if BounceToggleUlt[eventPlayer.PreviewsArray2[eventPlayer.PreviewsI]] else "",
                abilityIconString(Hero.GENJI, Button.ABILITY_1) if BounceToggleDash[eventPlayer.PreviewsArray2[eventPlayer.PreviewsI]] else "",
                iconString(Icon.WARNING) if BounceToggleLock[eventPlayer.PreviewsArray2[eventPlayer.PreviewsI]] else "",
                iconString(Icon.ARROW_UP) if BounceStrength[eventPlayer.PreviewsArray2[eventPlayer.PreviewsI]] > 0 else
                iconString(Icon.ARROW_DOWN) if BounceStrength[eventPlayer.PreviewsArray2[eventPlayer.PreviewsI]] < 0 else ""
            #) if eventPlayer.PreviewsI < len(eventPlayer.BouncePosition_Cache) + 1 and eventPlayer.PreviewsI > 0 else "", # [0:cp, 1-x:bounce, x-y:portal]
            ) if eventPlayer.PreviewsI < len(eventPlayer.BouncePosition_Cache) + 1 and eventPlayer.PreviewsI > 0 else

            (
                ("传送门 {} 入口 ".format(eventPlayer.PreviewsArray2[eventPlayer.PreviewsI][1])
                if eventPlayer.PreviewsArray2[eventPlayer.PreviewsI][0] == 0 else  
                "传送门 {} 出口 ".format( eventPlayer.PreviewsArray2[eventPlayer.PreviewsI][1])
                ) checkCN

                "portal {} start ".format(eventPlayer.PreviewsArray2[eventPlayer.PreviewsI][1])
                if eventPlayer.PreviewsArray2[eventPlayer.PreviewsI][0] == 0 else 
                "portal {} destination ".format(eventPlayer.PreviewsArray2[eventPlayer.PreviewsI][1])
            
            )
            if eventPlayer.PreviewsI >= len(eventPlayer.BouncePosition_Cache) + 1 and eventPlayer.PreviewsI > 0 else "",


            eventPlayer.PreviewsI + 1,
            len(eventPlayer.PreviewsArray)
        ) if eventPlayer.PreviewsArray != null else ""
        ,    
        "{2} {0} / {1}".format(
            len(eventPlayer.LockCollected), 
            eventPlayer.BounceLockMax_Cache,
            "{0}球".format(ColorConfig[customize.orb_lock]) checkCN "{0} orbs".format(ColorConfig[customize.orb_lock])
            #"收集球" checkCN "{0} orbs".format(ColorConfig[customize.orb_lock])
        ) if eventPlayer.BounceLockMax_Cache and eventPlayer.PreviewsArray == null else ""
        ,
        "{3}{2}{4} {0} / {1}".format(
            eventPlayer.CurrentCheckpoint, 
            len(CheckpointPositions) - 1,
            "\n" if eventPlayer.banstring else "",
            eventPlayer.banstring if eventPlayer.banstring else "",
            "关卡" checkCN "Level"
        ) if eventPlayer.PreviewsArray == null else ""
        ,   
        HudPosition.TOP, HO.game_level_orb, ColorConfig[customize.level], ColorConfig[customize.orb_lock], ColorConfig[customize.level], HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(eventPlayer,"{0}{1}{2}\n{3}{4}{5}".format(
        "■" if eventPlayer.HUDInputs.x else "□",
        "▲" if eventPlayer.getThrottle().z > null else "△", 
        "●" if eventPlayer.HUDInputs.y else "○",
        "◀" if eventPlayer.getThrottle().x > null else "◁",
        "▼" if eventPlayer.getThrottle().z < null else "∇",
        "▶" if eventPlayer.getThrottle().x < null else "▷"),
        HudPosition.LEFT, HO.game_input, evalOnce(ColorConfig[customize.time]),HudReeval.STRING, SpecVisibility.DEFAULT)
    
    # climb/bhop indicators
    hudHeader(eventPlayer,         
        #"爬墙已用{0}".format([] if eventPlayer.MultiClimbCount < 1 else " ({0})".format(eventPlayer.MultiClimbCount))
        "{1}{0}".format([] if eventPlayer.MultiClimbCount < 1 else " ({0})".format(eventPlayer.MultiClimbCount),
            "爬墙已用" if  eventPlayer.WallclimbUsed else "爬墙未用" # cn version text updates to say the status, unlike en
        )
        checkCN
        "Climb{0}".format([] if eventPlayer.MultiClimbCount < 1 else " ({0})".format(eventPlayer.MultiClimbCount))
        , HudPosition.LEFT, HO.game_climb, 
        evalOnce(ColorConfig[customize.bhopclimb_used]) if eventPlayer.WallclimbUsed else evalOnce(ColorConfig[customize.bhopclimb_available]), 
        HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    hudHeader(eventPlayer, 
        ( # cn version text updates to say the status, unlike en version
            "{0}{1}".format(
                "小跳未用" if eventPlayer.BhopUsed == 0 or eventPlayer.BhopHUDColor == evalOnce(ColorConfig[customize.bhopclimb_available]) else "小跳已用",
                [] if eventPlayer.CreateCounter < 1 else " ({0})".format(eventPlayer.CreateCounter)  
            )  
        ) 
        checkCN 
        "Bhop{0}".format(
            [] if eventPlayer.CreateCounter < 1 else
            " ({0})".format(eventPlayer.CreateCounter) 
        )
        , HudPosition.LEFT, HO.game_bhop, 
        evalOnce(ColorConfig[customize.bhopclimb_available]) if eventPlayer.BhopUsed == 0 else eventPlayer.BhopHUDColor, 
        HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    
    createInWorldText(
        #eventPlayer if eventPlayer.NotOnLastCp else null, 
        eventPlayer if eventPlayer.NotOnLastCp and eventPlayer.GuideToggle else null, 
        "{0} {1}".format(
            iconString(Icon.WARNING),    
            "先收集橙球" checkCN "collect orbs first"
        ) if eventPlayer.BounceLockMax_Cache and len(eventPlayer.LockCollected) < eventPlayer.BounceLockMax_Cache else
        "到这里来" checkCN "Come here",
        CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 
        1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING,  ColorConfig[customize.cometext], SpecVisibility.DEFAULT
    )
    
    wait(2.5)
    if CompMode:
        hudText(
            eventPlayer, 
            " ",
            (
                "! 比赛结束 !" if CompTime <= 0 else
                "剩余时间: {0} 分钟{1}".format(
                    CompTime, 
                    "\n你没有尝试过" if eventPlayer.AttemptCount == -1 else
                    "\n尝试 {0} / {1}".format(eventPlayer.AttemptCount, CompAtmpNum) if CompAtmpNum > 0 
                    else []
                )
            )
            checkCN
            (
                "! competition is over !" if CompTime <= 0 else
                "time left: {0} min{1}".format(
                    CompTime, 
                    "\nYou are out of attemps" if eventPlayer.AttemptCount == -1 else
                    "\nAttempt {0} / {1}".format(eventPlayer.AttemptCount, CompAtmpNum) if CompAtmpNum > 0 
                    else []
                )
            ), 
            ("竞赛模式" if CompTime > 0 else "竞赛模式\n\n\n")
            checkCN
            ("competitive mode" if CompTime > 0 else "competitive mode\n\n\n")
            , HudPosition.TOP, HO.comp_info, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.STRING, SpecVisibility.DEFAULT
        ) 

def UpdateTitle():
    @Name "Title"
    if TitleData == null or CompMode or eventPlayer.PracticeToggle or eventPlayer.EditorOn or (not eventPlayer.CurrentCheckpoint in TitleData[0]): 
        return
    destroyInWorldText(eventPlayer.TitleStore)
    createInWorldText(getAllPlayers() if not eventPlayer.invis else null,TitleData[1][TitleData[0].index(eventPlayer.CurrentCheckpoint)], eventPlayer,1.1,Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, TitleData[2][TitleData[0].index(eventPlayer.CurrentCheckpoint)], SpecVisibility.DEFAULT)
    eventPlayer.TitleStore = getLastCreatedText()