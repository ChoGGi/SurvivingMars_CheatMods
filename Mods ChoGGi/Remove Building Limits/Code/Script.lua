-- See LICENSE for terms

-- fired when settings are changed/init
local function ModOptions()
	ChoGGi_Funcs.Common.SetBuildingLimits(CurrentModOptions:GetProperty("RemoveBuildingLimits"))
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end


-- the below is needed for inside buildings to work outside

local IsValid = IsValid
local AttachToNearestDome = ChoGGi_Funcs.Common.AttachToNearestDome

function OnMsg.BuildingInit(obj)
	-- If an inside building is placed outside of dome, attach it to nearest dome (if there is one)
	if obj:GetDefaultPropertyValue("dome_required") then
		-- a slight delay is needed
		CreateRealTimeThread(function()
			if not IsValid(obj.parent_dome) then
				-- we use this to update the parent_dome (if there's a working/closer one)
				local city = Cities[obj:GetMapID()]
				city:AddToLabel("ChoGGi_InsideForcedOutDome", obj)

				AttachToNearestDome(obj)
			end
		end)
	end
end

function OnMsg.NewDay() -- NewSol...
	local objs = UIColony:GetCityLabels("ChoGGi_InsideForcedOutDome")
	for i = #objs, 1, -1 do
		local obj = objs[i]
		if not IsValid(obj) then
			local city = Cities[obj:GetMapID()]
			city:RemoveFromLabel("ChoGGi_InsideForcedOutDome", obj)
		else
			AttachToNearestDome(obj)
		end
	end
end
