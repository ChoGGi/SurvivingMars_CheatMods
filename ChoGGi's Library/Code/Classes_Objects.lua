-- See LICENSE for terms

local S = ChoGGi.Strings

-- simplest entity object possible for hexgrids (it went from being laggy with 100 to usable, though that includes some use of local, so who knows)
DefineClass.ChoGGi_OHexSpot = {
	__parents = {"CObject"},
	entity = "GridTile"
}

-- re-define objects for ease of deleting later on
DefineClass.ChoGGi_OVector = {
	__parents = {"Vector"},
}
DefineClass.ChoGGi_OSphere = {
	__parents = {"Sphere"},
}
DefineClass.ChoGGi_OPolyline = {
	__parents = {"Polyline"},
}
DefineClass.ChoGGi_OText = {
	__parents = {"Text"},
	text_style = "Action",
}
DefineClass.ChoGGi_OOrientation = {
	__parents = {"Orientation"},
}
DefineClass.ChoGGi_OCircle = {
	__parents = {"Circle"},
}

DefineClass.ChoGGi_BuildingEntityClass = {
	__parents = {
		"BuildingEntityClass",
		-- so we can have a selection panel for spawned entity objects
		"InfopanelObj",
	},
	-- defined in ECM OnMsgs
	ip_template = "ipChoGGi_Entity",
}
-- add some info/functionality to spawned entity objects
function ChoGGi_BuildingEntityClass:GetDisplayName()
	return self:GetEntity()
end
function ChoGGi_BuildingEntityClass:GetIPDescription()
	return S[302535920001110--[[Spawned entity object--]]]
end
function ChoGGi_BuildingEntityClass:OnSelected()
	AddSelectionParticlesToObj(self)
end
-- prevent an error msg in log
ChoGGi_BuildingEntityClass.BuildWaypointChains = empty_func
-- round n round she goes
function ChoGGi_BuildingEntityClass:Rotate(delta)
	SetRollPitchYaw(self,0,0,self:GetAngle() + (delta or -1)*60*60)
end
