### Random info about random stuff.

```lua
Be careful when using CreateGameTimeThread(), as they are persistent.
If you have one with an inf loop the next time you load a game it'll still be there.
Store a ref and check with IsValidThread(t) and DeleteThread(t)

To get your mod path (if user renames your mod folder):
CurrentModPath

If working with a large amount of entity objects:
SuspendPassEdits("SomeIdToUse")
MapDelete("map", "Building")
ResumePassEdits("SomeIdToUse")

List all objects:
~MapGet(true)
Just domes:
~MapGet(true,"Dome")
Just get objects on the map (colonists in a building are off the map):
MapGet("map","ResourceStockpile","ResourceStockpileLR")
Filter out which objects are returned:
MapGet("map", "Building", function(o)
	return o.ui_working
end)

Add cargo to the initial rocket:
https://steamcommunity.com/workshop/discussions/18446744073709551615/1694923613869322889/?appid=464920

Hash a value:
Encode16(SHA256(value))

Access varargs (...):
Use select(index,...) index being the argument you want to select, or run it through a for loop with
for i = 1, select("#",...) do
	local arg = select(i,...)
end
Or use: local vararg = {...}
and you can access them like a regular table

Countdown timer (use CreateGameTimeThread to have it follow the speed of the game):
local countdown = CreateRealTimeThread(function()
	Sleep(10000)
	-- do something after 10 seconds
end)
if you_want_stop_it_from_outside then
	DeleteThread(countdown)
end
if you want to use a realtime and pause it:
local we_paused
function OnMsg.MarsPause()
	we_paused = true
end
CreateRealTimeThread(function()
	while true do
		if we_paused then
			WaitMsg("MarsResume")
			we_paused = false
		end
		-- other stuff
		Sleep(1000)
	end
end

Loop backwards through a table (good for deleting as you go):
for i = #some_table, 1, -1 do
	print(some_table[i])
	table.remove(some_table,i)
end

Info from other people:

Crysm: 7200 units per revolution. So units = (degrees * 20)

BullettMAGNETTs CustomAssetDocs
https://docs.google.com/document/d/1LcZMS8UeRAQZZsPE-bsx75ZMGPUFGdbS-M9jDBMFEYs

```
