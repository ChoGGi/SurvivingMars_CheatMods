-- See LICENSE for terms

-- local some globals
local type = type
local Measure = UIL.MeasureImage
-- updated below
local mod_path

local function FixPath(image)
	-- not everything sent from below is an image str (in-game paths all use tga)
	if not image or type(image) == "string" and not image:find_lower(".tga") then
		-- send back it
		return image
	end

	-- if w and h are over 0 then it's an image
	local w, h = Measure(image)
--~ 	print(w, h, image:gsub(mod_path, ""), image, mod_path)
	if w > 0 and h > 0 then
		return image
	end

	-- strip away packed path if the image is missing
	return image:gsub(mod_path, "")
end

function OnMsg.ModsReloaded()
	-- loop through all the mods and test all the icon paths
	local Mods = Mods
	for _, mod_def in pairs(Mods) do
		-- no items, no paths to fix up (though my mods are probably the only ones with no items)
		local items = mod_def.items
		if items then
			-- update path var (used in FixPath)
			mod_path = mod_def.env.CurrentModPath
			for i = 1, #items do
				local item = items[i]
				-- start fixing paths
				item.icon = FixPath(item.icon)
				item.display_icon = FixPath(item.display_icon)
				item.encyclopedia_image = FixPath(item.encyclopedia_image)
				item.upgrade1_icon = FixPath(item.upgrade1_icon)
				item.upgrade2_icon = FixPath(item.upgrade2_icon)
				item.upgrade3_icon = FixPath(item.upgrade3_icon)
				-- it can happen (i check if it's an image path above)
				item.value = FixPath(item.value)
			end
		end
	end
end
