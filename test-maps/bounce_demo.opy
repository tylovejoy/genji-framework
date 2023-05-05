#!mainFile "../genji.opy"
rule "map data":
    A = [vect(-17.69, 5.751, -6.316), vect(-19.215, 1.604, -2.942), vect(-25.806, 7.75, 6.224), vect(-19.266, 1.603, -3.742), vect(-21.164, 7.75, 10.458), vect(-7.202, 1.603, -5.04)]
    H = []
    I = []
    TQ =  [vect(-22.432, 1.728, 2.299), vect(-22.697, 1.604, 2.242),
         vect(-22.145, 10.089, 4.736), vect(-15.769, 1.604, -0.011), 
         vect(-14.888, 1.603, 6.332), vect(-16.746, 1.604, 12.353), vect(-23.739, 7.75, 15.329), 
         vect(-16.835, 5.926, 4.55), vect(-12.778, 2, -0.068), vect(-12.778, 11, -0.068), vect(-12.8, 7, -0.068)]
    EditMode = [15, 10, 0, 10, 10, 10, 0, 0, 17, -12.1, 0]
    TQ5 = [false, false, false, false, false, false, false, false, false, false, false]
    TQ6 = [false, false, true, false, false, false, false, false, false, false, false]
    BounceToggleLock = [false, false, true, false, true, false, true, true, false, false, true]
    killballnumber = []
    pinballnumber = [1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4]
    LeaderBoardFull = []

