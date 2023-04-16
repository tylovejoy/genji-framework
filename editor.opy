#!mainFile "genji.opy"

rule "------------------------------------------------------------------------  Editor ------------------------------------------------------------------------":
    @Delimiter
    @Disabled
    
rule "Editor | Clear Excess Data to Save Map":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer == hostPlayer
    wait(1, Wait.ABORT_WHEN_FALSE)
    #hostPlayer.CurrentCheckpoint = 0
    #UpdateCache()
    #wait()
    CheckpointRings_Editing = 0
    SelectedKillball_Editing = 0
    KillBallEffects = 0
    KillBallChase = 0
    ListPlayersAtCheckpoints = 0
    CurrentBounce_Editing = 0
    TempIterator1 = 0
    BounceEffects = 0
    CurrentBouncePosition_Editing = 0

    SaveName = []
    SaveCp = []
    SaveTimer = []
    SaveEnt = []
    SavePauseTime = []
    SavePauseEnabled = []
    SaveElapsed = []

    LeaderBoardFull = []
    LeaderBoardHuds = []
    LeaderBoardHuds = []
    PortalOn = false

    TitleData = null
    CpHudText = null
    CpHudCp = null
    CpIwtText = null
    CpIwtCp = null
    CpIwtPos = null
    CpIwtColor = null


    PortalNames = []
    PortalLoc = []
    PortalDest  = []
    CustomPortalStart  = []
    CustomPortalEndpoint  = []
    CustomPortalCP  = []

    BanTriple = []
    BanMulti = []
    BanCreate = []
    BanDead = []
    BanEmote = []
    BanClimb = []
    BanBhop = []


    PortalNames = []
    PortalLoc = []
    PortalDest  = []
    CustomPortalStart  = []
    CustomPortalEndpoint  = []
    CustomPortalCP  = []

    BanTriple = []
    BanMulti = []
    BanCreate = []
    BanDead = []
    BanEmote = []
    BanClimb = []
    BanBhop = []

    enableInspector()

    hudText(eventPlayer,  
        " ",
        null,
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        " 0. 清理多余数据:\n"
        "打开此窗口时自动完成\n\n"
      
        "1. 复制数据:\n"
        "打开工作坊检查→将可变目标设置为全局\n\n"
        "按[x]\n"
    
        "2. 插入数据:\n"
        "将数据粘贴到名为'map data'的规则中(第2页)\n\n"
      
        "3.车间设置:\n"
        "ESC→展示大厅→设置→工作坊设置→\n"
        "关闭'编辑模式'\n"
        "选择显示难度\n"
        checkCN
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        " 0. 清理多余数据:\n"
        "打开此窗口时自动完成\n\n"
      
        "1. 复制数据:\n"
        "打开工作坊检查→将可变目标设置为全局\n\n"
        "按[x]\n"
    
        "2. 插入数据:\n"
        "将数据粘贴到名为'map data'的规则中(第2页)\n\n"
      
        "3.车间设置:\n"
        "ESC→展示大厅→设置→工作坊设置→\n"
        "关闭'编辑模式'\n"
        "选择显示难度\n"
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
       HudPosition.TOP, HO.edit_clearec1, Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.STRING, SpecVisibility.DEFAULT
    )
    eventPlayer.savemaphud[0] = getLastCreatedText()

    hudText(eventPlayer,  
        " ",
        null,
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "4. 创建初始共享代码:\n"
        "Esc→显示大厅→设置→共享代码→\n"
        "创建新代码→复制代码\n\n"
  
        "5. 添加参与者:\n"
        "在'Credits here'规则中输入您的姓名和地图代码\n\n"
        "(第二页)\n"
     
        "6. 参与者更新:\n"
        "Esc→显示大厅→设置→共享代码→\n"
        "上传到现有代码→粘贴在步骤4中创建的代码\n"

        checkCN
        "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　\n"
        "4. 创建初始共享代码:\n"
        "Esc→显示大厅→设置→共享代码→\n"
        "创建新代码→复制代码\n\n"
  
        "5. 添加参与者:\n"
        "在'Credits here'规则中输入您的姓名和地图代码\n\n"
        "(第二页)\n"
     
        "6. 参与者更新:\n"
        "Esc→显示大厅→设置→共享代码→\n"
        "上传到现有代码→粘贴在步骤4中创建的代码\n"

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
        HudPosition.TOP, HO.edit_clearec2, Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN, HudReeval.STRING, SpecVisibility.DEFAULT
    )
    eventPlayer.savemaphud[1] = getLastCreatedText()

    hudHeader(eventPlayer, 
        "    > 按互动键关闭当前窗口 <    "
        checkCN
        "    > Press Interact to close this window <    "
        , HudPosition.TOP, HO.edit_clearec3, Color.LIME_GREEN, HudReeval.STRING
    )
    hudHeader(eventPlayer, 
        "    > 按互动键关闭当前窗口 <    "
        checkCN
        "    > Press Interact to close this window <    "
        , HudPosition.TOP, HO.edit_clearec3, Color.LIME_GREEN, HudReeval.STRING
    )
    eventPlayer.savemaphud[2] = getLastCreatedText()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 9999)
    waitUntil(eventPlayer.isHoldingButton(Button.INTERACT), 9999)
    destroyHudText(eventPlayer.savemaphud[0])
    destroyHudText(eventPlayer.savemaphud[1])
    destroyHudText(eventPlayer.savemaphud[2])
    
