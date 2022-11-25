#!mainFile "genji.opy"

rule "------------------------------------------------------------------------ Addons  ------------------------------------------------------------------------":
    @Delimiter
    @Disabled

/*
text per cp
rule "changinghudrule":
       
    hudHeader(
        getAllPlayers(), 
        "Text for checkpoint 1" if localPlayer.CurrentCheckpoint == 1 else
        "Text for checkpoint 3" if localPlayer.CurrentCheckpoint == 3 else
        "Text for checkpoint 4" if localPlayer.CurrentCheckpoint == 4 else
        "", 
        HudPosition.TOP, 
        -4,
        Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
*/
 #HO.add_custommsg1, 

rule "Addon | Add Blade to Checkpoint <---- EDIT ME":
    @Disabled
    #Change "-1" to certain Checkpoints' number. For example if you want to add Blade to Checkpoint 2 and 6 change one of "-1" to 2 and other "-1" to 6
    wait(1)
    BladeEnabledCheckpoints = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

rule "Addon | Add Dash to Checkpoint <---- EDIT ME":
    @Disabled
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    wait(1)
    DashEnabledCheckpoints = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
    
rule "Addon | Title Data <---- EDIT ME":
    @Disabled
    # checkpoint number
    TitleData[0] = [
        0,
        10,
        20,
        30,
        40,
        50
    ]

    # title
    TitleData[1] = [
        "Bunny",
        "Jumper",
        "Ninja",
        "Pro",
        "Expert",
        "Master"
    ]

    # color
    TitleData[2] = [
        Color.LIME_GREEN,
        Color.WHITE,
        Color.YELLOW,
        Color.ORANGE,
        Color.PURPLE,
        Color.RED
    ]

rule "Addon | HUD text for certain Checkpoints <---- EDIT ME":
    @Disabled
    wait(0.5)
    # in CpHudText fill in text
    # in CpHudCp fill in the at wich to display
    # the example fill shows a text for cp 1 and cp 3
    CpHudText = ["text cp 1","text cp 3"]
    CpHudCp = [1, 3]
    
rule "Addon | In world text for certain Checkpoints <---- EDIT ME":
    @Disabled
    wait(0.5)
    # in CpIwtText fill in text
    # in CpIwtCp fill in cp at wich to display
    # in CpIwtPos fill in the vector
    # the example fill shows a text for cp 1 and cp 3
    CpIwtText = ["text cp 1","text cp 3"]
    CpIwtCp = [1, 3]
    CpIwtPos = [vect(0,0,0), vect(0,0,0)]
    # color is for all, not per cp
    CpIwtColor = Color.LIME_GREEN

