#!mainFile "framework.opy"

rule "<tx0C0000000000D297><fg00FFFFFF> Map Data - 数据录入 <---- INSERT HERE / 在这输入":
    @Delimiter

# note: Don't change defaults only here.
# If you change this, also change it in the name/credit construciton in the huds
# The old default should always be included to make old data valid
rule "<tx0C00000000044B55><fg0FFFFFFF> Credits and Colors here - 作者代码HUD颜色 <---- INSERT HERE / 在这输入":
    wait(LoadOrder.customize)
    #Filling this in adds it to the inspector pasta after next restart.
    #You can fill in again to overwrite.
    #修改的内容 在重新开始 比赛后生效
    #您可以反复 修改字符串 中的内容
    Name = "name here - 作者"
    Code = "code here - 代码"
    #
    #+++++  +++++  +++++  +++++  +++++  +++++
    #color customization below / 自定义 颜色(实体、HUD)
    #+++++  +++++  +++++  +++++  +++++  +++++
    #
    #credit hud name   -   作者HUD
    ColorConfig[Customize.credit_name] = Color.VIOLET
    #credit hud code   -   代码HUD
    ColorConfig[Customize.credit_code] = Color.SKY_BLUE
    #dsc.gg/genjiparkour
    ColorConfig[Customize.dsc] = Color.AQUA
    #server time hud   -   房间倒计时
    ColorConfig[Customize.servertime] = Color.RED
    #time  hud   -   单关用时HUD
    ColorConfig[Customize.time] = Color.WHITE
    #level hud   -   关卡HUD
    ColorConfig[Customize.level] = Color.WHITE
    #command hud   -   指令HUD
    ColorConfig[Customize.command_normal] = Color.WHITE
    #command hud highlight   -   指令HUD高亮
    ColorConfig[Customize.command_highlight] = Color.GREEN
    #bhop/climb available   -   小跳/爬墙未用HUD
    ColorConfig[Customize.bhopclimb_available] = Color.GREEN
    #bhop/climb used (cant be same as available)   -   小跳/爬墙已用HUD
    ColorConfig[Customize.bhopclimb_used] = Color.RED

    #current checkpoint ring   -   当前检查点光圈
    ColorConfig[Customize.ring_current] =  Color.SKY_BLUE
    #next checkpoint ring   -   下一关检查点光圈
    ColorConfig[Customize.ring_next] = Color.LIME_GREEN
    #next checkpoint light shaft   -   下一关检查点光柱
    ColorConfig[Customize.shaft] = Color.WHITE
    #next checkpoint icon   -   下一关检查点图标
    ColorConfig[Customize.nexticon_color] = Color.SKY_BLUE
    #"come here" text   -   到这里来" 文本
    ColorConfig[Customize.cometext] = Color.WHITE
    #kill orbs   -   击杀球
    ColorConfig[Customize.killorb] = Color.BLUE
    #normal orbs   -   弹球
    ColorConfig[Customize.orb_normal] = Color.GREEN
    #lock orbs (overwritten if its same as normal)
    #收集球 (与普通弹 球相同时将 自动覆写)
    ColorConfig[Customize.orb_lock] = Color.ORANGE
    #portals   -   自定义 传送门
    ColorConfig[Customize.portal] = Color.WHITE

rule "Instructions for Depricated Rules (ban / portal / dash /ult) - 旧版编辑器中已弃用规则指引 (单关封禁 / 传送门 / 给刀给S)":
    @Delimiter
    # The following rules should now be handled with the ingame editor
    #- Ban per checkpoint
    #- Dash/Ult per checkpoint
    #- Custom portals
    return
    # When updating old maps, these things should be added to your map data.
    # This is done with the instructions below
    return
    #step 1) Open the old rule
    #step 2) Select the variables and press copy
    #      (do not select waits or workshop toggles, only select variables)
    #step 3) Go to map data rule and paste this the variables
    return
    #以下规则现在 要用游戏内置 编辑器编辑
	#	- 单关 封禁(卡小、蹭留等)
	#	- 检查点给 刀给S
	#	- 自定义 传送门
    return
	#	当更新旧 图数据 时，以上 这些东西 应该放 到地图 数据里
    #	以下是一 些更新旧 图数据 指引:
    return
	#	步骤 1) 找到旧图 数据的 规则
	#	步骤 2) 选中旧图 数据的 全局变 量并复制
	#		  (不要复制含 等待 地图工坊设置 的指令, 只要 全局变量 的数据)
	#	步骤 3) 将全局变 量数据粘 贴到新版 编辑器的 地图数 据规则
    return