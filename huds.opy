/*
huds outside this file:
- addons you need otk now where to find:
    - custom diffiuclty
    - display world record
    - leaderboard

- title

*/


rule "Huds: Global/Localplayer":
    # names/creits here
    wait(2)
 
    hudSubtext(getAllPlayers(), "Discord: dsc.gg/genjiparkour", HudPosition.LEFT, HO.data_dsc, Color.AQUA, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)

    # padding for custom hud display
    hudSubtext(getAllPlayers(), "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nv", HudPosition.TOP, HO.fillermain, Color.ORANGE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    
    hudSubtext(getAllPlayers(), "{0}+{1}+{2} | Restart\nHold {3} | leaderboard".format(buttonString(Button.CROUCH), buttonString(Button.ABILITY_2), buttonString(Button.INTERACT),buttonString(Button.MELEE)), HudPosition.RIGHT, HO.com_restart_n_board, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0} {1} |  {2}".format( "" if localPlayer.QuickRestartToggle else "Hold",buttonString(Button.RELOAD),"Quick reset" if localPlayer.QuickRestartToggle else "Enable Quick reset"), HudPosition.RIGHT, HO.com_quickres, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "{0}+{1} | Invincible{2}".format(buttonString(Button.RELOAD), buttonString(Button.MELEE)," | ON" if localPlayer.InvincibleToggle else ""), HudPosition.RIGHT, HO.com_invincible, Color.GREEN if localPlayer.InvincibleToggle else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    
    hudSubtext(getAllPlayers(),  "Hold {0} | Preview orb/portal".format(buttonString(Button.PRIMARY_FIRE)), HudPosition.RIGHT, HO.com_preview, Color.GREEN if localPlayer.PreviewsArray else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    HudStoreEdit.append(getLastCreatedText())
    hudSubheader(getAllPlayers() if localPlayer.PreviewsArray else null, "Walk left/right | preview others\nAim | change preview angle", HudPosition.RIGHT, HO.com_previewsub, Color.LIME_GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    HudStoreEdit.append(getLastCreatedText())
    hudSubtext(getAllPlayers(), "Hold {0} | Splits{1}".format(buttonString(Button.ULTIMATE), " | ON " if localPlayer.splitson else ""), HudPosition.RIGHT, HO.com_splits, Color.GREEN if localPlayer.splitson else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)  
    HudStoreEdit.append(getLastCreatedText())

    #?????????
    hudSubheader(getAllPlayers(), "Server Restarts In {0} Min - V1.7.9b".format(TimeRemaining), HudPosition.RIGHT, HO.data_remaingtime, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    
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
        hudSubtext(getAllPlayers(), "Hold {0} | Spectate{1}".format(buttonString(Button.INTERACT)," | ON" if localPlayer.SpectateToggle else ""), HudPosition.RIGHT, HO.com_spec, Color.GREEN if localPlayer.SpectateToggle else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
        hudSubtext(getAllPlayers(), "Hold {0} | invisible{1}".format(buttonString(Button.ABILITY_2)," | ON" if localPlayer.invis else ""), HudPosition.RIGHT, HO.com_invis, Color.GREEN if localPlayer.invis else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
        HudStoreEdit.append(getLastCreatedText())
        hudSubtext(getAllPlayers() ,"{0} + {1} | Practice{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.PracticeCheckpoint) if localPlayer.PracticeToggle else ""),HudPosition.RIGHT, HO.com_practice, Color.GREEN if localPlayer.PracticeToggle else Color.GRAY if localPlayer.InvincibleToggle else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
        HudStoreEdit.append(getLastCreatedText())
        hudSubheader([i for i in getAllPlayers() if i.PracticeToggle],"{0} + {1} | Next level\n{0} + {2} | Previous level\n{3} | Start from practice cp ".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT)), HudPosition.RIGHT, HO.com_practicesub, Color.LIME_GREEN, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
        HudStoreEdit.append(getLastCreatedText())


    if hostPlayer.EditorOn
        # editor?
    elif not hostPlayer.EditorOn:
        # find the value
        Difficultyhud = createWorkshopSetting(enum[ "beginner", "easy-", "easy", "easy+", "medium-", "medium", "medium+", "hard-", "hard", "hard+", "very hard-", "very hard", "very hard+", "extreme-", "extreme", "extreme+", "hell", "don't display"],"map settings","difficulty (display hud)",0, 0)
        # display
        if Difficultyhud < 17: # 17th entry is dont display
            hudSubheader(getAllPlayers(), ["beginner", "easy -", "easy", "easy +","medium -","medium","medium +","hard -","hard","hard +","very hard -","very hard","very hard +","extreme -","extreme","extreme +","hell"][Difficultyhud], HudPosition.TOP, HO.data_dif,[Color.GREEN,Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN,Color.YELLOW,Color.YELLOW,Color.YELLOW, Color.ORANGE,Color.ORANGE,Color.ORANGE,rgb(255, 69, 0), rgb(255, 69, 0), rgb(255, 69, 0), Color.RED, Color.RED, Color.RED, rgb(150, 0, 0)][Difficultyhud], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
            HudStoreEdit.append(getLastCreatedText())



       CreateLeaderBoard()

rule "Huds: each player":
    @Event eachPlayer
    # ban icons in level
    hudText(eventPlayer, null, 
        "Practice Time {0}".format(prettyTime(eventPlayer.practicetimer)) if eventPlayer.PracticeToggle else "", 
        "Time {0}".format(prettyTime(eventPlayer.Timer)), 
        #"Time {0}{1}{2}".format(prettyTime(eventPlayer.Timer), "\nSplit " if eventPlayer.splitson else "",eventPlayer.splitdisplay  if eventPlayer.splitson else ""), 
        
        HudPosition.LEFT, HO.game_timer, Color.WHITE, Color.GRAY, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    
    hudText(eventPlayer, null, 
        "orange orbs {0} / {1}".format(len(eventPlayer.LockCollected), eventPlayer.BounceLockMax_Cache) if eventPlayer.BounceLockMax_Cache else "",
        "{3}{2}Level {0} / {1}".format(
            eventPlayer.CurrentCheckpoint, 
            len(CheckpointPositions) - 1,
            "\n" if eventPlayer.banstring else "",
            eventPlayer.banstring if eventPlayer.banstring else ""
            #"\nSplit {}".format(eventPlayer.splitdisplay) if eventPlayer.splitson else ""
        ),    
        HudPosition.TOP, HO.game_level_orb, Color.WHITE, Color.ORANGE, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT
    )
    # climb/bhop indicators
    hudHeader(eventPlayer, "Climb{0}".format("" if eventPlayer.MultiClimbCount < 1 else " ({0})".format(eventPlayer.MultiClimbCount)), HudPosition.LEFT, HO.game_climb, Color.RED if eventPlayer.WallclimbUsed else Color.GREEN, HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "Bhop", HudPosition.LEFT, HO.game_bhop, Color.GREEN if eventPlayer.BhopUsed == 0 else eventPlayer.BhopHUDColor, HudReeval.COLOR, SpecVisibility.DEFAULT)
    
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

  