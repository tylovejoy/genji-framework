#!mainFile "framework.opy"

/*
this gets put on page 1
this should be parts of addons that get toggled with a workshop toggle
*/

rule "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Addon Functions ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒":
    @Delimiter

rule "Addon | AFK Timer":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isMoving() == false
    @Condition eventPlayer.isCommunicatingEmote() == false
    @Condition EditorOn == false
    wait(300, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.addon_toggle3rdPov:
        eventPlayer.addon_toggle3rdPov = false
    eventPlayer.setStatusEffect(null, Status.ASLEEP, Math.INFINITY)
    # raycast to prevent camera stuck on low wall
    eventPlayer.startCamera(raycast(eventPlayer.getPosition(), eventPlayer.getPosition() + 4 * Vector.UP, null, null, false).getHitPosition() + Vector.DOWN, eventPlayer.getPosition(), 10)
    wait(1) # cancel it after jumping or not sleep, reset cures sleep
    waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or not eventPlayer.hasStatusEffect(Status.ASLEEP), Math.INFINITY)
    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.stopCamera()
    if eventPlayer.checkpoint_notLast and not eventPlayer.toggle_invincible:
        CheckpointFailReset()
    if RULE_CONDITION: goto RULE_START

rule "Addon | Pre-set control Map Portal - Toggle Via Workshop Settings":
    @Event eachPlayer
    @Condition PortalLoc != null
    @Condition eventPlayer.toggle_invincible or not eventPlayer.checkpoint_notLast
    @Condition PortalLoc.any(tuple: distance(CAE, eventPlayer.getPosition() + 0.2 * Vector.UP) < portalDistance)
    eventPlayer.teleport(sorted(PortalDest, tuple: distance(eventPlayer, PortalLoc[CAI]))[0])

rule "Addon | Custom Portals":
    @Event eachPlayer
    @Condition len(eventPlayer.cache_portalStart) != null
    @Condition eventPlayer.cache_portalStart.any(tuple: distance(CAE, eventPlayer.getPosition() + 0.2 * Vector.UP) < portalDistance)
    eventPlayer.teleport(sorted(eventPlayer.cache_portalEnd, tuple: distance(eventPlayer, eventPlayer.cache_portalStart[CAI]))[0])
    wait(0.512)

