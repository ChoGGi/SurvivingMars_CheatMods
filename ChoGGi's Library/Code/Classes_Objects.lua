-- See LICENSE for terms

local Strings = ChoGGi.Strings

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
--~ SetZOffsetInterpolation,SetOpacityInterpolation
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
		"BaseBuilding",

		"BuildingEntityClass",
		-- so we can have a selection panel for spawned entity objects
		"InfopanelObj",
	},
	-- defined in ECM OnMsgs
	ip_template = "ipChoGGi_Entity",
}
-- add any auto-attach items
DefineClass.ChoGGi_BuildingEntityClassAttach = {
	__parents = {
		"ChoGGi_BuildingEntityClass",
		"AutoAttachObject",
	},
	auto_attach_at_init = true,
}
function ChoGGi_BuildingEntityClassAttach:GameInit()
	AutoAttachObject.Init(self)
end

-- add some info/functionality to spawned entity objects
ChoGGi_BuildingEntityClass.GetDisplayName = CObject.GetEntity
function ChoGGi_BuildingEntityClass:GetIPDescription()
	return Strings[302535920001110--[[Spawned entity object--]]]
end
ChoGGi_BuildingEntityClass.OnSelected = AddSelectionParticlesToObj
-- prevent an error msg in log
ChoGGi_BuildingEntityClass.BuildWaypointChains = empty_func
-- round n round she goes
function ChoGGi_BuildingEntityClass:Rotate(delta)
	SetRollPitchYaw(self,0,0,(self:GetAngle() or 0) + (delta or -1)*60*60)
end
