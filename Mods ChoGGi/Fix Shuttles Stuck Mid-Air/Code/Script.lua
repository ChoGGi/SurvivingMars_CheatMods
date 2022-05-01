-- See LICENSE for terms

local type = type
local IsValid = IsValid

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

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	-- req has an invalid building
	CreateRealTimeThread(function()
		Sleep(1000)
		local objs = UICity.labels.CargoShuttle or ""
		for i = 1, #objs do
			local obj = objs[i]
			if obj.command == "Idle" then
				-- remove borked requests
				local req = obj.assigned_to_d_req and obj.assigned_to_d_req[1]
				if type(req) == "userdata" and req.GetBuilding and not IsValid(req:GetBuilding()) then
					obj.assigned_to_d_req[1]:UnassignUnit(obj.assigned_to_d_req[2], false)
					obj.assigned_to_d_req = false
				end

				req = obj.assigned_to_s_req and obj.assigned_to_s_req[1]
				if type(req) == "userdata" and req.GetBuilding and not IsValid(req:GetBuilding()) then
					obj.assigned_to_s_req[1]:UnassignUnit(obj.assigned_to_s_req[2], false)
					obj.assigned_to_s_req = false
				end

			end
		end


		-- fuck it just reset them all
		Sleep(1000)
		for i = 1, #objs do
			local obj = objs[i]
			if IsValid(obj) then
				obj:Idle()
				obj:SetCommand("GoHome")
			end
		end

	end)

end
