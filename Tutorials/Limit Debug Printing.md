### Have a print() func that only prints on your computer.

make a mod that consists of
```lua
-- metadata.lua
return PlaceObj("ModDef", {
	"title", "ChoGGi Testing Mods",
	"id", "ChoGGi_TestingMods",
})
-- items.lua can be a blank file
```

In your actual mod code add this:
```lua
if Mods.ChoGGi_TestingMods then
	function printT(...)
		print(...)
	end
else
	printT = empty_func
end
```
Now you can leave the print msgs, and not worry about them showing up for end-users.
The mod doesn't need to be enabled, just placed in your Mods folder.