rule "Editor | Hud and Effects":
    #@Condition hostPlayer.EditorOn
    # condition messes up if host player leaves
    waitUntil(hostPlayer.hasSpawned(), 90)
    wait(1)
    if not hostPlayer.EditorOn:
        HudStoreEdit = null
        return
    wait(2)
    
    while len(HudStoreEdit) > 0: # remove unnesesary huds
        destroyHudText(HudStoreEdit[0])
        destroyInWorldText(HudStoreEdit[0])
        del HudStoreEdit[0]
    
    wait()
    if CompMode: # infinite time and atemps
        CompAtmpNum = 0 
        CompTime = 99999
        getAllPlayers().AttemptCount = null
        getAllPlayers().CompDone = false

    # huds ==========================================================================================================================================================================
    hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
        "{0}".format(   
        [
        "{0} + {1} | 新建检查点\n"
	    "{0} + {2} | 删除选中的检查点\n"
		"{0} + {3} | 移除/新建传送点\n" #移除/新建 传送门
		"{0} + {4} | 移动检查点至当前位置\n"
        "{0} + {5} | 检查点碰撞模型\n"
        "{4} (长按) | 微调检查点位置".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_1)),

        "{0} + {1} | 新建击杀球\n"
		"{0} + {2} | 删除选中的击杀球\n"
        "{0} + {3} | 选择上一个击杀球\n"
        "{0} + {4} | 选择下一个击杀球\n\n"
        "{5} + {4} | 增大击杀球尺寸\n"
        "{5} + {3} | 减小击杀球尺寸\n"
        "{5} + {1} | 向前移动击杀球\n"
        "{5} + {2} | 向后移动击杀球".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2)),
		
        "{0} + {1} | 新建弹球\n"
		"{0} + {3} | 选择上一个弹球\n"
		"{0} + {4} | 选择下一个弹球\n\n"
		"{0} + {2} | 删除选中的弹球\n"
		"{5} + {4} | 增加弹球弹力\n"
		"{5} + {3} | 减少弹球弹力\n"
		"{5} + {1} | 向前移动弹球\n"
        "{5} + {2} | 向后移动弹球".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2))
        ][hostPlayer.EditModeSelection]
        checkCN 
        "{0}".format(   
        [
        "{0} + {1} | 新建检查点\n"
	    "{0} + {2} | 删除选中的检查点\n"
		"{0} + {3} | 移除/新建传送点\n" #移除/新建 传送门
		"{0} + {4} | 移动检查点至当前位置\n"
        "{0} + {5} | 检查点碰撞模型\n"
        "{4} (长按) | 微调检查点位置".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_1)),

        "{0} + {1} | 新建击杀球\n"
		"{0} + {2} | 删除选中的击杀球\n"
        "{0} + {3} | 选择上一个击杀球\n"
        "{0} + {4} | 选择下一个击杀球\n\n"
        "{5} + {4} | 增大击杀球尺寸\n"
        "{5} + {3} | 减小击杀球尺寸\n"
        "{5} + {1} | 向前移动击杀球\n"
        "{5} + {2} | 向后移动击杀球".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2)),
		
        "{0} + {1} | 新建弹球\n"
		"{0} + {3} | 选择上一个弹球\n"
		"{0} + {4} | 选择下一个弹球\n\n"
		"{0} + {2} | 删除选中的弹球\n"
		"{5} + {4} | 增加弹球弹力\n"
		"{5} + {3} | 减少弹球弹力\n"
		"{5} + {1} | 向前移动弹球\n"
        "{5} + {2} | 向后移动弹球".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2))
        ][hostPlayer.EditModeSelection]
        checkCN 
        [   
        "{0} + {1} | Create New Checkpoint\n"
        "{0} + {2} | Delete selected Checkpoint\n"
        "{0} + {3} | Remove/Add teleport\n"
        "{0} + {3} | Remove/Add teleport\n"
        "{0} + {4} | Set Checkpoint to current position\n"
        "{0} + {5} | Toggle Checkpoint Hitbox\n"
        "{6} (hold) | Precise position changing".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_1), buttonString(Button.MELEE)),
        "{6} (hold) | Precise position changing".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE),  buttonString(Button.RELOAD), buttonString(Button.ULTIMATE), buttonString(Button.ABILITY_1), buttonString(Button.MELEE)),

        "{0} + {1} | Create new kill orb\n"
        "{0} + {2} | Delete selected orb\n"
        "{0} + {3} | Select previous orb\n"
        "{0} + {4} | Select next orb\n\n"
        "{5} + {4} | Increase orb size\n"
        "{5} + {3} | Decrease orb size\n"
        "{5} + {1} | Move orb forward\n"
        "{5} + {2} | Move orb Backward".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2)),
 
        "{0} + {1} | Create new Bounce orb\n"
        "{0} + {3} | Select previous orb\n"
        "{0} + {4} | Select next orb\n\n"
        "{0} + {4} | Select next orb\n\n"
        "{0} + {2} | Delete selected orb\n"
        "{5} + {4} | Increase orb strength\n"
        "{5} + {3} | Decrease orb strength\n"
        "{5} + {1} | Move orb forward\n"
        "{5} + {2} | Move orb back".format(buttonString(Button.INTERACT), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.CROUCH), buttonString(Button.JUMP), buttonString(Button.ABILITY_2))
        ][hostPlayer.EditModeSelection]), 
        HudPosition.RIGHT, HO.edit_instructions_edit, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
        (
        " \n{0} + {1} | 下一个检查点\n"
        "{0} + {2} | 上一个检查点\n"
        "{3} | 飞行 (仅限检查点模式)\n"
        "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_2))
        
        checkCN
        
    hudSubtext(hostPlayer if hostPlayer.GuideToggle else null, 
        (
        " \n{0} + {1} | 下一个检查点\n"
        "{0} + {2} | 上一个检查点\n"
        "{3} | 飞行 (仅限检查点模式)\n"
        "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_2))
        
        checkCN
        
        " \n{0} + {1} | Next checkpoint\n"
        "{0} + {2} | Prev checkpoint\n"
        "{3} | Fly (checkpoint mode only)\n"
        "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_2))
        )
        
        ,HudPosition.RIGHT, HO.edit_instructions_general, Color.GREEN if hostPlayer.GuideToggle else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        "{3} | Fly (checkpoint mode only)\n"
        "".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.ABILITY_2))
        )
        
        ,HudPosition.RIGHT, HO.edit_instructions_general, Color.GREEN if hostPlayer.GuideToggle else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )
    
    hudSubheader(hostPlayer if hostPlayer.GuideToggle else null, 
        "保存地图长按 {0} + {1} + {2} 后按弹出窗口的提示进行操作".format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD))
        checkCN
        "to save map hold {0} + {1} + {2} and follow instructions".format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD))
        ,HudPosition.LEFT, HO.edit_savemap, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
        "保存地图长按 {0} + {1} + {2} 后按弹出窗口的提示进行操作".format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD))
        checkCN
        "to save map hold {0} + {1} + {2} and follow instructions".format(buttonString(Button.INTERACT), buttonString(Button.MELEE), buttonString(Button.RELOAD))
        ,HudPosition.LEFT, HO.edit_savemap, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    
    hudText(getAllPlayers(),  #  LEFT at -6 original position
        (
        " {1} {0} ".format(
            ["检查点模式","击杀球模式","弹球模式"][hostPlayer.EditModeSelection],
            [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON)][hostPlayer.EditModeSelection]
         ) if localPlayer == hostPlayer else " {0} 源氏 编辑者 {0} \n 房主/编辑者: {1} ".format(iconString(Icon.BOLT),hostPlayer)
        )
       checkCN
        (
        " {1} {0} ".format(
            ["检查点模式","击杀球模式","弹球模式"][hostPlayer.EditModeSelection],
            [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON)][hostPlayer.EditModeSelection]
         ) if localPlayer == hostPlayer else " {0} 源氏 编辑者 {0} \n 房主/编辑者: {1} ".format(iconString(Icon.BOLT),hostPlayer)
        )
       checkCN
        " {1} {0} ".format(
            ["Checkpoints mode" ,"Kill Orb mode","Bounce Orb mode"][hostPlayer.EditModeSelection],
            [iconString(Icon.FLAG), iconString(Icon.SKULL), iconString(Icon.MOON)][hostPlayer.EditModeSelection]
        ) if localPlayer == hostPlayer else " {0} Genji editor {0} \n host/editor: {1} ".format(iconString(Icon.BOLT),hostPlayer)
       
       , null, null,   
        ) if localPlayer == hostPlayer else " {0} Genji editor {0} \n host/editor: {1} ".format(iconString(Icon.BOLT),hostPlayer)
       
       , null, null,   
       HudPosition.TOP, HO.edit_host_mode, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    hudText(hostPlayer if hostPlayer.GuideToggle else null, 
        null,  # original part of the one ontop of it
        "长按 {0} 切换作图模式".format(buttonString(Button.ABILITY_1))
        checkCN
        "Hold {0} to change mode".format(buttonString(Button.ABILITY_1))
        , null,   
        "长按 {0} 切换作图模式".format(buttonString(Button.ABILITY_1))
        checkCN
        "Hold {0} to change mode".format(buttonString(Button.ABILITY_1))
        , null,   
        HudPosition.TOP, HO.edit_changemode, Color.SKY_BLUE, Color.SKY_BLUE, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    hudSubtext(hostPlayer if hostPlayer.GuideToggle and (hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0) else null, #if hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and hostPlayer.GuideToggle and len(hostPlayer.BounceIndex_Cache) > 0 else null, 
        "{0} + {1} | {4} {3} | {2}".format(
                        

    hudSubtext(hostPlayer if hostPlayer.GuideToggle and (hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0) else null, #if hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and hostPlayer.GuideToggle and len(hostPlayer.BounceIndex_Cache) > 0 else null, 
        "{0} + {1} | {4} {3} | {2}".format(
                        
            buttonString(Button.ULTIMATE), 
            buttonString(Button.PRIMARY_FIRE), 
            ("启用" if BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "关闭") if  hostPlayer.EditModeSelection == 2 else
            ("启用" if hostPlayer.CurrentCheckpoint in BladeEnabledCheckpoints else "关闭"),
            abilityIconString(Hero.GENJI, Button.ULTIMATE),
            "检查点给刀"  if hostPlayer.EditModeSelection == 0 else "弹球给刀"
            #"检查点" if hostPlayer.EditModeSelection == 0 else "弹球",
        )        
        checkCN
        "{0} + {1} | {4} give ult {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.PRIMARY_FIRE), 
            ("on" if BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "off") if  hostPlayer.EditModeSelection == 2 else
            ("on" if hostPlayer.CurrentCheckpoint in BladeEnabledCheckpoints else "off"),
            abilityIconString(Hero.GENJI, Button.ULTIMATE),
            "Level" if hostPlayer.EditModeSelection == 0  else "Orb"
        )        
        , HudPosition.LEFT, HO.edit_orb_ult, 
        Color.GREEN if BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 and hostPlayer.EditModeSelection == 2 else
        Color.GREEN if hostPlayer.CurrentCheckpoint in BladeEnabledCheckpoints and hostPlayer.EditModeSelection == 0 else
        Color.ORANGE
        , HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    
    hudSubtext(hostPlayer if hostPlayer.GuideToggle and (hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0) else null, #if hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and hostPlayer.GuideToggle and len(hostPlayer.BounceIndex_Cache) > 0 else null, 
        "{0} + {1} | {4} {3} | {2}".format(
            ("启用" if BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "关闭") if  hostPlayer.EditModeSelection == 2 else
            ("启用" if hostPlayer.CurrentCheckpoint in BladeEnabledCheckpoints else "关闭"),
            abilityIconString(Hero.GENJI, Button.ULTIMATE),
            "检查点给刀"  if hostPlayer.EditModeSelection == 0 else "弹球给刀"
            #"检查点" if hostPlayer.EditModeSelection == 0 else "弹球",
        )        
        checkCN
        "{0} + {1} | {4} give ult {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.PRIMARY_FIRE), 
            ("on" if BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "off") if  hostPlayer.EditModeSelection == 2 else
            ("on" if hostPlayer.CurrentCheckpoint in BladeEnabledCheckpoints else "off"),
            abilityIconString(Hero.GENJI, Button.ULTIMATE),
            "Level" if hostPlayer.EditModeSelection == 0  else "Orb"
        )        
        , HudPosition.LEFT, HO.edit_orb_ult, 
        Color.GREEN if BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 and hostPlayer.EditModeSelection == 2 else
        Color.GREEN if hostPlayer.CurrentCheckpoint in BladeEnabledCheckpoints and hostPlayer.EditModeSelection == 0 else
        Color.ORANGE
        , HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    
    hudSubtext(hostPlayer if hostPlayer.GuideToggle and (hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0) else null, #if hostPlayer.EditModeSelection == 0 or hostPlayer.EditModeSelection == 2 and hostPlayer.GuideToggle and len(hostPlayer.BounceIndex_Cache) > 0 else null, 
        "{0} + {1} | {4} {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.SECONDARY_FIRE), 
            ("启用" if BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "关闭") if  hostPlayer.EditModeSelection == 2 else
            ("启用" if hostPlayer.CurrentCheckpoint in DashEnabledCheckpoints else "关闭"),
            abilityIconString(Hero.GENJI, Button.ABILITY_1),
           # "检查点" if hostPlayer.EditModeSelection == 0 else "弹球"
           "检查点给Shift" if hostPlayer.EditModeSelection == 0 else "弹球给Shift"
        )   
        checkCN
        "{0} + {1} | {4} give dash {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.SECONDARY_FIRE), 
            ("on" if BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "off") if  hostPlayer.EditModeSelection == 2 else
            ("on" if hostPlayer.CurrentCheckpoint in DashEnabledCheckpoints else "off"),
            abilityIconString(Hero.GENJI, Button.ABILITY_1),
            "Level" if hostPlayer.EditModeSelection == 0
            else "Orb"
        )        
        , HudPosition.LEFT, HO.edit_orb_dash, 
        Color.GREEN if BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 and hostPlayer.EditModeSelection == 2 else
        Color.GREEN if hostPlayer.CurrentCheckpoint in DashEnabledCheckpoints and hostPlayer.EditModeSelection == 0 else
        Color.ORANGE
        , HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
            buttonString(Button.SECONDARY_FIRE), 
            ("启用" if BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "关闭") if  hostPlayer.EditModeSelection == 2 else
            ("启用" if hostPlayer.CurrentCheckpoint in DashEnabledCheckpoints else "关闭"),
            abilityIconString(Hero.GENJI, Button.ABILITY_1),
           # "检查点" if hostPlayer.EditModeSelection == 0 else "弹球"
           "检查点给Shift" if hostPlayer.EditModeSelection == 0 else "弹球给Shift"
        )   
        checkCN
        "{0} + {1} | {4} give dash {3} | {2}".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.SECONDARY_FIRE), 
            ("on" if BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "off") if  hostPlayer.EditModeSelection == 2 else
            ("on" if hostPlayer.CurrentCheckpoint in DashEnabledCheckpoints else "off"),
            abilityIconString(Hero.GENJI, Button.ABILITY_1),
            "Level" if hostPlayer.EditModeSelection == 0
            else "Orb"
        )        
        , HudPosition.LEFT, HO.edit_orb_dash, 
        Color.GREEN if BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 and hostPlayer.EditModeSelection == 2 else
        Color.GREEN if hostPlayer.CurrentCheckpoint in DashEnabledCheckpoints and hostPlayer.EditModeSelection == 0 else
        Color.ORANGE
        , HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )


    hudSubtext(hostPlayer if hostPlayer.EditModeSelection == 2 and hostPlayer.GuideToggle and len(hostPlayer.BounceIndex_Cache) > 0 else null,
        "{0} + {1} |  黄弹球(进点前必须收集) {3} | {2}\n".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.ABILITY_2),
            "启用" if BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "关闭",
            iconString(Icon.ASTERISK)
        )
        checkCN
        "{0} + {1} |  黄弹球(进点前必须收集) {3} | {2}\n".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.ABILITY_2),
            "启用" if BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "关闭",
            iconString(Icon.ASTERISK)
        )
        checkCN
        "{0} + {1} | unlocks checkpoint {3} | {2}\n".format(
            buttonString(Button.ULTIMATE), 
            buttonString(Button.ABILITY_2),
            "on" if BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else "off",
            iconString(Icon.ASTERISK)
        )
        , HudPosition.LEFT, HO.edit_orb_lock, Color.GREEN if BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
        )
        , HudPosition.LEFT, HO.edit_orb_lock, Color.GREEN if BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] != 0 else Color.ORANGE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT
    )

    hudText(hostPlayer if hostPlayer.GuideToggle else null,
        "球体/传送门上限: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxlimit)
        checkCN
        "orb/portal limit: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxlimit),
        null, null, HudPosition.LEFT, HO.edit_orblimit, Color.BLUE, Color.SKY_BLUE,Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    hudText(hostPlayer if hostPlayer.GuideToggle else null,
        "球体/传送门上限: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxlimit)
        checkCN
        "orb/portal limit: {0}/{1} ".format(len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart), fxlimit),
        null, null, HudPosition.LEFT, HO.edit_orblimit, Color.BLUE, Color.SKY_BLUE,Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
    
    # display selected cc/orb info
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
                KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]],
                KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]      
            ) 
            if hostPlayer.EditModeSelection == 1 and len(hostPlayer.KillIndex_Cache) > 0 else             
            "\n 选中的弹球 \n 矢量: {1} \n 弹力: {0} \n".format(
                BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]],
                BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
            )
            if hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0  else   
            "\n   当前无数据选中   \n"
        )         
        checkCN
        (
        (
            "\n 选中的检查点 \n 矢量: {0}{1} \n".format(
                CheckpointPositions[hostPlayer.CurrentCheckpoint],
                "" if len(CheckpointPositions[hostPlayer.CurrentCheckpoint]) < 2 else
                "\n 传送点: {0}".format(CheckpointPositions[hostPlayer.CurrentCheckpoint][1])
            ) 
            if hostPlayer.EditModeSelection == 0 and len(CheckpointPositions) > 0 else  
            "\n 选中的击杀球 \n 矢量: {1} \n 半径: {0} \n".format(
                KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]],
                KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]      
            ) 
            if hostPlayer.EditModeSelection == 1 and len(hostPlayer.KillIndex_Cache) > 0 else             
            "\n 选中的弹球 \n 矢量: {1} \n 弹力: {0} \n".format(
                BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]],
                BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
            )
            if hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0  else   
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
                KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]],
                KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]      
            ) 
            if hostPlayer.EditModeSelection == 1 and len(hostPlayer.KillIndex_Cache) > 0 else             
            "\n Selected Bounce Orb \n Vector: {1} \n strength: {0} \n".format(
                BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]],
                BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
            )
            if hostPlayer.EditModeSelection == 2 and len(hostPlayer.BounceIndex_Cache) > 0  else   
            "\n   No data selected   \n"
        )
        , null, null, HudPosition.LEFT, HO.edit_selecteddata, Color.WHITE, Color.ORANGE,Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
            "\n   No data selected   \n"
        )
        , null, null, HudPosition.LEFT, HO.edit_selecteddata, Color.WHITE, Color.ORANGE,Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )

    wait(2)
    # effects ==========================================================================================================================================================================

    # Purple bounce selection aura
    createEffect(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.BouncePosition_Cache and hostPlayer.EditModeSelection == 2  else null, 
        Effect.GOOD_AURA, Color.PURPLE, CurrentBouncePosition_Editing, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS
    )    
    

    # Purple bounce selection aura
    createEffect(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.BouncePosition_Cache and hostPlayer.EditModeSelection == 2  else null, 
        Effect.GOOD_AURA, Color.PURPLE, CurrentBouncePosition_Editing, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS
    )    
    

    # Selected kill orb text
    createInWorldText(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.KillPosition_Cache and hostPlayer.EditModeSelection == 1 else null, 
        "已选中该弹球" checkCN "Selected Kill Orb"
        , KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]], 
        1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT
    )
    createInWorldText(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.KillPosition_Cache and hostPlayer.EditModeSelection == 1 else null, 
        "已选中该弹球" checkCN "Selected Kill Orb"
        , KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]], 
        1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT
    )
    # Red distance orb for kill orb
    createEffect(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.KillPosition_Cache and hostPlayer.EditModeSelection == 1 else null,
        Effect.ORB, Color.RED, KillBallChase, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS
    )
    createEffect(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.KillPosition_Cache and hostPlayer.EditModeSelection == 1 else null,
        Effect.ORB, Color.RED, KillBallChase, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS
    )
    # Distance # text for kill orb (removed the L from M string)
    createInWorldText(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.KillPosition_Cache and hostPlayer.EditModeSelection == 1 else null,
        "{0} m".format(distance(hostPlayer, KillBallChase)), KillBallChase - vect(0, 1.5, 0), 
        1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT
    )
    createInWorldText(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.KillPosition_Cache and hostPlayer.EditModeSelection == 1 else null,
        "{0} m".format(distance(hostPlayer, KillBallChase)), KillBallChase - vect(0, 1.5, 0), 
        1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.DEFAULT
    )
    # Selected kill orb arrow icon
    #createIcon(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.KillPosition_Cache and hostPlayer.EditModeSelection == 1 else null, KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
    
    
    #createIcon(getAllPlayers() if hostPlayer.CurrentCheckpoint != -1 and hostPlayer.KillPosition_Cache and hostPlayer.EditModeSelection == 1 else null, KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.RED, true)
    
    
    # Purple sphere for teleport location
    createEffect(getAllPlayers() if len(CheckpointPositions[hostPlayer.CurrentCheckpoint] ) > 1 and hostPlayer.EditModeSelection == 0 else null, Effect.SPHERE, Color.PURPLE, CheckpointPositions[hostPlayer.CurrentCheckpoint][1]-vect(0,0.1,0), 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers() if len(CheckpointPositions[hostPlayer.CurrentCheckpoint] ) > 1 and hostPlayer.EditModeSelection == 0 else null, Effect.SPHERE, Color.PURPLE, CheckpointPositions[hostPlayer.CurrentCheckpoint][1]-vect(0,0.1,0), 0.2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    # Teleport arrow icon
    #createIcon(getAllPlayers() if len(CheckpointPositions[hostPlayer.CurrentCheckpoint] ) > 1 else null, CheckpointPositions[hostPlayer.CurrentCheckpoint][1] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.PURPLE, true)
    #createIcon(getAllPlayers() if len(CheckpointPositions[hostPlayer.CurrentCheckpoint] ) > 1 else null, CheckpointPositions[hostPlayer.CurrentCheckpoint][1] + vect(0, 0.6, 0), Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.PURPLE, true)
    # Teleport text
    createInWorldText(getAllPlayers() if len(CheckpointPositions[hostPlayer.CurrentCheckpoint] ) > 1 and hostPlayer.EditModeSelection == 0 else null, "传送点位置" checkCN "teleporter location", CheckpointPositions[hostPlayer.CurrentCheckpoint][1], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
        
    # normal cp if teleport
    createEffect(hostPlayer if CheckpointPositions[hostPlayer.CurrentCheckpoint][1] and hostPlayer.EditModeSelection == 0 else null, Effect.RING, Color.ORANGE, CheckpointPositions[hostPlayer.CurrentCheckpoint][0], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(hostPlayer if CheckpointPositions[hostPlayer.CurrentCheckpoint][1] and hostPlayer.EditModeSelection == 0 else null, "检查点点的位置" checkCN "level location", CheckpointPositions[hostPlayer.CurrentCheckpoint][0], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    
    createInWorldText(getAllPlayers() if len(CheckpointPositions[hostPlayer.CurrentCheckpoint] ) > 1 and hostPlayer.EditModeSelection == 0 else null, "传送点位置" checkCN "teleporter location", CheckpointPositions[hostPlayer.CurrentCheckpoint][1], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
        
    # normal cp if teleport
    createEffect(hostPlayer if CheckpointPositions[hostPlayer.CurrentCheckpoint][1] and hostPlayer.EditModeSelection == 0 else null, Effect.RING, Color.ORANGE, CheckpointPositions[hostPlayer.CurrentCheckpoint][0], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(hostPlayer if CheckpointPositions[hostPlayer.CurrentCheckpoint][1] and hostPlayer.EditModeSelection == 0 else null, "检查点点的位置" checkCN "level location", CheckpointPositions[hostPlayer.CurrentCheckpoint][0], 1.6, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    
# global functions ==============================================================
rule "Editor |  Fly/Noclip Toggle":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.EditModeSelection == 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    @Condition eventPlayer.flytoggle == null
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2) or (eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT)), 1)
    if eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.INTERACT):
        wait()
        return

    eventPlayer.flytoggle = eventPlayer.getPosition() + Vector.UP
    eventPlayer.startForcingPosition(eventPlayer.flytoggle, true)
    eventPlayer.disableEnvironmentCollision(true)
    while eventPlayer.isAlive() and eventPlayer.flytoggle != null and not eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.flytoggle += eventPlayer.getFacingDirection() * (
            0.25 + eventPlayer.isHoldingButton(Button.JUMP) if eventPlayer.getThrottle().z > 0 else 
            -0.25 - eventPlayer.isHoldingButton(Button.JUMP) if eventPlayer.getThrottle().z < 0 else 
            0
            )
        eventPlayer.flytoggle += worldVector(vect(eventPlayer.getThrottle().x*0.3,0,0), eventPlayer, Transform.ROTATION) 
        wait()
    
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.flytoggle = null
    eventPlayer.stopForcingPosition()
    wait(1)

rule "Editor | change mode":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    wait(0.84, Wait.ABORT_WHEN_FALSE)
    eventPlayer.flytoggle = null   
    smallMessage(hostPlayer, #c
        #["   击杀球模式","   弹球模式","   检查点模式"][eventPlayer.EditModeSelection]
        [ "   当前模式: 击杀球",  "   当前模式: 弹球", "   当前模式: 检查点"][eventPlayer.EditModeSelection]
        checkCN
        ["   Current mode: Kill Orb","   Current mode: Bounce Orb","   Current mode: Checkpoint"][eventPlayer.EditModeSelection]
    )

 

    smallMessage(hostPlayer, #c
        #["   击杀球模式","   弹球模式","   检查点模式"][eventPlayer.EditModeSelection]
        [ "   当前模式: 击杀球",  "   当前模式: 弹球", "   当前模式: 检查点"][eventPlayer.EditModeSelection]
        checkCN
        ["   Current mode: Kill Orb","   Current mode: Bounce Orb","   Current mode: Checkpoint"][eventPlayer.EditModeSelection]
    )

 

    wait()
    eventPlayer.EditModeSelection = (eventPlayer.EditModeSelection  + 1) % 3

rule "Editor | create cp/orb":
    @Event eachPlayer
    @Condition eventPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    
    if eventPlayer.EditModeSelection == 0:
        if len(CheckpointPositions) > 1 and distance(eventPlayer, CheckpointPositions[hostPlayer.CurrentCheckpoint]) <= cpcircleradius:
            smallMessage(eventPlayer, "   放置的检查点距离太近" checkCN "   Cannot place checkpoints too close.")
        if len(CheckpointPositions) > 1 and distance(eventPlayer, CheckpointPositions[hostPlayer.CurrentCheckpoint]) <= cpcircleradius:
            smallMessage(eventPlayer, "   放置的检查点距离太近" checkCN "   Cannot place checkpoints too close.")
            return
        if eventPlayer.CurrentCheckpoint > len(CheckpointPositions) - 1:
            eventPlayer.CurrentCheckpoint = len(CheckpointPositions) - 1

        if hostPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1:
            CheckpointPositions.append(eventPlayer.getPosition() )
            CheckpointPositions.append(eventPlayer.getPosition() )
            eventPlayer.CurrentCheckpoint ++
            UpdateCache()
        else:
            insert(CheckpointPositions, hostPlayer.CurrentCheckpoint + 1, eventPlayer.getPosition())
            hostPlayer.CurrentCheckpoint ++           
            KillballCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in KillballCheckpoints]
            BouncePadCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BouncePadCheckpoints]

            BladeEnabledCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BladeEnabledCheckpoints]
            DashEnabledCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in DashEnabledCheckpoints]


            BladeEnabledCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BladeEnabledCheckpoints]
            DashEnabledCheckpoints = [x + (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in DashEnabledCheckpoints]

            UpdateCache()
            RebuildKillOrbs()
            RebuildBounceOrbs()
        smallMessage(getAllPlayers(), "   新检查点已创建" checkCN "   New Checkpoint has been created")
        smallMessage(getAllPlayers(), "   新检查点已创建" checkCN "   New Checkpoint has been created")
        #UpdateCache()

    elif eventPlayer.EditModeSelection == 1:
        if len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart) >= fxlimit:
            bigMessage(eventPlayer, "当前地图弹球/传送门数量已达上限" checkCN "Orb/portal limit reached for this map")
            bigMessage(eventPlayer, "当前地图弹球/传送门数量已达上限" checkCN "Orb/portal limit reached for this map")
            wait()
            return
        KillBallPositions.append(eventPlayer.getPosition())
        KillballCheckpoints.append(eventPlayer.CurrentCheckpoint)
        UpdateCache()
        SelectedKillball_Editing = len(hostPlayer.KillIndex_Cache) - 1
        KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]] = 5
        createEffect([x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == KillballCheckpoints[evalOnce(hostPlayer.KillIndex_Cache[SelectedKillball_Editing])]], Effect.SPHERE, Color.BLUE, KillBallPositions[evalOnce(hostPlayer.KillIndex_Cache[SelectedKillball_Editing])], KillBallRadii[evalOnce(hostPlayer.KillIndex_Cache[SelectedKillball_Editing])], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        KillBallEffects.append(getLastCreatedEntity())
        UpdateCache()
        SelectedKillball_Editing = len(hostPlayer.KillIndex_Cache) - 1
        KillBallChase = KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        RebuildKillOrbs()
    
        bigMessage(getAllPlayers(), "{1} {0}".format(eventPlayer.CurrentCheckpoint, "新击杀球已创建! \r\n仅生效于检查点" checkCN "New Kill Orb has been created! \r\nIt's only valid for checkpoint"))

       
        bigMessage(getAllPlayers(), "{1} {0}".format(eventPlayer.CurrentCheckpoint, "新击杀球已创建! \r\n仅生效于检查点" checkCN "New Kill Orb has been created! \r\nIt's only valid for checkpoint"))

       
    elif eventPlayer.EditModeSelection == 2:
        if len(BouncePositions) + len(KillBallPositions) + len(CustomPortalStart) >= fxlimit:
            bigMessage(eventPlayer, "当前地图弹球/传送门数量已达上限" checkCN "Orb/portal limit reached for this map")
            bigMessage(eventPlayer, "当前地图弹球/传送门数量已达上限" checkCN "Orb/portal limit reached for this map")
            wait()
            return
        BouncePositions.append(eventPlayer.getPosition())
        BouncePadCheckpoints.append(eventPlayer.CurrentCheckpoint)
        UpdateCache()
        CurrentBounce_Editing = len(hostPlayer.BounceIndex_Cache) - 1
        BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = 10
        BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = false
        BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = false
        BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = false
        createEffect(
            #[x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)]], 
            [x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(hostPlayer.BounceIndex_Cache[CurrentBounce_Editing])] and not evalOnce(BouncePositions[evalOnce(hostPlayer.BounceIndex_Cache[CurrentBounce_Editing])]) in x.LockCollected], 
            Effect.ORB, 
            Color.ORANGE if BounceToggleLock[evalOnce(hostPlayer.BounceIndex_Cache[CurrentBounce_Editing])] else Color.GREEN, 
            BouncePositions[evalOnce(hostPlayer.BounceIndex_Cache[CurrentBounce_Editing])], 
            1, 
            EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
        BounceEffects.append(getLastCreatedEntity())
        UpdateCache()
        CurrentBounce_Editing = len(hostPlayer.BounceIndex_Cache) - 1
        CurrentBouncePosition_Editing = BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        RebuildBounceOrbs()
        bigMessage(getAllPlayers(), "{1} {0}".format(eventPlayer.CurrentCheckpoint, "新弹球已创建! \r\n仅生效于检查点" checkCN "New Bounce Orb has been created! \r\nIt's only valid for checkpoint"))
        bigMessage(getAllPlayers(), "{1} {0}".format(eventPlayer.CurrentCheckpoint, "新弹球已创建! \r\n仅生效于检查点" checkCN "New Bounce Orb has been created! \r\nIt's only valid for checkpoint"))
    
    wait(0.64)

rule "Editor | delete cp/orb":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) 
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.EditModeSelection == 0 and len(CheckpointPositions) > 0:
    if eventPlayer.EditModeSelection == 0 and len(CheckpointPositions) > 0:
        # Resync Kill Orbs
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
        SelectedKillball_Editing = len(hostPlayer.KillIndex_Cache) - 1
        KillBallChase = KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        eventPlayer.Temp = []
        # Resync Bounce Orbs
        eventPlayer.Temp = [e for e in [(i if e2 == hostPlayer.CurrentCheckpoint else -1) for e2, i in BouncePadCheckpoints] if  e >= 0]
        # eventPlayer.Temp = [i for e, i in BouncePadCheckpoints if e == hostPlayer.CurrentCheckpoint]
        for TempIterator1 in range(len(eventPlayer.Temp)):
            destroyEffect(BounceEffects[eventPlayer.Temp[TempIterator1]])
            del BounceEffects[eventPlayer.Temp[TempIterator1]]
            wait()

        # Remove specified checkpoint
        BouncePadCheckpoints = [x for x in BouncePadCheckpoints if x != hostPlayer.CurrentCheckpoint]
        # Decrement checkpoints after removed one
        BouncePadCheckpoints = [x - (1 if x > hostPlayer.CurrentCheckpoint else 0) for x in BouncePadCheckpoints]
        
        BouncePositions = [x for x, i in BouncePositions if i not in eventPlayer.Temp]
        BounceStrength = [x for x, i in BounceStrength if i not in eventPlayer.Temp]
        BounceToggleUlt = [x for x, i in BounceToggleUlt if i not in eventPlayer.Temp]
        BounceToggleDash = [x for x, i in BounceToggleDash if i not in eventPlayer.Temp]
        BounceToggleLock = [x for x, i in BounceToggleLock if i not in eventPlayer.Temp]
        CurrentBounce_Editing = len(hostPlayer.BounceIndex_Cache) - 1
        CurrentBouncePosition_Editing = BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]

        BladeEnabledCheckpoints = [i for i in BladeEnabledCheckpoints if i != hostPlayer.CurrentCheckpoint ]
        DashEnabledCheckpoints = [i for i in DashEnabledCheckpoints if i != hostPlayer.CurrentCheckpoint ]

        BladeEnabledCheckpoints = [x - (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BladeEnabledCheckpoints]
        DashEnabledCheckpoints = [x - (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in DashEnabledCheckpoints]
        BladeEnabledCheckpoints = [i for i in BladeEnabledCheckpoints if i != hostPlayer.CurrentCheckpoint ]
        DashEnabledCheckpoints = [i for i in DashEnabledCheckpoints if i != hostPlayer.CurrentCheckpoint ]

        BladeEnabledCheckpoints = [x - (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in BladeEnabledCheckpoints]
        DashEnabledCheckpoints = [x - (1 if x >= hostPlayer.CurrentCheckpoint else 0) for x in DashEnabledCheckpoints]

        del CheckpointPositions[hostPlayer.CurrentCheckpoint]
        del CheckpointRings_Editing[hostPlayer.CurrentCheckpoint]
        
        if hostPlayer.CurrentCheckpoint == 0 and len(CheckpointPositions) > 0:
            hostPlayer.CurrentCheckpoint = 0
            goto lbl_a
        elif hostPlayer.CurrentCheckpoint <= 0:
        
        if hostPlayer.CurrentCheckpoint == 0 and len(CheckpointPositions) > 0:
            hostPlayer.CurrentCheckpoint = 0
            goto lbl_a
        elif hostPlayer.CurrentCheckpoint <= 0:
            hostPlayer.CurrentCheckpoint = -1
            goto lbl_a
        hostPlayer.CurrentCheckpoint -= 1
        lbl_a:
        RebuildKillOrbs()
        RebuildBounceOrbs()
        smallMessage(getAllPlayers(), "   检查点已删除" checkCN "   Checkpoint has been deleted")
        smallMessage(getAllPlayers(), "   检查点已删除" checkCN "   Checkpoint has been deleted")
    
    elif eventPlayer.EditModeSelection == 1 and len(eventPlayer.KillIndex_Cache) != 0 and hostPlayer.KillPosition_Cache:
        del KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        del KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        del KillballCheckpoints[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        destroyEffect(KillBallEffects[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]])
        del KillBallEffects[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
        if SelectedKillball_Editing <= 0:
            goto lbl_b
        SelectedKillball_Editing -= 1
        lbl_b:
        UpdateCache()
        RebuildKillOrbs()
        KillBallChase = KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
    elif eventPlayer.EditModeSelection == 2 and len(eventPlayer.BounceIndex_Cache) != 0 and hostPlayer.BouncePosition_Cache:
        del BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        destroyEffect(BounceEffects[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]])
        del BounceEffects[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        del BouncePadCheckpoints[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
        if CurrentBounce_Editing <= 0:
            goto lbl_c
        CurrentBounce_Editing -= 1
        lbl_c:
        UpdateCache()
        RebuildBounceOrbs()
        CurrentBouncePosition_Editing = BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
    UpdateCache()
    wait()

# orb functions ==============================================================

rule "Editor | toggle orb functions":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 2
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition len(BouncePositions) != 0
    
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = not BounceToggleUlt[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
    elif eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = not BounceToggleDash[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] 
    else: 
        BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = not BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] 
        BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = 0 if BounceToggleLock[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] else 10
    UpdateCache()
    wait()

rule "Editor | orb radi/strength":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer 
    @Condition eventPlayer.EditModeSelection > 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH) 
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == false
    if eventPlayer.EditModeSelection == 2 and len(eventPlayer.BounceIndex_Cache) > 0:
        BounceStrength[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] += 0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1    
    elif eventPlayer.EditModeSelection == 1 and len(eventPlayer.KillIndex_Cache) > 0:
        KillBallRadii[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]] +=  0.1 if eventPlayer.isHoldingButton(Button.JUMP) else -0.1
    wait(0.1)
    if RULE_CONDITION:
        goto RULE_START
    UpdateCache()

rule "Editor | move orbs":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection > 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) 
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) 
    
    if eventPlayer.EditModeSelection == 1 and len(eventPlayer.KillIndex_Cache) > 0:
        while eventPlayer.isHoldingButton(Button.ABILITY_2) and (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            KillBallChase += eventPlayer.getFacingDirection() * (0.0625 if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) else -0.0625)
            wait()
        KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]] = KillBallChase

    elif eventPlayer.EditModeSelection == 2 and len(eventPlayer.BounceIndex_Cache) > 0:
        while eventPlayer.isHoldingButton(Button.ABILITY_2) and (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)):
            CurrentBouncePosition_Editing += eventPlayer.getFacingDirection() * (0.0625 if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) else -0.0625)
            wait()  
        BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]] = CurrentBouncePosition_Editing

    UpdateCache()
    wait()

