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
                "passiveUltGen%": 0,
                "ultGen%": 10
            },
            "enabledHeroes": [
                "genji"
            ]
        }
    }
}

# extensions

#!extension playMoreEffects
#!extension spawnMoreDummyBots





