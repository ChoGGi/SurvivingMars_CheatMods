-- See LICENSE for terms

local S = ChoGGi.Strings

--~ function FXObject:OnSelected()
--~ 	AddSelectionParticlesToObj(s)
--~ end
--~ function FXObject:GetEntity()
--~ 	return self.entity or EntityData.PointLight
--~ end

-- simplest entity object possible for hexgrids (it went from being laggy with 100 to usable, though that includes some use of local, so who knows)
DefineClass.ChoGGi_HexSpot = {
	__parents = {"CObject"},
	entity = "GridTile"
}

-- re-define objects for ease of deleting later on
DefineClass.ChoGGi_Vector = {
	__parents = {"Vector"},
}
DefineClass.ChoGGi_Sphere = {
	__parents = {"Sphere"},
}
DefineClass.ChoGGi_Polyline = {
	__parents = {"Polyline"},
}

-- so we can have a selection panel for spawned entity objects
DefineClass.ChoGGi_BuildingEntityClass = {
	__parents = {"BuildingEntityClass","InfopanelObj"},
	ip_template = "ipChoGGi_Entity",
}
-- add some info/functionality to spawned entity objects
function ChoGGi_BuildingEntityClass:GetDisplayName()
	return self.entity or self.class
end
function ChoGGi_BuildingEntityClass:GetIPDescription()
	return S[302535920001110--[[Spawned entity object--]]]
end
function ChoGGi_BuildingEntityClass:OnSelected()
	AddSelectionParticlesToObj(self)
end
-- prevent an error in log
function ChoGGi_BuildingEntityClass:BuildWaypointChains() end
