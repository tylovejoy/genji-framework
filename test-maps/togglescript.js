
if (x == 0){
    x = `#!define editorordata #\n #!define selectedmap "workshopChamber"\n#!define editoron true\n`

} else {
    datafiles = {
    1: "test-maps/1quicktest.opy", // spot free to pur temporary maps in
    2: "test-maps/hollydata.opy", // 1W8FF -  Kami - hollywood 
    3: "test-maps/route.opy", // 4QETZV - FRENCHFRIES - route 
    4: "test-maps/minimap.opy", // tiny 3 cp workshop map by me
    5: "test-maps/hanamura.opy", // RF0B8 - Kami - 100 cp hana
    6: "test-maps/busan.opy",// portal test map by me
    7: "test-maps/testinghana.opy", // BDRQ4 - genji community - framework test map
    8: "test-maps/cp1skipbug.opy", // 0zh5n - the map data that sometimes skips cp 1 on reseting when people spec you
    9: "test-maps/lavamap.opy", // some lava and balls
    10: "test-maps/bounce_demo.opy", // bounce demo - fisho - no original code but uploaded to X05Y0 on new fw
    11: "test-maps/bounce_heaven.opy",
    12: "test-maps/bug_reload_completcp.opy", // bug were you can complete a cp by reloading while not standing on the ground
    13: "test-maps/dashstart.opy", // dash start not banned
    14: "test-maps/fisho_nepal.opy", // fisho's nepal map
    15: "test-maps/fishodorado.opy", // my dorado
    16: "test-maps/bounces_close.opy",
    17: "test-maps/routetest.opy",
    18: "test-maps/rialtofisho.opy" // my rialto
    }[x]

    selectedmap = {
    1: "antarcticPeninsula", 
    2: "hollywood",
    3: "route66",
    4: "workshopChamber",
    5: "hanamura",
    6: "busan",
    7: "hanamura",
    8: "hanamura",
    9: "busan",
    10: "hollywood",
    11: "workshopChamber",
    12: "hanamura",
    13: "watchpointGibraltar",
    14: "nepal",
    15: "dorado",
    16: "busan",
    17: "route66",
    18: "rialto"
    }[x]

    x = '#!define editorordata #!include "'+ datafiles + '"\n #!define selectedmap "' + selectedmap + '"' + '\n #!define editoron false\n'

}

