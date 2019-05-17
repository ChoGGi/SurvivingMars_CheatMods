-- See LICENSE for terms

local mod_id = "ChoGGi_AddWaterEachSol"
local mod = Mods[mod_id]
local mod_AmountOfWater = mod.options and mod.options.AmountOfWater or 50
-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	mod_AmountOfWater = mod.options.AmountOfWater
end

-- for some reason mod options aren't retrieved before this script is loaded...
local function SomeCode()
	mod_AmountOfWater = mod.options.AmountOfWater
end

OnMsg.CityStart = SomeCode
OnMsg.LoadGame = SomeCode

function OnMsg.NewDay()
	local water = mod_AmountOfWater * const.ResourceScale

	MapForEach("map", "SubsurfaceDepositWater", function(o)
		if type(o.amount) == "number" then
			o.amount = o.amount + water
			if o.amount > o.max_amount then
				o.amount = o.max_amount
			end
		end
	end)
end


