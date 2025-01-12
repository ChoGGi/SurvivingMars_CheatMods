-- See LICENSE for terms

local mod_EnableMod

local specs = {
	botanist = true,
	engineer = true,
	geologist = true,
	medic = true,
	scientist = true,
	security = true,
	Tourist = true,
}
-- build a translated string to use
local workers_string
local ColonistSpecialization = const.ColonistSpecialization

local ChoOrig_UIItemMenu = UIItemMenu
function UIItemMenu(category_id, bCreateItems, ...)
	if not mod_EnableMod or not bCreateItems then
		return ChoOrig_UIItemMenu(category_id, bCreateItems, ...)
	end

	local items, count = ChoOrig_UIItemMenu(category_id, bCreateItems, ...)
--~ 	ex(items)
	local templates = BuildingTemplates
	for i = 1, #items do
		local item = items[i]
		local template = templates[item.Id]
		if template then
			local spec = template.specialist
			if specs[spec] then
				item.description = item.description .. "\n" .. workers_string
					.. ColonistSpecialization[spec].display_name_plural
			end
		end
	end
	return items, count
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- I did this in here in case user changes language
	workers_string = _InternalTranslate(T(995212188397--[[Best workers<right><em><UISpecialization></em>"]]))
	workers_string = workers_string:sub(1, 19)

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
