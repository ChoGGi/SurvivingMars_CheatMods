--keep everything stored in
ChoGGiX = {
  id = "ChoGGi_EmptyMechDepot",
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  StartupMsgs = {},
  OrigFunc = {},
  Defaults = {},
  CheatMenuSettings = {BuildingSettings = {},Transparency = {}},
}
ChoGGiX.ModPath = _G.Mods[ChoGGiX.id].path

--change some annoying stuff about UserActions.AddActions()
local g_idxAction = 0
function ChoGGiX.UserAddActions(ActionsToAdd)
  for k, v in pairs(ActionsToAdd) do
    if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
      if v.key ~= nil and v.key ~= "" then
        if type(v.key) == "table" then
          local keys = v.key
          if #keys <= 0 then
            v.description = ""
          else
            v.description = v.description .. " (" .. keys[1]
            for i = 2, #keys do
              v.description = v.description .. " or " .. keys[i]
            end
            v.description = v.description .. ")"
          end
        else
          v.description = tostring(v.description) .. " (" .. v.key .. ")"
        end
      end
      v.id = k
      v.idx = g_idxAction
      g_idxAction = g_idxAction + 1
      UserActions.Actions[k] = v
    else
      UserActions.RejectedActions[k] = v
    end
  end
  UserActions.SetMode(UserActions.mode)
end

function ChoGGiX.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
  if Menu then
    Menu = "/" .. tostring(Menu)
  end
  local name = "NOFUNC"
  if Action then
    local debug_info = debug.getinfo(Action, "Sn")
    name = string.gsub(tostring(debug_info.short_src .. "(" .. debug_info.linedefined .. ")"),ChoGGiX.ModPath,"")
  end

  ChoGGiX.UserAddActions({
    ["ChoGGiX_" .. name .. AsyncRand()] = {
      menu = Menu,
      action = Action,
      key = Key,
      description = Des or "",
      icon = Icon,
      toolbar = Toolbar,
      mode = Mode,
      xinput = xInput,
      toolbar_default = ToolbarDefault
    }
  })
end
