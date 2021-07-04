-- See LICENSE for terms

local table = table

-- always report building as not-a-wonder to the func that checks for wonders
local orig_UIGetBuildingPrerequisites = UIGetBuildingPrerequisites
function UIGetBuildingPrerequisites(cat_id, template, bCreateItems, ignore_checks, ...)
	if template.wonder then
		-- false so there's no build limit
		template.wonder = false

		-- store ret values as a table since there's more than one, and an update may change the amount
		local ret = {orig_UIGetBuildingPrerequisites(cat_id, template, bCreateItems, ignore_checks, ...)}

		-- we don't want to edit the template for anything else that uses it
		template.wonder = true

		return table.unpack(ret)
	end

	return orig_UIGetBuildingPrerequisites(cat_id, template, bCreateItems, ignore_checks, ...)
end
