if (x == 0){
    x = `#!define editorordata #!include "editor.opy" \n #!define selectedmap "workshopChamber" `



} else {
    datafiles = {
    1: "test-maps/krdata.opy",
    2: "test-maps/seconddata.opy"

    }[x]

    selectedmap = {
    1: "kingsRow",
    2: "kingsRow"


    }[x]

    x = '#!define editorordata #!include "'+ datafiles + '"\n #!define selectedmap "' + selectedmap + '"'

}

