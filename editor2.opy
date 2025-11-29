#!mainFile "framework.opy"

rule "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Editor v2 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒":
    @Delimiter

#!include "menu/menu.opy"
#globalvar EditorOn
globalvar debug_ult_on

rule "Editor | Menu - HUD":
    @Condition EditorOn
    #!disableOptimizations
    hudText(hostPlayer if hostPlayer.MenuIsVisible() else false,
        hostPlayer.MenuText_Translated_Vertical(),
        #hostPlayer.MenuText_Translated(),#backMsg = t" ▶ 0. Back"),
        hostPlayer.MenuPreview_Translated(),
        LeftAlign128, HudPosition.LEFT, null, Color.WHITE, Color.WHITE, null, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #!enableOptimizations
    #createInWorldText(hostPlayer if hostPlayer.MenuIsVisible() else false, hostPlayer.MenuText_Translated(), worldVector(100 * Vector.FORWARD, hostPlayer, Transform.ROTATION_AND_TRANSLATION), 2)

rule "Editor | Menu - Visibility":
    @Condition EditorOn
    @Condition hostPlayer.isHoldingButton(Button.MELEE)
    hostPlayer.MenuToggleVisibility()

rule "Editor | Menu - Selected Menu or Action":
    @Event eachPlayer
    @Condition hostPlayer == eventPlayer #Required for UpdateCache
    @Condition hostPlayer.MenuIsVisible()
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) != hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    hostPlayer.__MenuSelection__ = hostPlayer.MenuGetVerticalSelect()
    if hostPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        hostPlayer.__MenuSelection__ = null
    hostPlayer.MenuSelect()

