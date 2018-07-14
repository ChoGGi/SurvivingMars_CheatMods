-- See LICENSE for terms

local select,type,getmetatable,tostring,table,string = select,type,getmetatable,tostring,table,string

local CreateRealTimeThread = CreateRealTimeThread
local OpenXDialog = OpenXDialog
local GetInGameInterface = GetInGameInterface
local GetXDialog = GetXDialog

local g_Classes = g_Classes

local concat_table = {}
local concat_value
local function Concat(...)
  -- reuse old table if it's not that big, else it's quicker to make new one (should probably bench till i find a good medium rather than just using 500)
  if #concat_table > 500 then
    concat_table = {}
  else
    table.iclear(concat_table) -- i assume sm added a c func to clear tables, which does seem to be faster than a "lua for loop"
  end
  -- build table from args (see if devs added a c func to do this?)
  for i = 1, select("#",...) do
    concat_value = select(i,...)
    if type(concat_value) == "string" or type(concat_value) == "number" then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  -- and done
  return TableConcat(concat_table)
end

-- shows a popup msg with the rest of the notifications
local function MsgPopup(Msg,Title,Icon,Size)
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

local function CheckForBrokedPath(obj)
  -- 0 means it's stopped, so anything above that and without a path means it's broked
  if obj:GetAnim() > 0 and obj:GetPathLen() == 0 then
    obj:InterruptCommand()
    MsgPopup(
      string.format("%s at position: %s was stopped.",obj.name or obj.class,obj:GetVisualPos()),
      "Broked Pathing",
      "UI/Icons/IPButtons/transport_route.tga"
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
