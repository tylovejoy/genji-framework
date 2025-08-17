globalvar __MenuInit__
globalvar __MenuString__
globalvar __MenuPointer__

subroutine __MenuAction__
subroutine __MenuText__

playervar __MenuCurrent__ = -1
playervar __MenuSelection__ = 1

#!define __menuValidate(menu) __script__("menuValidate.js")

#!define __menuBuild(menu) __script__("menuBuild.js")

#!define MenuCreate(menu) __menuValidate(menu) \
__menuBuild(menu)

################################################################################
macro Player.MenuToggleVisibility():
    # Toggle menu visibility
    self.__MenuCurrent__ *= -1
################################################################################
macro Player.MenuIsVisible():
    # Check if menu is visible
    self.__MenuCurrent__ > null
################################################################################
macro Player.MenuNext():
    # Move menu selection to next
    self.__MenuSelection__ = (self.__MenuSelection__ + 1) % len(__MenuPointer__[self.__MenuCurrent__])
################################################################################
macro Player.MenuPrev():
    # Move menu selection to previous
    self.__MenuSelection__ = ((self.__MenuSelection__ + len(__MenuPointer__[self.__MenuCurrent__]) - 1) %
        len(__MenuPointer__[self.__MenuCurrent__]))
################################################################################
macro Player.MenuSelect():
    # Activate selected menu option
    __MenuAction__()
    if __MenuPointer__[self.__MenuCurrent__][self.__MenuSelection__]:
        self.__MenuCurrent__ = __MenuPointer__[self.__MenuCurrent__][self.__MenuSelection__]
        self.__MenuSelection__ = 1
    __MenuText__()
################################################################################
macro Player.MenuText_Translated(backMsg = " ▶ 0. Back"):
    # Display Menu
    # with translations enabled
    ("{0}▶{1}.{2}".format(
            _(__MenuString__[self.__MenuCurrent__]).split(f" {self.__MenuSelection__}."),
            self.__MenuSelection__,
            _(__MenuString__[self.__MenuCurrent__]).split(f" {self.__MenuSelection__}.").last())
            if self.__MenuSelection__ else backMsg)
################################################################################
macro Player.MenuPreview_Translated():
    # Display Menu Preview
    # with translations enabled
    # Requires optimizations disabled
    (_(__MenuString__[__MenuPointer__[self.__MenuCurrent__][self.__MenuSelection__]]) or [])