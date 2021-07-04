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

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UICity then
		return
	end

	UpdateTransports()
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

OnMsg.CityStart = UpdateTransports
OnMsg.LoadGame = UpdateTransports
