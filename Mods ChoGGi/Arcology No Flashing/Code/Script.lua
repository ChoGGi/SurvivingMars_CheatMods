-- See LICENSE for terms

local function RemovePar(obj)
	local attach = obj:GetAttach("Arcology_Beacon")
	if attach then
		attach:delete()
	end
end

local function StartupCode()
	local objs = UIColony:GetCityLabels("Arcology")
	for i = 1, #objs do
		RemovePar(objs[i])
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

function OnMsg.BuildingInit(obj)
	if obj:IsKindOf("Arcology") then
		-- needs a delay
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			RemovePar(obj)
		end)
	end
end
