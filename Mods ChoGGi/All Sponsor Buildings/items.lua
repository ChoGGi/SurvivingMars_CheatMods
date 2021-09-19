-- See LICENSE for terms

local def = CurrentModDef
-- we need to store the list of sponsor locked buildings
local sponsor_buildings = def.sponsor_buildings or {}

local T = T
local PlaceObj = PlaceObj
local table = table

local properties = {}
local c = 0

local BuildingTemplates = BuildingTemplates
for id, bld in pairs(BuildingTemplates) do
	for i = 1, 3 do
		if sponsor_buildings[id] or bld["sponsor_status" .. i] ~= false then
			sponsor_buildings[id] = true

			local image = ""
			if bld.encyclopedia_image and bld.encyclopedia_image ~= "" then
				image = "\n\n<image " .. bld.encyclopedia_image .. ">"
			elseif bld.display_icon and bld.display_icon ~= "" then
				image = "\n\n<image " .. bld.display_icon .. ">"
			end
			c = c + 1
			properties[c] = PlaceObj("ModItemOptionToggle", {
				"name", "ChoGGi_" .. id,
				"DisplayName", T(bld.display_name),
				"Help", table.concat(T(bld.description) .. image),
				"DefaultValue", true,
			})
			c = c + 1
			properties[c] = PlaceObj("ModItemOptionToggle", {
				"name", "ChoGGi_Tech_" .. id,
				"DisplayName", T(bld.display_name) .. " " .. T(3734, "Tech"),
				"Help", T(0000, "Lock behind tech unlock."),
				"DefaultValue", true,
			})
			break
		end
	end
end

-- If first time then save them
if not def.sponsor_buildings then
	def.sponsor_buildings = sponsor_buildings
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

--~ table.insert(properties, 1, PlaceObj("ModItemOptionToggle", {
--~ 		"name", "LockBehindTech",
--~ 		"DisplayName", T(302535920011937, "Lock Behind Tech"),
--~ 		"Help", T(302535920011938, "You need to research tech to unlock certain buildings (reload save to take effect)."),
--~ 		"DefaultValue", true,
--~ 	})
--~ )

return properties