rule "Addon | Preset Control Map Portal - Toggle Via Workshop Settings":
    @Condition createWorkshopSettingBool(SettingsText.MapCategory, SettingsText.Map_Portals, true, 3)
    #wait(LoadOrder.portal) # overwrite pasta
    # {name: "", start: end: }, # 
    if getCurrentMap() == Map.BUSAN:
        splitDictArray({name: PortalNames, start: PortalLoc, end: PortalDest},[
            {name: "Sanctuary", start: vect(47.946, 7.248, -93.922),    end: vect(-328.552, 10.01, 120.82)}, # Downtown
            {name: "MEKA Base", start: vect(55.921, 6.998, -94.024),    end: vect(221.152, 9.376, 238.765)}, # Downtown
            {name: "Downtown",  start: vect(-326.382, 10.81, 117.261),  end: vect(52.197, 6.301, -97.513)},  # Sanctuary
            {name: "MEKA Base", start: vect(-330.96, 10.81, 117.416),   end: vect(221.271, 9.431, 238.978)}, # Sanctuary
            {name: "Sanctuary", start: vect(219.567, 10.215, 243.653),  end: vect(-328.601, 10.01, 120.823)},# MEKA Base
            {name: "Downtown",  start: vect(225.976, 10.227, 240.799),  end: vect(52.197, 6.299, -97.513)}]) # MEKA Base
    elif getCurrentMap() == Map.ILIOS:
        splitDictArray({name: PortalNames, start: PortalLoc, end: PortalDest},[
            {name: "Ruins",      start: vect(325.722, -22.665, -40.401), end: vect(28.375, 57.659, -161.195)},  # Lighthouse
            {name: "Well",       start: vect(327.43, -22.665, -36.089),  end: vect(-200.464, 1.306, -8.604)},   # Lighthouse
            {name: "Lighthouse", start: vect(26.176, 58.367, -156.415),  end: vect(333.088, -23.389, -40.933)}, # Ruins
            {name: "Well",       start: vect(30.472, 58.367, -156.307),  end: vect(-200.464, 1.306, -8.604)},   # Ruins
            {name: "Lighthouse", start: vect(-199.945, 2.015, -2.918),   end: vect(333.088, -23.389, -40.933)}, # Well
            {name: "Ruins",      start: vect(-194.93, 2.015, -8.054),    end: vect(28.375, 57.829, -161.195)}]) # Well
    elif getCurrentMap() == Map.LIJIANG_TOWER or getCurrentMap() == Map.LIJIANG_TOWER_LNY:
        splitDictArray({name: PortalNames, start: PortalLoc, end: PortalDest},[
            {name: "Garden",         start: vect(-2.815, 271, 295.373),   end: vect(0.286, 94.292, 140.396)},  # Control Center
            {name: "Night Market",   start: vect(2.905, 271, 295.052),    end: vect(0.584, -0.709, -54.469)},  # Control Center
            {name: "Control Center", start: vect(5.788, 95.056, 135.298), end: vect(0.245, 270.292, 301.428)}, # Garden
            {name: "Night Market",   start: vect(-5.343, 95.05, 134.638), end: vect(0.773, -0.708, -54.361)},  # Garden
            {name: "Control Center", start: vect(-2.738, 0, -61.911),     end: vect(0.245, 270.292, 301.428)}, # Night Market
            {name: "Garden",         start: vect(5.043, 0, -61.879),      end: vect(0.286, 94.292, 140.396)}]) # Night Market
    elif getCurrentMap() == Map.NEPAL:
        splitDictArray({name: PortalNames, start: PortalLoc, end: PortalDest},[
            {name: "Shrine",  start: vect(-194.732, -92.86, -3.802), end: vect(-40.19, 13.292, -0.105)},  # Village
            {name: "Sanctum", start: vect(-194.585, -92.86, 4.187),  end: vect(78.43, 128.292, 0.149)},   # Village
            {name: "Village", start: vect(-33.165, 14, 5.212),       end: vect(-190.54, -93.569, 0.122)}, # Shrine
            {name: "Sanctum", start: vect(-33.058, 14, -5.55),       end: vect(78.43, 128.292, 0.149)},   # Shrine
            {name: "Village", start: vect(84.75, 129.008, -3.624),   end: vect(-190.54, -93.569, 0.122)}, # Sanctum
            {name: "Shrine",  start: vect(84.534, 129, 4.032),       end: vect(-40.19, 13.292, -0.105)}]) # Sanctum
    elif getCurrentMap() == Map.OASIS:
        splitDictArray({name: PortalNames, start: PortalLoc, end: PortalDest},[
            {name: "Gardens",     start: vect(-211.137, 20, -5.084),     end: vect(134.366, 7.829, -240.53)},  # University
            {name: "City Center", start: vect(-211.346, 20, 5.029),      end: vect(158.27, 11.814, 262.272)},  # University
            {name: "University",  start: vect(143.061, 8.377, -245.04),  end: vect(-206.269, 19.292, 0.103)},  # Gardens
            {name: "City Center", start: vect(139.333, 8.377, -249.964), end: vect(158.283, 11.814, 262.283)}, # Gardens
            {name: "Gardens",     start: vect(157.297, 12.522, 255.759), end: vect(134.318, 7.829, -240.667)}, # City Center
            {name: "University",  start: vect(151.452, 12.522, 261.099), end: vect(-206.269, 19.292, 0.103)}]) # City Center
    elif f"{__getCurrentMap__()}" == Map.SAMOA:
        splitDictArray({name: PortalNames, start: PortalLoc, end: PortalDest},[
            {name: "Beach",    start: vect(231.98, 7.23, -262.84), end: vect(-329.86, 3.05, -103.4)},  # Downtown
            {name: "Volcano",  start: vect(236.78, 7.23, -262.75), end: vect(27.59, 339.76, 348.77)},  # Downtown
            {name: "Downtown", start: vect(-327.59, 3.6, -108.69), end: vect(234.07, 6.12, -266.88)},  # Beach
            {name: "Volcano",  start: vect(-332.71, 3.6, -108.59), end: vect(27.59, 339.76, 348.77)},  # Beach
            {name: "Beach",    start: vect(25.4, 341, 354.38),     end: vect(-329.86, 3.05, -103.4)},  # Volcano
            {name: "Downtown", start: vect(30, 341, 354.34),       end: vect(234.07, 6.12, -266.88)}]) # Volcano
