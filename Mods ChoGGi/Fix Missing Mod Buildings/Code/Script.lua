-- See LICENSE for terms

--~ function ChoGGi.ComFuncs.AddParentToClass(class_obj, parent_name)
local function AddParentToClass(class_obj, parent_name)
	local p = class_obj.__parents
	if not table.find(p, parent_name) then
		p[#p+1] = parent_name
	end
end

--~ function OnMsg.ClassesPreprocess()
	-- stops crashing with certain missing pinned objects
	local umc = UnpersistedMissingClass
	AddParentToClass(umc, "AutoAttachObject")
	AddParentToClass(umc, "PinnableObject")
	umc.entity = "ErrorAnimatedMesh"
--~ end

function OnMsg.PersistPostLoad()
	-- [LUA ERROR] Mars/Lua/Construction.lua:860: attempt to index a boolean value (global 'ControllerMarkers')
	if type(ControllerMarkers) == "boolean" then
		ControllerMarkers = {}
	end

	local str = "Removed missing mod building from %s: %s, entity: %s, handle: %s"

	-- [LUA ERROR] Mars/Lua/Heat.lua:65: attempt to call a nil value (method 'ApplyForm')
	local s_Heaters = s_Heaters
	for obj, _ in pairs(s_Heaters) do
		if obj:IsKindOf("UnpersistedMissingClass") then
			ModLog(str:format("s_Heaters", RetName(obj), obj:GetEntity(), obj.handle))
			s_Heaters[obj] = nil
		end
	end

	-- GetFreeSpace, GetFreeLivingSpace, GetFreeWorkplaces, GetFreeWorkplacesAround
	local labels = UICity.labels or empty_table
	local ModLog = ModLog
	for label_id, label in pairs(labels) do
		for i = #label, 1, -1 do
			local obj = label[i]
			if obj:IsKindOf("UnpersistedMissingClass") then
				ModLog(str:format(label_id, RetName(obj), obj:GetEntity(), obj.handle))
				obj:delete()
				table.remove(label, i)
			end
		end
	end

end
