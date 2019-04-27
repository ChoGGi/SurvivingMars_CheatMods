-- See LICENSE for terms

local Measure = UIL.MeasureImage
local Ready = UIL.IsImageReady
local Reload = UIL.ReloadImage
local function FixPath(image,mod_path)
	if not image then
		return
	end

	-- leftover from my library func (doesn't hurt to check)
	if not Ready(image) then
		Reload(image)
	end

	local x,y = Measure(image)
	if x > 0 and y > 0 then
		return image
	end

	-- strip away packed path if the image is missing
	return image:gsub(mod_path,"")
end

local function StartupCode()
	local ct = ClassTemplates.Building
	local bt = BuildingTemplates

	for id,bld in pairs(bt) do
		-- only check modded buildings
		if bld.mod then
			local mod_path = bld.mod.env.CurrentModPath
			bld.display_icon = FixPath(bld.display_icon,mod_path)
			bld.encyclopedia_image = FixPath(bld.encyclopedia_image,mod_path)
			-- upgrade icons
			local bld_ct = ct[id]
			bld_ct.upgrade1_icon = FixPath(bld.upgrade1_icon,mod_path)
			bld_ct.upgrade2_icon = FixPath(bld.upgrade2_icon,mod_path)
			bld_ct.upgrade3_icon = FixPath(bld.upgrade3_icon,mod_path)
		end
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
