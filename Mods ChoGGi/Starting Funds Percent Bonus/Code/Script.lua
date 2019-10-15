-- See LICENSE for terms

local mod_FundingPercent

-- fired when settings are changed/init
local function ModOptions()
	mod_FundingPercent = CurrentModOptions:GetProperty("FundingPercent") + 0.0
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

function OnMsg.CityStart()
	-- no point in adding 0
	if mod_FundingPercent == 0.0 then
		return
	end

	local c = UICity
	c.funding = c.funding + (c.funding * (mod_FundingPercent / 100))
end
