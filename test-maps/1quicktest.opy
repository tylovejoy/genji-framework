rule "Map Data     <---- INSERT YOUR MAP DATA HERE":
    #======= Checkpoint data ==========================

   #======= Checkpoint data ==========================
    #		Checkpoints positions - Vector(123.456,123.456,123.456) - The order is the checkpoint number.  The first Vector here is checkpoint 0
    A = [vect(-110.42, 4, -57.84), vect(-90.82, 6.3, -44.97), vect(-90.93, 4, -80.43), vect(-76.7, 7.21, -49), vect(-35.48, 7.75, -44.66), vect(-3.97, 12, -51.46), [vect(34.12, 12.08, -58.94), vect(68.61, 10.28, -72.8)], vect(68.61, 10.28, -72.8), vect(75.35, 6.02, -103.05), vect(104.94, 2.02, -78.95), vect(112.57, 6.95, -57.67), vect(116.78, 13.19, -58.16), vect(144.91, 9.01, -57.99), vect(153.15, 9.98, -29.57), vect(146.81, 7.07, -21.48), vect(120.36, 4.99, -22.02), vect(98.43, 9.09, -18.63), [vect(77.25, 12.82, -57), vect(-2.31, 12, -36.04)], vect(-2.31, 12, -36.04), vect(25.8, 8.18, -30.19), [vect(-3.61, 12, -35.13), vect(-14.69, 12, -23.71)], vect(-14.69, 12, -23.71), vect(-12.6, 10, 8.99), [vect(-14.84, 12, -23.71), vect(31.16, 12.07, -55.03)], vect(31.16, 12.07, -55.03), vect(-3.52, 12, -51.3), vect(1.23, 6, -92.22), vect(-17.72, 9.79, -96.2), vect(-38.45, 6, -79.61), vect(-42.33, 5.99, -47.15), vect(-76.5, 4, -42.63), vect(-114.37, 4, -54.53)]
    #======= killballs ==========================
    #		Killball level number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    killballnumber = [0, 0, 1, 2, 5, 7, 7, 7, 8, 8, 9, 9, 9, 9, 9, 9, 9, 14, 15, 15, 15, 15, 15, 15, 15, 24, 24, 25, 26, 28, 28, 28, 29, 30, 30]
    #killball positions - Vector(123.456,123.456,123.456)
    H = [vect(-98.81, 17.77, -46.06), vect(-92.98, 16.45, -51.56), vect(-84.49, 6.95, -74.85), vect(-89.32, 16.19, -74.3), vect(10.96, 10.05, -51.66), vect(73.53, 9.29, -87.71), vect(80.37, 7.47, -91.77), vect(87.91, 4.52, -95.27), vect(94, 9.07, -91.67), vect(97.38, 7.01, -86.97), vect(103.59, 5.26, -67.27), vect(101.64, 5.19, -64.95), vect(102.47, 4.47, -60.41), vect(105.3, 3.12, -57.29), vect(106.28, 0.21, -55.78), vect(108.13, 0.1, -54.65), vect(109.68, 0.04, -53.58), vect(131.85, 5.01, -15.33), vect(113.92, 7.06, -33.79), vect(115.38, 1.99, -20.93), vect(112.29, 2.21, -20.17), vect(109.02, 2.18, -19.87), vect(105.76, 1.97, -20.08), vect(102.6, 2, -20.84), vect(108.09, 4.54, -24.26), vect(11.58, 7.96, -52.69), vect(10.06, 12.1, -58.08), vect(-4.35, 12, -59.46), vect(-13.49, 6, -91.02), vect(-38.9, 6, -59.45), vect(-38.24, 7, -72.52), vect(-38, 8.77, -70.48), vect(-49.29, 4, -45.34), vect(-103.82, 18.27, -55.32), vect(-98.95, 17.07, -60.16)]
    #killball radius - Vector(123.456,123.456,123.456)
    I = [5, 5, 5, 5, 3.4, 3.4, 5, 5, 5, 5, 5, 5, 5, 3.2, 1.4, 1.4, 1.4, 5, 5, 2.2, 2.2, 2.2, 2.2, 2.2, 5, 4.3, 5, 5, 5, 5, 2.3, 2.4, 3.9, 5, 5]
    #======= orbs ==========================
    #		orb checkpoint number - Number 123 - Number of the checkpoint (in position array starting count with 0)
    pinballnumber = [1, 3, 4, 7, 8, 11, 14, 15, 26, 27, 27, 28]
    #orb position - Vector(123.456,123.456,123.456)
    TQ = [vect(-78.54, 7.22, -65.06), vect(-52.24, 6.35, -43.82), vect(-2.53, 19.96, -55.12), vect(67.91, 14.76, -93.16), vect(79.64, 7.65, -103.11), vect(133.3, 13.36, -69.34), vect(126.63, 8.7, -21.56), vect(100.38, 1.98, -15.75), vect(-7.9, 7.63, -97.22), vect(-24.06, 15.86, -85.87), vect(-35.12, 17.23, -89.84), vect(-42.59, 12.31, -57.58)]
    #orb bounce strength - Number 123.456 - default bounce is 10 - 0 means dont bounce
    EditMode = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    #orb gives ult - True or False
    TQ5 = [false, false, false, false, false, false, false, false, false, false, false, false]
    #orb gives dash - True or False
    TQ6 = [false, false, false, false, false, false, false, false, false, false, false, false]
    #orb locks checkpoint - True or False
    BounceToggleLock = [true, true, true, true, true, true, true, true, true, true, true, true]
