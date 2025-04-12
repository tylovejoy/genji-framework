
rule "Checkpoint | Position <---------------------------------------------------------------------------- paste here!":
    # 0zh5n 
    A = [vect(72.475, 4.801, -5.682), vect(62.87, 6.088, -1.882), vect(-32.184, 1, -70.053), vect(-5.208, 4.01, -64.39), vect(18.176, 2, 20.107), vect(53.333, 2.62, -13.419), vect(-6.785, 8, -11.097), vect(24.945, 3.399, -80.163), vect(-1.274, 7, -91.956), [vect(-20.483, 4, -57.567), vect(62.95, 0.617, 6.339)], vect(-18.265, 9.187, -92.044)]
    H = [vect(56.497, 4.315, 14.525), vect(31.711, 6.985, 15.61), vect(11.623, 11.222, 20.804), vect(-10.628, -0.409, -16.394), vect(-24.863, 3.28, -70.993), vect(0.693, 6.016, -58.225), vect(-9.978, 1.061, -13.45), vect(34.967, 2.452, -9.393), vect(12.93, 4.703, -48.86), vect(16.472, -1.423, -32.452), vect(15.411, 5.894, -73.136), vect(14.898, 4.944, -79.676), vect(0.57, 5.972, -58.336), vect(0.276, 5.932, -58.774), vect(25.113, 2.955, -75.168)]
    I = [1.1, 2.8, 8.7, 2.3, 2.9, 2.4, 5, 3.5, 7.5, 1, 1.4, 3.4, 1.6, 1.9, 2.7]
    TQ = [vect(-17.144, -2.08, -5.85), vect(44.654, 5.825, 13.923), vect(44.788, 1.882, -75.245), vect(3.132, 1.294, 34.732), vect(6.703, 7.512, -3.855), vect(46.178, -0.104, -8.624)]
    EditMode = [0, 0, 0, 0, 0, 0]
    TQ5 = [true, true, true, true, true, true]
    TQ6 = [false, false, false, false, false, false]
    killballnumber = [1, 1, 1, 1, 2, 2, 3, 4, 6, 6, 8, 7, 8, 7, 6]
    pinballnumber = [1, 4, 6, 3, 9, 5]
    BanDead = true
    MsDestructo = []
    kaxiaotiao = true


rule "Add Blade to Checkpoint":
    #Change "-1" to certain Checkpoints' number. For example if you want to add Blade to Checkpoint 2 and 6 change one of "-1" to 2 and other "-1" to 6
    Dao = [[], 1, 6, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]




/*
bug instructions:
step 1) load the instance alone
step 2) go to cp 1
step 3) press restart run

the run should now restart on cp 1 instead of cp 2

- if you reach cp 1, then touch ground before pressing reset, it doesnt happen
    - ground touch only maters before u press reset run, it stops mathering after the bug happened
- u do not have to press reset instandly, u can wait, aslong as u dont walk off the cp
- skiping to next cp with fishocheat rmoves it

- it doesnt happen on the original fw
- sometimes it doesnt work, something can prevent this bug from trigering
- turning off ground reset prevents hte bug
- arrived runs when you get to cp 1 via this bug, unlike normal reset
- u seem to fall further on the buged cp

conclusion:
the ground reset rule somehow trigers after landing on cp 0 and puts you on cp 1

*/
