-- See LICENSE for terms

local table = table

-- always report building as not-a-wonder to the func that checks for wonders
local ChoOrig_UIGetBuildingPrerequisites = UIGetBuildingPrerequisites
function UIGetBuildingPrerequisites(cat_id, template, ...)
	if template.build_once then
		-- false so there's no build limit
		template.build_once = false

		-- store ret values as a table since there's more than one, and an update may change the amount
		local ret = {ChoOrig_UIGetBuildingPrerequisites(cat_id, template, ...)}

		-- we don't want to edit the template for anything else that uses it
		template.build_once = true

		return table.unpack(ret)
	end

	return ChoOrig_UIGetBuildingPrerequisites(cat_id, template, ...)
end
