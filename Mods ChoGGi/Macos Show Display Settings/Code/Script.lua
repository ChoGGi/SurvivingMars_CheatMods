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

local orig_FilterNonOSXOption = FilterNonOSXOption
function FilterNonOSXOption(...)
	if not mod_EnableMod then
		return orig_FilterNonOSXOption(...)
	end

  return true
end