rule "Editor | select orb":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection > 0
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.JUMP)
    if eventPlayer.EditModeSelection == 1:
        if eventPlayer.isHoldingButton(Button.CROUCH):
            SelectedKillball_Editing = (SelectedKillball_Editing - 1) % len(eventPlayer.KillIndex_Cache)
            SelectedKillball_Editing = SelectedKillball_Editing if SelectedKillball_Editing >= 0 else len(eventPlayer.KillIndex_Cache) - 1
        else:
            SelectedKillball_Editing = (SelectedKillball_Editing + 1) % len(eventPlayer.KillIndex_Cache)
        KillBallChase = KillBallPositions[hostPlayer.KillIndex_Cache[SelectedKillball_Editing]]
    
    elif eventPlayer.EditModeSelection == 2:
        if eventPlayer.isHoldingButton(Button.CROUCH):
            CurrentBounce_Editing = (CurrentBounce_Editing - 1) % len(eventPlayer.BounceIndex_Cache)
            CurrentBounce_Editing = CurrentBounce_Editing if CurrentBounce_Editing >= 0 else len(eventPlayer.BounceIndex_Cache) - 1
        else:
            CurrentBounce_Editing = (CurrentBounce_Editing + 1) % len(eventPlayer.BounceIndex_Cache)
        
        CurrentBouncePosition_Editing = BouncePositions[hostPlayer.BounceIndex_Cache[CurrentBounce_Editing]]
    wait()

