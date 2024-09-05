-- See LICENSE for terms

local mod_AmountOfWater
local mod_FollowWaterParameter

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_AmountOfWater = CurrentModOptions:GetProperty("AmountOfWater") * const.ResourceScale
	mod_FollowWaterParameter = CurrentModOptions:GetProperty("FollowWaterParameter")
	if not g_AvailableDlc.armstrong then
		mod_FollowWaterParameter = false
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local scale = const.ResourceScale + 0.0

local function EachDeposit(obj)
	if type(obj.amount) == "number" then

		if mod_FollowWaterParameter and g_AccessibleDlc.armstrong then
			local percent = (Terraforming.Water / scale) / 1000
			obj.amount = obj.amount + (percent * obj.amount)
		else
			obj.amount = obj.amount + (mod_AmountOfWater or 50000)
		end

		if obj.amount > obj.max_amount then
			obj.amount = obj.max_amount
		end
	end
end

function OnMsg.NewDay()
	GameMaps[MainMapID].realm:MapForEach("map", "SubsurfaceDepositWater", EachDeposit)
end
