var Hero;
var Result;
if (Array.isArray(Hero)){
    Result = Hero.map(i => '#!include "mechanics/' + i).join('.opy"\n');
}
else{
    Result = '#!include "mechanics/' + Hero + '.opy"\n'
}
Hero = Result