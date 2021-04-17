-- See LICENSE for terms

local mod_EnableMod
local mod_AddPlanetaryAnomalyBreakthroughs

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_AddPlanetaryAnomalyBreakthroughs = CurrentModOptions:GetProperty("AddPlanetaryAnomalyBreakthroughs")


	if not mod_EnableMod then
		return
	end
	-- make sure we're in-game
	local UICity = UICity
	if not UICity then
		return
	end

	local BreakthroughOrder = BreakthroughOrder
	local c = #BreakthroughOrder
	local unregs = UICity:GetUnregisteredBreakthroughs()
	for i = 1, mod_AddPlanetaryAnomalyBreakthroughs do
		local unreg = unregs[i]
		if unreg then
			c = c + 1
			BreakthroughOrder[c] = unreg
		end
	end

end

--~ -- load default/saved settings
--~ OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end
