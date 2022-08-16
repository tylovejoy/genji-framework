
if (x == 0){
    x = `#!define editorordata #\n #!define selectedmap "workshopChamber"\n#!define editoron true`

} else {
    datafiles = {
    1: "test-maps/krdata.opy", // 7JXAM - Vertigo - kings row
    2: "test-maps/hollydata.opy", // 1W8FF -  Kami - hollywood 
    3: "test-maps/route.opy", // 4QETZV - FRENCHFRIES - route 
    4: "test-maps/minimap.opy", // tiny 3 cp workshop map by me
    5: "test-maps/hanamura.opy", // RF0B8 - Kami - 100 cp hana
    6: "test-maps/busan.opy",// portal test map by me
    7: "test-maps/testinghana.opy", // BDRQ4 - genji community - framework test map
    8: "test-maps/cp1skipbug.opy" // 0zh5n - the map data that sometimes skips cp 1 on reseting when people spec you
    }[x]

    selectedmap = {
    1: "kingsRow",
    2: "hollywood",
    3: "route66",
    4: "workshopChamber",
    5: "hanamura",
    6: "busan",
    7: "hanamura",
    8: "hanamura"
    }[x]

    x = '#!define editorordata #!include "'+ datafiles + '"\n #!define selectedmap "' + selectedmap + '"' + '\n #!define editoron false'

}

