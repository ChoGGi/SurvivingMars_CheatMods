-- See LICENSE for terms

local table = table
local T = T
local PlaceObj = PlaceObj
local g_AvailableDlc = g_AvailableDlc

-- there's no list of all the dlc, so...
local dlc = {
	"ariane",
	"armstrong",
	"contentpack1",
	"contentpack3",
	"dde",
	"gagarin",
	"kerwin",
	"marsvision",
	"ockels",
	"picard",
	"preorder",
	"prunariu",
	"shepard",
	"wubbo",
	"zubrin", -- Robert Zubrin, I don't think this DLC will ever see the light of day
}
local dlc_names = {
	ariane = T(392597027369, "The Future Contemporary Asset Pack"),
	armstrong = T(429022939682, "Green Planet"),
	contentpack1 = T(34582765515863, "Mysteries Resupply Pack"),
	contentpack3 = T(11447, "Colony Design Set"),
	dde = T(8565, "Deluxe Edition Upgrade Pack"),
	gagarin = T(11095, "Space Race"),
	kerwin = T(469614409798, "In-Dome Buildings Pack"),
	marsvision = T(11693, "Marsvision Song Contest"),
	ockels = T(930916719229, "Revelation Radio"),
	picard = T(850718940827, "Below and Beyond"),
	preorder = T(8566, "Stellaris Dome Set"),
	prunariu = T(168219966957, "Prunariu"),
	shepard = T(750560872368, "Project Laika"),
	wubbo = T(934036492225, "Mars Lifestyle Radio"),
	-- arr?
	zubrin = T(990970539163, "Zubrin"),
}

-- remove when released
local unreleased = {
	zubrin = true,
}
-- remove when released

local mod_options = {}
local c = 0

for i = 1, #dlc do
	c = c + 1
	local id = dlc[i]
	local available = g_AvailableDlc[id]
	local ava_str = available and " *" or ""

	mod_options[c] = PlaceObj("ModItemOptionToggle", {
		"name", id,
		"DisplayName", table.concat{dlc_names[id], ava_str},
		"DefaultValue", true,
		"Help", T(0000, "* means you have the dlc."),
	})

	-- remove when released
	if available and unreleased[id] then
		mod_options[c].Help = T(0000, [[
Warning: This is unreleased probably buggy DLC.

If this DLC is offically released than ignore this text (bug me to update this mod).
]])
	end
	-- remove when released
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
