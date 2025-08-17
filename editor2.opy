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
 1. Playtest
 2. Checkpoints
 3. Ban Skills
 4. Collectable Orbs
 5. Lava Spheres
 6. Portals
 7. Targets
 8. Group Up
 9. Safe Zones
 10. Dummies
 11. Lorem Ipsum
 12. Save"`,
    pages: [
        {
            code: `smallMessage(true[0], "  Playtest")`
        },
        {
            text: `t"Checkpoints
 1. Create New
 2. Delete Selected
 3. Toggle Teleport
 4. Toggle Ultimate
 5. Toggle Dash
 6. Toggle Visual Hitbox
 7. Set Facing Angle"`,
            code: `smallMessage(true[0], "  Checkpoint Menu Opened!")`,
            pages: [
                {
                    code: `smallMessage(true[0], "  Checkpoint Created!")`
                },
                {
                    code: `smallMessage(true[0], "  Checkpoint Deleted!")`
                },
                0,
                {
                    text: `t"Toggle Ultimate\n 1. Hello ON\n 2. World OFF" if debug_ult_on else t"Toggle Ultimate\n 1. Hello OFF\n 2. World ON"`,
                    update: true,
                    pages: [
                        {
                            code: `smallMessage(true[0], "  Ultimate On!")
    debug_ult_on = true`
                        },
                        {
                            code: `smallMessage(true[0], "  Ultimate Off!")
    debug_ult_on = false`
                        }
                    ]
                },
                0,
                0,
                0
            ]
        },
        {
            text: `t"Ban Skills
 1. Emote ♥
 2. Dead X
 3. Multi-Climb ∞
 4. Create ♂
 5. Climb ↑
 6. Save Double △
 - - - - - - - - - - - -
 7. Have A Hop ≥
 8. Have A Double Jump »"`,
            pages: [
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0
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
        },
        {
            text: `t"Lorem Ipsum
 1. "`,
            pages: [0]
        }
    ]
})