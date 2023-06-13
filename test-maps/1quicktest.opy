rule "quicktest data":
     
    A = [vect(7.791, 0, -18.048), vect(0.613, 0, -17.643), vect(-5.895, 0, -17.51), vect(-10.665, 0, -15.097), vect(-3.395, 0, 1.023), vect(8.499, 0, -15.718), vect(-2.204, 0, -15.138), vect(-19.495, 0, -14.991)]
    TimeRemaining = 264
    H = []
    I = []
    Dao = []
    SHIFT = []
    EditSelectIdArray = []
    TQ = [vect(-15.968, 0, -9.815), vect(-16.248, 0, -4.944), vect(-16.448, 4.08, 0.63), vect(-15.631, 0.63, 5.149), vect(0.594, -0.06, 0.758), vect(-7.074, 0.328, -13.705), vect(-8.52, 0.24, -15.177), vect(-15.84, 0.45, -15.007)]
    EditorMoveItem = false
    EditMode = [10, 10, 0, 15, 10, 10, 10, 10]
    TQ5 = [true, false, false, false, false, false, true, false]
    TQ6 = [false, true, false, false, false, false, true, false]
    BounceToggleLock = [false, false, true, false, false, false, false, false]
    killballnumber = []
    pinballnumber = [3, 3, 3, 3, 4, 2, 6, 6]
    LeaderBoardFull = []
    LeaderBoardHuds = []
    LeaderBoardRemake = true
    DashExploitToggle = true
    PortalNames = []
    PortalLoc = []
    PortalDest = []
    PortalOn = false
    Difficultyhud = [0, false]
    CustomPortalStart = [vect(-16.351, 0.84, 12.607), vect(-1.693, 0.42, -14.003), vect(5.346, 0.48, 0.799), vect(15.256, 0.51, 0.353), vect(13.603, 0, -10.641), vect(2.081, 0, -15.366)]
    CustomPortalEndpoint = [vect(-3.462, 10, 1.293), vect(-5.581, 10, -17.052), vect(15.256, 14.5, 0.353), vect(13.497, 11.71, -10.091), vect(8.499, 10, -15.718), vect(-2.473, 10, -15.138)]
    CustomPortalCP = [3, 1, 4, 4, 4, 5]
    CompMode = false
    HudStoreEdit = []
    SaveName = []
    SaveCp = []
    SaveEnt = []
    SaveTimer = []
    SaveElapsed = []
    SavePauseTime = []
    SavePauseEnabled = []
    Cachedcredits = ["name here - 作者", "code here - 代码"]
    BanMulti = []
    BanCreate = []
    BanDead = []
    BanEmote = []
    BanClimb = []
    BanBhop = []


   /*
   SHIFT = [1]
   #======= Checkpoint data ==========================
   #		Checkpoints positions - Vector(123.456,123.456,123.456) - The order is the checkpoint number.  The first Vector here is checkpoint 0
   A = [vect(-6, 0, 0), vect(0, 0, 0), vect(6, 0, 0)]
   #======= killballs ==========================
   #		Killball level number - Number 123 - Number of the checkpoint (in position array starting count with 0)
   killballnumber = []
   #killball positions - Vector(123.456,123.456,123.456)
   H = []
   #killball radius - Vector(123.456,123.456,123.456)
   I = []
   #======= orbs ==========================
   #		orb checkpoint number - Number 123 - Number of the checkpoint (in position array starting count with 0)
   pinballnumber = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
   #orb position - Vector(123.456,123.456,123.456)
   TQ = [vect(15, 1, 0), vect(30, 1, 0), vect(45, 1, 0), vect(45, 15, 0), vect(45, 30, 0), vect(45, 40, 0), vect(45, 50, 0), vect(30, 50, 0), vect(15, 50, 0), vect(0, 50, 0), vect(0, 30, 0), vect(0, -110, 0), vect(-15, 30, 0), vect(-30, 30, 0), vect(-40, 30, -10), vect(-50, 30, 0), vect(-60, 30, 10), vect(-70, 30, 0), vect(-80, 30, 10), vect(-90, 30, 0), vect(-105, 30, 0), vect(-120, 30, 0), vect(-120, 30, 15), vect(-120, 30, 30), vect(-120, 30, 45), vect(-120, 30, 60), vect(-120, 30, 75), vect(-120, 30, 90), vect(-120, 30, 105), vect(-120, 30, 120), vect(-110, 30, 110), vect(-100, 30, 100), vect(-85, 30, 90), vect(-85, 30, 85), vect(-85, 30, 80), vect(-80, 30, 90), vect(-80, 30, 85), vect(-80, 30, 80), vect(-75, 30, 90), vect(-75, 30, 85), vect(-75, 30, 80), vect(-70, 30, 90), vect(-70, 30, 85), vect(-70, 30, 80), vect(-65, 30, 85), vect(-60, 30, 85), vect(-45, 30, 85), vect(-30, 30, 85), vect(-15, 30, 85), vect(-15, -20, 85), vect(0, -20, 85), vect(0, -20, 70), vect(0, -20, 55), vect(0, -20, 40), vect(0, -20, 25), vect(0, 0, 21.5), vect(0, 14, 21.5), vect(0, 28, 21.5), vect(0, 42, 21.5), vect(0, 56, 21.5), vect(0, 70, 21.5), vect(0, 84, 21.5), vect(0, 98, 21.5), vect(0, 106, 14), vect(0, 112, 6), vect(0, 125, 0), vect(0, 125, -15), vect(-15, 125, -15), vect(-30, 125, -15), vect(-30, 125, 0), vect(-30, 125, 15), vect(-30, 125, 30), vect(-15, 125, 30), vect(0, 125, 30), vect(15, 125, 30), vect(30, 125, 30), vect(45, 125, 30), vect(45, 125, 15), vect(45, 125, 0), vect(45, 125, -15), vect(45, 125, -30), vect(45, 125, -45), vect(30, 125, -45), vect(15, 125, -45), vect(0, 125, -45), vect(-15, 125, -45), vect(-30, 125, -45), vect(-45, 125, -45), vect(-60, 125, -45), vect(-60, 125, -30), vect(-60, 125, -15), vect(-60, 125, 0), vect(-60, 125, 15), vect(-60, 125, 30), vect(-60, 125, 45), vect(-60, 125, 60), vect(-60, 125, 75), vect(-45, 125, 75), vect(-30, 125, 75), vect(-15, 125, 75), vect(0, 125, 75), vect(15, 125, 75), vect(30, 125, 75), vect(45, 125, 75), vect(60, 125, 75), vect(75, 125, 75), vect(75, 125, 60), vect(75, 125, 45), vect(75, 125, 30), vect(75, 125, 15), vect(75, 125, 0), vect(75, 125, -15), vect(75, 125, -30), vect(75, 125, -45), vect(75, 125, -60), vect(75, 125, -75), vect(60, 125, -75), vect(45, 125, -75), vect(30, 125, -75), vect(15, 125, -75), vect(0, 125, -75), vect(0, -15, -75), vect(0, -15, -60), vect(0, -15, -45), vect(0, -15, -30), vect(0, -15, -22)]
   #orb bounce strength - Number 123.456 - default bounce is 10 - 0 means dont bounce
   EditMode = [0, 0, 0, 0, 0, 20, 0, 0, 0, -25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, -50, -50, -50, 10, -50, -50, -50, 10, -50, -50, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25]
   #orb gives ult - True or False
   TQ5 = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true]
   #orb gives dash - True or False
   TQ6 = [true, true, true, true, true, false, true, true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
   #orb locks checkpoint - True or False
   BounceToggleLock = [true, true, true, true, true, false, true, true, true, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false]
   #======= others - DONT CHANGE ==========================
   TimeRemaining = 263
   LeaderBoardFull = []
   Difficultyhud = 2
   */