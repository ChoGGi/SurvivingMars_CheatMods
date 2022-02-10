-- See LICENSE for terms

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	if UICity and CurrentModOptions:GetProperty("PinAllRockets") then
		MapForEach(true, "RocketBase", function(rocket)
			if rocket.command ~= "OnEarth" then
				rocket:SetPinned(true)
			end
		end)
	end
end
--~ -- load default/saved settings
--~ OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function RocketBase.CanBeUnpinned()
	return true
end

RocketBase.show_pin_toggle = true

local function StartupCode()
	MapForEach(true, "RocketBase", function(rocket)
		rocket.show_pin_toggle = true
	end)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local ChoOrig_RocketBase_SetPinned = RocketBase.SetPinned
local ChoOrig_SetPinned
local empty_func = empty_func

local ChoOrig_RocketBase_UpdateStatus = RocketBase.UpdateStatus
function RocketBase:UpdateStatus(status, ...)
	if status ~= "landing" or status ~= "landed" then
		return ChoOrig_RocketBase_UpdateStatus(self, status, ...)
	end

	-- okay a bit overkill
	ChoOrig_SetPinned = self.SetPinned
	self.SetPinned = empty_func
	ChoOrig_RocketBase_UpdateStatus(self, status, ...)
	self.SetPinned = ChoOrig_SetPinned or ChoOrig_RocketBase_SetPinned
	ChoOrig_SetPinned = nil
end
