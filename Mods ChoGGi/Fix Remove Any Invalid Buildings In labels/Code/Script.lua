local IsValid = IsValid

local removed_str = "Remove Invalid Label Buildings: %s> %s, entity: %s, handle: %s"
function OnMsg.LoadGame()
	-- loop through all the label objects and remove any invalid ones
	for label_id,label in pairs(UICity.labels) do
		-- not sure why they added Consts to labels when everything else in here is a building/vehicle/colonist of some sort.
		if label_id ~= "Consts" then
			for i = #label, 1, -1 do
				local obj = label[i]

				if not IsValid(obj) then
					print(removed_str:format(label_id,obj.class,obj.entity,obj.handle))
					table.remove(label,i)
				end

			end
		end
	end
end
