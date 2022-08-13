rule "Checkpoint | Position <---------------------------------------------------------------------------- paste here!":
    #BDRQ4 
    A = [vect(2.694, 7.01, -93.904), vect(13.393, 9.008, -87.702), vect(10.784, 4, -71.517), [vect(-17.424, 9.181, -91.497), vect(13.025, 7.069, -48.986)], vect(13.257, -1.918, -36.016), vect(13.408, -0.983, -11.116), vect(26.249, 0, 4.704), vect(23.763, 2, 21.772), vect(9.9, -1.145, 34.633), vect(1.165, 3.963, 22.685), vect(-11.155, 3.875, 22.315), vect(-14.425, 3.831, 14.037), vect(-16.29, -0.296, -5.542), vect(-10.131, 1.006, -12.838), vect(-16.314, -1.161, -24.714)]
    H = [vect(-5.657, 5.664, -80.063), vect(-8.539, 2.54, -76.794)]
    I = [5, 5]
    TQ = [vect(8.903, 8.832, -82.709), vect(9.32, 5.229, -76.429), vect(4.495, 8.524, -85.94)]
    EditMode = [9.9, 10, 0]
    TQ5 = [false, false, true]
    TQ6 = [false, false, true]
    killballnumber = [1, 2]
    pinballnumber = [1, 1, 2]
    MsDestructo = [null]


rule "Add Blade to Checkpoint":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Blade to Checkpoint 2 and 6 change one of "-1" to 2 and other "-1" to 6
    Dao = [[], 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]


rule "Add Dash to Checkpoint":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Dash to Checkpoint 7 and 1 change one of "-1" to 7 and other "-1" to 1
    SHIFT = [[], 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]


