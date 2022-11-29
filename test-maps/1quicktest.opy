rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    #======= Checkpoint data ==========================
    #		Checkpoints positions - Vector(123.456,123.456,123.456) - The order is the checkpoint number.  The first Vector here is checkpoint 0
    A = [vect(0, 0, 0), vect(5, 0, 0), vect(15, 0, 0), vect(5, 0, 0)]
    #======= killballs ==========================
    #		Killball level number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    killballnumber = []
    #killball positions - Vector(123.456,123.456,123.456)
    H = []
    #killball radius - Vector(123.456,123.456,123.456)
    I = []
    #======= orbs ==========================
    #		orb checkpoint number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    pinballnumber = [1, 1, 1]
    #orb position - Vector(123.456,123.456,123.456)
    TQ = [vect(7, 1, 0), vect(10, 1, 0), vect(13, 1, 0)]
    #orb bounce strength - Number 123.456 - default bounce is 10 - 0 means dont bounce
    EditMode = [20, 20, 20]
    #orb gives ult - True or False
    TQ5 = [true, true, true]
    #orb gives dash - True or False
    TQ6 = [true, true, true]
    #orb locks checkpoint - True or False
    BounceToggleLock = [false, false, false]
    #======= others - DONT CHANGE ==========================
    TimeRemaining = 263
    LeaderBoardFull = []
    Difficultyhud = 2

