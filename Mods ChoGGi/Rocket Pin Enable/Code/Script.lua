-- See LICENSE for terms

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	if UIColony and CurrentModOptions:GetProperty("PinAllRockets") then
		local objs = UIColony:GetCityLabels("RocketBase")
		for i = 1, #objs do
			local rocket = objs[i]
			if rocket.command ~= "OnEarth" then
				rocket:SetPinned(true)
			end
		end
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

local function ShowPins()
	local objs = UIColony:GetCityLabels("RocketBase")
	for i = 1, #objs do
		objs[i].show_pin_toggle = true
	end
end

OnMsg.CityStart = ShowPins
OnMsg.LoadGame = ShowPins
OnMsg.NewDay = ShowPins

-- They all use the same func, I'll leave the code incase something does a mod with it
local ChoOrig_RocketBase_SetPinned = RocketBase.SetPinned
--~ local ChoOrig_SetPinned
local function fake_SetPinned(rocket)
	-- might help keep pin around?
	rocket.show_pin_toggle = true
end

local empty_func = empty_func

local ChoOrig_RocketBase_UpdateStatus = RocketBase.UpdateStatus
function RocketBase:UpdateStatus(status, ...)
	if status ~= "landing" or status ~= "landed" then
		return ChoOrig_RocketBase_UpdateStatus(self, status, ...)
	end

--~ 	-- okay a bit overkill
--~ 	ChoOrig_SetPinned = self.SetPinned
	self.SetPinned = fake_SetPinned

	ChoOrig_RocketBase_UpdateStatus(self, status, ...)

	self.SetPinned = ChoOrig_RocketBase_SetPinned
--~ 	ChoOrig_SetPinned = nil
end
