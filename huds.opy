#!mainFile "genji.opy"

/*
huds outside this file:
- addons you need otk now where to find:
    - custom diffiuclty
    - display world record
- editor

*/

rule "Huds: Global/Localplayer":
    wait(2)
 
    # name/credit construction
    if Name != "name here" or Cachedcredits[0] == null::
        Cachedcredits[0] = Name
    
    if Code != "code here" or Cachedcredits[1] == null::
        Cachedcredits[1] = Code
    Name = null
    Code = null

    hudSubtext(getAllPlayers(), 
        "作者: {}".format( Cachedcredits[0] )
        CNany
        "Made by: {}".format( Cachedcredits[0] )
        , HudPosition.LEFT, HO.data_name, Color.VIOLET, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())
    hudSubtext(getAllPlayers(), 
        "代码: {}".format( Cachedcredits[1] )
        CNany
        "Map code: {}".format( Cachedcredits[1] )
        , HudPosition.LEFT, HO.data_code, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())
    hudSubtext(getAllPlayers(), "Discord: dsc.gg/genjiparkour", HudPosition.LEFT, HO.data_dsc, Color.AQUA, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)   
   
    # global huds
    hudSubheader(getAllPlayers(),
        "房间将在 {0} 分钟后重启 - V{1}".format(TimeRemaining,versionhere) 
        CNany 
        "Server Restarts In {0} Min - V{1}".format(TimeRemaining,versionhere)
        , HudPosition.RIGHT, HO.data_remaingtime, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS
    )
    
    # padding for custom hud display
    hudSubtext(getAllPlayers(), "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nv", HudPosition.TOP, HO.fillermain, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    
    hudSubtext(getAllPlayers(), 
        "{0}+{1}+{2} | 重新开始\n长按{3} | 完整成绩排名".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT),buttonString(Button.MELEE)) 
        CNany
        "{0}+{1}+{2} | Restart\nHold {3} | leaderboard".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT),buttonString(Button.MELEE))
        , HudPosition.RIGHT, HO.com_restart_n_board, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(getAllPlayers(), 
        "{0} {1} |  {2}".format( "" if localPlayer.QuickRestartToggle else "长按",buttonString(Button.RELOAD),"快速回点" if localPlayer.QuickRestartToggle else "启用快速回点")
        CNany
        "{0} {1} |  {2}".format( "" if localPlayer.QuickRestartToggle else "Hold",buttonString(Button.RELOAD),"Quick reset" if localPlayer.QuickRestartToggle else "Enable Quick reset")
        , HudPosition.RIGHT, HO.com_quickres, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(getAllPlayers(), 
        "{0}+{1} | 探点模式{2}".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)," | 启用" if localPlayer.InvincibleToggle else "") 
        CNany
        "{0}+{1} | Invincible{2}".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)," | ON" if localPlayer.InvincibleToggle else "") 
        ,HudPosition.RIGHT, HO.com_invincible, Color.GREEN if localPlayer.InvincibleToggle else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    
    hudSubtext(getAllPlayers(),  
        "长按 {0} |  预览弹球/传送".format(buttonString(Button.PRIMARY_FIRE))
        CNany
        "Hold {0} | Preview orb/portal".format(buttonString(Button.PRIMARY_FIRE))
        ,HudPosition.RIGHT, HO.com_preview, Color.GREEN if localPlayer.PreviewsArray else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())

    hudSubheader(getAllPlayers() if localPlayer.PreviewsArray else null,
        "移动键 左/右 | 预览其他\n视角移动 | 调整浏览视角"
        CNany
        "Walk left/right | preview others\nAim | change preview angle"
        ,HudPosition.RIGHT, HO.com_previewsub, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    HudStoreEdit.append(getLastCreatedText())

    /*
    hudSubtext(getAllPlayers(), 
        "Hold {0} | Splits{1}".format(buttonString(Button.ULTIMATE), " | ON " if localPlayer.splitson else ""), 
        HudPosition.RIGHT, HO.com_splits, Color.GREEN if localPlayer.splitson else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )  
    HudStoreEdit.append(getLastCreatedText())
    */
    #hudSubtext or hudSubheader
    hudSubtext(getAllPlayers(), 
        ("长按 {0} | 单关用".format(localPlayer.splitdisplay) if not localPlayer.SpectateToggle else "")
        CNany
        "Split: {0}".format(localPlayer.splitdisplay) if not localPlayer.SpectateToggle else ""
        ,HudPosition.LEFT, HO.game_split_display, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )  
    HudStoreEdit.append(getLastCreatedText())
 
    CreateLeaderBoard()

    if CpHudText != null: # text per cp
        #hudSubtext(getAllPlayers(), "                                                   \r\n  \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", HudPosition.TOP, HO.filler_custommsg, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        hudHeader(
            getAllPlayers(),    
            CpHudText[CpHudCp.index(localPlayer.CurrentCheckpoint)]
            if localPlayer.CurrentCheckpoint in CpHudCp else "", 
            HudPosition.TOP, HO.add_custommsg1, 
            Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    
    if CpIwtText != null:
        createInWorldText(
            getAllPlayers(), 
            CpIwtText[CpIwtCp.index(localPlayer.CurrentCheckpoint)]
            if localPlayer.CurrentCheckpoint in CpIwtCp else "",
            CpIwtPos[CpIwtCp.index(localPlayer.CurrentCheckpoint)], 
            2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, CpIwtColor, SpecVisibility.DEFAULT)


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
        hudSubtext(getAllPlayers(), 
            "长按 {0} | 观战模式{1}".format(buttonString(Button.INTERACT)," | 启用" if localPlayer.SpectateToggle else "")
            CNany
            "Hold {0} | Spectate{1}".format(buttonString(Button.INTERACT)," | ON" if localPlayer.SpectateToggle else "")
            , HudPosition.RIGHT, HO.com_spec, Color.GREEN if localPlayer.SpectateToggle else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        hudSubtext(getAllPlayers(), 
            "长按  {0} | 隐形的{1}".format(buttonString(Button.ABILITY_2)," | 启用" if localPlayer.invis else "")
            CNany
            "Hold {0} | invisible{1}".format(buttonString(Button.ABILITY_2)," | ON" if localPlayer.invis else "")
            , HudPosition.RIGHT, HO.com_invis, Color.GREEN if localPlayer.invis else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

        hudSubtext(getAllPlayers(),
            "{0} + {1} | 练习模式{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.PracticeCheckpoint) if localPlayer.PracticeToggle else "")
            CNany
            "{0} + {1} | Practice{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.PracticeCheckpoint) if localPlayer.PracticeToggle else "")
            ,HudPosition.RIGHT, HO.com_practice, Color.GREEN if localPlayer.PracticeToggle else Color.GRAY if localPlayer.InvincibleToggle else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

        hudSubheader([i for i in getAllPlayers() if i.PracticeToggle],
            "{0} + {1} | 下一关\n{0} + {2} | 上一关\n{3} | 回到练习模式起点 "
            "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT))     
            CNany
            "{0} + {1} | Next level\n{0} + {2} | Previous level\n{3} | Start from practice cp "
            "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT))          
            , HudPosition.RIGHT, HO.com_practicesub, Color.LIME_GREEN, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        HudStoreEdit.append(getLastCreatedText())

    if not hostPlayer.EditorOn:
        # find the value
        Difficultyhud = createWorkshopSetting(enum[ "beginner", "easy-", "easy", "easy+", "medium-", "medium", "medium+", "hard-", "hard", "hard+", "very hard-", "very hard", "very hard+", "extreme-", "extreme", "extreme+", "hell", "don't display"],"map settings","difficulty (display hud)",0, 0)
        # display
        if Difficultyhud < 17: # 17th entry is dont display
            hudSubheader(getAllPlayers(), 
                ["beginner", "easy -", "easy", "easy +","medium -","medium","medium +","hard -","hard","hard +","very hard -","very hard","very hard +","extreme -","extreme","extreme +","hell"][Difficultyhud], 
                HudPosition.TOP, HO.data_dif,
                [Color.GREEN,Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN,Color.YELLOW,Color.YELLOW,Color.YELLOW, Color.ORANGE,Color.ORANGE,Color.ORANGE,rgb(255, 69, 0), rgb(255, 69, 0), rgb(255, 69, 0), Color.RED, Color.RED, Color.RED, rgb(150, 0, 0)][Difficultyhud], 
                HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
            )
            HudStoreEdit.append(getLastCreatedText())


    

rule "Huds: each player":
    @Event eachPlayer
    # ban icons in level
    hudText(eventPlayer, null, 
        ("练习用时{0}".format(prettyTime(eventPlayer.practicetimer)) if eventPlayer.PracticeToggle else "")
        CNany  
        ("Practice Time {0}".format(prettyTime(eventPlayer.practicetimer)) if eventPlayer.PracticeToggle else "")
        , 
        "用时 {0}".format(prettyTime(eventPlayer.Timer))
        CNany  
        "Time {0}".format(prettyTime(eventPlayer.Timer)) ,
        #"Time {0}{1}{2}".format(prettyTime(eventPlayer.Timer), "\nSplit " if eventPlayer.splitson else "",eventPlayer.splitdisplay  if eventPlayer.splitson else ""), 
        HudPosition.LEFT, HO.game_timer, Color.WHITE, Color.GRAY, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    


    hudText(eventPlayer, null, 
        "黄弹球 {0} / {1}".format(len(eventPlayer.LockCollected), eventPlayer.BounceLockMax_Cache) if eventPlayer.BounceLockMax_Cache else ""
        CNany
        "orange orbs {0} / {1}".format(len(eventPlayer.LockCollected), eventPlayer.BounceLockMax_Cache) if eventPlayer.BounceLockMax_Cache else ""
        ,
        "{3}{2}Level {0} / {1}".format(
            eventPlayer.CurrentCheckpoint, 
            len(CheckpointPositions) - 1,
            "\n" if eventPlayer.banstring else "",
            eventPlayer.banstring if eventPlayer.banstring else ""
        )
        CNany
        "{3}{2}{4} {0} / {1}".format(
            eventPlayer.CurrentCheckpoint, 
            len(CheckpointPositions) - 1,
            "\n" if eventPlayer.banstring else "",
            eventPlayer.banstring if eventPlayer.banstring else "",
            "检查点" CNany "Level"
        ),    
        HudPosition.TOP, HO.game_level_orb, Color.WHITE, Color.ORANGE, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT
    )
    # climb/bhop indicators
    hudHeader(eventPlayer,         
        "爬墙已用{0}".format("" if eventPlayer.MultiClimbCount < 1 else " ({0})".format(eventPlayer.MultiClimbCount))
        CNany
        "Climb{0}".format("" if eventPlayer.MultiClimbCount < 1 else " ({0})".format(eventPlayer.MultiClimbCount))
        , HudPosition.LEFT, HO.game_climb, Color.RED if eventPlayer.WallclimbUsed else Color.GREEN, HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    hudHeader(eventPlayer, "小跳已用" CNany "Bhop", HudPosition.LEFT, HO.game_bhop, Color.GREEN if eventPlayer.BhopUsed == 0 else eventPlayer.BhopHUDColor, HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT)
    
    if CompMode:
        hudText(
            eventPlayer, 
            " ",
            "! competition is over !" if CompTime <= 0 else
            "time left: {0} min{1}".format(
                CompTime, 
                "\nYou are out of attemps" if eventPlayer.AttemptCount == -1 else
                "\nAttempt {0} / {1}".format(eventPlayer.AttemptCount, CompAtmpNum) if CompAtmpNum > 0 
                else "" 
            ),
            "competitive mode" if CompTime > 0 else "competitive mode\n\n\n", 
            HudPosition.TOP, HO.comp_info, Color.YELLOW, Color.YELLOW, Color.YELLOW, HudReeval.STRING, SpecVisibility.DEFAULT
        ) 

  
  
rule "Huds: remake leaderboard": # for global isntead of tied to player
    @Condition LeaderBoardRemake   
    wait() # account for delay in completion
    LeaderBoardFull = sorted(LeaderBoardFull, lambda i: i[1])
    
    while len(LeaderBoardHuds) > 0: 
        destroyHudText(LeaderBoardHuds[0])
        del LeaderBoardHuds[0]
    
    # top 5
    if LeaderBoardFull[0]:
        hudSubtext(getAllPlayers(),
            " \n{0} 排名前5 {0}".format(abilityIconString(Hero.GENJI,Button.PRIMARY_FIRE))
            CNany
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
        "　　　　 {0} Leaderboard {0} 　　　".format(iconString(Icon.FLAG)), HudPosition.TOP, HO.board_header, Color.BLUE, HudReeval.VISIBILITY, SpecVisibility.NEVER
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


def UpdateTitle():
    @Name "Tittle "
    if TitleData == null or CompMode or eventPlayer.PracticeToggle or eventPlayer.EditorOn or (not eventPlayer.CurrentCheckpoint in TitleData[0]): 
        return
    destroyInWorldText(eventPlayer.TitleStore)
    createInWorldText(getAllPlayers() if not eventPlayer.invis else null,TitleData[1][TitleData[0].index(eventPlayer.CurrentCheckpoint)], eventPlayer,1.1,Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, TitleData[2][TitleData[0].index(eventPlayer.CurrentCheckpoint)], SpecVisibility.DEFAULT)
    eventPlayer.TitleStore = getLastCreatedText()