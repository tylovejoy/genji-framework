rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    #======= Checkpoint data ==========================
    #		Checkpoints positions - Vector(123.456,123.456,123.456) - The order is the checkpoint number.  The first Vector here is checkpoint 0
    A = [vect(104, 1, -1), vect(85.75, 7.87, -5.14), vect(78, 2, 7), vect(100, -0.67, -5), vect(74.04, -2, -0.95), vect(73.5, 2.26, -4.75), vect(53.76, 4.4, -29.95), vect(30.42, 2.52, -13.65), vect(-23.93, -1, -18.63), vect(-5.97, 3, -57.62), vect(-15.46, 1, -96.18), vect(-18.94, 9, -72.29), vect(19.57, 4.35, -40.9), vect(35.84, 3, -77.47), vect(-10.25, 7, -27.82), vect(60.43, 1.21, -15.12), vect(41.87, 6, -0.46)]
    #======= killballs ==========================
    #		Killball level number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    killballnumber = [7, 7, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 12, 12, 12, 13, 14, 14, 15, 15]
    #killball positions - Vector(123.456,123.456,123.456)
    H = [vect(2.93, 8, -10.75), vect(-17, 4, 24.21), vect(-18.57, -1, -86), vect(-16.54, 9.35, -90.08), vect(2.53, -2.12, -76.66), vect(-16.74, -1, -74.08), vect(3.17, 1.49, -59.53), vect(-2.43, 0.17, -53.95), vect(14.68, 4, -74), vect(5.66, 8.76, -60.77), vect(7.4, -1.22, -65.69), vect(-25.9, 1, -70.94), vect(31.34, 1.66, -45.47), vect(31.63, 1.78, -54.14), vect(25.23, 1.95, -59.63), vect(-15, -1, -35), vect(49.66, 6.01, 7.6), vect(62.98, -0.61, 7.45), vect(57.77, 10.11, -12.98), vect(56.75, 0.88, 4.93)]
    #killball radius - Vector(123.456,123.456,123.456)
    I = [5, 5, 5, 5, 5, 5, 2.2, 1.5, 5, 3.2, 5, 5, 5.9, 4.2, 5, 5, 5, 0.8, 5, 5]
    #======= orbs ==========================
    #		orb checkpoint number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    pinballnumber = [5, 9, 13, 13, 15]
    #orb position - Vector(123.456,123.456,123.456)
    TQ = [vect(54.19, 2, -28.75), vect(13.25, 3.64, -88.07), vect(-22.35, 2.76, -59.42), vect(3.25, -0.72, -37.56), vect(42.43, 0.21, -8.59)]
    #orb bounce strength - Number 123.456 - default bounce is 10 - 0 means dont bounce
    EditMode = [1, 0, 0, 0, 0]
    #orb gives ult - True or False
    TQ5 = [false, false, false, true, true]
    #orb gives dash - True or False
    TQ6 = [false, false, false, false, false]
    #orb locks checkpoint - True or False
    BounceToggleLock = [false, true, true, false, false]

