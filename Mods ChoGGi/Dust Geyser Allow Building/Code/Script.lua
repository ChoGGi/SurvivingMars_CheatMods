-- See LICENSE for terms

local DoneObject = DoneObject

local mod_EnableMod
local mod_DeleteGeysers

local function RemoveGeysers()
	if not mod_EnableMod or not mod_DeleteGeysers then
		return
	end

	SuspendPassEdits("ChoGGi.DustGeyserAllowBuilding.DeleteGeysers")
	--
	local GameMaps = GameMaps
	for _, map in pairs(GameMaps) do
 		local objs = map.realm:MapGet("map", "PrefabFeatureMarker", function(obj)
			if obj.FeatureType == "CO2 Jets" or obj.FeatureType == "Flat Lands" then
				return true
			end
		end)
		for i = #objs, 1, -1 do
			DoneObject(objs[i])
		end
		map.realm:MapDelete("map", "GeyserObject")

	end
	--
	ResumePassEdits("ChoGGi.DustGeyserAllowBuilding.DeleteGeysers")
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DeleteGeysers = CurrentModOptions:GetProperty("DeleteGeysers")

	-- Make sure we're in-game
	if not UICity then
		return
	end
	RemoveGeysers()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local l_DontBuildHere

-- allows you to build on geysers
local ChoOrig_ConstructionController_IsObstructed = ConstructionController.IsObstructed
function ConstructionController:IsObstructed(...)
	if mod_EnableMod then
		if not l_DontBuildHere then
			l_DontBuildHere = g_DontBuildHere[ActiveMapID]
		end

		local o = self.construction_obstructors
		-- make sure it's the only obstructor
		if o and #o == 1 and o[1] == l_DontBuildHere then
			return false
		end
	end
	return ChoOrig_ConstructionController_IsObstructed(self, ...)
end

local ChoOrig_DontBuildHere_Check = DontBuildHere.Check
function DontBuildHere.Check(...)
	if mod_EnableMod then
		return false
	end
	return ChoOrig_DontBuildHere_Check(...)
end

--~ -- allows you to build on geysers (grid objs)
--~ local ChoOrig_HexGetBuilding = HexGetBuilding
--~ local function fake_HexGetBuilding(q, r)
--~ 	local obj = ChoOrig_HexGetBuilding(q, r)
--~ 	return obj ~= l_DontBuildHere and obj
--~ end

--~ local ChoOrig_CanExtendFrom = GridConstructionController.CanExtendFrom
--~ function GridConstructionController:CanExtendFrom(...)
--~ 	if mod_EnableMod then
--~ 		if not l_DontBuildHere then
--~ 			l_DontBuildHere = g_DontBuildHere
--~ 		end

--~ 		HexGetBuilding = fake_HexGetBuilding
--~ 	end

--~ 	local result, reason, obj = ChoOrig_CanExtendFrom(self, ...)
--~ 	HexGetBuilding = ChoOrig_HexGetBuilding
--~ 	return result, reason, obj
--~ end




--~ local ChoOrig_HexGetBuilding = HexGetBuilding
--~ function HexGetBuilding(...)
--~ 	local obj = ChoOrig_HexGetBuilding(...)

--~ 	if mod_EnableMod then
--~ 		if not l_DontBuildHere then
--~ 			l_DontBuildHere = g_DontBuildHere
--~ 		end
--~ 		return obj ~= l_DontBuildHere and obj
--~ 	end
--~ 	return obj
--~ end
