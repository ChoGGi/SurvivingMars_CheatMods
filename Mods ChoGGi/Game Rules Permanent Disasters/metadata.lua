return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 4,
		}),
	},
	"title", "Game Rules Permanent Disasters",
	"id", "ChoGGi_GameRulesPermanentDisasters",
	"steam_id", "2060296355",
	"pops_any_uuid", "09c4df72-ad70-43c3-aa81-558431221377",
	"lua_revision", 1007000, -- Picard
	"version", 11,
	"version_major", 1,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Add four new game rules for each of the disasters:

[b]Meteor Threat[/b]: Constantly raining meteors (this doesn't change the occurrence of regular meteors or storms).
Mod Options:
Overkill: For those that want extra pain.
No Deposits: No goodies from the meteors.
MDS Lasers/Defensive Turrets: Unlock building them from the get-go.

[b]Winter Wonderland[/b]: The ground will always be icy everywhere.
Give Subsurface Heaters: Start game with Subsurface Heaters unlocked.

[b]Great Bakersfield Dust Storm[/b]: Permanent dust storm.
This will allow MOXIEs operating at a reduced capacity, see mod options to disable.
Mod Options:
Allow Rockets: Allow rockets to take off and land.
Unbreakable Cables/Pipes: Cables/Pipes won't break (same as breakthrough tech, but no free construction).
Allow MOXIEs: You can build/use MOXIEs.
MOXIE Performance: Set the negative performance of MOXIEs during dust storms (higher = worse for you).
Electrostatic Storm: Chance of an electrostatic storm (lightning strikes).
Great Storm: Chance of a great storm (turbines spin faster?).
Electrostatic gets chosen before Great, so if it's high enough than Great won't happen.

[b]'74 Super Outbreak[/b]: Have at least one dust devil on the map at all times.
Mod Options:
Twister Amount: Minimum amount of twisters on the map (max is 2 * amount).
Twister Max Amount: If you want to set the max (0 to ignore).
Electrostatic Dust Devils: Chance of electrostatic dust devil (drains drone batteries).




This mod obsoletes two of my other mods:
Game Rule Meteor Threat
Game Rule Winter Wonderland
]],
})
