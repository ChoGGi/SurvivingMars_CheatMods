-- See LICENSE for terms

local mod_options = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddRivals",
		"DisplayName", T(0000, "Rival Amount"),
		"Help", T(0000, [[How many rivals to spawn.

This is ignored if you've manually selected rivals below!]]),
		"DefaultValue", 3,
		"MinValue", 0,
		"MaxValue", #Presets.DumbAIDef.MissionSponsors,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RivalSpawnSol",
		"DisplayName", T(0000, "Rival Spawn Sol"),
		"Help", T(0000, "Pick Sol that rivals will spawn on."),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 999,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RivalSpawnSolRandom",
		"DisplayName", T(0000, "Rival Spawn Sol Random"),
		"Help", T(0000, [[Turn this on to randomise Rival Spawn Sol.
Min value is 1, Max value is set to Rival Spawn Sol.
You might need to re-apply mod options after starting a couple new games.]]),
		"DefaultValue", false,
	}),
}

local c = #mod_options

local rivals = Presets.DumbAIDef.MissionSponsors
for i = 1, #rivals do
	local rival = rivals[i]
	if rival.id ~= "none" and rival.id ~= "random" then
		c = c + 1
		mod_options[c] = PlaceObj("ModItemOptionToggle", {
			"name", rival.id,
			"DisplayName", T(rival.display_name),
			"Help", T(rival.description .. "<newline> If turned on this will be used as a rival instead of random (this will override Rival Amount)."),
			"DefaultValue", false,
		})
	end
end

return mod_options
