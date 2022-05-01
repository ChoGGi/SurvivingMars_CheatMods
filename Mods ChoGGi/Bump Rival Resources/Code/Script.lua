-- See LICENSE for terms

local mod_BumpPercent
local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_BumpPercent = (CurrentModOptions:GetProperty("BumpPercent") + 0.0) / 100
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

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
