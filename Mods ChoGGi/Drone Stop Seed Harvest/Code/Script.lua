-- See LICENSE for terms

if not g_AvailableDlc.armstrong then
	return
end

local MapGet = MapGet
local GameState = GameState

local options
local mod_StopHarvest

-- fired when settings are changed and new/load
local function ModOptions()
	mod_StopHarvest = options.StopHarvest
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = options or CurrentModOptions
	ModOptions()
end

local function UpdateStuff()
	if not GameState.gameplay then
		return
	end

	local objs = MapGet("map","VegetationTaskRequester")
	for i = 1, #objs do
		if mod_StopHarvest then
			local obj = objs[i]
			obj.request = nil
			TaskRequester.Done(obj)
			obj.task_requests[1] = nil
		else
			objs[i]:CreateResourceRequests()
		end
	end

end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_DroneStopSeedHarvest" then
		return
	end

	ModOptions()
	UpdateStuff()
end

OnMsg.CityStart = UpdateStuff
OnMsg.LoadGame = UpdateStuff

local orig_VegetationTaskRequester_ = VegetationTaskRequester.GameInit
function VegetationTaskRequester:GameInit(...)
	orig_VegetationTaskRequester_(self, ...)
	if mod_StopHarvest then
		self.request = nil
		TaskRequester.Done(self)
		self.task_requests[1] = nil
	end
end
