# cheats ##############################
#!define editortoggle(x) __script__("test-maps/togglescript.js")
editortoggle(0) # 0 is editor, rest is numbers
#14 nepal 4 mini 6 busan 10 holly
#!define touchground false
#!define cpcheat false
#!define inspectoron false

# disable via double ## at include, not the define because the define needs to exist
#!define testaitoggle ##!include "test-scripts.opy"

#!define compmodetoggle false
#!define attemptcount 5
#!define comptimelimit 120
#!define comprestartlimit false
# defaults: off, atempt:5, 120 min, restart:false

# settings ##############################
# limit on how many orbs can be made
#!define fxlimit 193
#!define portaldistance 1.3

# distance range for player - orb 1.4
#!define bounceorbdistance 1.4
# eight added to player for orb detection. inludes the + 
#!define bounceoffset + vect(0,0.7,0)


#disable overpy map detection
#!disableMapDetectionFix 

#!include "settings.opy"
#!include "definitions.opy"

rule "fisho cp cheat for overpy toggle":
    @Event eachPlayer
    @Condition cpcheat
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.NotOnLastCp) or (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.CurrentCheckpoint != 0)
    @Condition not eventPlayer.EditorOn
    @Condition not eventPlayer.PracticeToggle   

    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint - 1])
        eventPlayer.CurrentCheckpoint -= 1
    else:
        eventPlayer.CurrentCheckpoint += 1
        eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint])


rule "------------------------------------------------------------------------ Map pasta ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled

rule "Map Data <---- INSERT YOUR MAP DATA HERE":
    @Delimiter


editorordata

