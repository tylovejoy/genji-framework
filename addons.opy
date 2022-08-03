#!mainFile "genji.opy"

rule "------------------------------------------------------------------------ Addons  ------------------------------------------------------------------------":
    @Delimiter
    @Disabled


rule "Add Blade to Checkpoint <---- EDIT ME":
    @Disabled
    #Change "-1" to certain Checkpoints' number. For example if you want to add Blade to Checkpoint 2 and 6 change one of "-1" to 2 and other "-1" to 6
    BladeEnabledCheckpoints = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]



rule "Add Dash to Checkpoint <---- EDIT ME":
    @Disabled
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    DashEnabledCheckpoints = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]



globalvar PortalNames
globalvar PortalLoc
globalvar PortalDest

rule "portal placement":
    @Condition createWorkshopSetting(bool, "addons","enable portals",true,0)

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
        return
    
    for TempIterator1 in range(len(PortalLoc)):
        createEffect(
            [i for i in getAllPlayers() if i.InvincibleToggle or i.CurrentCheckpoint == len(CheckpointPositions) - 1],
            Effect.BAD_AURA, 
            #Color.AQUA if localPlayer.portalselect != evalOnce(i) else Color.ORANGE, 
            Color.AQUA if evalOnce(TempIterator1) % 2 == 1 else Color.ORANGE,
            #[Color.AQUA, Color.GREEN, Color.RED, Color.BLUE, Color.LIME_GREEN, Color.ROSE][evalOnce(i)],
            PortalLoc[evalOnce(TempIterator1)], 
            0.6,
            EffectReeval.VISIBILITY
        )

        createInWorldText(
            [i for i in getAllPlayers() if i.InvincibleToggle or i.CurrentCheckpoint == len(CheckpointPositions) - 1], 
            "{0}".format(PortalNames[evalOnce(TempIterator1)]), 
            PortalLoc[evalOnce(TempIterator1)] + vect(0,1,0), 
            1, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.DEFAULT
        )
 



rule "portal function":
    @Event eachPlayer

    @Condition any([distance(eventPlayer.getPosition() + vect(0,0.2,0),i) < 1.4 for i in PortalLoc]) == true
    @Condition eventPlayer.InvincibleToggle or eventPlayer.CurrentCheckpoint == len(CheckpointPositions) - 1
    
    if PortalDest[
            PortalLoc.index(
               sorted(PortalLoc, lambda i: distance(eventPlayer, i))[0]
            )
       ] != vect(0,0,0):

            eventPlayer.teleport(
            PortalDest[
                    PortalLoc.index(
                    sorted(PortalLoc, lambda i: distance(eventPlayer, i))[0]
                    )
            ] 
            )

