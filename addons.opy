#!mainFile "genji.opy"


rule "-------------------------------------------Addons-------------------------------------------------------":



rule "Add Blade to Checkpoint":
    @Disabled
    #Change "-1" to certain Checkpoints' number. For example if you want to add Blade to Checkpoint 2 and 6 change one of "-1" to 2 and other "-1" to 6
    Dao__ = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]



rule "Add Dash to Checkpoint":
    @Disabled
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    SHIFT__ = [[], -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

rule "Portal 1-2":
    @Disabled
    @Event eachPlayer
    #Modify vector (0, 0, 0) to start teleport position
    @Condition distance(eventPlayer, vect(0, 0, 0)) <= 1.4
    #Modify "-1" to the number of levels of the portal level
    @Condition (eventPlayer.A__ == -1 or eventPlayer.A__ >= len(A__) - 1) == true

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
    @Condition (eventPlayer.A__ == -1 or eventPlayer.A__ >= len(A__) - 1) == true

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
    @Condition (eventPlayer.A__ == -1 or eventPlayer.A__ >= len(A__) - 1) == true

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
    createInWorldText(eventPlayer, "{{0}}".format(eventPlayer.H), vect(276.288, -17.222, -74.522), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW, SpecVisibility.DEFAULT)
    #Change Vector (1, 1, 1) to starting position of Portal 2-3
    createInWorldText(eventPlayer, "{{0}}".format(eventPlayer.H), vect(1, 1, 1), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW, SpecVisibility.DEFAULT)

rule "Portal Effects":
    @Disabled
    #Effects of Portal 1-2
    createEffect(F, Effect.RING, Color.LIME_GREEN, vect(0, 0, 0), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 1-2
    createEffect(F, Effect.LIGHT_SHAFT, Color.RED, vect(276.288, -17.222, -74.522), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 2-3
    createEffect(G, Effect.RING, Color.LIME_GREEN, vect(1, 1, 1), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 2-3
    createEffect(G, Effect.LIGHT_SHAFT, Color.RED, vect(1, 1, 1), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 3-1
    createEffect(F, Effect.RING, Color.LIME_GREEN, vect(2, 2, 2), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Effects of Portal 3-1
    createEffect(F, Effect.LIGHT_SHAFT, Color.RED, vect(2, 2, 2), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Change Vector  (0, 0, 0) to starting position of Portal 3-1
    createInWorldText(F, "to next map", vect(0, 0, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.YELLOW, SpecVisibility.DEFAULT)

rule "开启传送门视野—————————— 特定关卡时开启 ————————————":
    @Disabled
    @Event eachPlayer
    #将“-1”分别改为两个传送门所在关卡的关卡数
    @Condition (eventPlayer.A == -1 or eventPlayer.A == -1 or eventPlayer.A >= len(A) - 1) == true

    eventPlayer.H = 1
    #将“-1”修改为第一个传送门所在的关卡数
    if eventPlayer.A == -1:
        F.append(eventPlayer)
        #将“-2”修改为第二个传送门所在的关卡数
    elif eventPlayer.A == -2:
        G.append(eventPlayer)
        #无需更改
    elif eventPlayer.A >= len(A) - 1:
        G.append(eventPlayer)
        F.append(eventPlayer)
        eventPlayer.H = 2

rule "关闭传送门视野—————————— 特定关卡时关闭 ————————————":
    @Disabled
    @Event eachPlayer
    #将“-2”分别修改为两个传送门传送过去后的关卡数
    @Condition (eventPlayer.A == -2 or eventPlayer.A == -2 or false) == true

    eventPlayer.H = 0
    #将此处的“-2”修改为第一个传送门传送过去之后的关卡数
    if eventPlayer.A == -2:
        F.remove(eventPlayer)
        #将此处的“-2”修改为第二个传送门传送过去之后的关卡数
    elif eventPlayer.A == -2:
        G.remove(eventPlayer)
