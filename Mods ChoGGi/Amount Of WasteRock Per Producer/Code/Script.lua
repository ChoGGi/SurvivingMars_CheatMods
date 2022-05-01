-- See LICENSE for terms

local mod_Amount
local mod_MultiplyDivide

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_Amount = CurrentModOptions:GetProperty("Amount")
	mod_MultiplyDivide = CurrentModOptions:GetProperty("MultiplyDivide")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_CalcWasteRockAmount = CalcWasteRockAmount
function CalcWasteRockAmount(...)
	if mod_MultiplyDivide then
		return ChoOrig_CalcWasteRockAmount(...) / mod_Amount
	end
	return ChoOrig_CalcWasteRockAmount(...) * mod_Amount
end
