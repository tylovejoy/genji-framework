
if (x == 0){
    x = `#!define editorordata #\n #!define selectedmap "workshopChamber"\n#!define editoron true`

} else {
    datafiles = {
    1: "test-maps/krdata.opy", // kigns row
    2: "test-maps/hollydata.opy", // hollywood kami
    3: "test-maps/route.opy", // fries route, ez
    4: "test-maps/minimap.opy", // really small workshop map to test leaderboard
    5: "test-maps/hanamura.opy", // 100 cp hana kami
    6: "test-maps/busan.opy",// super short busan to test portals
    7: "test-maps/testinghana.opy", // from BDRQ4 the test map they build us
    8: "test-maps/cp1skipbug.opy" // the map data that sometimes skips cp 1 on reseting when people spec you
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

