-- See LICENSE for terms

local temp_route_obj
local temp_route_from
local temp_route_res

-- store resource name
local ChoOrig_ResourceItems_Close = ResourceItems.Close
function ResourceItems:Close(...)
	local c = self.context
	if c and c.object and c.object:IsKindOf("RCTransport") then
		temp_route_res = c.object.temp_route_transport_resource
	end
	return ChoOrig_ResourceItems_Close(self, ...)
end

-- store the unit/from point
local ChoOrig_SetTransportRoutePoint = UnitDirectionModeDialog.SetTransportRoutePoint
function UnitDirectionModeDialog:SetTransportRoutePoint(dir, pt, ...)
	-- make sure it's proper before we store it
	if dir == "from" and self.created_route then
		temp_route_obj = self.unit
		temp_route_from = pt
	end
	return ChoOrig_SetTransportRoutePoint(self, dir, pt, ...)
end

-- make sure it doesn't try to redo the route
local ChoOrig_OnTransportRouteCreated = UnitDirectionModeDialog.OnTransportRouteCreated
function UnitDirectionModeDialog.OnTransportRouteCreated(...)
	temp_route_obj = nil
	return ChoOrig_OnTransportRouteCreated(...)
end

-- restore it
local ChoOrig_Init = UnitDirectionModeDialog.Init or XWindow.Init
function UnitDirectionModeDialog:Init(...)
	CreateRealTimeThread(function()
		WaitMsg("OnRender")
		-- check that it's the right stuff
		if self.MouseCursor == "UI/Cursors/RoverTarget.tga"
			and self.unit == temp_route_obj and not Dialogs.OverviewModeDialog
		then
			self.unit:ToggleCreateRouteMode()
			self.unit.temp_route_transport_resource = temp_route_res
			self:SetCreateRouteMode(true)
			ChoOrig_SetTransportRoutePoint(self, "from", temp_route_from)
		end
	end)
	return ChoOrig_Init(self, ...)
end
