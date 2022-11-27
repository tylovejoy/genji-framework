
rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    #======= Checkpoint data ==========================
    #		Checkpoints positions - Vector(123.456,123.456,123.456) - The order is the checkpoint number.  The first Vector here is checkpoint 0
    A = [vect(2.41, 5.75, -69.33), vect(17.43, 1.38, -67.97), vect(29.87, -0.25, -64.04), vect(41.69, 5.75, -67.08), vect(60.67, -0.25, -73.67), vect(54.07, 3.74, -86.11), vect(39.16, 5.75, -86.08), vect(33.72, 5.76, -86.07), vect(33.86, 5.75, -78.17), vect(43.6, 5.75, -53.31), [vect(39.99, 2.11, -31.93), vect(59.11, 0.09, -8)], vect(72.78, 2.97, -5.13), vect(91, -0.57, 1.6), vect(108.35, -1.25, -3.48), vect(99.48, -1.25, -14.59), vect(110.04, 5.75, -14.5), vect(109.55, 5.75, -26.84), vect(82.1, 3.75, -24.45), vect(77.45, 3.75, -23.91), vect(66.85, 4.75, -20.5), [vect(50.51, 4.75, -24.71), vect(-10.17, -0.25, -61.79)], vect(-2, 5.76, -59.29), vect(-2.15, 5.75, -48.37), vect(-0.54, 5.75, -42.93), vect(10.28, -0.25, -46.94), vect(-14.01, 5.75, -50.32), vect(-13.77, -1.25, -50.1), vect(-25.52, -1.25, -61.8), vect(-41.19, -1.25, -60.98), vect(-13.82, 1.56, -62.23), vect(-10.5, 5.75, -78.23), vect(-41.01, 2.74, -88.22), vect(-36.51, 4.75, -82.47), vect(-36.13, 4.75, -77.25), vect(-54.92, -1.25, -66.71), vect(-34.95, -1.25, -33.66), [vect(-11.69, -1.25, -21.36), vect(-15.67, 2.75, -89.13)], vect(-8.27, 1.75, -99.65), vect(-7.44, 1.75, -112.91), [vect(-27.68, 1.75, -115.66), vect(-57.13, 65, -117.49)], vect(-57.13, 48.24, -117.49)]
    #======= killballs ==========================
    #		Killball level number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    killballnumber = [8, 38]
    #killball positions - Vector(123.456,123.456,123.456)
    H = [vect(37.86, 5.97, -69.18), vect(-19.66, 5.31, -115.34)]
    #killball radius - Vector(123.456,123.456,123.456)
    I = [5.1, 5]
    #======= orbs ==========================
    #		orb checkpoint number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    pinballnumber = [16, 18, 23, 23, 28, 31, 31, 34, 34, 35, 37]
    #orb position - Vector(123.456,123.456,123.456)
    TQ = [vect(106.63, 10.38, -30.53), vect(68.82, 5.18, -15.21), vect(2.11, 10.5, -46.26), vect(5.48, 12, -35.22), vect(-27.65, 6.51, -60.96), vect(-47.68, 9.65, -89.16), vect(-31.28, 12.41, -87.18), vect(-65.81, 3.89, -54.54), vect(-54.52, 4.38, -41.5), vect(-13.33, 2.97, -36.64), vect(-3.92, 2.14, -106.56)]
    #orb bounce strength - Number 123.456 - default bounce is 10 - 0 means dont bounce
    EditMode = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    #orb gives ult - True or False
    TQ5 = [false, false, false, false, false, false, false, false, false, false, false]
    #orb gives dash - True or False
    TQ6 = [false, false, false, false, true, true, false, true, true, true, false]
    #orb locks checkpoint - True or False
    BounceToggleLock = [true, true, true, true, false, true, true, true, true, true, true]
    #======= others - DONT CHANGE ==========================
    TimeRemaining = 263
    LeaderBoardFull = []
    Difficultyhud = 2
    
rule "Add Blade to Checkpoint <---- EDIT ME":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Blade to Checkpoint 2 and 6 change one of "-1" to 2 and other "-1" to 6
    wait(1)
    Dao = [29]


rule "Add Dash to Checkpoint <---- EDIT ME":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    wait(1)
    SHIFT = [8, 11, 24, 30, 34]

rule "Title Data <---- EDIT ME":
    #checkpoint number
    TitleData[0] = [0, 10, 20, 30, 40, 44]
    #title
    TitleData[1] = ["bunny", "jumper", "Ninja", "pro", "expert", "master"]
    #color
    TitleData[2] = [Color.LIME_GREEN, Color.WHITE, Color.YELLOW, Color.ORANGE, Color.PURPLE, Color.RED]


rule "Ban per CP <---- edit me":
    # Enter the checkpoint/level numbers in the lists below to apply the ban on them
    # Remember the workshop toggle overwrites this list
    wait(1.2)
    # ======================
    # ban  triple >
    BanTriple = []
    # ban  multi >
    BanMulti = [12]
    # ban create >
    BanCreate = []
    # ban dedhop >
    BanDead = []
    # ban emote >
    BanEmote = []
    # ban  climb >
    BanClimb = [0]
    # ======================
    # dash exploit (via toggles don't edit)
    DashExploitToggle = createWorkshopSetting(bool, "Ban Switch", "Ban Create Bhop", false, 2)
    
    # ban  bhop >



