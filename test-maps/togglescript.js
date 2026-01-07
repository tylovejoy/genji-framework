//editortoggle(x){
    if (x == 0){
        x = ('#!define testData #\n ' +
            '#!define skirmishMap ["workshopChamber"]\n' +
            '#!define tdmMap [] \n' +
            '#!define editorDefaultOn true\n')

    } else {
        data = {
        1: "1basic.opy",
        2: "1basic.opy",
        3: "1quicktest.opy", // spot free to pur temporary maps in
        4: "hollydata.opy", // 1W8FF -  Kami - hollywood 
        5: "route.opy", // 4QETZV - FRENCHFRIES - route 
        6: "minimap.opy", // tiny 3 cp workshop map by me
        7: "hanamura.opy", // RF0B8 - Kami - 100 cp hana
        8: "busan.opy",// portal test map by me
        9: "testinghana.opy", // BDRQ4 - genji community - framework test map
        10: "cp1skipbug.opy", // 0zh5n - the map data that sometimes skips cp 1 on reseting when people spec you
        11: "lavamap.opy", // some lava and balls
        12: "bounce_demo.opy", // bounce demo - fisho - no original code but uploaded to X05Y0 on new fw
        13: "bounce_heaven.opy",
        14: "bug_reload_completcp.opy", // bug were you can complete a cp by reloading while not standing on the ground
        15: "dashstart.opy", // dash start not banned
        16: "fisho_nepal.opy", // fisho's nepal map
        17: "fishodorado.opy", // my dorado
        18: "bounces_close.opy",
        19: "routetest.opy",
        20: "rialtofisho.opy", // my rialto
        21: "2cpmulti.opy", // 2 cp multi
        22: "generaltest.opy",
        23: "bandoublejump.opy", // lulledlion's map
        24: "nooter_midtown.opy"
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
        23: ["","lijiangNightMarket"],
        24: "midtown",
        }[x]

        if (Array.isArray(selectedmap)) {
            selectedmap = [(selectedmap[0] === "" ? "" : '"' + selectedmap[0] + '"'), '"' + selectedmap[1] + '"']
        }
        else {
            selectedmap = ['"' + selectedmap + '"', ""]
        }

        x = ('#!define testData ' +
            '#!include "test-maps/'+ data + '"\n'+
            '#!define skirmishMap [' + selectedmap[0] + ']\n' +
            '#!define tdmMap [' + selectedmap[1] + ']\n' +
            '#!define editorDefaultOn false\n')
    }
//return x}