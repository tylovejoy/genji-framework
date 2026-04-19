var Hero;
var Result;
if (Array.isArray(Hero)){
    Result = Hero.map(i => '#!include "FwHero/' + i).join('.opy"\n');
}
else{
    Discord = {
        "Doomfist": "dsc.gg/projectmomentum",
        "Genji": "dsc.gg/genjiparkour",
        "Kiriko": "",
        "Lucio": "discord.com/invite/G9QBCDY",
        "Mercy": "discord.gg/mercyparkour",
    }
    Result =
'enum FwHero:\n' +
    '\tHero = Hero.' + Hero.toUpperCase() + '\n' +
    '\tString = "' + Hero + '"\n' +
    '\tStringLC = "' + Hero.toLowerCase() + '"\n' +
    '\tStringUC = "' + Hero.toUpperCase() + '"\n' +
    '\tDiscord = "' + Discord[Hero] + '"\n' +
'#!define Fw_Include_Hero #!include "FwHero/' + Hero + '.opy"\n';
}
Hero = Result