# checkpoint functions ==============================================================

rule "Editor | cp size hitbox display":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    
    eventPlayer.EffectSizeToggle = not eventPlayer.EffectSizeToggle
    wait()

rule "Editor | cp add/remove teleport":
rule "Editor | cp add/remove teleport":
    @Condition hostPlayer.EditorOn
    @Condition hostPlayer.isHoldingButton(Button.INTERACT)
    @Condition hostPlayer.isHoldingButton(Button.RELOAD)
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == false
    @Condition len(CheckpointPositions) > 1
    @Condition hostPlayer.EditModeSelection == 0

    waitUntil(hostPlayer.isHoldingButton(Button.MELEE) or not (hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD)), 1)
    if hostPlayer.isHoldingButton(Button.MELEE) or hostPlayer.isHoldingButton(Button.INTERACT) and hostPlayer.isHoldingButton(Button.RELOAD):
      return

    if hostPlayer.CurrentCheckpoint == 0:
        smallMessage(hostPlayer,"   不能在第一个检查点设置传送门" checkCN "   Can't place a teleport on first checkpoint")
        return

    if len(CheckpointPositions[hostPlayer.CurrentCheckpoint]) > 1: # remove
        CheckpointPositions[hostPlayer.CurrentCheckpoint] = CheckpointPositions[hostPlayer.CurrentCheckpoint][0]
        smallMessage(hostPlayer,"   等级{0}的传送被移除".format(hostPlayer.CurrentCheckpoint) checkCN "   Teleport for level {0} has been removed".format(hostPlayer.CurrentCheckpoint))
    else: # add
        CheckpointPositions[hostPlayer.CurrentCheckpoint] = [
            CheckpointPositions[hostPlayer.CurrentCheckpoint][0] if len(CheckpointPositions[hostPlayer.CurrentCheckpoint]) != 0 else CheckpointPositions[hostPlayer.CurrentCheckpoint], 
            hostPlayer.getPosition()
        ]
        smallMessage(hostPlayer, "{1} {0}".format(hostPlayer.CurrentCheckpoint,"   传送点已添加到检查点" checkCN "   Teleport has been added for level"))
    wait()

