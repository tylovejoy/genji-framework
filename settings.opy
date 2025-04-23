#!mainFile "framework.opy"
# code 代码
settings {
    "main": {
        "modeName": "Genji Parkour - 源氏跑酷 - " + versionhere,
        "description": "\n◀ The Official Genji Parkour Editor ▶\nCode: 54CRY\nAdapted by: LulledLion, FishoFire, Nebula\n" + versionhere
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
        },
        "skirmish": {
            "enabled": true,
            "enablePerks": usePerks,
            "enabledMaps": [
                #"workshopChamber"
                selectedmap
            ]
        },
        "tdm": {
            "enabled": true,
            "enablePerks": usePerks,
            "enabledMaps": [
                selectedmap
            ],
            "enableSelfInitiatedRespawn": false
        },
        /*"assault": {
            "enabled": usePerks,
            "enablePerks": false
        },*/
        "bountyHunter": {
            "enabled": usePerks,
            "enablePerks": false
        },
        /*"clash": {
            "enabled": usePerks,
            "enablePerks": false
        },*/
        "ctf": {
            "enabled": usePerks,
            "enablePerks": false
        },
        /*"control": {
            "enabled": usePerks,
            "enablePerks": false
        },*/
        /*"escort": {
            "enabled": usePerks,
            "enablePerks": false
        },*/
        "elimination": {
            "enabled": usePerks,
            "enablePerks": false
        },
        /*"flashpoint": {
            "enabled": usePerks,
            "enablePerks": false
        },*/
        /*"hybrid": {
            "enabled": usePerks,
            "enablePerks": false
        },*/
        "practiceRange": {
            "enabled": usePerks,
            "enablePerks": false
        },
        /*"push": {
            "enabled": usePerks,
            "enablePerks": false
        },*/
    },
    "heroes": {
        "allTeams": {
            "genji": {
                "enableAbility2": false,
                "enableInfiniteAmmo": true,
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