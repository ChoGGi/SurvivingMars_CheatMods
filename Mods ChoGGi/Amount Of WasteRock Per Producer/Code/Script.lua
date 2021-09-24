-- See LICENSE for terms

local mod_Amount
local mod_MultiplyDivide

-- fired when settings are changed/init
local function ModOptions()
	mod_Amount = CurrentModOptions:GetProperty("Amount")
	mod_MultiplyDivide = CurrentModOptions:GetProperty("MultiplyDivide")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local ChoOrig_CalcWasteRockAmount = CalcWasteRockAmount
function CalcWasteRockAmount(...)
	if mod_MultiplyDivide then
		return ChoOrig_CalcWasteRockAmount(...) / mod_Amount
	end
	return ChoOrig_CalcWasteRockAmount(...) * mod_Amount
end
