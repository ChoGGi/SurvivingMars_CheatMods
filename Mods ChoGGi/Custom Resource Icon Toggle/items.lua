-- See LICENSE for terms

local table = table
local PlaceObj = PlaceObj
local T = T

local properties = {}
local c = 0

-- skip instead of add for mod added ones
local skips = {
	EffectDeposit = true,
	SubsurfaceAnomaly_aliens = true,
	SubsurfaceAnomaly_breakthrough = true,
	SubsurfaceAnomaly_complete = true,
	SubsurfaceAnomaly_unlock = true,
	SubsurfaceDeposit = true,
	SurfaceDeposit = true,
	SurfaceDepositConcrete = true,
	SurfaceDepositGroup = true,
	SurfaceDepositMetals = true,
	SurfaceDepositPolymers = true,
	TerrainDeposit = true,

	MetatronAnomaly = true,
	MirrorSphereAnomaly = true,
}

ClassDescendantsList("Deposit", function(name, class)
	if not skips[name] then
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionToggle", {
			"name", name,
			"DisplayName", class.display_name,
			"Help", T(302535920011943, "Turn on to have these icons toggled, turn off to always be visible."),
			"DefaultValue", true,
		})
	end
end)

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

table.insert(properties, 1, PlaceObj("ModItemOptionToggle", {
	"name", "ShowIcons",
	"DisplayName", T(302535920011944, "<color 255 255 0>Show Icons</color>"),
	"Help", T(302535920011945, "Turn this on to show all icons, turn off to hide certain icons."),
	"DefaultValue", true,
}))

table.insert(properties, 1, PlaceObj("ModItemOptionToggle", {
	"name", "EnableMod",
	"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
	"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
	"DefaultValue", true,
}))

return properties
