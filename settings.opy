#!mainFile "framework.opy"
#!extension spawnMoreDummyBots
#!extension playMoreEffects

settings {
    #$$ Figure out how to rename the framework for multiple heroes
    "main": {
        "modeName": f"{FwHero.String} Parkour - 源氏跑酷 - v{versionhere}",
        "description": f"◀ {FwHero.String} Parkour - 源氏跑酷 ▶\nCode: XXXXX\nMade By: \n\n◀ Official {FwHero.String} Parkour Editor ▶\nCode: 54CRY\nDiscord: dsc.gg/genjiparkour\nAdapted By: LulledLion, FishoFire, Nebula\nv{versionhere}"
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
            "enabledMaps": skirmishMap
        },
        "tdm": {
            "enabled": true,
            "enablePerks": usePerks,
            "enabledMaps": tdmMap,
            "enableSelfInitiatedRespawn": false
        },
        "assault": {
            "enabled": false,
            #"enablePerks": usePerks
        },
        "bountyHunter": {
            "enabled": false,
            "enablePerks": usePerks
        },
        "clash": {
            "enabled": false,
            #"enablePerks": usePerks
        },
        "ctf": {
            "enabled": false,
            "enablePerks": usePerks
        },
        "control": {
            "enabled": false,
            #"enablePerks": usePerks
        },
        "escort": {
            "enabled": false,
            #"enablePerks": usePerks
        },
        "elimination": {
            "enabled": false,
            "enablePerks": usePerks
        },
        "flashpoint": {
            "enabled": false,
            "enablePerks": usePerks
        },
        "hybrid": {
            "enabled": false,
            #"enablePerks": usePerks
        },
        "practiceRange": {
            "enabled": false,
            "enablePerks": usePerks
        },
        "push": {
            "enabled": false,
            #"enablePerks": usePerks
        }
    },
    "heroes": {
        "allTeams": {
            "general": {
                "enableInfiniteAmmo": true,
                "passiveUltGen%": 0,
                "ultDuration%": 25,
            },
            "genji": {
                "enableAbility2": false,
                "ability1Cooldown%": 1,
            },
            "enabledHeroes": [
                FwHero.StringLC
            ]
        }
    }
}

enum SettingsText:
    BanCategory = "Ban (All Levels)    ◆ 封禁(应用于所有关卡)    ◆ 금지 (모든 단계에 적용)",
        Ban_CreateBhop = "Ban Create Bhop         ◆ 封禁卡小      ◆ 앉콩 금지",
        Ban_AutoCreate = "Ban Auto Create         ◆ 封禁自动卡小    ◆ 자동앉콩 금지",
        Ban_StandCreate = "Ban Stand Create       ◆ 封禁站卡      ◆ 서콩 금지",
        Ban_MultiClimb = "Ban MultiClimb        ◆ 封禁蹭留      ◆ 벽캔 금지",
        Ban_DeathHop = "Ban Death Hop        ◆ 封禁死小      ◆ 죽음콩 금지",
        Ban_Emote = "Ban Emote Save Hop     ◆ 封禁表情留小    ◆ 감콩 금지",
        Ban_SaveDouble = "Ban Save Double         ◆ 封禁留二段跳    ◆ 더블 세이브 금지",
        Ban_WallClimb = "Ban WallClimb        ◆ 封禁爬墙      ◆ 벽타기 금지",
        Ban_RequireBhop = "Require Bhop Available     ◆ 留小跳进点     ◆ 콩콩이 금지",
        Ban_RequireDjump = "Require Djump Available   ◆ 留二段跳进点    ◆ 도착 시 이단 점프 필요",

    MapCategory = "Map Settings      ◆ 地图设置   ◆ 맵 설정",
        Map_Editor = "Editor Mode         ◆ 作图模式      ◆ 편집 모드",
        Map_Difficulty = "Difficulty (Display Hud)     ◆ 难度 (顶部hud)   ◆ 난이도 (HUD 디스플레이)",
            Map_DiffOptions = {
                0: "<fg27AAFFFF>Playtest ◆ 游戏测试 ◆ 플레이테스트",
                1: "<fgA0E81BFF>Easy-",
                2: "<fgA0E81BFF>Easy",
                3: "<fgA0E81BFF>Easy+",
                4: "<fgE0E000FF>Medium-",
                5: "<fgE0E000FF>Medium",
                6: "<fgE0E000FF>Medium+",
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
                17: "No Display ◆ 不显示 ◆ 난이도 표시 X"
            }
        Map_Playtest = "Playtest Display        ◆ 游戏测试      ◆ 플레이테스트 디스플레이",
        Map_Validator = "Basic Map Validator       ◆ 验证地图      ◆ 맵 가능 여부 확인기",
        Map_Portals = "Portals (Control Maps)    ◆ 启用传送门 (占点地图) ◆ 순간이동 활성화 (쟁탈 맵)",
        Map_Time = "Lobby Duration        ◆ 房间持续时间    ◆ 경기 지속 시간",
    
    TournamentCategory = "Tournament Mode   ◆ 竞赛模式    ◆ 토너먼트 모드",
        Tournament_Mode = "Tournament Mode        ◆ 开启竞赛模式    ◆ 토너먼트 모드 활성화",
        Tournament_Time = "Time Limit (Global)      ◆ 时间限制      ◆ 시간 제한 (전체)",
        Tournament_Attempts = "Attempt Count         ◆ 尝试次数      ◆ 시도 수 확인",
        Tournament_Marathon = "Marathon           ◆ 竞赛中禁用重新开始 ◆ 시도 중 재시작 비활성화",