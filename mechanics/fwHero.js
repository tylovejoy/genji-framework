var Hero;
var Result;
if (Array.isArray(Hero)){
    Result = Hero.map(i => '#!include "' + i).join('.opy"\n');
}
else{
    Result = '#!include "' + Hero + '.opy"\n'
}
Hero = Result