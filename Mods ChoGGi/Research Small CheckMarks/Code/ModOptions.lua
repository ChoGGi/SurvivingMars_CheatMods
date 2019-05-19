local mod_id = "ChoGGi_XDefaultMod"
local mod = Mods[mod_id]

local mod_ToggleExample = mod.options and mod.options.ToggleExample or true

local function ModOptions()
	print("ApplyModOptions", mod.options)
	mod_ToggleExample = mod.options.ToggleExample
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

-- for some reason mod options aren't retrieved before this script is loaded...
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

-- a func to get options from
local function GetModOption(name)
	return mod.options[name]
end
