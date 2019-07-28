-- See LICENSE for terms

local GetBuildingTechsStatus = GetBuildingTechsStatus

local function CleanUp()
	local UICity = UICity
	local BuildingTemplates = BuildingTemplates

	local controllers = self.controllers or empty_table
	for entry, controller in pairs(controllers) do
		local template = BuildingTemplates[entry.template]
		if template then
			local tech_shown, tech_enabled = GetBuildingTechsStatus(template.id, template.build_category)

			-- if it isn't unlocked and there's no prefabs then remove it
			if not tech_enabled and UICity:GetPrefabs(template.id) == 0 then
				self.skip_items[entry] = true
				controllers[entry]:Deactivate()
				controllers[entry] = nil
			end

		end
	end
end

local orig_Activate = LayoutConstructionController.Activate
function LayoutConstructionController:Activate(...)
	-- fire first so it builds the tables/etc
	orig_Activate(self, ...)
	-- now remove what shouldn't be there
	CleanUp(self)
end
