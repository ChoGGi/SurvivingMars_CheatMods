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
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end


local orig_RocketExpedition_OnDemolish = RocketExpedition.OnDemolish
function RocketExpedition:OnDemolish(...)
	if not mod_EnableMod then
		return orig_RocketExpedition_OnDemolish(self, ...)
	end

  ClearDestroyedExpeditionRocketSpot(self)
--~   SupplyRocket.OnDemolish(self)
  RocketBase.OnDemolish(self)
end

local orig_ForeignTradeRocket_OnModifiableValueChanged = ForeignTradeRocket.OnModifiableValueChanged
function ForeignTradeRocket:OnModifiableValueChanged(prop, ...)
	if not mod_EnableMod then
		return orig_ForeignTradeRocket_OnModifiableValueChanged(self, prop, ...)
	end

  if prop ~= "max_export_storage" and prop ~= "launch_fuel" then
--~     SupplyRocket.OnModifiableValueChanged(self, prop, ...)
    RocketBase.OnModifiableValueChanged(self, prop, ...)
  end
end

local orig_TradeRocket_OnModifiableValueChanged = TradeRocket.OnModifiableValueChanged
function TradeRocket:OnModifiableValueChanged(prop, ...)
	if not mod_EnableMod then
		return orig_TradeRocket_OnModifiableValueChanged(self, prop, ...)
	end

  if prop ~= "max_export_storage" then
--~     SupplyRocket.OnModifiableValueChanged(self, prop, ...)
    RocketBase.OnModifiableValueChanged(self, prop, ...)
  end
end
