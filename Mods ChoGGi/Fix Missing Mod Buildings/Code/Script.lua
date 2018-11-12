-- See LICENSE for terms

function OnMsg.ClassesPreprocess()
  -- stops crashing with certain missing pinned objects
  local umc = UnpersistedMissingClass
  umc.__parents[#umc.__parents+1] = "AutoAttachObject"
  umc.__parents[#umc.__parents+1] = "PinnableObject"
end

function OnMsg.PersistPostLoad()
  -- [LUA ERROR] Mars/Lua/Construction.lua:860: attempt to index a boolean value (global 'ControllerMarkers')
  if type(ControllerMarkers) == "boolean" then
    ControllerMarkers = {}
  end

  -- [LUA ERROR] Mars/Lua/Heat.lua:65: attempt to call a nil value (method 'ApplyForm')
  local s_Heaters = s_Heaters
  for obj,_ in pairs(s_Heaters) do
    if obj:IsKindOf("UnpersistedMissingClass") then
      s_Heaters[obj] = nil
    end
  end

	local str = "Removed missing mod building from %s: %s, entity: %s, handle: %s"
  -- GetFreeSpace,GetFreeLivingSpace,GetFreeWorkplaces,GetFreeWorkplacesAround
	for label_id,label in pairs(UICity.labels or {}) do
		for i = #label, 1, -1 do
			local obj = label[i]
			if obj:IsKindOf("UnpersistedMissingClass") then
				ModLog(str:format(label_id,RetName(obj),obj.entity,obj.handle))
				obj:delete()
				table.remove(label,i)
			end
		end
	end

end
