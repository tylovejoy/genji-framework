#!mainFile "genji.opy"

/*
this gets put on page 1
this should be parts of addons that get toggled with a workshop toggle
*/

rule "<tx0C00000000001344> Addon Functions <tx0C00000000001344>":
    @Delimiter

rule "Pre-set control map portal | function | toggled via workshop":
    @Event eachPlayer
    @Condition PortalOn
    @Condition eventPlayer.InvincibleToggle or not eventPlayer.NotOnLastCp
    @Condition len(PortalLoc) != null
    @Condition any([distance(eventPlayer.getPosition() + vect(0,0.2,0),i) < 1.4 for i in PortalLoc])
    if PortalDest[PortalLoc.index(sorted(PortalLoc, lambda i: distance(eventPlayer, i))[0])] != vect(0,0,0):
        eventPlayer.teleport(
            PortalDest[PortalLoc.index(sorted(PortalLoc, lambda i: distance(eventPlayer, i))[0])]
        )

rule "Custom portals | function":
    @Event eachPlayer
    @Condition len(eventPlayer.PortalStart_Cache) > 0
    @Condition [i for i in eventPlayer.PortalStart_Cache if distance(i, eventPlayer.getPosition() + vect(0,0.2,0)) < portalDistance]
    #@Condition any([distance(eventPlayer.getPosition() + vect(0, 0.2, 0), ent) < portalDistance for ent in eventPlayer.PortalStart_Cache]) == true

    eventPlayer.teleport(
        eventPlayer.PortalEnd_cache[eventPlayer.PortalStart_Cache.index(sorted([i for i in eventPlayer.PortalStart_Cache],lambda x: distance(eventPlayer,x))[0])
        ]
    )
    wait(0.4)

rule "Pre-set control map portal | toggled on via workshop settings":
    @Condition PortalOn
    wait(0.5, Wait.ABORT_WHEN_FALSE) # overwrite pasta
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

    elif getCurrentMap() == Map.ANTARCTIC_PENINSULA:
        PortalNames = ["labs", "icebreaker", "Sublevel", "icebreaker", "labs", "Sublevel"]
        PortalLoc = [vect(280.66, -12.15, -223.65), vect(273.27, 42.74, 198.15), vect(266.58, 42.74, 198.17), vect(-58.29, -154, 63.03), vect(-58.36, -154, 56.47), vect(287.08, -12.15, -223.59)]
        PortalDest = [vect(270, 42.7, 190.44), vect(284.07, -12.75, -216.15), vect(-53.51, -154.5, 60.08), vect(284.07, -12.75, -216.15), vect(270, 42.7, 190.44), vect(-53.51, -154.5, 60.08)]

    elif getCurrentMap() == Map.SAMOA:
        PortalNames = ["beach","volcano", "downtown", "volcano", "beach","downtown"  ]
        PortalLoc = [vect(231.98, 7.23, -262.84), vect(236.78, 7.23, -262.75), vect(-327.59, 3.6, -108.69), vect(-332.71, 3.6, -108.59), vect(25.4, 341, 354.38), vect( 30, 341, 354.34)     ]
        PortalDest = [vect(-329.86, 3.05, -103.4), vect(27.59, 339.76, 348.77), vect( 234.07, 6.12, -266.88), vect(27.59, 339.76, 348.77), vect(-329.86, 3.05, -103.4), vect( 234.07, 6.12, -266.88)   ]

    else:
        PortalDest = null
        PortalLoc = null
        PortalNames = null
        return

/*
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
        case Map.SAMOA:
            MapVectorArray = [vect(-328.19, 90.5, -103.11), vect(233.75, 71.95, -258.42), vect(26.93, 428.04, 336.34)]
            break
        default:
            if strContains( "{}".format(getCurrentMap()) , "{}".format(Map.LIJIANG_TOWER)): # lunar new year catch
                MapVectorArray = [vect(-5.808, 324.398, 282.523), vect(-0.414, 156.197, 148.681), vect(-0.381, 53.736, -33.335)]
            elif strContains( "{}".format(getCurrentMap()) ,"{}".format(Map.BUSAN)): # lunar new year catch
                MapVectorArray = [vect(51.885, 37.172, -113.654), vect(-329.934, 56.136, 149.839), vect(227.21, 43.353, 252.64)]
            else:  # This default covers almost every map
                MapVectorArray = [vect(73, 62, -17), vect(169, 62, 82), vect(-23, 62, -124), vect(-23, 62, 100)]
            break
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
*/


# decrease to make it wait more often if you have load problems, keep at full int numbers no floats
#!define fence_delay 3
# proejctile size, 30 is maximum possible atm
#!define fence_proj_size 30
# gridsize of 16 means a 16x16 grid with the point in the center
#!define fence_grid 16
# calculation to find the side of the map
#!define fence_offset vect( (fence_grid*fence_proj_size)/2, 0, (fence_grid*fence_proj_size)/2 )
# calculation for next explosion
#!define fence_position  MapVectorArray[1] - fence_offset + ( MapVectorArray[0] % fence_grid ) * vect(fence_proj_size,00,00) + floor( MapVectorArray[0] / fence_grid ) * vect(00,00,fence_proj_size)

