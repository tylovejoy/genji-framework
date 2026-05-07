var Hero;
var Result;
if (Array.isArray(Hero)){
    Result = Hero.map(i => '#!include "FwHero/' + i).join('.opy"\n');
}
else{
    Project = {
        "Doomfist": ["dsc.gg/projectmomentum", "NAPGF"],
        "Genji": ["dsc.gg/genjiparkour", "54CRY"],
        "Kiriko": [""],
        "Lucio": ["discord.com/invite/G9QBCDY"],
        "Mercy": ["discord.gg/mercyparkour"],
    }
    Result =
'enum FwHero:\n' +
    '\tHero = Hero.' + Hero.toUpperCase() + '\n' +
    '\tString = "' + Hero + '"\n' +
    '\tStringLC = "' + Hero.toLowerCase() + '"\n' +
    '\tStringUC = "' + Hero.toUpperCase() + '"\n' +
    '\tDiscord = "' + (Project[Hero][0] ?? '') + '"\n' +
    '\tShareCode = "' + (Project[Hero][1] ?? 'XXXXX') + '"\n' +
'#!define Fw_Include_Hero #!include "FwHero/' + Hero + '.opy"\n';
}
Hero = Result