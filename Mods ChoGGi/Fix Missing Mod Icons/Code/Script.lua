-- See LICENSE for terms

local Measure = UIL.MeasureImage
local function FixPath(image, mod_path)
	if not image then
		return
	end

	-- if w and h are over 0 then it's an image
	local w, h = Measure(image)
	if w > 0 and h > 0 then
		return image
	end

	-- strip away packed path if the image is missing
	return image:gsub(mod_path, "")
end

local icons = {
	"CropPresets",
	"BuildMenuSubcategories",
	"TechDef",
}

local pairs = pairs
local function StartupCode()
	local ct = ClassTemplates.Building

	local BuildingTemplates = BuildingTemplates
	for id, bld in pairs(BuildingTemplates) do
		-- only check modded buildings
		if bld.mod then
			local mod_path = bld.mod.env.CurrentModPath
			bld.display_icon = FixPath(bld.display_icon, mod_path)
			bld.encyclopedia_image = FixPath(bld.encyclopedia_image, mod_path)
			-- upgrade icons
			local bld_ct = ct[id]
			bld_ct.upgrade1_icon = FixPath(bld.upgrade1_icon, mod_path)
			bld_ct.upgrade2_icon = FixPath(bld.upgrade2_icon, mod_path)
			bld_ct.upgrade3_icon = FixPath(bld.upgrade3_icon, mod_path)
		end
	end

	-- maybe think about adding all preset global maps
	for i = 1, #icons do
		local items = _G[icons[i]]
		for _, item in pairs(items) do
			if item.mod then
				item.icon = FixPath(item.icon, item.mod.env.CurrentModPath)
			end
		end
	end

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
