### A print() func that only prints on your computer.

make a mod that consists of
```lua
-- metadata.lua
return PlaceObj("ModDef", {
	"title", "ChoGGi Testing Mods",
	"id", "ChoGGi_TestingMods",
})
-- items.lua can be a blank file (or nothing, it doesn't matter)
```

In any mods you want to use prints; add this at the top of the first Script.lua:
```lua
if Mods.ChoGGi_TestingMods then
	local print = print
	function printT(...)
		print(...)
	end
else
	printT = empty_func
end
```
You can leave printT() msgs sprinkled around, and not worry about them showing up for end-users.
The mod doesn't need to be enabled, just placed in your Mods folder.