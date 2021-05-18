-- See LICENSE for terms

local mod_BumpPercent
local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_BumpPercent = (CurrentModOptions:GetProperty("BumpPercent") + 0.0) / 100
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

local whitelist = {
	concrete = true,
	electronics = true,
	food = true,
	fuel = true,
	machineparts = true,
	metals = true,
	polymers = true,
	raremetals = true,
}

function OnMsg.NewDay()
	local RivalAIs = RivalAIs

	if not mod_EnableMod or not RivalAIs or mod_BumpPercent == 0.0 then
		return
	end

	for _, rival in pairs(RivalAIs) do
		for res, amount in pairs(rival.resources) do
			if whitelist[res] then
				rival.resources[res] = amount + (amount * mod_BumpPercent)
			end
		end
	end

end