/*
    elif false: # getCurrentMap() == Map.ANTARCTIC_PENINSULA:
        PortalNames = ["Labs", "Icebreaker", "Sublevel", "Icebreaker", "Labs", "Sublevel"]
        splitDictArray({name: PortalNames, start: PortalLoc, end: PortalDest},[
            {name: "Labs",       start: vect(280.66, -12.15, -223.65), end: vect(270, 42.7, 190.44)},       # Sublevel
            {name: "Icebreaker", start: vect(273.27, 42.74, 198.15),   end: vect(284.07, -12.75, -216.15)}, # Sublevel
            {name: "Sublevel",   start: vect(266.58, 42.74, 198.17),   end: vect(-53.51, -154.5, 60.08)},   # Labs
            {name: "Icebreaker", start: vect(-58.29, -154, 63.03),     end: vect(284.07, -12.75, -216.15)}, # Labs
            {name: "Labs",       start: vect(-58.36, -154, 56.47),     end: vect(270, 42.7, 190.44)},       # Icebreaker
            {name: "Sublevel",   start: vect(287.08, -12.15, -223.59), end: vect(-53.51, -154.5, 60.08)}])  # Icebreaker
*/
rule "Ms. Destructo | Destroys Breakable Objects On All Maps":
    # Credit: nebula#11571
    @Condition false
    @Condition isGameInProgress()
    MsDestructo = []  # Multiple bots
    waitUntil(getAllPlayers().any(tuple: CAE.hasSpawned()), Math.INFINITY)
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
            if strContains("{}".format(getCurrentMap()), "{}".format(Map.LIJIANG_TOWER)): # lunar new year catch
                MapVectorArray = [vect(-5.808, 324.398, 282.523), vect(-0.414, 156.197, 148.681), vect(-0.381, 53.736, -33.335)]
            elif strContains("{}".format(getCurrentMap()), "{}".format(Map.BUSAN)): # lunar new year catch
                MapVectorArray = [vect(51.885, 37.172, -113.654), vect(-329.934, 56.136, 149.839), vect(227.21, 43.353, 252.64)]
            else: # This default covers almost every map
                MapVectorArray = [vect(73, 62, -17), vect(169, 62, 82), vect(-23, 62, -124), vect(-23, 62, 100)]
            break
    for DestructoIter in range(len(MapVectorArray)):
        createDummy(Hero.DVA, getAllPlayers().filter(tuple: CAE.hasSpawned() and not CAE.isDummy())[0].getTeam(), 20 - evalOnce(DestructoIter), evalOnce(MapVectorArray[evalOnce(DestructoIter)]), vect(0, 0, 0))
        MsDestructo[evalOnce(DestructoIter)] = getLastCreatedEntity()
        MsDestructo[evalOnce(DestructoIter)].startScalingSize(20, true)
        wait(0)
        MsDestructo[evalOnce(DestructoIter)].setGravity(0)
        MsDestructo[evalOnce(DestructoIter)].applyImpulse(Vector.UP, 1, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        MsDestructo[evalOnce(DestructoIter)].teleport(evalOnce(MapVectorArray[evalOnce(DestructoIter)]))
        wait(1)
        MsDestructo[evalOnce(DestructoIter)].disableEnvironmentCollision(true)
        wait(0)
        MsDestructo[evalOnce(DestructoIter)].setUltEnabled(true)
        wait(0)
        MsDestructo[evalOnce(DestructoIter)].setUltCharge(100)
        wait(0)
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

macro fence_delay = 3 # decrease to make it wait more often if you have load problems, keep at full int numbers no floats
macro fence_proj_size = 30 # projectile size, 30 is maximum possible atm
macro fence_grid = 16 # gridsize of 16 means a 16x16 grid with the point in the center
rule "Addon | Little Destructo - Fence Breaker":
    # Made by FishoFire version 1.0
	wait(LoadOrder.destructo) # wait to overwrite any from copy pastas
    # flag mode = both flag points, just incase
    # tdm/dm = first spawn points, the maps are not big so it just covers entire map. all teams defaults to team 1 spawn
    # push: payload and cp 0 are set but rest isnt. normal payload maps have more then 1 point.
    # rest of maps have up to 3 points
    MapVectorArray.append(
        [getFlagPosition(Team.1), getFlagPosition(Team.2)] if getCurrentGamemode() == Gamemode.CTF else
        getSpawnPoints(Team.ALL)[0] if getCurrentGamemode() in [Gamemode.TDM, Gamemode.FFA] else
        getPayloadPosition() if getPayloadPosition()[0] and not (getObjectivePosition(1) + getObjectivePosition(2)) else
        [getObjectivePosition(0), getObjectivePosition(1), getObjectivePosition(2)])
    # explode in a grid around the selected points
    while len(MapVectorArray) > 1:
        MapVectorArray[0] = 0
        while MapVectorArray[0] < (fence_grid * fence_grid):
            createProjectile(
                Projectile.ORB,  # the only orb available without fx extension
                null,
                # calculation for next explosion
                MapVectorArray.last() - (vect(fence_grid * fence_proj_size, 0, fence_grid * fence_proj_size) / 2) + (MapVectorArray[0] % fence_grid) *
                    (Vector.LEFT * fence_proj_size) + floor(MapVectorArray[0] / fence_grid) * (Vector.FORWARD * fence_proj_size),
                Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.HEAL, Team.1, 0, 0, fence_proj_size,
                DynamicEffect.GOOD_EXPLOSION, # possible without extensions: bad, good, ring
                DynamicEffect.EXPLOSION_SOUND, # possible without extensions: explosion sound, buf sound, ring explosion sound
                1, 1, 0, 0, 0, 0)
            MapVectorArray[0]++
            if not (MapVectorArray[0] % fence_delay): # use modulo to only wait every x orbs keep the 0 change the other number
                wait(0)
        del MapVectorArray[1]

    # handle exceptions (looking at you new queen street)
    MapVectorArray = [vect(8.276, 4.113, 15.261), vect(-8.319, 2.624, 14.245), vect(0, 4.821, 18.513)]
    while len(MapVectorArray):
        # same as other projectile before
        createProjectile(
            Projectile.ORB,
            null,
            MapVectorArray[0],
            Vector.DOWN, Relativity.TO_WORLD, ModifyHealth.HEAL, Team.1, 0, 0, fence_proj_size,
            DynamicEffect.GOOD_EXPLOSION,
            DynamicEffect.EXPLOSION_SOUND,
            1, 1, 0, 0, 0, 0)
        del MapVectorArray[0]
        wait(0)
    MapVectorArray = null

rule "Addon | Caching Jump & Crouch Inputs For Spectators":
    @Event playerJoined
    wait(0)
    eventPlayer.cache_inputs = vect(eventPlayer.isHoldingButton(Button.JUMP), eventPlayer.isHoldingButton(Button.CROUCH), false)
    goto RULE_START

def Addon3rdPerson():
    @Name "Addon | SUB 3rd Person Camera"
    if eventPlayer.addon_toggle3rdPov:
        eventPlayer.startCamera(updateEveryTick(
            raycast(0.5 * Vector.UP + eventPlayer.getEyePosition(),
            0.5 * Vector.UP + eventPlayer.getEyePosition() - 3.5 * eventPlayer.getFacingDirection(), [], [], false).getHitPosition() + 0.5 * eventPlayer.getFacingDirection()),
            updateEveryTick(0.5 * Vector.UP + eventPlayer.getEyePosition()), false)
    else:
        eventPlayer.stopCamera()
/*
def AddonCheckMap():
    @Name "Addon | SUB Basic Map Validator"
    if len(CheckpointPositions) <= 1: return
    createDummy(Hero.ANA, Team.1 if getNumberOfSlots(Team.1) < getNumberOfSlots(Team.2) else Team.2, -1, CheckpointPositions[0], null)
    MsDestructo = getLastCreatedEntity()
    MsDestructo.disableEnvironmentCollision(false)
    MsDestructo.setStatusEffect(null, Status.PHASED_OUT, Math.INFINITY)
    MsDestructo.setInvisibility(Invis.ALL)
    MsDestructo.startScalingSize(cpCircleRadius / 0.45, false)
    MsDestructo.setGravity(Math.INFINITY)
    waitUntil(MsDestructo.hasSpawned(), 16) # Not infinity incase dummy does not spawn

    for MsDestructo.checkpoint_current in range(1, len(CheckpointPositions)):
        if nearestWalkablePosition(CheckpointPositions[MsDestructo.checkpoint_current]) and distance(CheckpointPositions[MsDestructo.checkpoint_current], nearestWalkablePosition(CheckpointPositions[MsDestructo.checkpoint_current])) > cpCircleRadius:
            MsDestructo.startForcingPosition(raycast(CheckpointPositions[MsDestructo.checkpoint_current] + Vector.UP * cpCircleRadius, CheckpointPositions[MsDestructo.checkpoint_current] +
                Vector.DOWN * cpCircleRadius, [], [], false).getHitPosition(), true)
            wait(7 * 0.016)
            MsDestructo.stopForcingPosition()
            waitUntil(MsDestructo.isOnGround(), true)
            if MsDestructo.isOnGround() and distance(MsDestructo, CheckpointPositions[MsDestructo.checkpoint_current]) <= cpCircleRadius:
                goto lbl_MsDestructo_nextCp

            for MsDestructo.checkpoint_practice in range(cpCircleRadius, cpCircleRadius - 0.2, -0.2):
                MsDestructo.startForcingPosition(CheckpointPositions[MsDestructo.checkpoint_current] + Vector.UP * MsDestructo.checkpoint_practice,true)
                wait(7 * 0.016)
                MsDestructo.stopForcingPosition()
                waitUntil(MsDestructo.isOnGround(), true)
                if MsDestructo.isOnGround() and distance(MsDestructo, CheckpointPositions[MsDestructo.checkpoint_current]) <= cpCircleRadius:
                    goto lbl_MsDestructo_nextCp

            enableInspector()
            printLog("Fail {0}".format(MsDestructo.checkpoint_current))
            disableInspector()
        lbl_MsDestructo_nextCp:

    MsDestructo.editor_saveCache = EditorOn
    EditorOn = null
    enableInspector()
    printLog("◆ Map Check Complete ◆")
    disableInspector()
    EditorOn = MsDestructo.editor_saveCache
    destroyDummy(MsDestructo.getTeam(), MsDestructo.getSlot())
    MsDestructo = null
*/