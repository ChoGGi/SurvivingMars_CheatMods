-- See LICENSE for terms

local options
local mod_AmountOfWater

-- fired when settings are changed/init
local function ModOptions()
	mod_AmountOfWater = options.AmountOfWater * const.ResourceScale
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_AddWaterEachSol" then
		return
	end

	ModOptions()
end

local function EachDeposit(obj)
	if type(obj.amount) == "number" then
		obj.amount = obj.amount + mod_AmountOfWater
		if obj.amount > obj.max_amount then
			obj.amount = obj.max_amount
		end
	end
end

function OnMsg.NewDay()
	MapForEach("map", "SubsurfaceDepositWater", EachDeposit)
end
