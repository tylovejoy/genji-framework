

rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    #======= Checkpoint data ==========================
    #		Checkpoints positions - Vector(123.456,123.456,123.456) - The order is the checkpoint number.  The first Vector here is checkpoint 0
    A = [vect(51.95, 21.4, -127.24), vect(53.6, 14.5, -118.59), vect(70.27, 10.46, -117.12), vect(62.51, 9.95, -117.46), vect(69.22, 20, -109.88), vect(75.19, 22.75, -109.86), vect(74.9, 22.74, -107.13)]
    #======= killballs ==========================
    #		Killball level number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    killballnumber = []
    #killball positions - Vector(123.456,123.456,123.456)
    H = []
    #killball radius - Vector(123.456,123.456,123.456)
    I = []
    #======= orbs ==========================
    #		orb checkpoint number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    pinballnumber = [0, 1, 1, 1, 2, 2, 3, 4, 5]
    #orb position - Vector(123.456,123.456,123.456)
    TQ = [vect(52.04, 19.35, -122.1), vect(60.13, 17.81, -118.08), vect(64.57, 18.38, -117.79), vect(70.38, 18.79, -117.49), vect(66.88, 11.81, -117.13), vect(66.92, 13.21, -117.12), vect(69.13, 13.37, -112.29), vect(72.76, 20, -112.39), vect(74.67, 26.5, -110.8)]
    #orb bounce strength - Number 123.456 - default bounce is 10 - 0 means dont bounce
    EditMode = [0, 10, 10, 0, 10, 0, 0, 0, 0]
    #orb gives ult - True or False
    TQ5 = [false, false, false, false, false, false, false, false, false]
    #orb gives dash - True or False
    TQ6 = [false, true, false, false, false, false, false, false, false]
    #orb locks checkpoint - True or False
    BounceToggleLock = [true, false, false, true, false, true, true, true, true]
    #======= others - DONT CHANGE ==========================
    TimeRemaining = 263
    LeaderBoardFull = []
    Difficultyhud = 2