rule "Addon | pre-set control map portal | placement | toggled via workshop":
    @Condition PortalOn
    wait(2, Wait.ABORT_WHEN_FALSE) # overwrite pasta
    if getCurrentMap() == Map.BUSAN:
        #"down > sanc","down > meka","sanc > down","sanc > meka","meka > sanc","meka > down"
        PortalNames = ["Sanctuary","MEKA base","Downtown","MEKA base","Sanctuary","Downtown"]
        PortalLoc = [vect(47.946, 7.248, -93.922), vect(55.921, 6.998, -94.024), vect(-326.382, 10.81, 117.261), vect(-330.96, 10.81, 117.416), vect(219.567, 10.215, 243.653), vect(225.976, 10.227, 240.799)]
        PortalDest = [vect(-328.552, 10.01, 120.82), vect(221.152, 9.376, 238.765), vect(52.197, 6.301, -97.513), vect(221.271, 9.431, 238.978), vect(-328.601, 10.01, 120.823), vect(52.197, 6.299, -97.513)]
    
    elif getCurrentMap() == Map.ILIOS:
        #"light > ruin","light > well","ruin > light","ruin > well","well > light","well > ruin"
        PortalNames = ["Ruins","Well","Lighthouse","Well","Lighthouse","Ruins"]
        PortalLoc = [vect(325.722, -22.665, -40.401), vect(327.43, -22.665, -36.089), vect(26.176, 58.367, -156.415), vect(30.472, 58.367, -156.307), vect(-199.945, 2.015, -2.918), vect(-194.93, 2.015, -8.054)]
        PortalDest = [vect(28.375, 57.659, -161.195), vect(-200.464, 1.306, -8.604), vect(333.088, -23.389, -40.933), vect(-200.464, 1.306, -8.604), vect(333.088, -23.389, -40.933), vect(28.375, 57.829, -161.195)]

    elif getCurrentMap() == Map.LIJIANG_TOWER or getCurrentMap() == Map.LIJIANG_TOWER_LNY:
        #"control > garden","control > market","garden > control","garden > market","market > control","market > garden"
        PortalNames = ["Garden","Night Market","Control Center","Night Market","Control Center","Garden"]
        PortalLoc = [vect(-2.815, 271, 295.373), vect(2.905, 271, 295.052), vect(5.788, 95.056, 135.298), vect(-5.343, 95.05, 134.638), vect(-2.738, 0, -61.911), vect(5.043, 0, -61.879)]
        PortalDest = [vect(0.286, 94.292, 140.396), vect(0.584, -0.709, -54.469), vect(0.245, 270.292, 301.428), vect(0.773, -0.708, -54.361), vect(0.245, 270.292, 301.428), vect(0.286, 94.292, 140.396)]

    elif getCurrentMap() == Map.NEPAL:
        #"vil > shrine","vil > sanc", "shrine > vil","shrine > sanc",#"sanc > vil","sanc > shrine"
        PortalNames = ["Shrine","Sanctum","Village", "Sanctum",  "Village",  "Shrine"]
        PortalLoc = [vect(-194.732, -92.86, -3.802), vect(-194.585, -92.86, 4.187), vect(-33.165, 14, 5.212), vect(-33.058, 14, -5.55), vect(84.75, 129.008, -3.624), vect(84.534, 129, 4.032)]
        PortalDest = [vect(-40.19, 13.292, -0.105), vect(78.43, 128.292, 0.149), vect(-190.54, -93.569, 0.122), vect(78.43, 128.292, 0.149), vect(-190.54, -93.569, 0.122), vect(-40.19, 13.292, -0.105)]

    elif getCurrentMap() == Map.OASIS:
        #"uni > garden","uni > city","garden > uni","garden > city","city > garden","city > uni"
        PortalNames = ["Gardens","City Center","University","City Center","Gardens","University"]
        PortalLoc = [vect(-211.137, 20, -5.084), vect(-211.346, 20, 5.029), vect(143.061, 8.377, -245.04), vect(139.333, 8.377, -249.964), vect(157.297, 12.522, 255.759), vect(151.452, 12.522, 261.099)]
        PortalDest = [vect(134.366, 7.829, -240.53), vect(158.27, 11.814, 262.272), vect(-206.269, 19.292, 0.103), vect(158.283, 11.814, 262.283), vect(134.318, 7.829, -240.667), vect(-206.269, 19.292, 0.103)]

    else:
        PortalDest = null
        return
rule "Addon | pre-set control map portal | function | toggled via workshop":
    @Event eachPlayer
    @Condition PortalOn
    @Condition eventPlayer.InvincibleToggle or not eventPlayer.NotOnLastCp
    @Condition len(PortalLoc) != null
    @Condition any([distance(eventPlayer.getPosition() + vect(0,0.2,0),i) < 1.4 for i in PortalLoc])
    
    if PortalDest[PortalLoc.index(sorted(PortalLoc, lambda i: distance(eventPlayer, i))[0])] != vect(0,0,0):
        eventPlayer.teleport(
            PortalDest[PortalLoc.index(sorted(PortalLoc, lambda i: distance(eventPlayer, i))[0])] 
        )

rule "Addon | custom portals | data <---- EDIT ME":
    @Disabled
    #warning: This can cause you to exceed global orb/portal limit. 
    #make sure portal + orbs do not go past the limit.
    wait(1)
    #Portal start position
    CustomPortalStart = [vect(0,0,0)]
    #Portal end position (on same number as start position)
    CustomPortalEndpoint = [vect(0,10,0)]
    #Portal checkpoint (on same number as start position) 
    #999 = apply portal to entire map
    CustomPortalCP = [999]

rule "Addon | custom portals | function":
    @Disabled
    @Event eachPlayer
    @Condition len(CustomPortalStart) > 0

    @Condition (any([
        distance(eventPlayer.getPosition() + vect(0, 0.2, 0), ent) < portaldistance and 
        CustomPortalCP[i] in [999, eventPlayer.CurrentCheckpoint]
        for ent, i in CustomPortalStart
        ])) == true

    eventPlayer.PortalLoop = 0
    for eventPlayer.PortalLoop in range(len(CustomPortalStart)):
        if (
            distance(
                eventPlayer.getPosition() + vect(0, 0.2, 0), 
                CustomPortalStart[eventPlayer.PortalLoop]
            ) < portaldistance and 
            CustomPortalCP[eventPlayer.PortalLoop] in [999, eventPlayer.CurrentCheckpoint]
            ):
            eventPlayer.teleport(CustomPortalEndpoint[eventPlayer.PortalLoop])
            return

    wait(1)