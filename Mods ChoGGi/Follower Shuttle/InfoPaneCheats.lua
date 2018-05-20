local cCodeFuncs = ChoGGiX.CodeFuncs
local cTables = ChoGGiX.Tables
local cConsts = ChoGGiX.Consts

--add items to the cheats pane
function ChoGGiX.MsgFuncs.InfoPaneCheats_ClassesGenerate()

  function ShuttleHub:CheatShuttleReturnF()
    for _, s_i in pairs(self.shuttle_infos) do
      local shuttle = s_i.shuttle_obj
      if shuttle and shuttle.ChoGGiX_FollowMouse then
        shuttle.ChoGGiX_FollowMouseShuttle = nil
        shuttle:SetCommand("Home")
      end
    end
  end
  function ShuttleHub:CheatShuttleFollower()
    for _, s_i in pairs(self.shuttle_infos) do
      if s_i:CanLaunch() then
        --ShuttleInfo:Launch(task)
        local hub = s_i.hub
        if not hub or not hub.has_free_landing_slots then
          return false
        end
        --LRManagerInstance
        local shuttle = CargoShuttle:new({
          hub = hub,
          transport_task = ChoGGiX_ShuttleFollowTask:new({
            state = "ready_to_follow",
            dest_pos = GetTerrainCursor() or GetRandomPassable()
          }),
          info_obj = s_i
        })
        s_i.shuttle_obj = shuttle
        local slot = hub:ReserveLandingSpot(shuttle)
        shuttle:SetPos(slot.pos)
        --CargoShuttle:Launch()
        shuttle:PushDestructor(function(self)
          self.hub:ShuttleLeadOut(self)
          self.hub:FreeLandingSpot(self)
        end)
        --shuttle:WaitingStart()
        --shuttle:SetState("fly")
        --follow that cursor little minion
        shuttle:SetCommand("ChoGGiX_FollowMouse")
        CreateRealTimeThread(function()
          Sleep(2000)
          SelectObj(shuttle)
        end)
        --since we found a shuttle break the loop
        break
      end
    end
  end

end --OnMsg

function ChoGGiX.InfoFuncs.SetInfoPanelCheatHints(win)
  local function SetHint(action,hint)
    --name has to be set to make the hint show up
    action.ActionName = action.ActionId
    action.RolloverHint = hint
  end
  local tab = win.actions or empty_table
  for i = 1, #tab do
    local action = tab[i]

    if action.ActionId == "ShuttleFollower" then
      SetHint(action,"Spawns a Shuttle that will follow your cursor, scan nearby anomalies for you, and (one day) pick up resources you've selected.")
    elseif action.ActionId == "ShuttleReturnF" then
      SetHint(action,"Make all followers return home.")
    end

  end --for
end
