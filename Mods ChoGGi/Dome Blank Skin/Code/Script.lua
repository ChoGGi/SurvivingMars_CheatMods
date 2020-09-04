-- See LICENSE for terms

local AsyncRand = AsyncRand
local table_icopy = table.icopy
local table_copy = table.copy

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
if g_AvailableDlc.armstrong then
	local orig_OpenAirBuilding_GetSkins = OpenAirBuilding.GetSkins
	function OpenAirBuilding:GetSkins(...)
		return GetSkins(orig_OpenAirBuilding_GetSkins, self, ...)
	end
else
	local orig_GetSkins = Building.GetSkins
	function Dome:GetSkins(...)
		return GetSkins(orig_GetSkins, self, ...)
	end
end

