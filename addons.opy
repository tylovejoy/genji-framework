#!mainFile "genji.opy"

rule "-------------------------------------------Addons-------------------------------------------------------":
    @Delimiter
    @Disabled


rule "Add Blade to Checkpoint":
    @Disabled
    #Change "-1" to certain Checkpoints' number. For example if you want to add Blade to Checkpoint 2 and 6 change one of "-1" to 2 and other "-1" to 6
    BladeEnabledCheckpoints = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]



rule "Add Dash to Checkpoint":
    @Disabled
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    DashEnabledCheckpoints = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

rule "Portal 1-2":
    @Disabled
    @Event eachPlayer
    #Modify vector (0, 0, 0) to start teleport position
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #Modify "-1" to the number of levels of the portal level
    @Condition (eventPlayer.CurrentCheckpoint == -1 or eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1) == true

    #Modify the vector (0, 0, 0) to the position where the teleport ends
    eventPlayer.teleport(vect(0, 0, 0))
    #If you don't want to find the coordinates, send it directly to level 0
    eventPlayer.teleport(CheckpointPositions[0])

rule "Portal 2-3":
    @Disabled
    @Event eachPlayer
    #Modify vector (0, 0, 0) to start teleport position
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #Modify "-1" to the number of levels of the portal level
    @Condition (eventPlayer.CurrentCheckpoint == -1 or eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1) == true

    #Modify the vector (0, 0, 0) to the position where the teleport ends
    eventPlayer.teleport(vect(0, 0, 0))
    #If you don't want to find the coordinates, send it directly to level 0
    eventPlayer.teleport(CheckpointPositions[0])

rule "Portal 3-1":
    @Disabled
    @Event eachPlayer
    #Modify vector (0, 0, 0) to start teleport position
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #Modify "-1" to the number of levels of the portal level
    @Condition (eventPlayer.CurrentCheckpoint == -1 or eventPlayer.CurrentCheckpoint >= len(CheckpointPositions) - 1) == true

    #Modify the vector (0, 0, 0) to the position where the teleport ends
    eventPlayer.teleport(vect(0, 0, 0))
    #If you don't want to find the coordinates, send it directly to level 0
    eventPlayer.teleport(CheckpointPositions[0])

rule "In world text for certain Checkpoints":
    @Disabled
    createInWorldText(sorted(ListPlayersAtCheckpoints[0]), "Text for checkpoint 0", vect(0, 0, 0), 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    createInWorldText(sorted(ListPlayersAtCheckpoints[1]), "Text for checkpoint 1", vect(0, 0, 0), 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)
    createInWorldText(sorted(ListPlayersAtCheckpoints[2]), "Text for checkpoint 2", vect(0, 0, 0), 3, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.DEFAULT)

rule "HUD text for certain Checkpoints":
    @Disabled
    hudHeader(sorted(ListPlayersAtCheckpoints[0]), "Text for checkpoint 0", HudPosition.TOP, -4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(sorted(ListPlayersAtCheckpoints[1]), "Text for checkpoint 1", HudPosition.TOP, -4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(sorted(ListPlayersAtCheckpoints[2]), "Text for checkpoint 2", HudPosition.TOP, -4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

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

rule "Open the portal view ——————————— Open in a specific checkpoint ————————————":
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

rule "Close the portal view ——————————— Close in certain checkpoints ————————————":
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