/*
rule "Portal 1 -> 2 <---- EDIT ME":
    @Disabled
    @Event eachPlayer
    #Modify vector (0, 0, 0) to start teleport position
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #Modify "-1" to the number of levels of the portal checkpoint
    @Condition (eventPlayer.CurrentCheckpoint == -1 or eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1) == true

    #Modify the vector (0, 0, 0) to the position where the teleport ends
    eventPlayer.teleport(vect(0, 0, 0))
    #If you don't want to find the coordinates, send it directly to checkpoint 0
    eventPlayer.teleport(CheckpointPositions[0])

rule "Portal 2 -> 3 <---- EDIT ME":
    @Disabled
    @Event eachPlayer
    #Modify vector (0, 0, 0) to start teleport position
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #Modify "-1" to the number of levels of the portal checkpoint
    @Condition (eventPlayer.CurrentCheckpoint == -1 or eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1) == true

    #Modify the vector (0, 0, 0) to the position where the teleport ends
    eventPlayer.teleport(vect(0, 0, 0))
    #If you don't want to find the coordinates, send it directly to checkpoint 0
    eventPlayer.teleport(CheckpointPositions[0])

rule "Portal 3 -> 1 <---- EDIT ME":
    @Disabled
    @Event eachPlayer
    #Modify vector (0, 0, 0) to start teleport position
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #Modify "-1" to the number of levels of the portal checkpoint
    @Condition (eventPlayer.CurrentCheckpoint == -1 or eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1) == true

    #Modify the vector (0, 0, 0) to the position where the teleport ends
    eventPlayer.teleport(vect(0, 0, 0))
    #If you don't want to find the coordinates, send it directly to checkpoint 0
    eventPlayer.teleport(CheckpointPositions[0])
*/
rule "In world text for certain Checkpoints <---- EDIT ME":
    @Disabled
    createInWorldText(sorted(ListPlayersAtCheckpoints[0]), "Text for checkpoint 0", vect(0, 0, 0), 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    createInWorldText(sorted(ListPlayersAtCheckpoints[1]), "Text for checkpoint 1", vect(0, 0, 0), 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    createInWorldText(sorted(ListPlayersAtCheckpoints[2]), "Text for checkpoint 2", vect(0, 0, 0), 3, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)

rule "HUD text for certain Checkpoints <---- EDIT ME":
    @Disabled
    hudHeader(sorted(ListPlayersAtCheckpoints[0]), "Text for checkpoint 0", HudPosition.TOP, -4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(sorted(ListPlayersAtCheckpoints[1]), "Text for checkpoint 1", HudPosition.TOP, -4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(sorted(ListPlayersAtCheckpoints[2]), "Text for checkpoint 2", HudPosition.TOP, -4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
/*
rule "Portal Effect - Text":
    @Disabled
    @Event eachPlayer

    #Change Vector (0, 0, 0) to starting position of Portal 1-2
    createInWorldText(eventPlayer, "{0}{1}".format(eventPlayer.PortalText, "Send to next target to next map"), vect(276.288, -17.222, -74.522), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW, SpecVisibility.DEFAULT)
    #Change Vector (1, 1, 1) to starting position of Portal 2-3
    createInWorldText(eventPlayer, "{0}{1}".format(eventPlayer.PortalText, "Send to next target to next map"), vect(1, 1, 1), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW, SpecVisibility.DEFAULT)

rule "Portal Effects":
    @Disabled
    #Effects of Portal 1-2
    createEffect(Portal1PlayerList, Effect.RING, Color.LIME_GREEN, vect(0, 0, 0), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 1-2
    createEffect(Portal1PlayerList, Effect.LIGHT_SHAFT, Color.RED, vect(276.288, -17.222, -74.522), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 2-3
    createEffect(Portal2PlayerList, Effect.RING, Color.LIME_GREEN, vect(1, 1, 1), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 2-3
    createEffect(Portal2PlayerList, Effect.LIGHT_SHAFT, Color.RED, vect(1, 1, 1), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 3-1
    createEffect(Portal1PlayerList, Effect.RING, Color.LIME_GREEN, vect(2, 2, 2), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 3-1
    createEffect(Portal1PlayerList, Effect.LIGHT_SHAFT, Color.RED, vect(2, 2, 2), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Change Vector  (0, 0, 0) to starting position of Portal 3-1
    createInWorldText(Portal1PlayerList, "to next map", vect(0, 0, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW, SpecVisibility.DEFAULT)

rule "Enable Portal For Specific CPs <---- EDIT ME":
    @Disabled
    @Event eachPlayer
    #Change "-1" to the number of checkpoints of the checkpoint where the two portals are located
    @Condition (eventPlayer.CurrentCheckpoint == -1 or eventPlayer.CurrentCheckpoint == -1 or eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1) == true

    eventPlayer.PortalText = 1
    #Change "-1" to the number of checkpoints where the first portal is located
    if eventPlayer.CurrentCheckpoint == -1:
        Portal1PlayerList.append(eventPlayer)
        #Change "-2" to the number of checkpoints where the second portal is located
    elif eventPlayer.CurrentCheckpoint == -2:
        Portal2PlayerList.append(eventPlayer)
        #No changes required
    elif eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1:
        Portal2PlayerList.append(eventPlayer)
        Portal1PlayerList.append(eventPlayer)
        eventPlayer.PortalText = 2

rule "Disable Portal For Specific CPs <---- EDIT ME":
    @Disabled
    @Event eachPlayer
    #Modify "-2" to the number of checkpoints after the two portals have been teleported
    @Condition (eventPlayer.CurrentCheckpoint == -2 or eventPlayer.CurrentCheckpoint == -2 or false) == true

    eventPlayer.PortalText = 0
    #Modify the "-2" here to the number of checkpoints after the first portal has passed
    if eventPlayer.CurrentCheckpoint == -2:
        Portal1PlayerList.remove(eventPlayer)
        #Modify the "-2" here to the number of checkpoints after the second portal has passed
    elif eventPlayer.CurrentCheckpoint == -2:
        Portal2PlayerList.remove(eventPlayer)
*/