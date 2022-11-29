
rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    #======= Checkpoint data ==========================
    #		Checkpoints positions - Vector(123.456,123.456,123.456) - The order is the checkpoint number.  The first Vector here is checkpoint 0
    A = [vect(63.75, 62.57, 67.73), vect(64.08, 49.75, 70.05), vect(65.23, 49.76, 61.96), vect(68.82, 31.08, 39.96), [vect(81.27, 1.7, 52.19), vect(17.43, 1.38, -67.97)], vect(29.87, -0.25, -64.04), vect(41.69, 5.75, -67.08), vect(60.67, -0.25, -73.67), vect(54.07, 3.74, -86.11), vect(39.16, 5.75, -86.08), vect(33.72, 5.76, -86.07), vect(33.86, 5.75, -78.17), vect(43.6, 5.75, -53.31), [vect(39.99, 2.11, -31.93), vect(59.11, 0.09, -8)], vect(72.78, 2.97, -5.13), vect(91, -0.57, 1.6), vect(108.35, -1.25, -3.48), vect(99.48, -1.25, -14.59), vect(110.04, 5.75, -14.5), vect(109.55, 5.75, -26.84), vect(83.56, 3.75, -24.5), vect(77.45, 3.75, -23.91), vect(66.85, 4.75, -20.5), [vect(50.51, 4.75, -24.71), vect(-10.17, -0.25, -61.79)], vect(-2, 5.76, -59.29), vect(-2.15, 5.75, -48.37), vect(-0.54, 5.75, -42.93), vect(10.28, -0.25, -46.94), vect(-14.01, 5.75, -50.32), vect(-13.77, -1.25, -50.1), vect(-25.52, -1.25, -61.8), vect(-41.19, -1.25, -60.98), vect(-13.82, 1.56, -62.23), vect(-10.5, 5.75, -78.23), vect(-41.01, 2.74, -88.22), vect(-36.51, 4.75, -82.47), vect(-36.13, 4.75, -77.25), vect(-54.92, -1.25, -66.71), vect(-34.95, -1.25, -33.66), [vect(-11.69, -1.25, -21.36), vect(-15.67, 2.75, -89.13)], vect(-8.27, 1.75, -99.65), vect(-7.44, 1.75, -112.91), [vect(-27.68, 1.75, -115.66), vect(-57.13, 65, -117.49)], vect(-57.13, 48.24, -117.49)]
    #======= killballs ==========================
    #		Killball level number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    killballnumber = [11, 41]
    #killball positions - Vector(123.456,123.456,123.456)
    H = [vect(37.86, 5.97, -69.18), vect(-19.66, 5.31, -115.34)]
    #killball radius - Vector(123.456,123.456,123.456)
    I = [5.1, 5]
    #======= orbs ==========================
    #		orb checkpoint number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    pinballnumber = [19, 21, 26, 26, 31, 34, 34, 37, 37, 38, 40]
    #orb position - Vector(123.456,123.456,123.456)
    TQ = [vect(106.72, 10.37, -30.31), vect(68.82, 5.18, -15.21), vect(2.11, 10.5, -46.26), vect(5.48, 12, -35.22), vect(-27.65, 6.51, -60.96), vect(-47.68, 9.65, -89.16), vect(-31.28, 12.41, -87.18), vect(-65.81, 3.89, -54.54), vect(-54.52, 4.38, -41.5), vect(-13.33, 2.97, -36.64), vect(-3.92, 2.14, -106.56)]
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

rule "Addon | Add Blade to Checkpoint <---- EDIT ME":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Blade to Checkpoint 2 and 6 change one of "-1" to 2 and other "-1" to 6
    wait(1)
    Dao = [32]


rule "Addon | Add Dash to Checkpoint <---- EDIT ME":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    wait(1)
    SHIFT = [11, 14, 27, 33, 37]


rule "Addon | Title Data <---- EDIT ME":
    #checkpoint number
    TitleData[0] = [0, 6, 13, 20, 33, 43]
    #title
    TitleData[1] = ["afraid of heights", "bunny", "mario", "ninja", "spiderman", "Rialto Royalty"]
    #color
    TitleData[2] = [Color.LIME_GREEN, Color.GREEN, Color.RED, Color.PURPLE, Color.ORANGE, Color.ROSE]


rule "Addon | HUD text for certain Checkpoints <---- EDIT ME":
    wait(0.5)
    #in CpHudText fill in text
    # in CpHudCp fill in the at wich to display
    # the example fill shows a text for cp 1 and cp 3
    CpHudText = [" Some checkpoints are locked untill you collect orange orbs. ", " Ultimate gives movement speed, this also makes you climb slightly higher. "]
    CpHudCp = [19, 32]


rule "Addon | In world text for certain Checkpoints <---- EDIT ME":
    wait(0.5)
    #in CpIwtText fill in text
    # in CpIwtCp fill in cp at wich to display
    # in CpIwtPos fill in the vector
    # the example fill shows a text for cp 1 and cp 3
    CpIwtText = ["Super mario pipe"]
    CpIwtCp = [12]
    CpIwtPos = [vect(39.99, 3.11, -31.93)]
    #color is for all, not per cp
    CpIwtColor = Color.LIME_GREEN



