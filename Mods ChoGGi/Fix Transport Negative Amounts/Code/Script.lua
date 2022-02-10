-- See LICENSE for terms

local mod_EnableMod

local function UpdateTransports()
	if not mod_EnableMod then
		return
	end

	local rovers = UICity.labels.RCTransport or ""
	for i = 1, #rovers do
		local rover = rovers[i]
		for j = 1, #(rover.storable_resources or "") do
			local res = rover.storable_resources[j]
			if rover.resource_storage[res] < 0 then
				rover.resource_storage[res] = 0
			end
		end
	end
end
OnMsg.CityStart = UpdateTransports
OnMsg.LoadGame = UpdateTransports

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UICity then
		return
	end

	UpdateTransports()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
