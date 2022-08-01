
if (x == 0){
    x = `#!define editorordata #\n #!define selectedmap "workshopChamber"\n#!define editoron true`

} else {
    datafiles = {
    1: "test-maps/krdata.opy",
    2: "test-maps/hollydata.opy",
    3: "test-maps/route.opy",
    4: "test-maps/minimap.opy",
    5: "test-maps/hanamura.opy"
    }[x]

    selectedmap = {
    1: "kingsRow",
    2: "hollywood",
    3: "route66",
    4: "workshopChamber",
    5: "hanamura"
    }[x]

    x = '#!define editorordata #!include "'+ datafiles + '"\n #!define selectedmap "' + selectedmap + '"' + '\n #!define editoron false'

}

