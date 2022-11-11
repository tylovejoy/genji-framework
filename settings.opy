#!mainFile "genji.opy"

settings {
    "main": {
        "description": "  ~ The Official Genji Parkour Editor ~\nCode: 54CRY\nAdapted by: nebula#11571/FishoFire#2431",
        "modeName": "Genji Parkour v1.7"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "enableMatchVoiceChat": true,
        "spectatorSlots": 3,
        "team1Slots": 11,
        "team2Slots": 0,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                #"workshopChamber"
                selectedmap
            ]
        },
        "tdm": {
            "enabledMaps": [],
            "gameLengthInMn": 15,
            "enableMercyRezKillCancel": false,
            "enableSelfInitiatedRespawn": false
        },
        "general": {
            "enableHeroSwitching": false,
            "enableEnemyHealthBars": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableKillCam": false,
            "enableKillFeed": false,
            "respawnTime%": 0,
            "spawnHealthPacks": "disabled",
            "enableRandomHeroes": true,
        }
    },
    "heroes": {
        "allTeams": {
            #"dva": {
                #"enableSpawningWithUlt": true
                #"spawnWithoutMech": true
            #},
            "genji": {
                "enableAbility2": false,
                "enableInfiniteAmmo": true,
                "enableSpawningWithUlt": true,
                "ability1Cooldown%": 0,
                "ultDuration%": 25,
                "passiveUltGen%": 500,
                "ultGen%": 500
            },
            "enabledHeroes": [
                "genji"
            ]
        }
    }
}

# extensions

#!extension playMoreEffects
##!extension spawnMoreDummyBots



enum HO:
    # Left #####################
    data_name = -200,
    data_code,
    data_dsc,
    edit_savemap,
    
    game_timer,
    game_bhop,
    game_climb,

    edit_orblimit,
    edit_selecteddata,
    edit_orb_ult,
    edit_orb_dash,
    edit_orb_lock,



    leftend,
    # Top #####################
    edit_clearec1,
    edit_clearec2,
    edit_clearec3,

    comp_info,
    comp_instructtop,
    comp_instruct1,
    comp_instruct2,
    comp_instruct3,
    comp_instruct4,
    comp_instructbottom,

 
    edit_changemode,
    edit_host_mode,
    data_dif,
    game_level_orb,



    filler_custommsg,
    add_custommsg1,
    add_custommsg2,
    add_custommsg3,

    board_header,
    board_display1,
    board_display2,
    board_display3,
    board_display4,


    fillermain, # push skirmish etc down
    topend,
    # Right #####################
    data_remaingtime,
    


    com_restart_n_board,
    com_invincible,
    com_quickres,
    com_spec,
    com_invis,
    com_traces,

    com_practice,
    com_practicesub,
    com_preview,
    com_previewsub,

    edit_instructions_general,
    edit_instructions_edit,

    board_top5,

    wr,

    rightend,
    # End #####################

