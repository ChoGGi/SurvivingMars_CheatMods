-- See LICENSE for terms

local mod_EnableMod
local mod_DeleteGeysers

local function RemoveGeysers()
	if not mod_EnableMod or not mod_DeleteGeysers then
		return
	end

	SuspendPassEdits("ChoGGi.DustGeyserAllowBuilding.DeleteGeysers")
	-- I can't get MapDelete and func filter working...
	local objs = MapGet("map", "PrefabFeatureMarker", function(obj)
		if obj.FeatureType == "CO2 Jets" then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		objs[i]:delete()
	end
	MapDelete("map", "GeyserObject")
	ResumePassEdits("ChoGGi.DustGeyserAllowBuilding.DeleteGeysers")
end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DeleteGeysers = CurrentModOptions:GetProperty("DeleteGeysers")

	-- make sure we're in-game
	if not UICity then
		return
	end
	RemoveGeysers()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local l_DontBuildHere

-- allows you to build on geysers
local orig_ConstructionController_IsObstructed = ConstructionController.IsObstructed
function ConstructionController:IsObstructed(...)
	if mod_EnableMod then
		if not l_DontBuildHere then
			l_DontBuildHere = g_DontBuildHere
		end

		local o = self.construction_obstructors
		-- make sure it's the only obstructor
		if o and #o == 1 and o[1] == l_DontBuildHere then
			return false
		end
	end
	return orig_ConstructionController_IsObstructed(self, ...)
end

local orig_DontBuildHere_Check = DontBuildHere.Check
function DontBuildHere.Check(...)
	if mod_EnableMod then
		return false
	end
	return orig_DontBuildHere_Check(...)
end

--~ -- allows you to build on geysers (grid objs)
--~ local orig_HexGetBuilding = HexGetBuilding
--~ local function fake_HexGetBuilding(q, r)
--~ 	local obj = orig_HexGetBuilding(q, r)
--~ 	return obj ~= l_DontBuildHere and obj
--~ end

--~ local orig_CanExtendFrom = GridConstructionController.CanExtendFrom
--~ function GridConstructionController:CanExtendFrom(...)
--~ 	if mod_EnableMod then
--~ 		if not l_DontBuildHere then
--~ 			l_DontBuildHere = g_DontBuildHere
--~ 		end

--~ 		HexGetBuilding = fake_HexGetBuilding
--~ 	end

--~ 	local result, reason, obj = orig_CanExtendFrom(self, ...)
--~ 	HexGetBuilding = orig_HexGetBuilding
--~ 	return result, reason, obj
--~ end




--~ local orig_HexGetBuilding = HexGetBuilding
--~ function HexGetBuilding(...)
--~ 	local obj = orig_HexGetBuilding(...)

--~ 	if mod_EnableMod then
--~ 		if not l_DontBuildHere then
--~ 			l_DontBuildHere = g_DontBuildHere
--~ 		end
--~ 		return obj ~= l_DontBuildHere and obj
--~ 	end
--~ 	return obj
--~ end