rule "Little destructo - fence breaker":
    # Made by FishoFire version 1.0
    # wait to overwrite any from copy pastas
	wait(0.032)
    # first entry will act as index, rest is the points themselves
    MapVectorArray = [0]
    # flag mode = both flag points, just incase
    # tdm/dm = first spawn points, the maps are not big so it just covers entire map. all teams defaults to team 1 spawn
    # push: payload and cp 0 are set but rest isnt. normal payload maps have more then 1 point.
    # rest of maps have up to 3 points
    MapVectorArray.append(
        [getFlagPosition(Team.1), getFlagPosition(Team.2)] if getCurrentGamemode() == Gamemode.CTF else
        getSpawnPoints(Team.ALL)[0] if getCurrentGamemode() in [Gamemode.TDM, Gamemode.FFA] else
        getPayloadPosition() if getPayloadPosition() != null and getObjectivePosition(1) == vect(0,0,0) and getObjectivePosition(2) == vect(0,0,0) else
        [getObjectivePosition(0),getObjectivePosition(1),getObjectivePosition(2)]
    )
    # explode in a grid around the selected points
    while len(MapVectorArray) > 1:
        MapVectorArray[0] = 0
        while MapVectorArray[0] < (fence_grid*fence_grid):
            createProjectile(
                Projectile.ORB,  # the only orb available without fx extension
                getAllPlayers(),
                fence_position ,
                Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.HEAL, Team.1, 0, 0, fence_proj_size,
                DynamicEffect.GOOD_EXPLOSION, # possible without extensions: bad, good, ring
                DynamicEffect.EXPLOSION_SOUND, # possible without extensions: explosion sound, buf sound, ring explosion sound
                1, 1, 0, 0, 0, 0
            )

            MapVectorArray[0] ++
            if MapVectorArray[0] % fence_delay == 0: # use modulo to only wait every x orbs keep the 0 change the other number
                wait()

        del MapVectorArray[1]

    # handle exceptions (looking at you new queen street)
    MapVectorArray = [vect(8.276, 4.113, 15.261), vect(-8.319, 2.624, 14.245), vect(0.006, 4.821, 18.513)]
    while len(MapVectorArray) > 0:
        # same as other projectile before
        createProjectile(
            Projectile.ORB,
            getAllPlayers(),
            MapVectorArray[0],
            Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.HEAL, Team.1, 0, 0, fence_proj_size,
            DynamicEffect.GOOD_EXPLOSION,
            DynamicEffect.EXPLOSION_SOUND,
            1, 1, 0, 0, 0, 0
        )
        del MapVectorArray[0]
        wait()

    MapVectorArray = null

rule "Poll jump and crouch inputs for spectators":
    @Event playerJoined
    wait()
    eventPlayer.HUDInputs = vect(eventPlayer.isHoldingButton(Button.JUMP),eventPlayer.isHoldingButton(Button.CROUCH),false)
    goto RULE_START

def CheckMap():
    @Name "SUB | Basic Map Validator"
    if len(CheckpointPositions) <= 1: return
    createDummy(Hero.ANA, Team.1 if getNumberOfSlots(Team.1) < getNumberOfSlots(Team.2) else Team.2, -1, CheckpointPositions[0], null)
    MapChecker = getLastCreatedEntity()
    MapChecker.disableEnvironmentCollision(false)
    MapChecker.disablePlayerCollision()
    MapChecker.setStatusEffect(null, Status.PHASED_OUT, Math.INFINITY)
    MapChecker.setInvisibility(Invis.ALL)
    MapChecker.startScalingSize(cpcircleradius / 0.45, false)
    MapChecker.setGravity(Math.INFINITY)
    waitUntil(MapChecker.hasSpawned(), Math.INFINITY)

    for MapCheckerIter in range(1, len(CheckpointPositions)):
        if nearestWalkablePosition(CheckpointPositions[MapCheckerIter]) and distance(CheckpointPositions[MapCheckerIter], nearestWalkablePosition(CheckpointPositions[MapCheckerIter])) > cpcircleradius:
            MapChecker.startForcingPosition(raycast(CheckpointPositions[MapCheckerIter] + Vector.UP * cpcircleradius,CheckpointPositions[MapCheckerIter] +
                Vector.DOWN * cpcircleradius, [], [], false).getHitPosition(), true)
            wait(7 * 0.016)
            MapChecker.stopForcingPosition()
            waitUntil(MapChecker.isOnGround(), true)
            if MapChecker.isOnGround() and distance(MapChecker, CheckpointPositions[MapCheckerIter]) <= cpcircleradius:
                goto lbl_MapChecker_nextCp

            for MapChecker.Temp in range(cpcircleradius, cpcircleradius - 0.2, -0.2):
                MapChecker.startForcingPosition(CheckpointPositions[MapCheckerIter] + Vector.UP * MapChecker.Temp,true)
                wait(7 * 0.016)
                MapChecker.stopForcingPosition()
                waitUntil(MapChecker.isOnGround(), true)
                if MapChecker.isOnGround() and distance(MapChecker, CheckpointPositions[MapCheckerIter]) <= cpcircleradius:
                    goto lbl_MapChecker_nextCp
                    
            enableInspector()
            printLog("Fail {0}".format(MapCheckerIter))
            disableInspector()
        lbl_MapChecker_nextCp:

    destroyDummy(MapChecker.getTeam(), MapChecker.getSlot())
    MapChecker = null
    MapCheckerIter = null
    enableInspector()
    printLog("■■■■■■■■■■■■■■■■■■■■■■■■")
    disableInspector()
