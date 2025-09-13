#!mainFile "framework.opy"
#!extension spawnMoreDummyBots
#!extension playMoreEffects

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

enum SettingsText:
    BanCategory = "Ban (All Levels) ◆ 封禁(应用于所有关卡) ◆ 금지 (모든 레벨에 적용)",
        BanMultiClimb = "Ban MultiClimb ◆ 封禁蹭留 ◆ 무한 벽타기 금지",
        BanCreateBhop = "Ban CreateBhop ◆ 封禁卡小 ◆ 콩콩이 생성 금지",
        BanStandCreate = "Ban StandCreate ◆ 封禁站卡 ◆ 서서 콩콩이 생성 금지",
        BanDeathBhop = "Ban DeathBhop ◆ 封禁死小 ◆ 죽음 콩콩이 금지",
        BanEmote = "Ban Emote Savehop ◆ 封禁表情留小 ◆ 감정표현 콩콩이 금지",
        BanSaveDouble = "Ban Save Double ◆ 封禁留二段跳 ◆ 이단점프 킵 금지",
        BanWallClimb = "Ban WallClimb ◆ 封禁爬墙 ◆ 벽타기 금지",
        RequireBhop = "Require Bhop Available ◆ 留小跳进点 ◆ 도착 시 콩콩이 필요",
        RequireDjump = "Require Djump Available ◆ 留二段跳进点 ◆ 도착 시 이단 점프 필요",

    MapCategory = "Map Settings ◆ 地图设置 ◆ 맵 설정",
        MapEditor = "Editor Mode ◆ 作图模式 ◆ 수정 모드",
        MapDifficulty = "Difficulty (Display Hud) ◆ 难度 (顶部hud) ◆ 난이도 (HUD 디스플레이)",
            MapDiffOptions = {
                0: "<fg27AAFFFF>Playtest ◆ 游戏测试 ◆ 플레이테스트",
                1: "<fgA0E81BFF>Easy-",
                2: "<fgA0E81BFF>Easy",
                3: "<fgA0E81BFF>Easy+",
                4: "<fge0e000FF>Medium-",
                5: "<fge0e000FF>Medium",
                6: "<fge0e000FF>Medium+",
                7: "<fgEC9900FF>Hard-",
                8: "<fgEC9900FF>Hard",
                9: "<fgEC9900FF>Hard+",
                10: "<fgFF4500FF>Very Hard-",
                11: "<fgFF4500FF>Very Hard",
                12: "<fgFF4500FF>Very Hard+",
                13: "<fgC80013FF>Extreme-",
                14: "<fgC80013FF>Extreme",
                15: "<fgC80013FF>Extreme+",
                16: "<fg960000FF>Hell",
                17: "Do Not Display ◆ 不显示 ◆ 표시 X"
            }
        MapPlaytest = "Playtest Display ◆ 游戏测试 ◆ 플레이테스트 디스플레이",
        MapValidator = "Basic Map Validator ◆ 验证地图 ◆ 맵 가능 여부 확인기",
        MapPortals = "Portals (Control Maps) ◆ 启用传送门 (占点地图) ◆ 순간이동 활성화 (쟁탈 맵)",
    
    TournamentCategory = "Tournament Mode ◆ 竞赛模式 ◆ 토너먼트 모드",
        TournamentMode = "Tournament Mode ◆ 开启竞赛模式 ◆ 토너먼트 모드 활성화",
        TournamentTime = "Time Limit (Global) ◆ 时间限制 ◆ 시간 제한 (전체)",
        TournamentAttempts = "Attempt Count ◆ 尝试次数 ◆ 시도 수 확인",
        TournamentRestart = "Disable Restart During Run ◆ 竞赛中禁用重新开始 ◆ 시도 중 재시작 비활성화",