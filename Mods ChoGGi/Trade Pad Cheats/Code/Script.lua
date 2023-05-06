-- See LICENSE for terms

if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed!")
	return
end

local mod_EnableMod
local mod_MinTradeAmount

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_MinTradeAmount = CurrentModOptions:GetProperty("MinTradeAmount")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_TradePad_GenerateOffer = TradePad.GenerateOffer
function TradePad:GenerateOffer(...)
	if not mod_EnableMod then
		self.MinAIExportAmount = TradePad.MinAIExportAmount
		return ChoOrig_TradePad_GenerateOffer(self, ...)
	end

	self.MinAIExportAmount = mod_MinTradeAmount

	return ChoOrig_TradePad_GenerateOffer(self, ...)
end
