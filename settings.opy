#!mainFile "framework.opy"
# code 代码
settings {
    "main": {
        "modeName": f"Genji Parkour - 源氏跑酷 - v{versionhere}",
        "description": f"\n\n\n◀ The Official Genji Parkour Editor ▶\nCode: 54CRY\nAdapted by: LulledLion, FishoFire, Nebula\nv{versionhere}"
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
             #"workshopChamber"
            "enabledMaps": skirmishMap
        },
        "tdm": {
            "enabled": true,
            "enablePerks": usePerks,
            "enabledMaps": tdmMap,
            "enableSelfInitiatedRespawn": false
        },
        /*"assault": {
            "enabled": false,
            "enablePerks": usePerks
        },*/
        "bountyHunter": {
            "enabled": false,
            "enablePerks": usePerks
        },
        /*"clash": {
            "enabled": false,
            "enablePerks": usePerks
        },*/
        "ctf": {
            "enabled": false,
            "enablePerks": usePerks
        },
        /*"control": {
            "enabled": false,
            "enablePerks": usePerks
        },*/
        /*"escort": {
            "enabled": false,
            "enablePerks": usePerks
        },*/
        "elimination": {
            "enabled": false,
            "enablePerks": usePerks
        },
        /*"flashpoint": {
            "enabled": false,
            "enablePerks": usePerks
        },*/
        /*"hybrid": {
            "enabled": false,
            "enablePerks": usePerks
        },*/
        "practiceRange": {
            "enabled": false,
            "enablePerks": usePerks
        },
        /*"push": {
            "enabled": false,
            "enablePerks": usePerks
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