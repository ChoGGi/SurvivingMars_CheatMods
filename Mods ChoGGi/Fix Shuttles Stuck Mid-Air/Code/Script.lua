-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local IsValid = IsValid
local Sleep = Sleep
local type = type

local function CleanupShuttles()
	-- in case this func gets called again for some reason
	local old_pos = {}
	local c = 0
	local FlyingObjs = FlyingObjs or ""

	-- get list of any shuttles on the GoHome command (all stuck ones are)
	for i = 1, #FlyingObjs do
		local obj = FlyingObjs[i]
		if obj:IsKindOf("CargoShuttle") and obj.command == "GoHome" then
			-- store it
			c = c + 1
			old_pos[c] = {
				pos = obj:GetPos(),
				obj = obj,
			}
		end
	end

	-- wait for it...
	Sleep(1000)

	-- now we loop through all the stored ones and see if the pos is any diff
	for i = 1, #old_pos do
		local item = old_pos[i]
		-- same place, so probably a stuck shuttle
		if item.pos == item.obj:GetPos() then
			-- send it the idle command which'll reset it, and send it on it's merry way
			item.obj:Idle()
			o:SetCommand("GoHome")
		end
		-- if we do them all at once then it does a funky flipper dance
		-- shuttles that go back in the hub are deleted
		local timer = 10000
		while IsValid(item.obj) and timer > 0 do
			Sleep(1000)
			timer = timer - 1000
		end
	end
end

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
	end)

	CreateGameTimeThread(function()
		CleanupShuttles()
		-- just in case
		Sleep(60000)
		CleanupShuttles()
	end)

end
