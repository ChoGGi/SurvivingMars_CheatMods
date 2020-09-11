-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local orig_Activate = LayoutConstructionController.Activate
function LayoutConstructionController:Activate(...)
	-- fire first so it builds the tables/etc
	local ret = orig_Activate(self, ...)

	if not mod_EnableMod then
		return ret
	end

	-- now remove what shouldn't be there
	local GetBuildingTechsStatus = GetBuildingTechsStatus
	local UICity = UICity
	local BuildingTemplates = BuildingTemplates

	local controllers = self.controllers or empty_table
	for entry in pairs(controllers) do
		local template = BuildingTemplates[entry.template]
		if template then
			local _, tech_enabled = GetBuildingTechsStatus(template.id, template.build_category)

			-- If it isn't unlocked and there's no prefabs then remove it
			if not tech_enabled and UICity:GetPrefabs(template.id) == 0 then
				self.skip_items[entry] = true
				controllers[entry]:Deactivate()
				controllers[entry] = nil
			end

		end
	end

	return ret
end
