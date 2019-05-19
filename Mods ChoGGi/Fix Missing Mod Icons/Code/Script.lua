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
	-- just for you enzo (and I guess anyone else)
	local CropPresets = CropPresets
	for id, crop in pairs(CropPresets) do
		if crop.mod then
			crop.icon = FixPath(crop.icon, crop.mod.env.CurrentModPath)
		end
	end

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
