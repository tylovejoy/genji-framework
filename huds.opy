
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


    waitUntil player is in
    if editor
        # editor?
    elif non editor:
        # only if not editor



       CreateLeaderBoard()

rule "Huds: each player":
    @Event eachPlayer


    # if cn

    # if not cn do en