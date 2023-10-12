rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    A = [vect(-193.265, -91.763, 48.396), vect(-194.36, -89.596, 32.517), vect(-193.174, -94.24, 18.255), vect(-194.195, -87.153, 7.229), vect(-179.485, -87.949, 1.242), vect(-188.221, -87.616, 7.776), vect(-190.079, -84.916, -6.454), vect(-204.606, -91.027, -12.433), vect(-211.002, -91.108, -14.714), vect(-205.942, -94.584, -28.957), vect(-194.154, -89.589, -32.506), vect(-173.808, -89.561, -35.061), vect(-163.376, -89.98, -42.056), [vect(-145.396, -91.977, -63.319), vect(-46.1, 39.704, -86.27)], vect(-46.261, 15, -61.165), vect(-33.731, 21.022, -53.709), vect(-39.369, 11, -36.09), vect(-49.961, 16.721, -35.901), vect(-56.445, 18.117, -20.326), vect(-70.668, 19.147, -0.012), vect(-44.777, 12.852, 0.021), vect(-39.905, 13, 0.025), vect(-24.783, 16.971, 8.934), vect(-24.97, 10, 12.832), [vect(-56.569, 18.142, 20.303), vect(55.339, 132.625, -4.486)], vect(55.339, 130.034, -4.486), vect(55.281, 137.01, -7.048), vect(71.898, 131.688, -24.179), vect(71.503, 132.327, -21.021), vect(70, 132, -2.94), vect(78.144, 128, 0.696), vect(-173.972, -88.105, 0.021)]
    TimeRemaining = 263
    H = [vect(-50.128, 11.151, -27.179)]
    I = [5.7]
    TQ = [vect(-182.096, -86.368, 5.007), vect(-213.325, -88.63, -31.519), vect(-153.374, -84.894, -46.268), vect(-55.71, 14.222, 0.02), vect(-51.856, 21.487, 0.078), vect(-45.629, 19.617, 19.985), vect(56.723, 129.135, -24.02), vect(71.756, 135.788, 0.058), vect(-186.252, -84.934, -38.121), vect(79.791, 128.562, -7.963), vect(-55.053, 18.196, -15.394), vect(-54.645, 21.688, -12.614), vect(-52.049, 27.034, 20.173), vect(-213.423, -87.062, -22.894)]
    EditMode = [0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 10, 10, 0, 0]
    TQ5 = [false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    TQ6 = [false, false, true, false, false, true, true, true, false, false, false, false, false, false]
    BounceToggleLock = [true, true, false, false, true, false, true, true, true, true, false, false, true, true]
    killballnumber = [17]
    pinballnumber = [4, 8, 12, 19, 19, 23, 26, 30, 10, 29, 18, 18, 23, 8]
    LeaderBoardFull = []
    PortalOn = false
    Difficultyhud = 2
/*

rule "Credits here <---- INSERT YOUR NAME HERE":
    hudSubtext(getAllPlayers(), "made by: FishoFire", HudPosition.LEFT, -15, Color.VIOLET, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "map code: 75RRX", HudPosition.LEFT, -14, Color.SKY_BLUE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "Discord: dsc.gg/genjiparkour", HudPosition.LEFT, -13, Color.AQUA, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
*/

rule "Add Dash to Checkpoint <---- EDIT ME":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    wait(2)
    SHIFT = [[], 1, 19, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
    BladeEnabledCheckpoints = [3]

rule "In world text for certain Checkpoints <---- EDIT ME":
    createInWorldText([player for player in getAllPlayers() if player.A == 30], "hint: look up", vect(71.368, 131.21, 0.036), 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA, SpecVisibility.DEFAULT)
    createInWorldText([player for player in getAllPlayers() if player.A == 30], "hi", vect(83.734, 145.208, -0.418), 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.AQUA, SpecVisibility.DEFAULT)

rule "custom portals - data <---- EDIT ME":
    #Portal start position
    CustomPortalStart = [vect(83.734, 145.208, -0.418), vect(81.16, 179.126, -0.082), vect(-50.356, 73, 0.621)]
    #Portal end position (on same number as start position)
    CustomPortalEndpoint = [vect(81.16, 250, -0.082), vect(-50.25, 120, 0.621), vect(-173.972, -59.179, 0.021)]
    #Portal checkpoint (on same number as start position) 
    #999 = apply portal to entire map
    CustomPortalCP = [30, 30, 30]

/*
rule "custom portals - function":
    @Event eachPlayer
    @Condition len(CustomPortalStart) > 0
    @Condition (any([distance(eventPlayer.getPosition() + vect(0, 0.2, 0), player) < 1.1 and CustomPortalCP[i] in [999, eventPlayer.A] for player, i in CustomPortalStart])) == true
    
    eventPlayer.PortalLoop = 0
    for eventPlayer.PortalLoop in range(len(CustomPortalStart)):
        if distance(eventPlayer.getPosition() + vect(0, 0.2, 0), CustomPortalStart[eventPlayer.PortalLoop]) < 1.1 and CustomPortalCP[eventPlayer.PortalLoop] in [999, eventPlayer.A]:
            eventPlayer.teleport(CustomPortalEndpoint[eventPlayer.PortalLoop])
            return
    wait(1)


*/