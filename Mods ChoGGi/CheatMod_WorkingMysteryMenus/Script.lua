ChoGGiX = {}

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
  ChoGGiX.UserAddActions({
    ["ChoGGi_" .. AsyncRand()] = {
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

ChoGGiX.AddAction(nil,UAMenu.ToggleOpen,"F2")

local function CheatStartMystery(mystery_id)
--mapdata.StartMystery?
  UICity.mystery_id = mystery_id
  for i = 1, #TechTree do
    local field = TechTree[i]
    local field_id = field.id
    --local costs = field.costs or empty_table
    local list = UICity.tech_field[field_id] or {}
    UICity.tech_field[field_id] = list
    for _, tech in ipairs(field) do
      if tech.mystery == mystery_id then
        local tech_id = tech.id
        list[#list + 1] = tech_id
        UICity.tech_status[tech_id] = {points = 0, field = field_id}
        tech:Initialize(UICity)
      end
    end
  end
  UICity:InitMystery()
end

function ChoGGiX.StartMystery(Mystery)
  --inform people of actions, so they don't add a bunch of them
  UICity.mystery_id = Mystery
  CheatStartMystery(Mystery)
end

--if you pick a mystery from the cheat menu
function OnMsg.MysteryBegin()
  ChoGGiX.MsgPopup("You've started a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
end
function OnMsg.MysteryChosen()
  ChoGGiX.MsgPopup("You've chosen a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
end
function OnMsg.MysteryEnd(Outcome)
  ChoGGiX.MsgPopup(Outcome,"Mystery","UI/Icons/Logos/logo_13.tga")
end

function ChoGGiX.MsgPopup(Msg,Title,Icon)
  pcall(function()
    Msg = Msg or "Empty"
    --returns translated text corresponding to number if we don't do this
    if type(Msg) == "number" then
      Msg = tostring(Msg)
    end
    Title = Title or "Placeholder"
    Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
    if type(AddCustomOnScreenNotification) == "function" then --incase we called it where there ain't no UI
      CreateRealTimeThread(AddCustomOnScreenNotification(
        AsyncRand(),Title,Msg,Icon,nil,{expiration=5000}
      ))
    end
  end)
end

--for mystery menu items
ChoGGiX.MysteryDescription = {BlackCubeMystery = 1165,DiggersMystery = 1171,MirrorSphereMystery = 1185,DreamMystery = 1181,AIUprisingMystery = 1163,MarsgateMystery = 7306,WorldWar3 = 8073,TheMarsBug = 8068,UnitedEarthMystery = 8071}
ChoGGiX.MysteryDifficulty = {
    BlackCubeMystery = 1164, --The Power of Three (Easy)
    DiggersMystery = 1170, --The Dredgers (Normal)
    MirrorSphereMystery = 1184, --Spheres (Normal)
    DreamMystery = 1180, --Inner Light (Easy)
    AIUprisingMystery = 1162, --Artificial Intelligence (Normal)
    MarsgateMystery = 8063, --Marsgate (Hard)
    WorldWar3 = 8072, --The Last War (Hard)
    TheMarsBug = 8067, --Wildfire (Hard)
    UnitedEarthMystery = 8070 --Beyond Earth (Easy)
  }

function OnMsg.ClassesBuilt()

  --build "Cheats/Start Mystery" menu
  --MysteryBase = { AIUprisingMystery, BlackCubeMystery, DiggersMystery, DreamMystery, MarsgateMystery, MirrorSphereMystery, TheMarsBug, UnitedEarthMystery, WorldWar3 }
  --type(g_Classes.DreamMystery.scenario_name)
  ClassDescendantsList("MysteryBase", function(class)
    ChoGGiX.AddAction(
      "Cheats/[05]Start Mystery/" .. g_Classes[class].scenario_name .. " " .. _InternalTranslate(T({ChoGGiX.MysteryDifficulty[class]})) or "Missing Name",
      function()
        return ChoGGiX.StartMystery(class)
      end,
      nil,
      _InternalTranslate(T({ChoGGiX.MysteryDescription[class]})) or "Missing Description",
      "DarkSideOfTheMoon.tga"
    )
  end)

end --OnMsg

function OnMsg.LoadingScreenPreClose()

  UserActions.RemoveActions({
    "StartMysteryAIUprisingMystery",
    "StartMysteryBlackCubeMystery",
    "StartMysteryDiggersMystery",
    "StartMysteryDreamMystery",
    "StartMysteryMarsgateMystery",
    "StartMysteryMirrorSphereMystery",
    "StartMysteryTheMarsBug",
    "StartMysteryUnitedEarthMystery",
    "StartMysteryWorldWar3",
  })
  --update menu
  UAMenu.UpdateUAMenu(UserActions.GetActiveActions())

end --OnMsg
