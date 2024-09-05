-- See LICENSE for terms

local r = const.ResourceScale

local function GetModValue()
	return CurrentModOptions:GetProperty("AmountOfRares") * r
end

local function UpdateExistingRockets()
	if not UIColony then
		return
	end

	local value = GetModValue()

	local SetTaskReqAmount = ChoGGi_Funcs.Common.SetTaskReqAmount
	local rockets = UIColony:GetCityLabels("AllRockets")
	for i = 1, #rockets do
		local rocket = rockets[i]
		if rocket.export_requests then
			SetTaskReqAmount(rocket, value, "export_requests", "max_export_storage")
		else
			rocket.max_export_storage = value
		end
	end
end

-- update on new/load game
OnMsg.CityStart = UpdateExistingRockets
OnMsg.LoadGame = UpdateExistingRockets

-- update on mod applied
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		UpdateExistingRockets()
	end
end

-- set when new rocket made
function OnMsg.BuildingInit(obj)
	if obj:IsKindOf("RocketBase") then
		obj.max_export_storage = GetModValue()
	end
end

