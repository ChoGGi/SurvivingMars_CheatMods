-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local removed_str = "Remove Invalid Label Buildings: %s> %s, entity: %s, handle: %s"
function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local IsValid = IsValid
	-- loop through all the label objects and remove any invalid ones
	local labels = UICity.labels
	for label_id, label in pairs(labels) do
		-- not sure why they added Consts to labels when everything else in here is a building/vehicle/colonist of some sort.
		if label_id ~= "Consts" then
			for i = #label, 1, -1 do
				local obj = label[i]

				if not IsValid(obj) then
					print(removed_str:format(label_id, obj.class, obj:GetEntity(), obj.handle))
					table.remove(label, i)
				end

			end
		end
	end
end
