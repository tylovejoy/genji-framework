#!mainFile "../framework.opy"

################################################################################
/* Rename Global Variables */
#!define BanAutoCreate CM
################################################################################
/* Include Shared Skill Macros*/
#!include "all.opy"
#!include "climbers.opy"
################################################################################

macro Fw_Parkour_Setup_Hero():
    Ability1Checkpoints = Ability1Checkpoints.exclude(-1) if len(Ability1Checkpoints) else []
    UltCheckpoints = UltCheckpoints.exclude(-1) if len(UltCheckpoints) else []
    # remove legacy -1's after the ban data has been loaded
    # BanTriple = BanTriple.exclude(-1) if len(BanTriple) else [] # legacy code, now auto sets it to null to save space
    BanCreate = BanCreate.exclude(-1) if len(BanCreate) else []
    BanAutoCreate = BanAutoCreate if len(BanAutoCreate) else []
    BanStand = BanStand.exclude(-1) if len(BanStand) else []
    BanMulti = BanMulti.exclude(-1) if len(BanMulti) else []
    BanDead = BanDead.exclude(-1) if len(BanDead) else []
    BanEmote = BanEmote.exclude(-1) if len(BanEmote) else []
    BanSaveDouble = BanSaveDouble if len(BanSaveDouble) else []
    BanClimb = BanClimb.exclude(-1) if len(BanClimb) else []
    BanBhop = BanBhop.exclude(-1) if len(BanBhop) else []
    BanDjump = BanDjump if len(BanDjump) else []

macro Fw_Parkour_UpdateCache_Hero():
    if eventPlayer.checkpoint_notLast:
        eventPlayer.cache_startAbility1 = eventPlayer.checkpoint_current in Ability1Checkpoints
        if eventPlayer.cache_startAbility1:
            smallMessage(eventPlayer, f"   {abilityIconString(Hero.GENJI, Button.ABILITY_1)} {t'Dash Is Ready'}")
        eventPlayer.cache_startUlt = eventPlayer.checkpoint_current in UltCheckpoints
        if eventPlayer.cache_startUlt:
            smallMessage(eventPlayer, f"   {abilityIconString(Hero.GENJI, Button.ULTIMATE)} {t'Ultimate Is Ready'}")
        eventPlayer.ban_create = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_CreateBhop, false, 1) or eventPlayer.checkpoint_current in BanCreate
        if eventPlayer.ban_create:
            eventPlayer.banString = f"♂ {eventPlayer.banString}"
        eventPlayer.ban_autocreate = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_AutoCreate, false, 2) or eventPlayer.checkpoint_current in BanAutoCreate
        if eventPlayer.ban_autocreate:
            eventPlayer.banString = f"∀ {eventPlayer.banString}"
        eventPlayer.ban_standcreate = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_StandCreate, false, 3) or eventPlayer.checkpoint_current in BanStand
        if eventPlayer.ban_standcreate:
            eventPlayer.banString = f"♠ {eventPlayer.banString}" # ≥  √ ▼ ↓
        eventPlayer.ban_multi = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_MultiClimb, false, 4) or eventPlayer.checkpoint_current in BanMulti
        if eventPlayer.ban_multi:
            eventPlayer.banString = f"∞ {eventPlayer.banString}"
        eventPlayer.ban_dead = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_DeathHop, false, 5) or eventPlayer.checkpoint_current in BanDead
        if eventPlayer.ban_dead:
            eventPlayer.banString = f"X {eventPlayer.banString}"
        eventPlayer.ban_emote = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_Emote, false, 6) or eventPlayer.checkpoint_current in BanEmote
        if eventPlayer.ban_emote:
            eventPlayer.banString = f"♥ {eventPlayer.banString}"
        eventPlayer.ban_savedouble = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_SaveDouble, false, 7) or eventPlayer.checkpoint_current in BanSaveDouble
        if eventPlayer.ban_savedouble:
            eventPlayer.banString = f"△ {eventPlayer.banString}"
        eventPlayer.ban_climb = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_WallClimb, false, 8) or eventPlayer.checkpoint_current in BanClimb
        if eventPlayer.ban_climb:
            eventPlayer.banString = f"↑ {eventPlayer.banString}"
        eventPlayer.ban_bhop = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_RequireBhop, false, 9) or eventPlayer.checkpoint_current in BanBhop
        if eventPlayer.ban_bhop:
            eventPlayer.banString = f"≥ {eventPlayer.banString}" # ≥  √ ▼ ↓
        eventPlayer.ban_djump = createWorkshopSettingBool(SettingsText.BanCategory, SettingsText.Ban_RequireDjump, false, 10) or eventPlayer.checkpoint_current in BanDjump
        if eventPlayer.ban_djump:
            eventPlayer.banString = f"» {eventPlayer.banString}" # ≥  √ ▼ ↓ ︽
    else:
        eventPlayer.cache_startAbility1 = true
        eventPlayer.cache_startUlt = true
        eventPlayer.ban_create = false
        eventPlayer.ban_autocreate = false
        eventPlayer.ban_standcreate = false
        eventPlayer.ban_multi = false
        eventPlayer.ban_dead = false
        eventPlayer.ban_emote = false
        eventPlayer.ban_savedouble = false
        eventPlayer.ban_climb = false
        eventPlayer.ban_bhop = false
        eventPlayer.ban_djump = false

