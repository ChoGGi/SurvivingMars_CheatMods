return PlaceObj("ModDef", {
	"title", "math. Functions",
	"version", 6,
	"version_major", 0,
	"version_minor", 6,

	"id", "ChoGGi_AddMathFunctions",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"image", "Preview.png",
	"steam_id", "1443143020",
	"pops_any_uuid", "c632be42-2a13-414c-a293-4ed7174211c0",
	"lua_revision", 249143,
	"description", [[Modders only (unless it's a mod that uses these functions).

For some reason SM doesn't have any of lua "math." functions.
Functions are either from SM (math.min = Min()), or pure lua.

SM and certain SM functions have issues with floats: 5 == 5.5 returns true for one (though 5.0 == 5.5 returns false).
Which is why I'm not just using math.cos = cos... (you can access them as math.sm_cos)
I'm going for accuracy not speed: Bench with GetPreciseTicks()

Implemented:
abs, ceil, deg, exp, floor, fmod, huge, log, max, maxinteger, min, mininteger, modf, pi, rad, random, randomseed, sqrt, tointeger, type, ult

Not implemented yet:
cos, sin, tan, acos, asin, atan


I'm only implementing the ones listed in the manual, if you have some to add: feel free to send them to me.

Functions should return values according to:
https://www.lua.org/manual/5.3/manual.html#6.7
You can test results with a copy of lua.exe: https://github.com/HazeProductions/Lua-x64.
If the result it gives is different then my func: Please let me know.]],
})
