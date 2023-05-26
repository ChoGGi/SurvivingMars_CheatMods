-- See LICENSE for terms

if not g_AvailableDlc.shepard then
	print(CurrentModDef.title, ": Project Laika DLC not installed! Abort!")
	return
end

local classes = {
  RoamingPet = true,
  Pet = true,
  StaticPet = true,
}

local PlaceObj = PlaceObj
local T = T

local properties = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SpawnDelayPercent",
		"DisplayName", T(302535920011962, "<color ChoGGi_yellow>Spawn Delay Percent</color>"),
		"Help", T(302535920011963, "100% is default delay, 50% is half the delay."),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 200,
	}),
}
local c = 2

local Animals = Animals
for id, def in pairs(Animals) do
	if classes[def.AnimalClass] then
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionToggle", {
			"name", id,
			"DisplayName", T(def.display_name),
			"Help", T(302535920011961, "Turning <color ChoGGi_red>off</color> will allow the animal to spawn."),
			"DefaultValue", true,
		})
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties
