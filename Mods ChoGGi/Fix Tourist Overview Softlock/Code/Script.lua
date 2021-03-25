-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local table_insert = table.insert

local orig_SupplyRocket_UIOpenTouristOverview = SupplyRocket.UIOpenTouristOverview
function SupplyRocket:UIOpenTouristOverview(...)
	if not mod_EnableMod then
		return orig_SupplyRocket_UIOpenTouristOverview(self, ...)
	end

	local tourists = {}
	local boarded = self.boarded or ""
	for i = 1, #boarded do
		local colonist = self.boarded[i]
		if colonist.traits.Tourist then
			table_insert(tourists, colonist)
		end
	end
	HolidayRating:OpenTouristOverview{
		rocket_name = Untranslated(self.name),
		colonists = tourists,
	}

end
