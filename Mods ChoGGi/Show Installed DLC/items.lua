-- See LICENSE for terms

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
	"zubrin",
}
local dlc_names = {
	armstrong = T(429022939682, "Green Planet"),
	contentpack1 = T(34582765515863, "Mysteries Resupply Pack"),
	contentpack3 = T(11447, "Colony Design Set"),
	dde = T(8565, "Deluxe Edition Upgrade Pack"),
	gagarin = T(11095, "Space Race"),
	kerwin = T(469614409798, "In-Dome Buildings Pack"),
	marsvision = T(11693, "Marsvision Song Contest"),
	picard = T(850718940827, "Below and Beyond"),
	preorder = T(8566, "Stellaris Dome Set"),
	shepard = T(750560872368, "Project Laika"),
	wubbo = T(934036492225, "Mars Lifestyle Radio"),
	-- arr
	ariane = T(392597027369, "The Future Contemporary Asset Pack"),
	ockels = T(930916719229, "Revelation Radio"),
	zubrin = T(990970539163, "Zubrin"),
	prunariu = T(168219966957, "Prunariu"),
}

-- remove when released
local unreleased = {
	zubrin = true,
}
-- remove when released

local properties = {}
local c = 0

for i = 1, #dlc do
	c = c + 1
	local id = dlc[i]
	local available = g_AvailableDlc[id]

	properties[c] = PlaceObj("ModItemOptionToggle", {
		"name", id,
		"DisplayName", dlc_names[id],
		"DefaultValue", available,
	})

	-- remove when released
	if available and unreleased[id] then
		properties[c].Help = T(0000, [[
Warning: This is unreleased probably buggy DLC.

If this DLC is offically released than ignore this text (bug me to update this mod).
]])
	end
	-- remove when released
end

return properties
