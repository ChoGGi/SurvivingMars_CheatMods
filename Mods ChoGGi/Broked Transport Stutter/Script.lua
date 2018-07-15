-- See LICENSE for terms

local type,tostring,table,string = type,tostring,table,string

local AsyncRand = AsyncRand
local CreateRealTimeThread = CreateRealTimeThread
local OpenXDialog = OpenXDialog
local GetInGameInterface = GetInGameInterface
local GetXDialog = GetXDialog

local g_Classes = g_Classes

-- shows a popup msg with the rest of the notifications
local function MsgPopup(Msg,Title,Icon)
  --build our popup
  local params = {
    expiration=10000,
    --dismissable=false,
  }
  ---if there's no interface then we probably shouldn't open the popup
  local dlg = GetXDialog("OnScreenNotificationsDlg")
  if not dlg then
    if not GetInGameInterface() then
      return
    end
    dlg = OpenXDialog("OnScreenNotificationsDlg", GetInGameInterface())
  end
  --build the popup
  local data = {
    id = AsyncRand(),
    title = tostring(Title or ""),
    text = tostring(Msg or ""),
    image = type(tostring(Icon):find(".tga")) == "number" and Icon
  }
  table.set_defaults(data, params)
  table.set_defaults(data, g_Classes.OnScreenNotificationPreset)
  --and show the popup
  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, params.cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
  end)
end

local function MsgPopup(text,title,icon,size,objects)
  local g_Classes = g_Classes
  -- build our popup
  local timeout = 10000
--~   if size then
--~     timeout = 30000
--~   end
  local params = {
    expiration = timeout,
--~     {expiration = 99999999999999999},
--~     dismissable = false,
  }
  -- if there's no interface then we probably shouldn't open the popup
  local dlg = GetXDialog("OnScreenNotificationsDlg")
  if not dlg then
    local igi = GetInGameInterface()
    if not igi then
      return
    end
    dlg = OpenXDialog("OnScreenNotificationsDlg", igi)
  end
  --build the popup
  local data = {
    id = AsyncRand(),
    title = tostring(title or ""),
    text = tostring(text or ""),
    image = type(tostring(icon):find(".tga")) == "number" and icon
  }
  table.set_defaults(data, params)
  table.set_defaults(data, g_Classes.OnScreenNotificationPreset)
  if objects then
    if type(objects) ~= "table" then
      objects = {objects}
    end
    params.cycle_objs = objects
  end
  --and show the popup
  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, params.cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
  end)
end


local function CheckForBrokedPath(obj)
  -- 0 means it's stopped, so anything above that and without a path means it's broked
  if obj:GetAnim() > 0 and obj:GetPathLen() == 0 then
    obj:InterruptCommand()
    MsgPopup(
      string.format("%s at position: %s was stopped.",obj.name or obj.class,obj:GetVisualPos()),
      "Broked Pathing",
      "UI/Icons/IPButtons/transport_route.tga"
      nil,
      obj
    )
  end
end
function OnMsg.ClassesBuilt()

  local orig_RCTransport_TransportRouteLoad = RCTransport.TransportRouteLoad
  function RCTransport:TransportRouteLoad()
    orig_RCTransport_TransportRouteLoad(self)
    CheckForBrokedPath(self)
  end
  local orig_RCTransport_TransportRouteUnload = RCTransport.TransportRouteUnload
  function RCTransport:TransportRouteUnload()
    orig_RCTransport_TransportRouteUnload(self)
    CheckForBrokedPath(self)
  end

end
