-- we store a ref to the blue route crap here
local cursor_objs = {}

local orig_UnitDirectionModeDialog_UpdateCursorObj = UnitDirectionModeDialog.UpdateCursorObj
function UnitDirectionModeDialog:UpdateCursorObj(...)
	orig_UnitDirectionModeDialog_UpdateCursorObj(self,...)

	if self.cursor_obj then
		cursor_objs[self.cursor_obj.handle] = self.cursor_obj
	end
end

local orig_UnitDirectionModeDialog_UpdateTransportRouteVisuals = UnitDirectionModeDialog.UpdateTransportRouteVisuals
function UnitDirectionModeDialog:UpdateTransportRouteVisuals(...)
	orig_UnitDirectionModeDialog_UpdateTransportRouteVisuals(self,...)

	if self.route_visuals then
		cursor_objs[self.route_visuals.handle] = self.route_visuals
	end
end

-- kill off stuck crap when selection is changed
local DoneObject = DoneObject
function OnMsg.SelectedObjChange()
	for _,cursor_obj in pairs(cursor_objs) do
		DoneObject(cursor_obj)
	end
	table.clear(cursor_objs)
end

function OnMsg.LoadGame()

	-- remove any crap stuck on the map
	SuspendPassEdits("RangeHexMovableRadius")
	SuspendPassEdits("WireFramedPrettification")
	MapDelete("map", "RangeHexMovableRadius")
	-- remove the rover outlines added from https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-persistent-transport-route-blueprint-on-map.1121333/
	MapDelete("map", "WireFramedPrettification",function(o)
		if o.entity == "RoverTransport" then
			return true
		end
	end)
	ResumePassEdits("RangeHexMovableRadius")
	ResumePassEdits("WireFramedPrettification")

end
