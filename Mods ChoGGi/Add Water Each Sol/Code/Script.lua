-- See LICENSE for terms

local mod_AmountOfWater

-- fired when settings are changed/init
local function ModOptions()
	mod_AmountOfWater = CurrentModOptions:GetProperty("AmountOfWater") * const.ResourceScale
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function EachDeposit(obj)
	if type(obj.amount) == "number" then
		obj.amount = obj.amount + (mod_AmountOfWater or 50000)
		if obj.amount > obj.max_amount then
			obj.amount = obj.max_amount
		end
	end
end

function OnMsg.NewDay()
	ActiveGameMap.realm:MapForEach("map", "SubsurfaceDepositWater", EachDeposit)
end