rule "Credits here <---- INSERT YOUR NAME HERE": 
    hudSubtext(getAllPlayers(), "made by: name", HudPosition.LEFT, HO.data_name, Color.VIOLET, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    HudStoreEdit.append(getLastCreatedText()) # appending these makes em removed in editor
    hudSubtext(getAllPlayers(), "map code: XXXXX", HudPosition.LEFT, HO.data_code, Color.SKY_BLUE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    HudStoreEdit.append(getLastCreatedText())
    hudSubtext(getAllPlayers(), "Discord: dsc.gg/genjiparkour", HudPosition.LEFT, HO.data_dsc, Color.AQUA, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    #HudStoreEdit.append(getLastCreatedText())

rule "Ban per CP <---- edit me":
    # Enter the checkpoint/level numbers in the lists below to apply the ban on them
    # Remember the workshop toggle overwrites this list
    wait(1)
    # ======================
    # ban  triple >
    BanTriple = [-1]
    # ban  multi >
    BanMulti = [-1]
    # ban create >
    BanCreate = [-1]
    # ban dedhop >
    BanDead = [-1]
    # ban emote >
    BanEmote = [-1]
    # ban  climb >
    BanClimb = [-1]
    # ======================
    # dash exploit (via toggles don't edit)
    DashExploitToggle = createWorkshopSetting(bool, "Ban Switch", "Ban Dash Start", false, 2)
    
    # ban  bhop >
    #BanBhop = [2,3]

rule "Custom difficulty hud":
    @Disabled
    @Delimiter
    #1) workshop settings > difficulty > set to "dont display"
    #2) enable this rule
    #3) type your difficulty in the hud below
    hudSubheader(getAllPlayers(), "enter custom difficulty here", HudPosition.TOP, HO.data_dif,Color.GREEN, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    HudStoreEdit.append(getLastCreatedText())

rule "Display World Record": 
    @Disabled
    @Delimiter
    #type your entry in the textfield that says "name and time here"
    hudText(getAllPlayers(), null," \n{0} world record {0}".format(iconString(Icon.FIRE)),"name and time here", HudPosition.RIGHT, HO.wr, Color.ROSE, Color.ROSE, Color.ROSE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    HudStoreEdit.append(getLastCreatedText())


rule "Friend Title <---- DISPLAY MESSAGE HERE (ON PLAYER)":
    @Disabled
    @Delimiter
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    
    #In the field custom string your nickname
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(getAllPlayers(), "Message to the whole room")
        createInWorldText(getAllPlayers(), "Title <---------------The inscription that will be displayed on you", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    #Fill in the blank with your friend's name
    if "your nickname <-------" == "{0}".format(eventPlayer):
        bigMessage(getAllPlayers(), "Message to the whole room")
        createInWorldText(getAllPlayers(), "Title <---------------The inscription that will be displayed on you", eventPlayer, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)

rule "Comp Mode instruction message":
    #Instructions that show when you start comp mode.
    #Due to the hud text limit, you there is 4 huds available.
    #If you dont need a field just empty the textfield.
    instructiontext[0] = "Change in Comp Mode instruction message hud 1"
    instructiontext[1] = "Change in Comp Mode instruction message hud 2"
    instructiontext[2] = "Change in Comp Mode instruction message hud 2"
    instructiontext[3] = "Change in Comp Mode instruction message hud 2"


rule "------------------------------------------------------------------------  General functions ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled

def RebuildBounceOrbs():
    @Name "SUB | Rebuild Bounce Orbs"
    destroyEffect(BounceEffects)
    BounceEffects = [] 
    for TempIterator1 in range(0, len(BouncePadCheckpoints)):
        createEffect(
            [x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)] and not evalOnce(BouncePositions[evalOnce(TempIterator1)]) in x.LockCollected], 
            Effect.ORB, 
            Color.ORANGE if BounceToggleLock[evalOnce(TempIterator1)] else Color.GREEN, 
            BouncePositions[evalOnce(TempIterator1)], 
            1, 
            EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR
        )
    BounceEffects.append(getLastCreatedEntity())
    wait()

def RebuildKillOrbs():
    @Name "SUB | Rebuild Kill Orbs"
    destroyEffect(KillBallEffects)
    KillBallEffects = []  
    for TempIterator1 in range(0, len(KillballCheckpoints)):
        createEffect([x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == KillballCheckpoints[evalOnce(TempIterator1)]], Effect.SPHERE, Color.BLUE, KillBallPositions[evalOnce(TempIterator1)], KillBallRadii[evalOnce(TempIterator1)], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        KillBallEffects.append(getLastCreatedEntity())
        wait()

def BuildPortals():
    @Name "SUB | Rebuild Portals"
    # custom portals
    if CustomPortalStart:
        for TempIterator1 in range(len(CustomPortalStart)):
            createEffect(
                [i for i in getAllPlayers() if i.CurrentCheckpoint == CustomPortalCP[evalOnce(TempIterator1)] or CustomPortalCP[evalOnce(TempIterator1)] == 999],
                Effect.GOOD_AURA, Color.WHITE,
                CustomPortalStart[evalOnce(TempIterator1)], 
                0.6,
                EffectReeval.VISIBILITY
            )
            wait(0.16)
    # pre-set portals
    if PortalDest:
        for TempIterator1 in range(len(PortalLoc)):
            createEffect(
                [i for i in getAllPlayers() if i.InvincibleToggle or not i.NotOnLastCp],
                Effect.BAD_AURA, 
                Color.AQUA if evalOnce(TempIterator1) % 2 == 1 else Color.ORANGE,
                PortalLoc[evalOnce(TempIterator1)], 
                0.6,
                EffectReeval.VISIBILITY
            )
            createInWorldText(
                [i for i in getAllPlayers() if i.InvincibleToggle or not i.NotOnLastCp], 
                "{0}".format(PortalNames[evalOnce(TempIterator1)]), 
                PortalLoc[evalOnce(TempIterator1)] + vect(0,1,0), 
                1, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT
            )

def UpdateCache():
    @Name "SUB | Update Effect Cache"
    eventPlayer.NotOnLastCp = (eventPlayer.CurrentCheckpoint < len(CheckpointPositions) - 1 and len(CheckpointPositions)  > 1)
    
    eventPlayer.BouncePosition_Cache = [_ for _, i in BouncePositions if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceStrength_Cache = [_ for _, i in BounceStrength if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceUlt_Cache = [_ for _, i in BounceToggleUlt if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceDash_Cache = [_ for _, i in BounceToggleDash if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceLock_Cache = [_ for _, i in BounceToggleLock if BouncePadCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.KillPosition_Cache = [_ for _, i in KillBallPositions if KillballCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.KillRadii_Cache = [_ for _, i in KillBallRadii if KillballCheckpoints[i] == eventPlayer.CurrentCheckpoint]
    eventPlayer.BounceLockMax_Cache = len([i for i in eventPlayer.BounceLock_Cache if i])    
    
    eventPlayer.banstring = ""
    wait()
    if createWorkshopSetting(bool, "Ban Switch", "Ban Triple Jump on all cps", false, 0):
        eventPlayer.ban_triple = true
    elif eventPlayer.CurrentCheckpoint in BanTriple:
        eventPlayer.banstring = "▲ {}".format(eventPlayer.banstring)
        eventPlayer.ban_triple = true
    else:
        eventPlayer.ban_triple = false

    if createWorkshopSetting(bool, "Ban Switch", "Ban Multiclimb on all cps", false, 1):
        eventPlayer.ban_multi = true
    elif eventPlayer.CurrentCheckpoint in BanMulti:
        eventPlayer.banstring = "∞ {}".format(eventPlayer.banstring)
        eventPlayer.ban_multi = true
    else:
        eventPlayer.ban_multi = false

    if createWorkshopSetting(bool, "Ban Switch", "Ban Createbhop on all cps", false, 2):
        eventPlayer.ban_create = true
    elif eventPlayer.CurrentCheckpoint in BanCreate:
        eventPlayer.banstring = "♂ {}".format(eventPlayer.banstring)
        eventPlayer.ban_create = true
    else:
        eventPlayer.ban_create = false

    if createWorkshopSetting(bool, "Ban Switch", "Ban Deathbhop on all cps", false, 3):
        eventPlayer.ban_dedhop = true
    elif eventPlayer.CurrentCheckpoint in BanDead:
        eventPlayer.banstring = "X {}".format(eventPlayer.banstring)
        eventPlayer.ban_dedhop = true
    else:
        eventPlayer.ban_dedhop = false

    if createWorkshopSetting(bool, "Ban Switch", "Ban Emote Savehop on all cps", false, 4):
        eventPlayer.ban_emote = true
    elif eventPlayer.CurrentCheckpoint in BanEmote:
        eventPlayer.banstring = "♥ {}".format(eventPlayer.banstring)
        eventPlayer.ban_emote = true
    else:
        eventPlayer.ban_emote = false
    
    if createWorkshopSetting(bool, "Ban Switch", "Ban Wallclimb on all cps", false, 5):
        eventPlayer.ban_climb = true
    elif eventPlayer.CurrentCheckpoint in BanClimb:
        eventPlayer.banstring = "↑ {}".format(eventPlayer.banstring)
        eventPlayer.ban_climb = true
    else:
        eventPlayer.ban_climb = false

    wait()
    async(CheckUlt(), AsyncBehavior.RESTART)
    async(CheckDash(), AsyncBehavior.RESTART)

    if not eventPlayer.EditorOn:
        return

    destroyEffect(eventPlayer.EffectSizeArray)
    eventPlayer.EffectSizeArray = []
    createEffect(eventPlayer if eventPlayer.EffectSizeToggle else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint], 1.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.EffectSizeArray.append(getLastCreatedEntity())
    createEffect(eventPlayer if eventPlayer.EffectSizeToggle and eventPlayer.NotOnLastCp else null, Effect.SPHERE, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.EffectSizeArray.append(getLastCreatedEntity())

    eventPlayer.BounceIndex_Cache = [e for e in [(i if e2 == eventPlayer.CurrentCheckpoint else -1) for e2, i in BouncePadCheckpoints] if  e >=0]
    eventPlayer.KillIndex_Cache = [e for e in [(i if e2 == eventPlayer.CurrentCheckpoint else -1) for e2, i in KillballCheckpoints] if  e >=0]

    if eventPlayer.MovedCheckpoint and eventPlayer == hostPlayer:
        #SelectedCheckpoint_Editing = eventPlayer.CurrentCheckpoint
        SelectedKillball_Editing = 0 if eventPlayer.KillIndex_Cache else 99999
        KillBallChase = KillBallPositions[eventPlayer.KillIndex_Cache[SelectedKillball_Editing]] if len(eventPlayer.KillIndex_Cache) else vect(0,0,0)
        CurrentBounce_Editing = 0 if eventPlayer.BounceIndex_Cache else 99999
        CurrentBouncePosition_Editing = BouncePositions[eventPlayer.BounceIndex_Cache[CurrentBounce_Editing]] if len(eventPlayer.BounceIndex_Cache) else vect(0,0,0)
        eventPlayer.MovedCheckpoint = false

#!include "editor.opy"

rule "------------------------------------------------------------------------  General rules ------------------------------------------------------------------------ ":
    @Delimiter
    @Disabled


rule "Setup and Variables":
    if not inspectoron:
        disableInspector()

    disableGamemodeCompletion()
    disableScoring()
    disableMusic()
    disableAnnouncer()
    startForcingSpawn(Team.ALL,  0)
    startForcingSpawn(Team.ALL,  1)
    startForcingSpawn(Team.ALL,  2)

    BladeEnabledCheckpoints = BladeEnabledCheckpoints if len([i for i in BladeEnabledCheckpoints if i != -1 and i != [] ]) and BladeEnabledCheckpoints != null else []
    DashEnabledCheckpoints =  DashEnabledCheckpoints if len([i for i in DashEnabledCheckpoints if i != -1 and i != [] ]) and DashEnabledCheckpoints != null  else  []
    BouncePadCheckpoints = BouncePadCheckpoints if len(BouncePadCheckpoints) else []
    CheckpointPositions = CheckpointPositions if len(CheckpointPositions) else []
    CheckpointPositions = CheckpointPositions if len(CheckpointPositions) else []
    KillballCheckpoints = KillballCheckpoints if len(KillballCheckpoints) else []
    KillBallPositions = KillBallPositions if len(KillBallPositions) else []
    KillBallRadii = KillBallRadii if len(KillBallRadii) else []
    KillBallEffects = KillBallEffects if len(KillBallEffects) else []
    SelectedKillball_Editing = 0
    BouncePositions = BouncePositions if len(BouncePositions) else []
    BounceEffects = BounceEffects if len(BounceEffects) else []
    BounceStrength = BounceStrength if len(BounceStrength) else []
    CurrentBounce_Editing = 0
    BounceToggleUlt = BounceToggleUlt if len(BounceToggleUlt) else []
    BounceToggleDash = BounceToggleDash if len(BounceToggleDash) else []
    BounceToggleLock = BounceToggleLock if len(BounceToggleLock) else []
    LeaderBoardFull = []
    wait(1)
    PortalOn = createWorkshopSetting(bool, "map settings","enable portals (control maps)",true,0)
    #SelectedCheckpoint_Editing = len(CheckpointPositions) - 1 # This probably isn't necessary
        
    CompMode = createWorkshopSetting(bool, "Competitive mode","Turn on competitive mode" , compmodetoggle , 100)
    if CompMode:
        # -! comp minutes !- 
        CompTime = createWorkshopSetting(int[1:240], "Competitive mode", "time limit", comptimelimit, 101) # 5-240
        # -! comp attempt count !- 
        CompAtmpNum = createWorkshopSetting(int[0:500], "Competitive mode", "attempt count", attemptcount, 102) 
        # -! comp restartlimiter !-
        CompRestartLimit = createWorkshopSetting(bool, "Competitive mode","disable restart during run" , comprestartlimit , 103)

        hudHeader([i for i in getAllPlayers() if i.instructionhud],"                                                                                                                           ", HudPosition.TOP, HO.comp_instructtop, Color.WHITE, HudReeval.VISIBILITY,SpecVisibility.DEFAULT)
        # replace the instructions custom string for your own instructions. type \n for enter/next line
        if instructiontext[0]:
            hudSubtext([i for i in getAllPlayers() if i.instructionhud], instructiontext[0], HudPosition.TOP, HO.comp_instruct1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if instructiontext[1]:
            hudSubtext([i for i in getAllPlayers() if i.instructionhud], instructiontext[1], HudPosition.TOP, HO.comp_instruct2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if instructiontext[2]:
            hudSubtext([i for i in getAllPlayers() if i.instructionhud], instructiontext[2], HudPosition.TOP, HO.comp_instruct3, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        if instructiontext[3]:
            hudSubtext([i for i in getAllPlayers() if i.instructionhud], instructiontext[3], HudPosition.TOP, HO.comp_instruct4, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        hudHeader([i for i in getAllPlayers() if i.instructionhud],"                                   Press {0} to start                                ".format(buttonString(Button.INTERACT)), HudPosition.TOP, HO.comp_instructbottom, Color.WHITE, HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
                
    else:
        hudSubtext(getAllPlayers(), "Hold {0} | Spectate{1}".format(buttonString(Button.INTERACT)," | ON" if localPlayer.SpectateToggle else ""), HudPosition.RIGHT, HO.com_spec, Color.GREEN if localPlayer.SpectateToggle else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
        
        hudSubtext(getAllPlayers(), "Hold {0} | invisible{1}".format(buttonString(Button.ABILITY_2)," | ON" if localPlayer.invis else ""), HudPosition.RIGHT, HO.com_invis, Color.GREEN if localPlayer.invis else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
        HudStoreEdit.append(getLastCreatedText())
        hudSubtext(getAllPlayers() ,"{0} + {1} | Practice{2}".format(buttonString(Button.ULTIMATE), buttonString(Button.MELEE), " | ({0})".format(localPlayer.PracticeCheckpoint) if localPlayer.PracticeToggle else ""),HudPosition.RIGHT, HO.com_practice, Color.GREEN if localPlayer.PracticeToggle else Color.GRAY if localPlayer.InvincibleToggle else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
        HudStoreEdit.append(getLastCreatedText())
        hudSubheader([i for i in getAllPlayers() if i.PracticeToggle],"{0} + {1} | Next level\n{0} + {2} | Previous level\n{3} | Start from practice cp ".format(buttonString(Button.CROUCH), buttonString(Button.PRIMARY_FIRE), buttonString(Button.SECONDARY_FIRE), buttonString(Button.INTERACT)), HudPosition.RIGHT, HO.com_practicesub, Color.LIME_GREEN, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
        HudStoreEdit.append(getLastCreatedText())
   
    CreateLeaderBoard()
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


    if not hostPlayer.EditorOn:
        Difficultyhud = createWorkshopSetting(enum[ "beginner", "easy-", "easy", "easy+", "medium-", "medium", "medium+", "hard-", "hard", "hard+", "very hard-", "very hard", "very hard+", "extreme-", "extreme", "extreme+", "hell", "don't display"],"map settings","difficulty (display hud)",0, 0)

        if Difficultyhud < 17: # 17th entry is dont display
            hudSubheader(getAllPlayers(), ["beginner", "easy -", "easy", "easy +","medium -","medium","medium +","hard -","hard","hard +","very hard -","very hard","very hard +","extreme -","extreme","extreme +","hell"][Difficultyhud], HudPosition.TOP, HO.data_dif,[Color.GREEN,Color.LIME_GREEN,Color.LIME_GREEN,Color.LIME_GREEN,Color.YELLOW,Color.YELLOW,Color.YELLOW, Color.ORANGE,Color.ORANGE,Color.ORANGE,rgb(255, 69, 0), rgb(255, 69, 0), rgb(255, 69, 0), Color.RED, Color.RED, Color.RED, rgb(150, 0, 0)][Difficultyhud], HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
            HudStoreEdit.append(getLastCreatedText())

    wait(5)
    KILLBALL()
    wait(2)
    pinball() #
    wait(2)
    BuildPortals()
    # Check for editor/host spawn to redo effect reeval
    waitUntil(hostPlayer.hasSpawned(), 99999)
    wait()
    if not hostPlayer.EditorOn:
        return
    
    RebuildKillOrbs()
    RebuildBounceOrbs()
    
rule "Match time":
    if getCurrentGamemode() != Gamemode.SKIRMISH:
        wait(0.25)
        setMatchTime(1)
        wait(1.1)
        setMatchTime(1)
        wait(1.1)
        wait(10)
    
    setMatchTime(69)
    pauseMatchTime()
    wait(5)
    TimeRemaining = 265
    hudSubheader(getAllPlayers(), "Server Restarts In {0} Min - V1.7.8c".format(TimeRemaining), HudPosition.RIGHT, HO.data_remaingtime, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    
    while TimeRemaining > 0:
        wait(60)
        TimeRemaining --
        if CompMode:
            CompTime --
            if CompTime == 0:
                bigMessage(getAllPlayers(),"time's up")
                getAllPlayers().CompDone = true
                stopChasingVariable(getAllPlayers().Timer)
                getAllPlayers().disableRespawn()
                kill(getAllPlayers(), null)
                wait(0.032)
                async(CreateLeaderBoard(), AsyncBehavior.RESTART)            

    bigMessage(getAllPlayers(), "maximum lobby time expired, restarting")
    wait(5)
    if getCurrentGamemode() == Gamemode.FFA:
        declarePlayerVictory(hostPlayer)
    else:
        declareTeamVictory(hostPlayer.getTeam())


rule "Player Initialize and game HUD":
    @Event eachPlayer
    eventPlayer.EditorOn = createWorkshopSetting(bool, "Editor","Editor mode" ,  editoron , 0) # Turn Editor On
    eventPlayer.GuideToggle = eventPlayer.EditorOn
    eventPlayer.disableGamemodeHud()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.preloadHero(Hero.GENJI)
    eventPlayer.setRespawnTime(0)
    eventPlayer.SpectateToggle = false
    eventPlayer.WallclimbUsed = false #Climbing the wall prompts the HUD
    eventPlayer.JumpCount = 0
    eventPlayer.bouncetouchedlast = -1
    #big waits first for about 1 second before loading, to make sure things like comp mode are fully loaded and configured, load fx in meanwhile
    wait(1) 
    createEffect(eventPlayer, Effect.RING, Color.SKY_BLUE, CheckpointPositions[eventPlayer.CurrentCheckpoint].last(), 1, EffectReeval.POSITION_AND_RADIUS)
    createEffect(eventPlayer if eventPlayer.NotOnLastCp  else null, Effect.RING, Color.LIME_GREEN, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    wait(0.5)
    createEffect(eventPlayer if eventPlayer.NotOnLastCp  else null, Effect.LIGHT_SHAFT, Color.WHITE, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createIcon(eventPlayer if eventPlayer.NotOnLastCp  else null, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1] + Vector.UP, Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.SKY_BLUE, true)
    wait(0.5)
    createInWorldText(eventPlayer if eventPlayer.NotOnLastCp else null, "{0} collect orbs first".format(iconString(Icon.WARNING)) if eventPlayer.BounceLockMax_Cache and len(eventPlayer.LockCollected) < eventPlayer.BounceLockMax_Cache else "Come here", CheckpointPositions[eventPlayer.CurrentCheckpoint + 1], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    wait(1)  

    if not eventPlayer.isDummy():
        eventPlayer.startForcingHero(Hero.GENJI)
    elif eventPlayer.getCurrentHero() != Hero.GENJI: # only do the things on genji test bots
        return

    waitUntil(eventPlayer.hasSpawned(), 9999)

    if CompMode:
        eventPlayer.setInvisibility(Invis.ALL)
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
        if not "{0}".format(eventPlayer) in CompAtmpSaveNames: # instructions and settings for comp start
            eventPlayer.instructionhud = true
            CompAtmpSaveNames.append("{0}".format(eventPlayer))
            CompAtmpSaveCount.append(1)
            eventPlayer.AttemptCount = 1
            eventPlayer.setMoveSpeed(0)
            eventPlayer.setAbility1Enabled(false)
            eventPlayer.setUltEnabled(false)
            waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT),1)
            waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) or CompTime < 1,99999)
            eventPlayer.setMoveSpeed(100)
            eventPlayer.instructionhud = false
        else:
            eventPlayer.AttemptCount = CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))]
            smallMessage(eventPlayer,"now {0}".format( eventPlayer.AttemptCount))
        if eventPlayer.AttemptCount == (-1) or CompTime < 1:
            eventPlayer.CompDone = true
    
    # ban icons in level
    hudText(eventPlayer, null, 
        "Practice Time {0}".format(prettyTime(eventPlayer.practicetimer)) if eventPlayer.PracticeToggle else "", 
        "Time {0}".format(prettyTime(eventPlayer.Timer)), 
        HudPosition.LEFT, HO.game_timer, Color.WHITE, Color.GRAY, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT)
    
    hudText(eventPlayer, null, 
        "orange orbs {0} / {1}".format(len(eventPlayer.LockCollected), eventPlayer.BounceLockMax_Cache) if eventPlayer.BounceLockMax_Cache else "",
        "{3}{2}Level {0} / {1}".format(
            eventPlayer.CurrentCheckpoint, 
            len(CheckpointPositions) - 1,
            "\n" if eventPlayer.banstring else "",
            eventPlayer.banstring if eventPlayer.banstring else ""
        ),    
        HudPosition.TOP, HO.game_level_orb, Color.WHITE, Color.ORANGE, Color.WHITE, HudReeval.STRING, SpecVisibility.DEFAULT
    )
    # climb/bhop indicators
    hudHeader(eventPlayer, "Climb{0}".format("" if eventPlayer.MultiClimbCount < 1 else " ({0})".format(eventPlayer.MultiClimbCount)), HudPosition.LEFT, HO.game_climb, Color.RED if eventPlayer.WallclimbUsed else Color.GREEN, HudReeval.STRING_AND_COLOR, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "Bhop", HudPosition.LEFT, HO.game_bhop, Color.GREEN if eventPlayer.BhopUsed == 0 else eventPlayer.BhopHUDColor, HudReeval.COLOR, SpecVisibility.DEFAULT)
    
    wait()
    StartGame_Sub()  # initialization of the game
   
def DeleteSave():
    @Name "delete save" 
    del SaveName[SaveEnt.index(eventPlayer)]
    del SaveCp[SaveEnt.index(eventPlayer)]
    del SaveTimer[SaveEnt.index(eventPlayer)]
    del SaveElapsed[SaveEnt.index(eventPlayer)]
    del SavePauseTime[SaveEnt.index(eventPlayer)]
    del SavePauseEnabled[SaveEnt.index(eventPlayer)]
    del SaveEnt[SaveEnt.index(eventPlayer)] # must always be last because its the index itself

def MakeSave():
    @Name "make save"
    SaveName.append("{}".format(eventPlayer))
    SaveCp.append(eventPlayer.CurrentCheckpoint)
    SaveTimer.append(eventPlayer.Timer)
    SaveEnt.append(eventPlayer)
    SaveElapsed.append(getTotalTimeElapsed())
    SavePauseTime.append(0)
    SavePauseEnabled.append(false)

def StartPauseTimer():
    @Name "start pause timer"
    chase(eventPlayer.PauseTimer, 999999, rate=1, ChaseReeval.NONE)
    SaveTimer[SaveEnt.index(eventPlayer)] = eventPlayer.Timer
    SaveElapsed[SaveEnt.index(eventPlayer)] = getTotalTimeElapsed()
    SavePauseEnabled[SaveEnt.index(eventPlayer)] = true

def StopPauseTimer():
    @Name "stop pause timer"
    stopChasingVariable(eventPlayer.PauseTimer)
    SavePauseTime[SaveEnt.index(eventPlayer)] = eventPlayer.PauseTimer
    eventPlayer.PauseTimer = 0
    SavePauseEnabled[SaveEnt.index(eventPlayer)] = false

def CreateLeaderBoard():
    @Name "leaderboard hud"
    # turns into global rule so it doesnt delete when player leaves
    LeaderBoardRemake = false
    wait()
    LeaderBoardRemake = true
 
rule "remake leaderboard": # for global isntead of tied to player
    @Condition LeaderBoardRemake   
    wait() # account for delay in completion
    LeaderBoardFull = sorted(LeaderBoardFull, lambda i: i[1])
    
    while len(LeaderBoardHuds) > 0: 
        destroyHudText(LeaderBoardHuds[0])
        del LeaderBoardHuds[0]
    
    # top 5
    if LeaderBoardFull[0]:
        hudSubtext(getAllPlayers()," \n{0} Top 5 {0}".format(abilityIconString(Hero.GENJI,Button.PRIMARY_FIRE)), HudPosition.RIGHT, HO.board_top5, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
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

    hudHeader(getAllPlayers() if evalOnce(CompMode and CompTime == 0) else localPlayer.LeaderboardToggle, "　　　　 {0} Leaderboard {0} 　　　".format(iconString(Icon.FLAG)), HudPosition.TOP, HO.board_header, Color.BLUE, HudReeval.VISIBILITY, SpecVisibility.NEVER)
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
        ),HudPosition.TOP, HO.board_display1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    LeaderBoardHuds.append(getLastCreatedText())

    if LeaderBoardFull[5]:
        hudHeader(
            getAllPlayers() if evalOnce(CompMode and CompTime == 0) else localPlayer.LeaderboardToggle,
            "　　　　　　　　　　　　　　　　　 　\n"
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
            ),HudPosition.TOP, HO.board_display2, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
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
            ),HudPosition.TOP, HO.board_display3, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
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
            ),HudPosition.TOP, HO.board_display4, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        LeaderBoardHuds.append(getLastCreatedText())

def Leaderboardupdate():
    @Name "SUB | Leaderboard Update"
    # [i[0] for i in var1]   list of first element of each in var 1
    # [ [name, seconds, prettytime] ]
    if "{0}".format(eventPlayer) in [i[0] for i in LeaderBoardFull]: # you already have a time
        if eventPlayer.Timer > [i for i in LeaderBoardFull if i[0] == "{0}".format(eventPlayer)][0][1]: # new time worse
            goto lbl_a
        else: # new time better
            LeaderBoardFull.remove( [i for i in LeaderBoardFull if i[0] == "{0}".format(eventPlayer)])
            LeaderBoardFull.append( [["{0}".format(eventPlayer),eventPlayer.Timer, prettyTime(eventPlayer.Timer)]] )
            CreateLeaderBoard()
    else: # you are not in list yet
        if len(LeaderBoardFull) < 20: # board has room for more
            LeaderBoardFull.append( [["{0}".format(eventPlayer),eventPlayer.Timer, prettyTime(eventPlayer.Timer)] ])
            CreateLeaderBoard()
        else: # 20 entries already
            if LeaderBoardFull[19][1] < eventPlayer.Timer:  # your time lower then last entry
                goto lbl_a
            else: # you beat the last entry, thus replacing it
                del LeaderBoardFull[19]
                LeaderBoardFull.append( [["{0}".format(eventPlayer),eventPlayer.Timer, prettyTime(eventPlayer.Timer)]] )
                CreateLeaderBoard()
    lbl_a:

def checkpointFailReset():
    @Name "SUB | Checkpoint Fail"
    eventPlayer.LockCollected = []
    eventPlayer.cancelPrimaryAction()
    eventPlayer.applyImpulse(Vector.DOWN, eventPlayer.getSpeed(), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.1)
    eventPlayer.teleport( CheckpointPositions[eventPlayer.CurrentCheckpoint].last() )
    if eventPlayer.ban_dedhop and eventPlayer.InvincibleToggle == false and eventPlayer.NotOnLastCp:
        # if eventPlayer.isOnWall():
        #smallMessage(eventPlayer, "Deathbhop is banned!")
        eventPlayer.disallowButton(Button.JUMP)
        wait(0.1)
        eventPlayer.allowButton(Button.JUMP)        
    if eventPlayer.CurrentCheckpoint == 0 and not eventPlayer.PracticeToggle:
        eventPlayer.Timer = 0
        eventPlayer.splittime = 0
    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)
        wait()
   
    async(CheckUlt(), AsyncBehavior.RESTART)
    async(CheckDash(), AsyncBehavior.RESTART)

def StartGame_Sub():
    @Name "SUB | Start Game"
    if CompMode and (CompTime < 1 or eventPlayer.CompDone):
        eventPlayer.LeaderboardToggle = true
        eventPlayer.CompDone = true
        eventPlayer.disableRespawn()
        kill(eventPlayer,null)
        return
    
    if DashExploitToggle:
        eventPlayer.setAbility1Enabled(false)
        if eventPlayer.isUsingAbility1():
            waitUntil(not eventPlayer.isUsingAbility1(), 1.5)
            smallMessage(eventPlayer, "   Dash Start is banned!")            

    if eventPlayer.isUsingUltimate():
        kill(eventPlayer, null)
    if len(CheckpointPositions) != 0:
        destroyInWorldText(eventPlayer.TitleStore) # restarting reset t itle even if non on cp 0
        if "{0}".format(eventPlayer) in SaveName: # load saved progres
            SaveEnt[SaveName.index("{}".format(eventPlayer))] = eventPlayer
            eventPlayer.CurrentCheckpoint = SaveCp[SaveEnt.index(eventPlayer)]
            eventPlayer.Timer = SaveTimer[SaveEnt.index(eventPlayer)]
            SaveElapsed[SaveEnt.index(eventPlayer)] = getTotalTimeElapsed()
            SavePauseTime[SaveEnt.index(eventPlayer)] = 0
            SavePauseEnabled[SaveEnt.index(eventPlayer)] = false
            eventPlayer.teleport(CheckpointPositions[eventPlayer.CurrentCheckpoint] + Vector.UP)
            if TitleData != null and  any([i for i in TitleData[0] if i <= eventPlayer.CurrentCheckpoint]) and (not eventPlayer.EditorOn ): # if any title data, find last cp
                
                createInWorldText(
                    getAllPlayers() if not eventPlayer.invis else null,
                    TitleData[1][TitleData[0].index(
                    sorted([i for i in TitleData[0] if i <= eventPlayer.CurrentCheckpoint], lambda i:i*-1)[0])], 
                    eventPlayer,1.1,Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, 
                    TitleData[2][TitleData[0].index(sorted([i for i in TitleData[0] if i <= eventPlayer.CurrentCheckpoint], lambda i:i*-1)[0])], 
                    SpecVisibility.DEFAULT
                )
                eventPlayer.TitleStore = getLastCreatedText()

        else:
            eventPlayer.teleport(CheckpointPositions[0] + Vector.UP)
            eventPlayer.CurrentCheckpoint = 0
            eventPlayer.Timer = 0
            stopChasingVariable(eventPlayer.PauseTimer)
            eventPlayer.PauseTimer = 0
            MakeSave()
            UpdateTitle()
    
    eventPlayer.splittime = 0
    chase(eventPlayer.Timer, 9999999, rate=1, ChaseReeval.NONE)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    eventPlayer.LockCollected = []
    eventPlayer.InvincibleToggle = false
    # eventPlayer.LockState = false
    UpdateCache()

def UpdateTitle():
    @Name "Tittle "
    if TitleData == null or CompMode or eventPlayer.PracticeToggle or eventPlayer.EditorOn or (not eventPlayer.CurrentCheckpoint in TitleData[0]): 
        return
    destroyInWorldText(eventPlayer.TitleStore)
    createInWorldText(getAllPlayers() if not eventPlayer.invis else null,TitleData[1][TitleData[0].index(eventPlayer.CurrentCheckpoint)], eventPlayer,1.1,Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, TitleData[2][TitleData[0].index(eventPlayer.CurrentCheckpoint)], SpecVisibility.DEFAULT)
    eventPlayer.TitleStore = getLastCreatedText()

def KILLBALL():
    @Name "SUB | Kill Orb Effects"
    if KillBallPositions == [] or hostPlayer.EditorOn:
        return
    for TempIterator1 in range(0, len(KillBallPositions)):
        createEffect([x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == KillballCheckpoints[evalOnce(TempIterator1)]], Effect.SPHERE, Color.BLUE, KillBallPositions[evalOnce(TempIterator1)], KillBallRadii[evalOnce(TempIterator1)], EffectReeval.VISIBILITY)
        KillBallEffects.append(getLastCreatedEntity())
        wait()

def pinball():
    @Name "SUB | Bounce Ball Effects"
    if BouncePositions == [] or hostPlayer.EditorOn:
        return
    for TempIterator1 in range(0, len(BouncePositions)):
        createEffect(
            [x for x in getAllPlayers().concat(null) if x.CurrentCheckpoint == BouncePadCheckpoints[evalOnce(TempIterator1)] and not BouncePositions[evalOnce(TempIterator1)] in x.LockCollected], 
            Effect.ORB, 
            Color.ORANGE if BounceToggleLock[TempIterator1] else Color.GREEN, 
            BouncePositions[evalOnce(TempIterator1)], 
            1, 
            EffectReeval.VISIBILITY
        )
        BounceEffects.append(getLastCreatedEntity())
        wait()

rule "Arrive | Ground reset | traces":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.isAlive()
    if eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1:
        
        if (eventPlayer.isMoving() and eventPlayer.PracticeToggle == false and eventPlayer.invis == false and eventPlayer.EditorOn == false and CompMode == false):
            # traces ----------------------------------------------------------------------------------------------------
            eventPlayer.finishfxcache = [Color.RED, Color.ORANGE, Color.YELLOW, Color.LIME_GREEN, Color.GREEN, Color.TURQUOISE, Color.BLUE, Color.PURPLE, Color.VIOLET, Color.ROSE][(floor(getTotalTimeElapsed()*2))%10]
            #eventPlayer.finishfxcache =  rgb((cosDeg(getTotalTimeElapsed()/2 * 360 - 0) + 0.5) * 255, (cosDeg(getTotalTimeElapsed/2 * 360 - 120) + 0.5) * 255, (cosDeg(getTotalTimeElapsed/2 * 360 - 240) + 0.5) * 255)
            wait(0.16)
            # 1.6 - 0.2 in 0.2 steps
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 1.4)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 1.2)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 1)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 0.8)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 0.6)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.finishfxcache, eventPlayer.getPosition(), 0.4)
            wait(0.128)     
    elif eventPlayer.NotOnLastCp and eventPlayer.InvincibleToggle == false and (CompMode == false or CompTime > 0) and eventPlayer.LockState == false:
        if distance(eventPlayer, CheckpointPositions[eventPlayer.CurrentCheckpoint + 1]) <= 1.4:
            # arrived ----------------------------------------------------------------------------------------------------
            eventPlayer.MovedCheckpoint = true
            if eventPlayer.BounceLockMax_Cache and len(eventPlayer.LockCollected) < eventPlayer.BounceLockMax_Cache: # kill player if not colleted the locks
                smallMessage(eventPlayer, "   ! collect ALL orange orbs to unlock !")
                kill(eventPlayer, null)
                goto lbl_abc
            if eventPlayer.ban_climb and eventPlayer.WallclimbUsed:
                smallMessage(eventPlayer, "   Climb ↑ is banned!")
                checkpointFailReset()
                goto lbl_abc
            eventPlayer.LockCollected = []
            eventPlayer.CurrentCheckpoint += 1
            UpdateCache()
            if len(CheckpointPositions[eventPlayer.CurrentCheckpoint]) > 1:# teleport cps
                eventPlayer.startForcingPosition( CheckpointPositions[eventPlayer.CurrentCheckpoint].last() ,false)
                wait(0.1)
                eventPlayer.flytoggle = null
                eventPlayer.stopForcingPosition()
            
            eventPlayer.splitdisplay =  (eventPlayer.practicetimer if eventPlayer.PracticeToggle else eventPlayer.Timer) - eventPlayer.splittime
            wait()
            playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
            playEffect(eventPlayer if CompMode or eventPlayer.invis else getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, CheckpointPositions[eventPlayer.CurrentCheckpoint] + vect(0, 1.5, 0), 4)
            bigMessage(eventPlayer, "Arrived at {0} / {1}{2}".format(eventPlayer.CurrentCheckpoint, len(CheckpointPositions) - 1, " - Split {}".format(eventPlayer.splitdisplay) if eventPlayer.splitson else ""))
            wait()
            UpdateTitle()
            if eventPlayer.isUsingUltimate():
                kill(eventPlayer, null)
            if eventPlayer.PracticeToggle:
                eventPlayer.splittime = eventPlayer.practicetimer
                goto lbl_abc
            
            eventPlayer.splittime = eventPlayer.Timer
                
            if eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1 and (not eventPlayer.EditorOn) and (not eventPlayer.PracticeToggle): # complete lvl
                stopChasingVariable(eventPlayer.Timer)
                stopChasingVariable(eventPlayer.practicetimer) 
                wait()
                bigMessage(getAllPlayers(), "{0} Mission complete! Time {1}".format(eventPlayer, prettyTime(eventPlayer.Timer)))
                
                DeleteSave()
                Leaderboardupdate()
                if CompMode and CompAtmpNum > 0:
                    if eventPlayer.AttemptCount == CompAtmpNum: 
                        CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))] = -1 
                        eventPlayer.AttemptCount = -1                     
                        eventPlayer.CompDone = true
                        eventPlayer.LeaderboardToggle = true
                        eventPlayer.disableRespawn()
                        kill(eventPlayer,null)
                    else:
                        CompAtmpSaveCount[CompAtmpSaveNames.index("{0}".format(eventPlayer))] = eventPlayer.AttemptCount + 1
            else: # update save
                DeleteSave()
                MakeSave()
        elif distance(eventPlayer,CheckpointPositions[eventPlayer.CurrentCheckpoint].last()) > 1.4 and not touchground:
            # ground reset ----------------------------------------------------------------------------------------------------
            checkpointFailReset()

    lbl_abc:
    wait(0.048)

    if RULE_CONDITION:
        goto RULE_START               
   
rule "Kill Orb | Activate":
    @Event eachPlayer
    @Condition eventPlayer.KillPosition_Cache != []
    @Condition not eventPlayer.InvincibleToggle
    @Condition eventPlayer.NotOnLastCp
    @Condition (any([distance(i, eventPlayer) <= eventPlayer.KillRadii_Cache[eventPlayer.KillPosition_Cache.index(i)] for i in eventPlayer.KillPosition_Cache]))
    checkpointFailReset()



rule "Bounce Ball / Orb | Activate":
    @Event eachPlayer
    @Condition eventPlayer.BouncePosition_Cache != []
    #@Condition eventPlayer.NotOnLastCp # disabled coz editor
    @Condition (any([distance(i, eventPlayer.getPosition() bounceoffset) < bounceorbdistance for i in eventPlayer.BouncePosition_Cache]))
    
    eventPlayer.bouncetouched = eventPlayer.BouncePosition_Cache.index( # cashe the touched bouncepad number
        sorted(
            [i for i in eventPlayer.BouncePosition_Cache if distance(eventPlayer bounceoffset, i ) < bounceorbdistance and not (i in eventPlayer.LockCollected) ],
            lambda x: distance(eventPlayer, x)
            )[0]
        )

    if eventPlayer.bouncetouched == eventPlayer.bouncetouchedlast: # prevent same one trigering twice in a row
        wait(0.24)
        eventPlayer.bouncetouchedlast = -1 # -1 because null becomes 0 and thats a legit index
        if RULE_CONDITION:
            goto RULE_START
        return #only return if no others in radius

    eventPlayer.bouncetouchedlast = eventPlayer.bouncetouched 

    if eventPlayer.BounceStrength_Cache[eventPlayer.bouncetouched] != 0:
        eventPlayer.applyImpulse(Vector.UP, eventPlayer.BounceStrength_Cache[eventPlayer.bouncetouched], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

    if eventPlayer.BounceUlt_Cache[eventPlayer.bouncetouched]:
        eventPlayer.setUltEnabled(true)
        eventPlayer.setUltCharge(100)
        smallMessage(eventPlayer, "   Ultimate is ready")
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    if eventPlayer.BounceLock_Cache[eventPlayer.bouncetouched]:
        eventPlayer.LockCollected.append(eventPlayer.BouncePosition_Cache[eventPlayer.bouncetouched])
        smallMessage(eventPlayer, "   orb has been collected")
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    if eventPlayer.BounceDash_Cache[eventPlayer.bouncetouched]:
        if eventPlayer.isUsingAbility1():
            waitUntil(not eventPlayer.isUsingAbility1(), 1)
            wait(0.032) # wait til set false by check
        eventPlayer.setAbility1Enabled(true)
        smallMessage(eventPlayer, "   Dash is ready")
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 75)

    wait(0.24)
    if RULE_CONDITION:
        goto RULE_START

    eventPlayer.bouncetouchedlast = -1

rule "Death Reset":
    @Event playerDied
    @Condition not eventPlayer.SpectateToggle
    @Condition not eventPlayer.CompDone
    #@Condition len(CheckpointPositions) >= 2
    
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.resurrect()
    checkpointFailReset()

rule "Player Phase":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.PHASED_OUT) == false
    @Condition eventPlayer.isAlive()
    
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)


rule "Player Leaves":
    @Event playerLeft
    if SaveCp[SaveEnt.index(eventPlayer)] == 0: # delete if player didnt do first cp
       DeleteSave()
    else:
        if SaveCp[SaveEnt.index(eventPlayer)] >= len(CheckpointPositions) - 1 or SavePauseEnabled[SaveEnt.index(eventPlayer)]: # level complete or ?
            goto lbl_a
        SaveTimer[SaveEnt.index(eventPlayer)]  = (
            getTotalTimeElapsed() - 
            SaveElapsed[SaveEnt.index(eventPlayer)]  - 
            SavePauseTime[SaveEnt.index(eventPlayer)]  + 
            SaveTimer[SaveEnt.index(eventPlayer)] 
        )        
        lbl_a:
        SavePauseTime[SaveEnt.index(eventPlayer)] = 0
        SavePauseEnabled[SaveEnt.index(eventPlayer)] = false


#!include "commands.opy"     

#!include "mechanics.opy"

#!include "addons.opy"

rule "Ms. Destructo | Destroys Breakable Objects On All Maps":
    # Credit: nebula#11571
    @Condition isGameInProgress()
    
    MsDestructo = []  # Multiple bots
    waitUntil(any([x.hasSpawned() for x in getAllPlayers()]), 99999)

    switch getCurrentMap():
        case Map.ILIOS:
            MapVectorArray = [vect(322.988, 40, -37.732), vect(27.711, 100, -161.298), vect(-223.895, 50, 0.89)]
            break
        case Map.BUSAN:
            MapVectorArray = [vect(51.885, 37.172, -113.654), vect(-329.934, 56.136, 149.839), vect(227.21, 43.353, 252.64)]
            break
        case Map.LIJIANG_TOWER:
            MapVectorArray = [vect(-5.808, 324.398, 282.523), vect(-0.414, 156.197, 148.681), vect(-0.381, 53.736, -33.335)]
            break
        case Map.NEPAL:
            MapVectorArray = [vect(83.1, 178.926, 0.593), vect(-49.803, 63.29, -0.413), vect(-184.659, -38.73, -0.783)]
            break
        case Map.OASIS:
            MapVectorArray = [vect(150.125, 30.619, 251.966), vect(134.888, 36.76, -240.736), vect(-195.549, 60.35, -0.098)]
            break
        case Map.NEW_QUEEN_STREET:
            MapVectorArray = [vect(-13.79, 1.96, 15.92), vect(0,35,25), vect(0,8, 23.77), vect(13.28, 2, 15)]
            break
        case Map.ANTARCTIC_PENINSULA:
            MapVectorArray = [vect(-86, -110, 59), vect(277, 132, 170), vect(283, 57, -235)]
            break
        default:
            # This default covers almost every map
            MapVectorArray = [
                vect(73, 62, -17),
                vect(169, 62, 82),
                vect(-23, 62, -124), 
                vect(-23, 62, 100)
            ]

    for DestructoIter in range(len(MapVectorArray)):
        createDummy(Hero.DVA, [player for player in getAllPlayers() if player.hasSpawned() and not player.isDummy()][0].getTeam(), 20 - evalOnce(DestructoIter), evalOnce(MapVectorArray[evalOnce(DestructoIter)]), vect(0, 0, 0))
        MsDestructo[evalOnce(DestructoIter)] = getLastCreatedEntity()
        MsDestructo[evalOnce(DestructoIter)].startScalingSize(20, true)
        wait()
        MsDestructo[evalOnce(DestructoIter)].setGravity(0)
        MsDestructo[evalOnce(DestructoIter)].applyImpulse(Vector.UP, 1, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        MsDestructo[evalOnce(DestructoIter)].teleport(evalOnce(MapVectorArray[evalOnce(DestructoIter)]))
        wait(1)
        MsDestructo[evalOnce(DestructoIter)].disableEnvironmentCollision(true)
        wait()
        MsDestructo[evalOnce(DestructoIter)].setUltEnabled(true)
        wait()
        MsDestructo[evalOnce(DestructoIter)].setUltCharge(100)
        wait()

    wait(1)
    for DestructoIter in range(len(MapVectorArray)):
        MsDestructo[evalOnce(DestructoIter)].startForcingButton(Button.ULTIMATE)

    wait(5)
    for DestructoIter in range(len(MapVectorArray)):
        destroyDummy(MsDestructo[evalOnce(DestructoIter)].getTeam(), MsDestructo[evalOnce(DestructoIter)].getSlot())

    # Remove MsDestructo data when done
    MapVectorArray = null
    DestructoIter = null
    MsDestructo = null
 
# enable/disable the include via defines
testaitoggle 