rule "Editor | move cp once":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer    
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    
    if CheckpointPositions[hostPlayer.CurrentCheckpoint][1]:
        CheckpointPositions[hostPlayer.CurrentCheckpoint] = [eventPlayer.getPosition(), CheckpointPositions[hostPlayer.CurrentCheckpoint][1] ]
    else:
        CheckpointPositions[hostPlayer.CurrentCheckpoint] = eventPlayer.getPosition() 
    smallMessage(hostPlayer,"   检查点已移动至当前位置" checkCN "   Checkpoint has been moved to your position")
    
    if CheckpointPositions[hostPlayer.CurrentCheckpoint][1]:
        CheckpointPositions[hostPlayer.CurrentCheckpoint] = [eventPlayer.getPosition(), CheckpointPositions[hostPlayer.CurrentCheckpoint][1] ]
    else:
        CheckpointPositions[hostPlayer.CurrentCheckpoint] = eventPlayer.getPosition() 
    smallMessage(hostPlayer,"   检查点已移动至当前位置" checkCN "   Checkpoint has been moved to your position")
    
    wait()

rule "Editor | precision moving":
rule "Editor | precision moving":
    @Event eachPlayer
    @Condition eventPlayer.EditorOn
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.EditModeSelection == 0
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition len(CheckpointPositions) > 0
    @Condition not eventPlayer.isHoldingButton(Button.INTERACT)
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setMoveSpeed(3)
    eventPlayer.startCamera( eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * -2.5) + vect(0,0.5,0), eventPlayer.getEyePosition(), 15)
    
    #while eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.EditModeSelection == 0 and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false:
    #while eventPlayer.isHoldingButton(Button.ULTIMATE) and eventPlayer.EditModeSelection == 0 and eventPlayer.isAlive():
    while eventPlayer.isHoldingButton(Button.MELEE) and eventPlayer.EditModeSelection == 0 and eventPlayer.isAlive() and not eventPlayer.isHoldingButton(Button.INTERACT):
        #CheckpointPositions[eventPlayer.CurrentCheckpoint][0] = eventPlayer.getPosition()
        if len(CheckpointPositions[hostPlayer.CurrentCheckpoint])  :
            CheckpointPositions[hostPlayer.CurrentCheckpoint] = [eventPlayer.getPosition(), CheckpointPositions[hostPlayer.CurrentCheckpoint][1] ]
        else:
            CheckpointPositions[hostPlayer.CurrentCheckpoint] = eventPlayer.getPosition() 
        wait()
    eventPlayer.stopCamera()
    eventPlayer.setMoveSpeed(100)

