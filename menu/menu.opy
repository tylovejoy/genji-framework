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

#
macro Player.MenuToggleVisibility():
    self.__MenuCurrent__ *= -1
#
macro Player.MenuIsVisible():
    self.__MenuCurrent__ > null
#
macro Player.MenuNext():
    self.__MenuSelection__ = (self.__MenuSelection__ + 1) % len(__MenuPointer__[self.__MenuCurrent__])
#
macro Player.MenuPrev():
    self.__MenuSelection__ = ((self.__MenuSelection__ + len(__MenuPointer__[self.__MenuCurrent__]) - 1) %
        len(__MenuPointer__[self.__MenuCurrent__]))
#
macro Player.MenuSelect():
    __MenuAction__()
    if __MenuPointer__[self.__MenuCurrent__][self.__MenuSelection__]:
        self.__MenuCurrent__ = __MenuPointer__[self.__MenuCurrent__][self.__MenuSelection__]
        self.__MenuSelection__ = 1
    __MenuText__()

#
macro Player.MenuCreateHud(backMsg = " ▶ 0. Back", primaryColor = Color.WHITE, secondaryColor = Color.WHITE):
    #!disableOptimizations
    hudText(self if self.MenuIsVisible() else false,
        "{0}▶{1}.{2}".format(
            __MenuString__[self.__MenuCurrent__].split(f" {self.__MenuSelection__}."),
            self.__MenuSelection__,
            __MenuString__[self.__MenuCurrent__].split(f" {self.__MenuSelection__}.").last())
            if self.__MenuSelection__ else backMsg,
        __MenuString__[__MenuPointer__[self.__MenuCurrent__][self.__MenuSelection__]] or [],
        null,
        HudPosition.LEFT, null, primaryColor, secondaryColor, null, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #!enableOptimizations
#
macro Player.MenuCreateTranslatedHud(backMsg = t" ▶ 0. Back", primaryColor = Color.WHITE, secondaryColor = Color.WHITE):
    #!disableOptimizations
    hudText(self if self.MenuIsVisible() else false,
        "{0}▶{1}.{2}".format(
            _(__MenuString__[self.__MenuCurrent__]).split(f" {self.__MenuSelection__}."),
            self.__MenuSelection__,
            _(__MenuString__[self.__MenuCurrent__]).split(f" {self.__MenuSelection__}.").last())
            if self.__MenuSelection__ else backMsg,
        _(__MenuString__[__MenuPointer__[self.__MenuCurrent__][self.__MenuSelection__]]) or [],
        null,
        HudPosition.LEFT, null, primaryColor, secondaryColor, null, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #!enableOptimizations