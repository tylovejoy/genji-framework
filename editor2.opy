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
        hostPlayer.MenuText_Translated(backMsg = t" ▶ 0. Back"),
        hostPlayer.MenuPreview_Translated(),
        null,
        HudPosition.LEFT, null, Color.WHITE, Color.WHITE, null, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #!enableOptimizations

rule "Editor | Menu - Visibility":
    @Condition EditorOn
    @Condition hostPlayer.isHoldingButton(Button.MELEE)
    hostPlayer.MenuToggleVisibility()

rule "Editor | Menu - Move Selection":
    @Condition hostPlayer.MenuIsVisible()
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) != hostPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    if hostPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        hostPlayer.MenuNext()
    else:
        hostPlayer.MenuPrev()

rule "Editor | Menu - Selected Menu or Action":
    @Condition hostPlayer.MenuIsVisible()
    @Condition hostPlayer.isHoldingButton(Button.JUMP) != hostPlayer.isHoldingButton(Button.CROUCH)
    if hostPlayer.isHoldingButton(Button.CROUCH):
        hostPlayer.__MenuSelection__ = null
    hostPlayer.MenuSelect()

MenuCreate(menu = {
    text: `t"Main Menu
 1. Checkpoints
 2. Abilities
 3. Ban Skills
 4. Collectibles
 5. Lava Spheres
 6. Portals
 7. Targets
 8. Group Up
 9. Safe Zones
 10. Dummies
 11. Save"`,
    pages: [
        {
            text: `t"Checkpoints
 1. Create New
 2. Delete Selected
 3. Toggle Teleport
 4. Toggle Visual Hitbox
 5. Set Facing Angle"`,
            code: `smallMessage(true[0], "  Checkpoint Menu Opened!")`,
            pages: [
                {
                    code: `smallMessage(true[0], "  Checkpoint Created!")`
                },
                {
                    code: `smallMessage(true[0], "  Checkpoint Deleted!")`
                },
                0,
                0,
                0
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
 #. Jump"`,
            pages: [
                {
                    text: `ft"Ultimate: {hostPlayer.checkpoint_current in BladeEnabledCheckpoints}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BladeEnabledCheckpoints.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                },
                {
                    text: `ft"Ability 1: {hostPlayer.checkpoint_current in DashEnabledCheckpoints}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `DashEnabledCheckpoints.toggleItem(hostPlayer.checkpoint_current)`
                    }]
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
 8. Require Bhop ≥
 9. Require Double Jump »"`,
            pages: [
                {
                    text: `ft"Multi-Climb ∞: {hostPlayer.checkpoint_current in BanMulti}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BanMulti.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                },
                {
                    text: `ft"Create ♂: {hostPlayer.checkpoint_current in BanCreate}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BanCreate.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                },
                {
                    text: `ft"Stand Create ♠: {hostPlayer.checkpoint_current in BanStand}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BanStand.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                },
                {
                    text: `ft"Dead Hop X: {hostPlayer.checkpoint_current in BanDead}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BanDead.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                },
                {
                    text: `ft"Emote ♥: {hostPlayer.checkpoint_current in BanEmote}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BanEmote.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                },
                {
                    text: `ft"Save Double △: {hostPlayer.checkpoint_current in BanSaveDouble}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BanSaveDouble.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                },
                {
                    text: `ft"Climb ↑: {hostPlayer.checkpoint_current in BanClimb}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BanClimb.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                },
                {
                    text: `ft"Require Bhop ≥: {hostPlayer.checkpoint_current in BanBhop}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BanBhop.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                },
                {
                    text: `ft"Require Double Jump »: {hostPlayer.checkpoint_current in BanDjump}\n1. Switch"`,
                    update: true,
                    pages: [{
                        code: `BanDjump.toggleItem(hostPlayer.checkpoint_current)`
                    }]
                }
            ]
        },
        {
            text: `t"Collectable Orbs
 1. "`,
            pages: [0]
        },
        {
            text: `t"Lava Spheres
 1. "`,
            pages: [0]
        },
        {
            text: `t"Portals
 1. "`,
            pages: [0]
        },
        {
            text: `t"Targets
 1. "`,
            pages: [0]
        },
        {
            text: `t"Group Up
 1. "`,
            pages: [0]
        },
        {
            text: `t"Safe Zones
 1. "`,
            pages: [0]
        },
        {
            text: `t"Dummies
 1. "`,
            pages: [0]
        }
    ]
})