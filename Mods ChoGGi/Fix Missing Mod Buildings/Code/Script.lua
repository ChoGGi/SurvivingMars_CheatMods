-- See LICENSE for terms

local function AddParentToClass(class_obj,parent_name)
	if not table.find(class_obj,parent_name) then
		class_obj.__parents[#class_obj.__parents+1] = parent_name
	end
end
function OnMsg.ClassesPreprocess()
  -- stops crashing with certain missing pinned objects
	AddParentToClass(UnpersistedMissingClass,"AutoAttachObject")
	AddParentToClass(UnpersistedMissingClass,"PinnableObject")
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
	local labels = UICity.labels or empty_table
	local ModLog = ModLog
	for label_id,label in pairs(labels) do
		for i = #label, 1, -1 do
			local obj = label[i]
			if obj:IsKindOf("UnpersistedMissingClass") then
				ModLog(str:format(label_id,RetName(obj),obj:GetEntity(),obj.handle))
				obj:delete()
				table.remove(label,i)
			end
		end
	end

end
