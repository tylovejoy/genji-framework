rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    #======= Checkpoint data ==========================
    #		Checkpoints positions - Vector(123.456,123.456,123.456) - The order is the checkpoint number.  The first Vector here is checkpoint 0
    A = [vect(53.89, 4.4, -30.04), vect(51.56, -1.02, 4.76), vect(33.21, 0.12, 1.36), vect(-16.64, -1.23, -18.06), vect(-26, 1.19, -54.19), vect(-5.45, 3, -57.99), vect(-0.99, -0.92, -91.92), vect(15.16, 4, -73.76), vect(22.17, 0.43, -40.3), vect(7.21, -0.11, -5.68), vect(14.15, -1.29, 36.64), vect(-15.46, -1.03, -11.09), vect(13, -0.59, -32.48), vect(18.63, -1.95, -67.39), vect(14.01, 4, -74.56), vect(-26.99, 1, -69.93), vect(-22.42, -1.25, -15.53), vect(26.39, 6, 10.46), vect(47.96, 6, -4.9), vect(64.83, -2.02, 10.89), vect(46.09, 6, 7.88), vect(29.21, 10.43, -1.99), vect(17.07, 0, -21.25), vect(-14, 1.03, -35.09), vect(-13.69, -0.64, -6.55), vect(5.86, 8.01, 12.8), vect(47.99, 6, -0.61), vect(30.11, 2.53, -13.49), vect(12.53, 0, -19.45), vect(3.78, 0.49, -38.92), vect(-3.75, 4, -63.8), vect(-24.83, 1, -92.36), vect(10.07, 7.01, -80.94), vect(24.11, -1.72, -46.73), vect(40.58, 2.13, -35.13), vect(27.29, 5.93, -16.98)]
    #======= killballs ==========================
    #		Killball level number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    killballnumber = [18]
    #killball positions - Vector(123.456,123.456,123.456)
    H = [vect(45.57, 6.11, 10.19)]
    #killball radius - Vector(123.456,123.456,123.456)
    I = [10.3]
    #======= orbs ==========================
    #		orb checkpoint number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    pinballnumber = []
    #orb position - Vector(123.456,123.456,123.456)
    TQ = []
    #orb bounce strength - Number 123.456 - default bounce is 10 - 0 means dont bounce
    EditMode = []
    #orb gives ult - True or False
    TQ5 = []
    #orb gives dash - True or False
    TQ6 = []
    #orb locks checkpoint - True or False
    BounceToggleLock = []
    killballnumber = []
    pinballnumber = []
    LeaderBoardFull = []
    LeaderBoardHuds = []
    LeaderBoardRemake = true
    DashExploitToggle = true
    PortalNames = []
    PortalLoc = []
    PortalDest = []
    PortalOn = false
    CustomPortalStart = []
    CustomPortalEndpoint = []
    CustomPortalCP = []
    CompMode = false
    instructiontext = ["Change in Comp Mode instruction message hud 1", "Change in Comp Mode instruction message hud 2", "Change in Comp Mode instruction message hud 2", "Change in Comp Mode instruction message hud 2"]
    HudStoreEdit = []
    SaveName = []
    SaveCp = []
    SaveEnt = []
    SaveTimer = []
    SaveElapsed = []
    SavePauseTime = []
    SavePauseEnabled = []
    Cachedcredits = ["name here - 作者", "code here - 代码"]
    BanTriple = []
    BanMulti = []
    BanCreate = []
    BanDead = []
    BanEmote = []
    BanClimb = []
    BanBhop = []
