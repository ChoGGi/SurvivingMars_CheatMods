-- we store a ref to the blue route crap here
local cursor_obj

local CreateRealTimeThread = CreateRealTimeThread
local Sleep = Sleep
local DoneObject = DoneObject

local orig_UnitDirectionModeDialog_SetCreateRouteMode = UnitDirectionModeDialog.SetCreateRouteMode
function UnitDirectionModeDialog:SetCreateRouteMode(...)
	-- we wait till cursor_obj is created
	CreateRealTimeThread(function()
		while not self.cursor_obj do
			Sleep(50)
		end
		cursor_obj = self.cursor_obj
	end)
	return orig_UnitDirectionModeDialog_SetCreateRouteMode(self,...)
end

-- kill off stuck crap when selection is changed
function OnMsg.SelectedObjChange()
	if cursor_obj then
		DoneObject(cursor_obj)
		cursor_obj = nil
	end
end

function OnMsg.LoadGame()

	-- remove any crap stuck on the map
	SuspendPassEdits("RangeHexRadius")
	SuspendPassEdits("WireFramedPrettification")
	MapDelete("map", "RangeHexRadius")
	-- remove the rover outlines added from https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-persistent-transport-route-blueprint-on-map.1121333/
	MapDelete("map", "WireFramedPrettification",function(o)
		if o.entity == "RoverTransport" then
			return true
		end
	end)
	ResumePassEdits("RangeHexRadius")
	ResumePassEdits("WireFramedPrettification")

end