################################################################################

macro Fw_Mechanics_GroundReset_Hero():
    eventPlayer.skill_usedDouble = null

macro Fw_Mechanics_Hero():
    Fw_Mechanics_All(Fw_Mechanics_GroundReset_Climbers(Fw_Mechanics_GroundReset_Hero()))
    Fw_Mechanics_Climber()

    def ResetAbilities():
        @Name "Mechanic | Genji | SUB Reset Abilities"
        if eventPlayer.toggle_invincible or (eventPlayer == hostPlayer and EditorOn):
            eventPlayer.setAbility1Enabled(true)
            eventPlayer.setUltEnabled(true)
        else:
            eventPlayer.setAbility1Enabled(eventPlayer.cache_startAbility1)
            eventPlayer.setUltEnabled(eventPlayer.cache_startUlt)
        eventPlayer.setUltCharge(100)

    rule "Mechanic | Genji | Dash":
        @Event eachPlayer
        @Hero genji
        @Condition eventPlayer.isUsingAbility1()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast: return
        eventPlayer.setAbility1Enabled(false)
        waitUntil(not eventPlayer.isUsingAbility1(), true)
        if distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last()) <= cpCircleRadius:
            ResetAbilities()

    rule "Mechanic | Genji | Ultimate":
        @Event eachPlayer
        @Hero genji
        # Total Duration: 218 ticks, 3.488s
        # Casting: 76 ticks, 1.216s
        # Blade: 125 ticks, 2s
        # Recovery: 17 ticks, 0.272s
        # Swing Duration: 38 ticks, 0.608s
        @Condition eventPlayer.isUsingUltimate()
        if eventPlayer.toggle_invincible or (EditorOn and eventPlayer == hostPlayer) or not eventPlayer.checkpoint_notLast:
            eventPlayer.setUltEnabled(true)
            eventPlayer.setUltCharge(100)
            wait(3.488, Wait.ABORT_WHEN_FALSE)
            if ruleCondition: loop()
        else:
            waitUntil(not eventPlayer.isUsingUltimate(), (3 * 38) * 0.016)
            eventPlayer.disallowButton(Button.PRIMARY_FIRE) # Disallow primary fire because of slash exploit
            waitUntil(not eventPlayer.isUsingUltimate(), (218 - (3 * 38)) * 0.016)
            eventPlayer.allowButton(Button.PRIMARY_FIRE)
            if distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current].last()) <= cpCircleRadius:
                ResetAbilities()

    rule "Mechanic | Genji | Double Jump":
        @Event eachPlayer
        @Hero genji
        @Condition eventPlayer.isAlive()
        @Condition eventPlayer.isInAir()
        @Condition eventPlayer.ban_djump or eventPlayer.ban_savedouble or eventPlayer.addon_enableDoubleChecks
        #Save drop
        waitUntil(eventPlayer.isOnGround() or eventPlayer.isJumping() or eventPlayer.isHoldingButton(Button.JUMP), 0.096)
        if not RULE_CONDITION: return
        while true:
            #Released Jump
            waitUntil(eventPlayer.isOnGround() or not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
            if not RULE_CONDITION: return
            #Double Jumped
            waitUntil(eventPlayer.isOnGround() or eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
            if not RULE_CONDITION: return
            eventPlayer.skill_usedDouble = true
            #Reset
            waitUntil(eventPlayer.isOnGround() or not eventPlayer.skill_usedDouble, Math.INFINITY)
            if not RULE_CONDITION: return

    rule "Mechanic | Genji | Ban Save Double - 封禁二段跳":
        @Event eachPlayer
        @Hero genji
        @Condition eventPlayer.ban_savedouble
        @Condition eventPlayer.toggle_invincible == false
        @Condition eventPlayer.isInAir()
        @Condition eventPlayer.skill_usedDouble == false
        waitUntil(eventPlayer.getThrottle().z > null or not eventPlayer.isInAir() or eventPlayer.skill_usedDouble, Math.INFINITY)
        if not RULE_CONDITION: return
        waitUntil(eventPlayer.getThrottle().z <= null or not eventPlayer.isInAir() or eventPlayer.skill_usedDouble, Math.INFINITY)
        if not RULE_CONDITION: return
        #Prevent false positives
        #Default climb speed is 7.8 and small slowdown upon mantling
        if eventPlayer.getVerticalSpeed() < 6: goto RULE_START
        if eventPlayer.skill_usedBhop:
            wait(0.8, Wait.ABORT_WHEN_FALSE)
        else:
            wait(0.8, Wait.ABORT_WHEN_FALSE)
            #This can give a false negative, but advantage is small
            if eventPlayer.skill_usedBhop: return
        #"   延二段跳已禁用!" checkCN "   save double banned!"
        smallMessage(eventPlayer, t"   Save Double » Is Banned!")
        CheckpointFailReset()

################################################################################
macro Fw_AddonsPg1_Hero():
    rule ""::@Disabled:pass

macro Fw_AddonsPg2_Hero():
    rule "Addon | Genji | Fake Ledge Dash - 超级跳":
        @Event eachPlayer
        @Disabled
        #Version 2
        @Condition eventPlayer.isUsingAbility1()
        @Condition eventPlayer.getSpeed() < 45
        @Condition eventPlayer.getThrottle().z > null
        @Condition abs(eventPlayer.getVerticalSpeed() - 7) < 0.8
        # Dash into a wall/edge
        # Release wall/edge before dash ends
        eventPlayer.addon_ledgeDash = eventPlayer.getFacingDirection()
        waitUntil(not eventPlayer.isUsingAbility1(), true) #25 * 0.016
        if eventPlayer.isInAir():
            eventPlayer.applyImpulse(eventPlayer.addon_ledgeDash, 50, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

    rule "Addon | Genji | Fake Triple Jump - 假三段跳":
        @Disabled
        @Event eachPlayer
        @Hero genji
        #@Condition BanTriple == false
        @Condition eventPlayer.isOnGround() == false
        @Condition eventPlayer.skill_usedDouble == false #Double cannot be used already
        @Condition eventPlayer.isHoldingButton(Button.RELOAD) == false #Don't activate on reset
        eventPlayer.addon_enableDoubleChecks = true #Enable checking double jump
        wait(0)
        if RULE_CONDITION: goto RULE_START
        if eventPlayer.skill_usedDouble or eventPlayer.isHoldingButton(Button.RELOAD):
            return
        #Input window to Triple
        waitUntil(eventPlayer.isJumping() and eventPlayer.isHoldingButton(Button.JUMP), 0.048)
        if eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.isJumping():
            eventPlayer.applyImpulse(Vector.UP, 9, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        else:
            if RULE_CONDITION: goto RULE_START

    rule "Addon | Genji | Old Fake Ledge Dash - 超级跳":
        @Event eachPlayer
        @Condition false
        # based on code taken: wzr31 and S7DR0 and simplified
        @Condition eventPlayer.isUsingAbility1()
        #climb / ledge > hold jump > hands on the ledge > dash  > wait for launch > release jump
        #爬墙/扒 > 长按跳 > 抓住窗台 > SHIFT > 等待发射 > 释放跳跃
        eventPlayer.addon_ledgeDash[0] = 0
        waitUntil(eventPlayer.getSpeed() >= 45, 0.4)
        while eventPlayer.isUsingAbility1() and eventPlayer.addon_ledgeDash[0] <= 12:
            eventPlayer.addon_ledgeDash[1] = eventPlayer.getFacingDirection()
            eventPlayer.addon_ledgeDash[2] = eventPlayer.getSpeed()
            if eventPlayer.getSpeed() < 45: # dashed into air or object = end
                goto lbla
            else:
                eventPlayer.addon_ledgeDash[0] ++
            if eventPlayer.addon_ledgeDash[0] == 12: # stop storing, we keep this speed/direction
                waitUntil(eventPlayer.getSpeed() < 40, 0.4) # wait for dash to finish to execute
            wait(0)
        # dash after ledge grab
        if eventPlayer.addon_ledgeDash[0] >= 5: #and eventPlayer.addon_ledgeDash[0] <= 12: # ledge dash execute
            # stores speed and launches you after dash if you done it during climb
            eventPlayer.applyImpulse(eventPlayer.addon_ledgeDash[1], eventPlayer.addon_ledgeDash[2], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        # above 12 - climbed to long
        # below 5 - dashed into object
        lbla:
        eventPlayer.addon_ledgeDash[0] = null
        eventPlayer.addon_ledgeDash[1] = null
        eventPlayer.addon_ledgeDash[2] = null

    rule "Addon | Genji | Save Double - Enable Rule - 二段跳":
        # Obsoleted by hero settings.
        @Event eachPlayer
        @Condition false
        @Condition eventPlayer.isOnGround() == false
        @Condition eventPlayer.skill_usedDouble == false
        @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
        waitUntil(eventPlayer.getThrottle().z > null or eventPlayer.isOnGround() or eventPlayer.skill_usedDouble or not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
        if not RULE_CONDITION: return
        waitUntil(eventPlayer.getThrottle().z <= null or eventPlayer.isOnGround() or eventPlayer.skill_usedDouble or not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
        if not RULE_CONDITION: return
        eventPlayer.cancelPrimaryAction()
        if RULE_CONDITION: goto RULE_START