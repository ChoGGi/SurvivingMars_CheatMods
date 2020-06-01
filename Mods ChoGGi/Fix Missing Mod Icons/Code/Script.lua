-- See LICENSE for terms

-- local some globals
local type = type
local UIL_Measure = UIL.MeasureImage

-- updated below
local mod_path1, mod_path2

local function FixPath(image)
	-- not everything sent from below is an image str (in-game paths all use tga)
	if not image or type(image) == "string" and not (image:find_lower(".tga") or image:find_lower(".png")) then
		-- send back it
		return image
	end

	-- if w and h are over 0 then it's an image
	local w, h = UIL_Measure(image)
	if w > 0 and h > 0 then
		return image
	end

	-- ClassTemplates doesn't have the .mod added, so there's no path to use
	if mod_path1 then
		-- strip away packed path if the image is missing
		return image:gsub(mod_path1, ""):gsub(mod_path2, "")
	else
		-- need to reverse string so it finds the last one, since find looks ltr
		local last = image:reverse():find("/IU/", 1, true)
		if last then
			-- we need a neg number for sub + 1 to remove the slash
			return "UI/" .. image:sub((last * -1) + 1)
		end
	end

	-- make sure we don't blank out the icon... If there's some weird issue (Sir McKaby, Destroyer of Mods)
	return image
end

function OnMsg.ModsReloaded()
	-- of course ClassTemplates...
	local ct = ClassTemplates.Building
	for _, item in pairs(ct) do
		item.icon = FixPath(item.icon)
		item.display_icon = FixPath(item.display_icon)
		item.encyclopedia_image = FixPath(item.encyclopedia_image)
		item.upgrade1_icon = FixPath(item.upgrade1_icon)
		item.upgrade2_icon = FixPath(item.upgrade2_icon)
		item.upgrade3_icon = FixPath(item.upgrade3_icon)
	end

	-- loop through all the mods and test all the icon paths
	local ConvertToOSPath = ConvertToOSPath
	local Mods = Mods
	for _, mod_def in pairs(Mods) do
		-- no items, no paths to fix up (though my mods are probably the only ones with no items)
		local items = mod_def.items
		if items then
			-- update path var (used in FixPath)
			mod_path1 = mod_def.env.CurrentModPath
			mod_path2 = ConvertToOSPath(mod_path1):gsub("\\","/")
			for i = 1, #items do
				local item = items[i]
				if item then
					-- start fixing paths
					item.icon = FixPath(item.icon)
					item.display_icon = FixPath(item.display_icon)
					item.encyclopedia_image = FixPath(item.encyclopedia_image)
					item.upgrade1_icon = FixPath(item.upgrade1_icon)
					item.upgrade2_icon = FixPath(item.upgrade2_icon)
					item.upgrade3_icon = FixPath(item.upgrade3_icon)
					-- it can happen (i check if it's an image path above)
					item.value = FixPath(item.value)
					-- sponsors
					for j = 1, 5 do
						local image = "goal_image_" .. j
						item[image] = FixPath(item[image])
					end
					for j = 1, 5 do
						local image = "goal_pin_image_" .. j
						item[image] = FixPath(item[image])
					end
				end
			end
		end
	end
end
