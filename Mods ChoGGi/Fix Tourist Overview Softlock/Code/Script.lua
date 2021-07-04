-- See LICENSE for terms

if LuaRevision >= 1001586 then
	return
end

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

local table = table
local rawget = rawget

local orig_SupplyRocket_UIOpenTouristOverview = SupplyRocket.UIOpenTouristOverview
function SupplyRocket:UIOpenTouristOverview(...)
	if not mod_EnableMod or rawget(_G, "g_AT_Options") then
		return orig_SupplyRocket_UIOpenTouristOverview(self, ...)
	end

	local tourists = {}
	local boarded = self.boarded or ""
	for i = 1, #boarded do
		local colonist = self.boarded[i]
		if colonist.traits.Tourist then
			table.insert(tourists, colonist)
		end
	end
	HolidayRating:OpenTouristOverview{
		rocket_name = Untranslated(self.name),
		colonists = tourists,
	}
end
