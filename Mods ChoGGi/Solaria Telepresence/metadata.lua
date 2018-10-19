return PlaceObj("ModDef", {
  "title", "Solaria Telepresence v0.9",
  "version", 9,
  "saved", 1539950400,
  "tags", "Buildings",
	"image", "Preview.png",
  "id", "ChoGGi_SolariaTelepresence",
  "author", "ChoGGi",
  "steam_id", "1411115080",
  "code", {
		"Code/Script.lua",
		"Code/WorkVRWorkshop.lua",
	},
	"lua_revision", LuaRevision,
  "description", [[Adds a telepresence VR building; remote control factories and mines (with reduced production).

This mod also removes distance limits on workplace buildings placed outside of domes (hard not to).

##### Currently it can control:
Drone Factory
Fungal Farm
Fusion Reactor
Metals Extractor
Precious Metals Extractor

Unfortunately Comcast was chosen as the official internet of Mars:
Performance and production take awhile to update.

I could make it update faster, but this way seems better.
I also would've used Telus, but I think more people have heard of Comcast.

##### How to use:
Place building you want to control somewhere (next to a mine for example).
Place a Solaria Telepresence inside of a dome.

Click the Solaria, and select Remote Control Building.
You'll now see a list of buildings to control.

Double-right click to select and view building.
Double-click to activate remote control.

Set shifts on the remote building (the Solaria will use those to toggle its own shifts).

That's it!

There will now be a "Solaria Telepresence" button added to the controlled building.
Use it to view the Solaria controlling it.

If you want to remove control, select the Solaria controller, and click the "Remove Remote Control" button.

All Solaria buildings also have a "All Attached Buildings" button, you can use this to remove or view.

##### Production amounts:
Metal extractor (not upgraded, workers have no specialisations)
12
Telepresence (worker type doesn't matter for prod, only amount)
8

Rare metals extractor
3.5
Telepresence
2

numbers do vary, but only by a few points

##### Thanks
Kevin Bagust for the mod idea.

Isaac Asimov for the actual idea.]],
})
