-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print("Fix Deposits Stuck Underground: Below and Beyond DLC NOT INSTALLED!")
	return
end

--~ local RetObjMapId = ChoGGi.ComFuncs.RetObjMapId
local function RetObjMapId(obj)
	if obj then
		return obj.city and obj.city.map_id or obj.GetMapID and obj:GetMapID()
	end
end

local mod_EnableMod

-- skip the indexed sector tables since we're using pairs()
local sector_nums = {
 [1] = true,
 [2] = true,
 [3] = true,
 [4] = true,
 [5] = true,
 [6] = true,
 [7] = true,
 [8] = true,
 [9] = true,
 [10] = true,
}

local function UpdateDeposits()
	if not mod_EnableMod then
		return
	end

	local MainMapID = MainMapID
	local sectors = MainCity.MapSectors
	for sector in pairs(sectors) do
		if not sector_nums[sector] and #sector.markers.surface > 0 then
			local deposits = sector.markers.surface
			for i = 1, #deposits do
				local deposit = deposits[i].deposit
				-- no point in moving something already there
				if deposit and RetObjMapId(deposit) ~= MainMapID then
					-- move d to surface map (preserves position)
					deposit:TransferToMap(MainMapID)
					-- z is still set to z from underground
					local pos = deposit:GetPos()
					deposit:SetPos(pos:SetZ(GameMaps[MainMapID].terrain:GetHeight(pos)))
				end
			end
		end
	end
end
--~ OnMsg.CityStart = UpdateDeposits
OnMsg.LoadGame = UpdateDeposits

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game UIColony
	if not UICity then
		return
	end

	UpdateDeposits()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
