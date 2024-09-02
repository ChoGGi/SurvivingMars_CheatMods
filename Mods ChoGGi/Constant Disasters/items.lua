-- See LICENSE for terms

local properties = {}
local c = #mod_options
local disasters = {
	ColdWaves = T(4148, "Cold Waves"),
	DustStorms = T(4144, "Dust Storms"),
	DustDevils = T(4142, "Dust Devils"),
	MeteorStorms = T(5620, "Meteor Storm"),
	Marsquakes = T(866254995932, "Marsquakes"),
	Rains = T(553301803055, "Rain!"),
}

for id, name in pairs(disasters) do
	c = c + 1
	properties[c] = PlaceObj("ModItemOptionToggle", {
		"name", "Constant_" .. id,
		"DisplayName", name,
		"DefaultValue", false,
	})

	c = c + 1
	properties[c] = PlaceObj("ModItemOptionNumber", {
		"name", "Delay_" .. id,
		"DisplayName", table.concat(T(3778, "Hours") .. " " .. name),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 600,
		"StepSize", 10,
	})
end

return properties
