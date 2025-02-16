
if (x == 0){
    x = `#!define editorordata #\n #!define selectedmap "workshopChamber"\n#!define editoron true\n`

} else {
    datafiles = {
    1: "test-maps/1basic.opy",
    2: "test-maps/1quicktest.opy", // spot free to pur temporary maps in
    3: "test-maps/hollydata.opy", // 1W8FF -  Kami - hollywood 
    4: "test-maps/route.opy", // 4QETZV - FRENCHFRIES - route 
    5: "test-maps/minimap.opy", // tiny 3 cp workshop map by me
    6: "test-maps/hanamura.opy", // RF0B8 - Kami - 100 cp hana
    7: "test-maps/busan.opy",// portal test map by me
    8: "test-maps/testinghana.opy", // BDRQ4 - genji community - framework test map
    9: "test-maps/cp1skipbug.opy", // 0zh5n - the map data that sometimes skips cp 1 on reseting when people spec you
    10: "test-maps/lavamap.opy", // some lava and balls
    11: "test-maps/bounce_demo.opy", // bounce demo - fisho - no original code but uploaded to X05Y0 on new fw
    12: "test-maps/bounce_heaven.opy",
    13: "test-maps/bug_reload_completcp.opy", // bug were you can complete a cp by reloading while not standing on the ground
    14: "test-maps/dashstart.opy", // dash start not banned
    15: "test-maps/fisho_nepal.opy", // fisho's nepal map
    16: "test-maps/fishodorado.opy", // my dorado
    17: "test-maps/bounces_close.opy",
    18: "test-maps/routetest.opy",
    19: "test-maps/rialtofisho.opy", // my rialto
    20: "test-maps/2cpmulti.opy", // 2 cp multi
    21: "test-maps/generaltest.opy",
    22: "test-maps/bandoublejump.opy"
    }[x]

    selectedmap = {
    1: "workshopIsland",
    2: "lijiangTower",//"workshopChamber",// "antarcticPeninsula", 
    3: "hollywood",
    4: "route66",
    5: "workshopChamber",
    6: "hanamura",
    7: "busan",
    8: "hanamura",
    9: "hanamura",
    10: "busan",
    11: "hollywood",
    12: "workshopChamber",
    13: "hanamura",
    14: "watchpointGibraltar",
    15: "nepal",
    16: "dorado",
    17: "busan",
    18: "route66",
    19: "rialto",
    20: "workshopChamber",
    21: "workshopChamber",
    22: "lijiangNightMarket"
    }[x]

    x = '#!define editorordata #!include "'+ datafiles + '"\n #!define selectedmap "' + selectedmap + '"' + '\n #!define editoron false\n'

}