rule "add ult/dash":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer    
    @Condition hostPlayer.EditModeSelection == 0
    @Condition len(CheckpointPositions) > 0
    # @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) or eventPlayer.isHoldingButton(Button.ABILITY_1)
    #@Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)


    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        if eventPlayer.CurrentCheckpoint in BladeEnabledCheckpoints:
            BladeEnabledCheckpoints = [i for i in BladeEnabledCheckpoints if i != eventPlayer.CurrentCheckpoint]
        else:
            BladeEnabledCheckpoints.append(eventPlayer.CurrentCheckpoint)

    else:
        if eventPlayer.CurrentCheckpoint in DashEnabledCheckpoints:
            DashEnabledCheckpoints = [i for i in DashEnabledCheckpoints if i != eventPlayer.CurrentCheckpoint]
        else:
            DashEnabledCheckpoints.append(eventPlayer.CurrentCheckpoint)


    # move in other rule
    wait()

     #BladeEnabledCheckpoints 
    #DashEnabledCheckpoints 


rule "add ult/dash":
    @Event eachPlayer
    @Condition hostPlayer.EditorOn
    @Condition eventPlayer == hostPlayer    
    @Condition hostPlayer.EditModeSelection == 0
    @Condition len(CheckpointPositions) > 0
    # @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) or eventPlayer.isHoldingButton(Button.ABILITY_1)
    #@Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)


    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        if eventPlayer.CurrentCheckpoint in BladeEnabledCheckpoints:
            BladeEnabledCheckpoints = [i for i in BladeEnabledCheckpoints if i != eventPlayer.CurrentCheckpoint]
        else:
            BladeEnabledCheckpoints.append(eventPlayer.CurrentCheckpoint)

    else:
        if eventPlayer.CurrentCheckpoint in DashEnabledCheckpoints:
            DashEnabledCheckpoints = [i for i in DashEnabledCheckpoints if i != eventPlayer.CurrentCheckpoint]
        else:
            DashEnabledCheckpoints.append(eventPlayer.CurrentCheckpoint)


    # move in other rule
    wait()

     #BladeEnabledCheckpoints 
    #DashEnabledCheckpoints 

