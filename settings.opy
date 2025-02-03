#!mainFile "genji.opy"
# code 代码
settings {
    "main": {
        "modeName": "Genji Parkour - 源氏跑酷 - v" + versionhere,
        "description": "My Fun Map\n◀ The Official Genji Parkour Editor ▶\nCode: 54CRY\nAdapted by: LulledLion, FishoFire, Nebula\nv" + versionhere
        #"description": "  ~ The Official Genji Parkour Editor ~\nCode: 54CRY\nAdapted by: LulledLion#1133 FishoFire#2431 nebula#11571",
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "enableMatchVoiceChat": false,
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
            "enabledMaps": [
                selectedmap
            ],
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
            "genji": {
                "enableAbility2": false,
                "enableInfiniteAmmo": true,
                #"enableSpawningWithUlt": true,
                "ability1Cooldown%": 1,
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

#extensions
#!extension spawnMoreDummyBots
#!extension playMoreEffects