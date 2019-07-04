-- See LICENSE for terms

local properties = {}
local c = 0
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
	properties[c] = {
		default = false,
		editor = "bool",
		id = "Constant_" .. id,
		name = name,
	}
	c = c + 1
	properties[c] = {
		default = 1,
		max = 600,
		min = 1,
		editor = "number",
		id = "Delay_" .. id,
		name = T(3778, "Hours") .. " " .. name,
	}
end

-- max 40 chars
DefineClass("ModOptions_ChoGGi_ConstantDisasters", {
	__parents = {
		"ModOptionsObject",
	},
	properties = properties,
})
