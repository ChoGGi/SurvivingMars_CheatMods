-- See LICENSE for terms

local mod_AmountOfWater

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_AmountOfWater = CurrentModOptions:GetProperty("AmountOfWater") * const.ResourceScale
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function EachDeposit(obj)
	if type(obj.amount) == "number" then
		obj.amount = obj.amount + (mod_AmountOfWater or 50000)
		if obj.amount > obj.max_amount then
			obj.amount = obj.max_amount
		end
	end
end

function OnMsg.NewDay()
	MapForEach("map", "SubsurfaceDepositWater", EachDeposit)
end
