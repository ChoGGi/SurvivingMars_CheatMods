ChoGGi_AddWaterEachSol = {
	AmountOfWater = 50,
}

function OnMsg.NewDay()
	local water = ChoGGi_AddWaterEachSol.AmountOfWater * const.ResourceScale

	MapForEach("map","SubsurfaceDepositWater",function(o)
		if type(o.amount) == "number" then
			o.amount = o.amount + water
			if o.amount > o.max_amount then
				o.amount = o.max_amount
			end
		end
	end)
end
