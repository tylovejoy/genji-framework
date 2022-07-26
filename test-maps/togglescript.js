if (x == 0){
    x = `#!define editorordata #!include "editor.opy" \n #!define selectedmap "workshopChamber" `



} else {
    datafiles = {
    1: "test-maps/krdata.opy",
    2: "test-maps/hollydata.opy"

    }[x]

    selectedmap = {
    1: "kingsRow",
    2: "hollywood"


    }[x]

    x = '#!define editorordata #!include "'+ datafiles + '"\n #!define selectedmap "' + selectedmap + '"'

}

