-- See LICENSE for terms

local mod_options = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxSpawn",
		"DisplayName", T(302535920011387, "<color ChoGGi_yellow>Max Spawn</color>"),
		"Help", T(302535920011480, "Max amount to spawn."),
		"DefaultValue", 50,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RandomGrazeTime",
		"DisplayName", T(0000, "<color ChoGGi_yellow>Random Graze Time</color>"),
		"Help", T(0000, "How long to Graze for (seconds)."),
		"DefaultValue", 85,
		"MinValue", 0,
		"MaxValue", 600,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RandomIdleTime",
		"DisplayName", T(0000, "<color ChoGGi_yellow>Random Idle Time</color>"),
		"Help", T(0000, "How long to Idle for (seconds)."),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 600,
	}),
}
local c = #mod_options

local animals = {
	{"Chicken", T(299174615385--[[Chicken]])},
	{"Deer", T(409677371105--[[Deer]])},
	{"Goose", T(319767019420--[[Goose]])},
	{"Lama_Ambient", T(808881013020--[[Llama]])},
	{"Ostrich", T(929526939780--[[Ostrich]])},
	{"Pig", T(221418710774--[[Pig]])},
	{"Pony_01", T(176071455701--[[Pony]])},
	{"Pony_02", T(176071455701--[[Pony]])},
	{"Pony_03", T(176071455701--[[Pony]])},
	{"Rabbit_01", T(520473377733--[[Rabbit]])},
	{"Rabbit_02", T(520473377733--[[Rabbit]])},
	{"Turkey", T(977344055059--[[Turkey]])},
	{"Tortoise", T(768070368933--[[Tortoise]])},
	{"Platypus", T(210528297343--[[Platypus]])},
	{"Penguin_01", T(397432391921--[[Penguin]])},
	{"Penguin_02", T(397432391921--[[Penguin]])},
	{"Penguin_03", T(397432391921--[[Penguin]])},
}

for i = 1, #animals do
	local animal = animals[i]
	c = c + 1
	mod_options[c] = PlaceObj("ModItemOptionToggle", {
		"name", animal[1],
		"DisplayName", animal[2],
		"Help", table.concat(T(0000, "Allow this animal to spawn.") .. "\n\nenity: " .. animal[1]),
		"DefaultValue", true,
	})
end

-- Sort by display name
local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
