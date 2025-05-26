if (x == 0){
    x = '#!define testData #\n #!define selectedmap "workshopChamber"\n#!define editoron true\n'

} else {
    datafiles = {
    1: "test-maps/1basic.opy",
    2: "test-maps/1basic.opy",
    3: "test-maps/1quicktest.opy", // spot free to pur temporary maps in
    4: "test-maps/hollydata.opy", // 1W8FF -  Kami - hollywood 
    5: "test-maps/route.opy", // 4QETZV - FRENCHFRIES - route 
    6: "test-maps/minimap.opy", // tiny 3 cp workshop map by me
    7: "test-maps/hanamura.opy", // RF0B8 - Kami - 100 cp hana
    8: "test-maps/busan.opy",// portal test map by me
    9: "test-maps/testinghana.opy", // BDRQ4 - genji community - framework test map
    10: "test-maps/cp1skipbug.opy", // 0zh5n - the map data that sometimes skips cp 1 on reseting when people spec you
    11: "test-maps/lavamap.opy", // some lava and balls
    12: "test-maps/bounce_demo.opy", // bounce demo - fisho - no original code but uploaded to X05Y0 on new fw
    13: "test-maps/bounce_heaven.opy",
    14: "test-maps/bug_reload_completcp.opy", // bug were you can complete a cp by reloading while not standing on the ground
    15: "test-maps/dashstart.opy", // dash start not banned
    16: "test-maps/fisho_nepal.opy", // fisho's nepal map
    17: "test-maps/fishodorado.opy", // my dorado
    18: "test-maps/bounces_close.opy",
    19: "test-maps/routetest.opy",
    20: "test-maps/rialtofisho.opy", // my rialto
    21: "test-maps/2cpmulti.opy", // 2 cp multi
    22: "test-maps/generaltest.opy",
    23: "test-maps/bandoublejump.opy", // lulledlion's map
    24: "test-maps/puzzle.opy", // lulledlion's map
    }[x]

    selectedmap = {
    1: "workshopChamber",
    2: "workshopIsland",
    3: "lijiangTower",//"workshopChamber",// "antarcticPeninsula", 
    4: "hollywood",
    5: "route66",
    6: "workshopChamber",
    7: "hanamura",
    8: "busan",
    9: "hanamura",
    10: "hanamura",
    11: "busan",
    12: "hollywood",
    13: "workshopChamber",
    14: "hanamura",
    15: "watchpointGibraltar",
    16: "nepal",
    17: "dorado",
    18: "busan",
    19: "route66",
    20: "rialto",
    21: "workshopChamber",
    22: "workshopChamber",
    23: "lijiangNightMarket",
    24: "hanamura",
    }[x]

    x = '#!define testData #!include "'+ datafiles + '"\n #!define selectedmap "' + selectedmap + '"' + '\n #!define editoron false\n'
}