MenuCreate(menu = {
    text: `t"Main Menu
 1. Editor Movement
 2. Checkpoints
 3. Abilities
 4. Ban Skills
 5. Collectibles
 6. Lava Spheres
 7. Portals
 8. Targets
 9. Group Up
 10. Safe Zones
 11. Dummies
 12. Save
 0. × Close"`,
    pages: [
        {
            text: `t"Editor Movement
 1. Fly
 2. Walk
 3. Collision Off
 4. Collision On
 5. Move Slow 3%
 6. Move Normal 100%
 7. Move Fast 300%
 8. Slow Motion 50%
 9. Slow Motion Off
 0. ← Back"`,
            pages: [
                { code: `eventPlayer.startForcingPosition(eventPlayer.getPosition() + eventPlayer.flyMovementDelta(), true)` },
                { code: `eventPlayer.stopForcingPosition()` },
                { code: `eventPlayer.disableEnvironmentCollision(false)` },
                { code: `eventPlayer.enableEnvironmentCollision()` },
                { code: `eventPlayer.setMoveSpeed(3)` },
                { code: `eventPlayer.setMoveSpeed(100)` },
                { code: `eventPlayer.setMoveSpeed(300)` },
                { code: `setSlowMotion(50)` },
                { code: `setSlowMotion(100)` }
            ]
        },
        {
            text: `t"Checkpoints
 1. Create
 2. Move
 3. Delete
 4. Toggle Teleport
 5. Toggle Visual Hitbox
 #. Set Facing Angle
 0. ← Back"`,
            /*code: `smallMessage(true[0], "  Checkpoint Menu Opened!")`,*/
            pages: [
                {
                    code: `
    if len(CheckpointPositions) and distance(eventPlayer, CheckpointPositions[eventPlayer.checkpoint_current]) <= cpCircleRadius:
        smallMessage(eventPlayer, "   Cannot Place Checkpoint Too Close.") #"   放置的检查点距离太近"
    else:
        CheckpointPositions.insertAt(eventPlayer.checkpoint_current, eventPlayer.getPosition())
        eventPlayer.checkpoint_current++
        #Abilities
        BladeEnabledCheckpoints.shiftAt(hostPlayer.checkpoint_current)
        DashEnabledCheckpoints.shiftAt(hostPlayer.checkpoint_current)
        #Bans
        BanMulti.shiftAt(eventPlayer.checkpoint_current)
        BanCreate.shiftAt(eventPlayer.checkpoint_current)
        BanStand.shiftAt(eventPlayer.checkpoint_current)
        BanDead.shiftAt(eventPlayer.checkpoint_current)
        BanEmote.shiftAt(eventPlayer.checkpoint_current)
        BanClimb.shiftAt(eventPlayer.checkpoint_current)
        BanSaveDouble.shiftAt(eventPlayer.checkpoint_current)
        BanBhop.shiftAt(eventPlayer.checkpoint_current)
        BanDjump.shiftAt(eventPlayer.checkpoint_current)

        smallMessage(eventPlayer, "   Checkpoint Created!")
        UpdateCache()`
                },
                0,
                {
                    code: `
    #Abilities
    BladeEnabledCheckpoints.removeAndShift(hostPlayer.checkpoint_current)
    DashEnabledCheckpoints.removeAndShift(hostPlayer.checkpoint_current)
    #Bans
    BanMulti.removeAndShift(hostPlayer.checkpoint_current)
    BanCreate.removeAndShift(hostPlayer.checkpoint_current)
    BanStand.removeAndShift(hostPlayer.checkpoint_current)
    BanDead.removeAndShift(hostPlayer.checkpoint_current)
    BanEmote.removeAndShift(hostPlayer.checkpoint_current)
    BanClimb.removeAndShift(hostPlayer.checkpoint_current)
    BanSaveDouble.removeAndShift(hostPlayer.checkpoint_current)
    BanBhop.removeAndShift(hostPlayer.checkpoint_current)
    BanDjump.removeAndShift(hostPlayer.checkpoint_current)
    
    del CheckpointPositions[eventPlayer.checkpoint_current]
    eventPlayer.checkpoint_current = max(eventPlayer.checkpoint_current - 1, 0 - not len(CheckpointPositions))
    smallMessage(eventPlayer, "   Checkpoint Deleted!")
    UpdateCache()`
                },
                {
                    code: `
    if eventPlayer.checkpoint_current <= 0:
        smallMessage(eventPlayer, "   Teleport Unavailable For Level") # "   不能在第一个检查点设置传送门"
    elif len(CheckpointPositions[eventPlayer.checkpoint_current]) >= 2:
        CheckpointPositions[eventPlayer.checkpoint_current] = CheckpointPositions[eventPlayer.checkpoint_current][0]
        smallMessage(eventPlayer, "   Teleport Removed For Level") # "   关卡{0}的传送点已移除"
    else:
        CheckpointPositions[eventPlayer.checkpoint_current] = [CheckpointPositions[eventPlayer.checkpoint_current], eventPlayer.getPosition()]
        smallMessage(eventPlayer, "   Teleport Added For Level") # "   传送点已添加到当前关卡"`
                },
                {
                    code: `eventPlayer.editor_hitboxToggle = not eventPlayer.editor_hitboxToggle`
                }
            ]
        },
        {
            text: `t"Abilities
 1. Ultimate
 2. Ability 1
 #. Ability 2
 #. Primary Fire
 #. Secondary Fire
 #. Crouch
 #. Jump
 0. ← Back"`,
            code: `
    if not len(CheckpointPositions):
        eventPlayer.MenuInvalidateSelect()
        #UpdateCache()
    `,
            pages: [
                {
                    text: `ft"Ultimate: {eventPlayer.checkpoint_current in BladeEnabledCheckpoints}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BladeEnabledCheckpoints.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BladeEnabledCheckpoints.remove(eventPlayer.checkpoint_current)`}
                    ]
                },
                {
                    text: `ft"Ability 1: {eventPlayer.checkpoint_current in DashEnabledCheckpoints}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `DashEnabledCheckpoints.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `DashEnabledCheckpoints.remove(eventPlayer.checkpoint_current)`}
                    ]
                }
            ]
        },
        {
            text: `t"Ban Skills
 1. Multi-Climb ∞ 
 2. Create ♂
 3. Stand Create ♠
 4. Dead Hop X
 5. Emote ♥
 6. Save Double △
 7. Climb ↑
 - - - - - - - - - - - -
 8. Bhop ≥
 9. Double Jump »
 0. ← Back"`,
            code: `if not len(CheckpointPositions):
        eventPlayer.MenuInvalidateSelect()`,
            pages: [
                {
                    text: `ft"Ban Multi-Climb ∞: {eventPlayer.checkpoint_current in BanMulti}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BanMulti.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BanMulti.remove(eventPlayer.checkpoint_current)`}
                    ]
                },
                {
                    text: `ft"Ban Create ♂: {eventPlayer.checkpoint_current in BanCreate}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BanCreate.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BanCreate.remove(eventPlayer.checkpoint_current)`}
                    ]
                },
                {
                    text: `ft"Ban Stand Create ♠: {eventPlayer.checkpoint_current in BanStand}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BanStand.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BanStand.remove(eventPlayer.checkpoint_current)`}
                    ]
                },
                {
                    text: `ft"Ban Dead Hop ×: {eventPlayer.checkpoint_current in BanDead}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BanDead.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BanDead.remove(eventPlayer.checkpoint_current)`}
                    ]
                },
                {
                    text: `ft"Ban Emote ♥: {eventPlayer.checkpoint_current in BanEmote}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BanEmote.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BanEmote.remove(eventPlayer.checkpoint_current)`}
                    ]
                },
                {
                    text: `ft"Ban Save Double △: {eventPlayer.checkpoint_current in BanSaveDouble}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BanSaveDouble.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BanSaveDouble.remove(eventPlayer.checkpoint_current)`}
                    ]
                },
                {
                    text: `ft"Ban Climb ↑: {eventPlayer.checkpoint_current in BanClimb}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BanClimb.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BanClimb.remove(eventPlayer.checkpoint_current)`}
                    ]
                },
                {
                    text: `ft"Unused Bhop ≥: {eventPlayer.checkpoint_current in BanBhop}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BanBhop.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BanBhop.remove(eventPlayer.checkpoint_current)`}
                    ]
                },
                {
                    text: `ft"Unused Double Jump »: {eventPlayer.checkpoint_current in BanDjump}\n 1. On\n 2. Off\n 0. ← Back"`,
                    update: true,
                    pages: [
                        {code: `BanDjump.addUnique(eventPlayer.checkpoint_current)`},
                        {code: `BanDjump.remove(eventPlayer.checkpoint_current)`}
                    ]
                }
            ]
        },
        {
            text: `t"Collectable Orbs
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. ← Back"`,
            pages: [0, 0, 0, 0, 0]
        },
        {
            text: `t"Lava Spheres
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. ← Back"`,
            pages: [0, 0, 0, 0, 0]
        },
        {
            text: `t"Portals
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. ← Back"`,
            pages: [0, 0, 0, 0, 0]
        },
        {
            text: `t"Targets
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. ← Back"`,
            pages: [0, 0, 0, 0, 0]
        },
        {
            text: `t"Group Up
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. ← Back"`,
            pages: [0, 0, 0, 0, 0]
        },
        {
            text: `t"Safe Zones
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. ← Back"`,
            pages: [0, 0, 0, 0, 0]
        },
        {
            text: `t"Dummies
 1. Create
 2. Move
 3. Delete
 4. Next
 5. Previous
 0. ← Back"`,
            pages: [0, 0, 0, 0, 0]
        },
        {
            code: `#Export to Inspector
    pass`
        }
    ]
})