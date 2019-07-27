-- See LICENSE for terms

local options
local mod_logos = {}
local mod_logos_c = 0

local ChangeLogo
-- fired when settings are changed/init
local function ModOptions()
	if not GameState.gameplay then
		return
	end

	for i = 1, mod_logos_c do
		local id = mod_logos[i]
		if options[id] then
			ChangeLogo(id)
		end
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
--~ 	ex(Dialogs)

	-- update mod option properties
	table.iclear(mod_logos)
	mod_logos_c = 0

	local p = options.properties
	table.iclear(p)

	local meta = getmetatable(options)
	local MissionLogoPresetMap = MissionLogoPresetMap
	for id, def in pairs(MissionLogoPresetMap) do
		mod_logos_c = mod_logos_c + 1
		p[mod_logos_c] = {
			default = false,
			editor = "bool",
			name = T(def.display_name) .. "<right><image " .. def.image .. ">",
			id = id,
		}
		mod_logos[mod_logos_c] = id
		-- needed for mod options cancel (since I didn't add options in options.lua)
		meta[id] = false
	end

	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_ChangeLogo" then
		return
	end

	ModOptions()
end

local GetAllAttaches = ChoGGi.ComFuncs.GetAllAttaches
local RetAllOfClass = ChoGGi.ComFuncs.RetAllOfClass

local function ChangeAttachesLogo(label, entity_name)
	label = RetAllOfClass(label)
	for i = 1, #label do
		local attaches = GetAllAttaches(label[i], nil, "Logo")
		for j = 1, #attaches do
			attaches[j]:ChangeEntity(entity_name)
		end
	end
end

ChangeLogo = function(logo_str)
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
