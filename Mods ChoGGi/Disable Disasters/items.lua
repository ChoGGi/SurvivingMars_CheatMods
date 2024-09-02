-- See LICENSE for terms

local mod_options = {}
local c = #mod_options
local table = table

local disasters = {
	ColdWave = T(4148, "Cold Waves"),
	DustDevils = T(4142, "Dust Devils"),
	DustStorm = T(4144, "Dust Storms"),
	Meteor = T(4146, "Meteors"),
--~ 	Marsquake = T(382404446864, "Marsquake"),
--~ 	RainsDisaster = T(558613651480, "Toxic Rains"),
}

for id, text in pairs(disasters) do
	c = c + 1
	mod_options[c] = PlaceObj("ModItemOptionToggle", {
		"name", id,
		"DisplayName", table.concat(T(302535920011494, "Turn off ") .. text),
		"Help", T(302535920011493, "Enable this option to stop this type of disaster from occurring."),
		"DefaultValue", false,
	})
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options