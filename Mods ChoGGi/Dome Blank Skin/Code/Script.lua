-- See LICENSE for terms

local AsyncRand = AsyncRand
local table_icopy = table.icopy
local table_copy = table.copy
--~ local table_rand = table.rand

--~ -- make meteor impacts work
--~ local leak_height = point(0, 0, 2000)
--~ local orig_IntersectRayWithObject = IntersectRayWithObject
--~ function IntersectRayWithObject(start, dest, glass, ...)
--~ 	if glass.class == "InvisibleObject" then
--~ 		local dome = glass:GetParent()
--~ 		if not dome then
--~ 			return glass:GetPos() + leak_height
--~ 		end
--~ 		local buildings = dome.labels.Buildings or ""
--~ 		if #buildings == 0 then
--~ 			return glass:GetPos() + leak_height
--~ 		end
--~ 		return table_rand(buildings):GetPos() + leak_height
--~ 	end
--~ 	return orig_IntersectRayWithObject(start, dest, glass, ...)
--~ end

local function GetSkins(func, self, ...)
	local skins, palettes = func(self, ...)

	-- skip domes opened by GP dlc
	if not self.open_air then
		local skin_count = #skins
		-- pick a random skin to use for road variety
		local rand = AsyncRand(skin_count - 1 + 1) + 1
		local count = skin_count + 1
		-- we need to make sure we make a copy of the skin and not override the built-in skin tables
		skins[count] = table_copy(skins[rand])
		local new_skin = skins[count]
		new_skin[2].ChoGGi_DomeBlankSkin = true

		new_skin[2] = table_icopy(skins[rand][2])
		local skin_entities = new_skin[2]
		for i = 1, #skin_entities do
			skin_entities[i] = table_icopy(skin_entities[i])
		end

		-- change it to not use any glass
		for i = 1, #skin_entities do
			-- find the glass entity and change it to InvisibleObject
			if skin_entities[i][1]:sub(-6) == "_Glass" then
				skin_entities[i][1] = "InvisibleObject"
			-- some domes have bars on the glass
			elseif skin_entities[i][1]:sub(-4) == "_Top" then
				skin_entities[i][1] = "InvisibleObject"
			end
		end

		palettes[#palettes+1] = palettes[rand]
	end

	return skins, palettes
end


-- add our "skin"
local orig_OpenAirBuilding_GetSkins = OpenAirBuilding.GetSkins
function OpenAirBuilding:GetSkins(...)
	return GetSkins(orig_OpenAirBuilding_GetSkins, self, ...)
end

function OnMsg.ClassesPostprocess()
	local orig_Dome_GetSkins = Dome.GetSkins
	function Dome:GetSkins(...)
		return GetSkins(orig_Dome_GetSkins, self, ...)
	end

--~ 	-- make meteor impacts work
--~ 	local orig_Building_GetAttach = Building.GetAttach
--~ 	function Building:GetAttach(entity, ...)
--~ 		if entity == self.entity .. "_Glass" and self:GetCurrentSkin()[2].ChoGGi_DomeBlankSkin then
--~ 			entity = "InvisibleObject"
--~ 		end
--~ 		return orig_Building_GetAttach(self, entity, ...)
--~ 	end

end
