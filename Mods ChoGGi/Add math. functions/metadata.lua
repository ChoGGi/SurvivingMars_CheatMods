return PlaceObj("ModDef", {
  "title", [[Add "math." Functions v0.1]],
  "version", 1,
  "saved", 1531742400,
  "id", "ChoGGi_AddMathFunctions",
  "author", "ChoGGi",
	"code", {"Script.lua"},
	"image", "Preview.png",
  "steam_id", "1443143020",
  "description", [[For some reason SM doesn't have any of lua "math." functions.
Functions are either from SM (math.min = Min()), or pure lua.

SM and certain SM functions have issues with floats: 5 == 5.5 returns true for one.
Which is why I'm not just using math.cos = cos... (you can access them as math.sm_cos)
I'm going for accuracy not speed: Bench with GetPreciseTicks()

Implemented:
abs,ceil,deg,exp,floor,fmod,huge,log,max,maxinteger,min,mininteger,modf,pi,rad,random,randomseed,sqrt,tointeger,type,ult

Not implemented yet:
cos,sin,tan,acos,atan

I'm only implementing the ones listed in the manual, if you have some to add: feel free to send them to me.

Functions should return the value according to:
https://www.lua.org/manual/5.3/manual.html#6.7
I included a compiled copy of lua.exe, if the result it gives is different then my func: Please let me know.]],
})
