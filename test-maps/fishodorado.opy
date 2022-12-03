
rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    #======= Checkpoint data ==========================
    #		Checkpoints positions - Vector(123.456,123.456,123.456) - The order is the checkpoint number.  The first Vector here is checkpoint 0
    A = [vect(34.32, 11.08, -18.09), vect(21.63, 11, -24.43), vect(17.05, 9.54, -4.19), vect(14.05, 9.5, 14.33), vect(17.85, 10, 17.33), vect(36.53, 10.7, 20.78), vect(39.35, 9, 2.86), vect(56.2, 9, 3.25), vect(65.37, 16.44, 4.49), vect(81.07, 17.48, -4.86), vect(99.11, 11.5, -4.37), [vect(108.01, 11, -30.04), vect(129.53, 32.74, -25.08)], vect(124.9, 8.83, 0.43), vect(120.99, 17.93, 10.33), vect(113.46, 18, 37.49), vect(134, 11.05, 32.67), vect(137.24, 11.5, 18.35), vect(120.39, 18.27, 10.84), vect(104.44, 18.04, 20.56), vect(95.89, 12.75, 36.75), vect(90.72, 12.75, 37.84), vect(85.43, 12.75, 37.06), vect(72.6, 17, 39.65), vect(55.13, 13.22, 24.92), vect(32.17, 10.44, 24.62), vect(11.22, 9.5, 20), vect(-2.47, -0.58, 5.54), vect(2.39, 2.77, -0.86), [vect(-6.66, 8, 0.85), vect(-12.58, 9, -8)], vect(-12.58, 8, -8), vect(-33.6, 0, -32.32), [vect(-55.86, 0.68, -8.88), vect(208.45, 32.03, 61.02)], vect(162.65, 10.85, 45.71), vect(172.18, 19, 47.79), vect(185.37, 14.1, 34.46), vect(172.64, 19, 48.35)]
    #======= killballs ==========================
    #		Killball level number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    killballnumber = []
    #killball positions - Vector(123.456,123.456,123.456)
    H = []
    #killball radius - Vector(123.456,123.456,123.456)
    I = []
    #======= orbs ==========================
    #		orb checkpoint number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    pinballnumber = [10, 13, 22, 25, 29, 29, 29, 33, 33, 33]
    #orb position - Vector(123.456,123.456,123.456)
    TQ = [vect(101.62, 13, -8.95), vect(117.03, 18.93, 24.74), vect(69.32, 20, 35.6), vect(-10.99, 20, 12.1), vect(-10.71, 8.2, -17.76), vect(-17.94, 8.2, -24.64), vect(-32.24, 8.2, -35.63), vect(182.61, 39, 41.83), vect(210.55, 30, 34), vect(182.61, 31, 41.83)]
    #orb bounce strength - Number 123.456 - default bounce is 10 - 0 means dont bounce
    EditMode = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    #orb gives ult - True or False
    TQ5 = [false, false, false, false, false, false, false, false, false, false]
    #orb gives dash - True or False
    TQ6 = [true, true, false, false, false, true, false, true, false, false]
    #orb locks checkpoint - True or False
    BounceToggleLock = [true, true, true, true, true, true, true, true, true, true]
    #======= others - DONT CHANGE ==========================
    TimeRemaining = 263
    LeaderBoardFull = []
    Difficultyhud = 2


rule "Add Dash to Checkpoint <---- EDIT ME":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    wait(1.2)
    SHIFT = [[], 13, 15, 25, 30, 33]


rule "Title Data <---- EDIT ME":
    #checkpoint number
    TitleData[0] = [0, 10, 15, 25, 35]
    #title
    TitleData[1] = ["Alpla", "frog", "bunny", "Ninja", "Master"]
    #color
    TitleData[2] = [Color.ROSE, Color.LIME_GREEN, Color.BLUE, Color.ORANGE, Color.RED]



