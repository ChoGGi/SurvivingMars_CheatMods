-- copy n paste from CommonLua\Ged\GedSocket.lua

-- needed to be able to open the inspector
XTemplates.GedInspector.save_in = "Ged"

-- if it gets added then
if rawget(_G,"GedSocket") then
	return
end

DefineClass.GedSocket = {
  __parents = {
    "MessageSocket"
  },
  msg_size_max = 268435456,
  bound_objects = false,
  app = false
}
function GedSocket:Init()
  self.bound_objects = {}
end
function GedSocket:Done()
  if self.app then
    self.app:Close()
    if not self.app.in_game then
      os.exit(1)
    end
  end
end
function GedSocket:rpcGedQuit()
  self:delete()
end
function GedSocket:Obj(name)
  return self.bound_objects[name]
end
function GedSocket:BindObj(name, obj_address, func_name, ...)
  self:Rpc("rpcBindObj", name, obj_address, func_name, ...)
end
function GedSocket:BindFilterObj(target, name, class_or_instance)
  self:Rpc("rpcBindFilterObj", target, name, class_or_instance)
end
function GedSocket:SelectAndBindObj(name, obj_address, func_name, ...)
  self:Rpc("rpcSelectAndBindObj", name, obj_address, func_name, ...)
end
function GedSocket:SelectAndBindMultiObj(name, obj_address, all_indexes, func_name, ...)
  self:Rpc("rpcSelectAndBindMultiObj", name, obj_address, all_indexes, func_name, ...)
end
function GedSocket:UnbindObj(name, to_prefix)
  self:Rpc("rpcUnbindObj", name, to_prefix)
  self.bound_objects[name] = nil
  if to_prefix then
    local pref = name .. to_prefix
    for obj_name in pairs(self.bound_objects) do
      if string.starts_with(obj_name, pref) then
        self.bound_objects[obj_name] = nil
      end
    end
  end
end
function GedSocket:rpcObjValue(name, svalue)
  local err, obj = LuaCodeToTuple(svalue)
  if err then
    printf("Error deserializing %s", name)
    return
  end
  self.bound_objects[name] = obj
  local obj_name, view = name:match("(.+)|(.+)")
  XObjUpdate(obj_name or name, view)
end
function GedSocket:rpcOpenApp(template_or_class, context)
  context = context or {}
  context.connection = self
  local app = XTemplateSpawn(template_or_class, nil, context)
  if not app then
    return "xtemplate"
  end
  if app.AppId == "" then
    app:SetAppId(template_or_class)
  end
  if app:GetTitle() == "" then
    app:SetTitle(template_or_class)
  end
  LogOnlyPrint("Initializing ged app :" .. tostring(template_or_class))
  app:Open()
end
function GedSocket:rpcClose()
  quit()
end
function GedSocket:rpcApp(func, ...)
  local app = self.app
  if not app or app.window_state == "destroying" then
    return "app"
  end
  if not app:HasMember(func) then
    return "func"
  end
  return app[func](app, ...)
end
--~ if Platform.ged then
  function OnMsg.ApplicationQuit()
		local desktop = terminal.desktop
		for i = #desktop, 1, -1 do
      if desktop[i]:IsKindOf("GedApp") then
        desktop[i]:Close()
      end
		end
  end
--~ end
