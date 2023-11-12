-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T

local properties = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
}
local c = #properties

-- Check for map images pack and use previews.
local image_mod = Mods.ChoGGi_MapImagesPack

local MapDataPresets = MapDataPresets
for id, item in pairs(MapDataPresets) do
	if item.IsRandomMap then
		-- strip out "Blank"
		local name = id:sub(6)
		-- Fails on Undergound maps, but asteroids are okay
		if not name:find("Undergound") then
			local desc = T(000, "Only turn on one map.")
			-- Add preview image
			if image_mod and not name:find("Asteroid") then
				desc = desc .. "\n\n<image " .. image_mod.env.CurrentModPath .. "Maps/" .. id .. ".png>"
			end
			c = c + 1
			properties[c] = PlaceObj("ModItemOptionToggle", {
				"name", id,
				"DisplayName", name,
				"Help", desc,
				"DefaultValue", false,
			})
		end
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)


return properties
