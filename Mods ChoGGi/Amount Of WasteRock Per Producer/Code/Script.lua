-- See LICENSE for terms

local mod_Amount

-- fired when settings are changed/init
local function ModOptions()
	mod_Amount = CurrentModOptions:GetProperty("Amount")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local orig_CalcWasteRockAmount = CalcWasteRockAmount
function CalcWasteRockAmount(...)
	return orig_CalcWasteRockAmount(...) / mod_Amount
end
