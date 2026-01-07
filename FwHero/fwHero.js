var Hero;
var Result;
if (Array.isArray(Hero)){
    Result = Hero.map(i => '#!include "FwHero/' + i).join('.opy"\n');
}
else{
    Result =
'enum FwHero:\n' +
    '\tHero = Hero.' + Hero.toUpperCase() + '\n' +
    '\tString = "' + Hero + '"\n' +
    '\tStringLC = "' + Hero.toLowerCase() + '"\n' +
    '\tStringUC = "' + Hero.toUpperCase() + '"\n' +
//'#!define FwHero@Hero ' + Hero.toLowerCase() + '\n' +
'#!define Fw_Include_Hero #!include "FwHero/' + Hero + '.opy"\n';
}
Hero = Result