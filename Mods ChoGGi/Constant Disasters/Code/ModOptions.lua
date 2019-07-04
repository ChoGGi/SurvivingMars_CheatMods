-- See LICENSE for terms

local options
local mod_ToggleExample

-- fired when settings are changed/init
local function ModOptions()
	mod_ToggleExample = options.ToggleExample
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_XDefaultMod" then
		return
	end

	ModOptions()
end





--~ -- for some reason mod options aren't retrieved before this script is loaded...
--~ OnMsg.CityStart = ModOptions
--~ OnMsg.LoadGame = ModOptions

-- a func to get options from
local function GetModOption(name)
	return mod.options[name]
end
