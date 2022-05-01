-- See LICENSE for terms

local mod_FundingPercent

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_FundingPercent = CurrentModOptions:GetProperty("FundingPercent") + 0.0
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.CityStart()
	-- no point in adding 0
	if mod_FundingPercent == 0.0 then
		return
	end

	local funds = UIColony.funds
	funds.funding = funds.funding + (funds.funding * (mod_FundingPercent / 100))
end
