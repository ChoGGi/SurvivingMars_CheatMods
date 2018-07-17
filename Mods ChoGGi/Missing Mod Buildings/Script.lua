-- See LICENSE for terms

local table,pairs,type = table,pairs,type

function OnMsg.ClassesPreprocess()
  -- stops crashing with certain missing pinned objects
  local umc = UnpersistedMissingClass
  umc.__parents[#umc.__parents+1] = "AutoAttachObject"
  umc.__parents[#umc.__parents+1] = "PinnableObject"
end

function OnMsg.PersistPostLoad()
  --[LUA ERROR] Mars/Lua/Construction.lua:860: attempt to index a boolean value (global 'ControllerMarkers')
  if type(ControllerMarkers) == "boolean" then
    ControllerMarkers = {}
  end

  --[LUA ERROR] Mars/Lua/Heat.lua:65: attempt to call a nil value (method 'ApplyForm')
  local s_Heaters = s_Heaters
  for obj,_ in pairs(s_Heaters) do
    if obj:IsKindOf("UnpersistedMissingClass") then
      s_Heaters[obj] = nil
    end
  end

  --GetFreeSpace,GetFreeLivingSpace,GetFreeWorkplaces,GetFreeWorkplacesAround
  local UICity = UICity
  for _,label in pairs(UICity.labels or empty_table) do
    for i = #label, 1, -1 do
      if IsKindOf(label[i],"UnpersistedMissingClass") then
        label[i]:delete()
        table.remove(label,i)
      end
    end
  end
  local domes = UICity.labels.Dome or empty_table
  for i = 1, #domes do
    for _,label in pairs(domes[i].labels or empty_table) do
      for j = #label, 1, -1 do
        if type(label[j].SetBase) ~= "function" then
          label[j]:delete()
          table.remove(label,j)
        end
      end
    end
  end
end
