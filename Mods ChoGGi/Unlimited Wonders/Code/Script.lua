-- See LICENSE for terms

local table_unpack = table.unpack

-- always report building as not-a-wonder to the func that checks for wonders
local orig_UIGetBuildingPrerequisites = UIGetBuildingPrerequisites
function UIGetBuildingPrerequisites(cat_id, template, ...)
	-- save orig boolean
	local orig_wonder = template.wonder
	-- always false so there's no build limit
	template.wonder = false
	-- store ret values as a table since there's more than one, and an update may change the amount
	local ret = {orig_UIGetBuildingPrerequisites(cat_id, template, ...)}

	-- make sure to restore orig value after func fires
	template.wonder = orig_wonder
	return table_unpack(ret)
end
