-- See LICENSE for terms

local table = table

local GetAllAttaches = ChoGGi_Funcs.Common.GetAllAttaches
local MapGet = ChoGGi_Funcs.Common.MapGet

local options
local mod_logos = {}
local mod_logos_c = 0

local function ChangeAttachesLogo(label, entity_name)
	label = MapGet(label)
	for i = 1, #label do
		local attaches = GetAllAttaches(label[i], nil, "Logo")
		for j = 1, #attaches do
			attaches[j]:ChangeEntity(entity_name)
		end
	end
end

local function ChangeLogo(logo_str)
	local logo = MissionLogoPresetMap[logo_str]
	if not logo then
		return
	end

	local entity_name = logo.entity_name

	-- for any new objects
	g_CurrentMissionParams.idMissionLogo = logo_str

	-- might help for large amounts of buildings
	SuspendPassEdits("ChoGGi.ChangeLogo")

	-- loop through rockets and change logo
	ChangeAttachesLogo("SupplyRocket", entity_name)
	-- same for any buildings that use the logo
	ChangeAttachesLogo("Building", entity_name)

	ResumePassEdits("ChoGGi.ChangeLogo")
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	if not UIColony then
		return
	end

	for i = 1, mod_logos_c do
		local id = mod_logos[i]
		if options:GetProperty(id) then
			ChangeLogo(id)
		end
	end
end

-- Load default/saved settings
-- build list of logos
function OnMsg.ModsReloaded()
	options = CurrentModOptions

	-- reset logo list
	table.iclear(mod_logos)
	mod_logos_c = 0
	-- reset options
	local properties = options.properties
	table.iclear(properties)
	-- add table for defaults if needed
	if not options.__defaults then
		options.__defaults = {}
	end

	local items = CurrentModDef.items
	local items_c = #items

	local MissionLogoPresetMap = MissionLogoPresetMap
	for id, def in pairs(MissionLogoPresetMap) do
		local image = "<image " .. def.image .. ">"
		local name = def.display_name

		mod_logos_c = mod_logos_c + 1
		properties[mod_logos_c] = {
			default = false,
			editor = "bool",
			name = name,
			help = image,
			id = id,
		}
		-- add to mod items list if not already added
		if not table.find(items, "name", id) then
			items_c = items_c + 1
			items[items_c] = PlaceObj("ModItemOptionToggle", {
				"name", id,
				"DisplayName", name,
				"Help", image,
				"DefaultValue", false,
			})
		end

		mod_logos[mod_logos_c] = id
		-- needed for mod options cancel (since I didn't add options in items.lua)
		options.__defaults[id] = false
	end

	-- sort logo list
	local CmpLower = CmpLower
	local _InternalTranslate = _InternalTranslate
	table.sort(items, function(a, b)
		return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
	end)
	for i = 1, mod_logos_c do
		local id = properties[i].id
		mod_logos[i] = id
	end

end
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
