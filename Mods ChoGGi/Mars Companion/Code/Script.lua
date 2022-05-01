-- See LICENSE for terms

GlobalVar("g_MarsCompanion", false)

local function StartupCode()
	if IsValid(g_MarsCompanion) then
		return
	end

	-- see if i need to spawn a hidden hub somewhere?
	g_MarsCompanion = MarsCompanion:new({
--~ 			hub = hub,
		hub = {current_fuel = 0},
		transport_task = MarsCompanion_FollowTask:new({
			state = "ready_to_follow",
			dest_pos = point(0, 0)
		}),
--~ 			info_obj = s_i,
		info_obj = {current_fuel = 0},
	})

	CreateGameTimeThread(function()
		local self = g_MarsCompanion
		self.last_good_pos = GetMapBox():Center()

		local pos = cameraRTS.GetPos()
		pos = pos:SetStepZ(800 * guim)
		Sleep(1000)
		self:SetPos(pos)
		pos = pos:SetStepZ(100 * guim)
		local time = 10000
		self:SetPos(pos, time)
		Sleep(time)

		self:SetCommand("MainLoop")
	end)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local AsyncRand = AsyncRand
function MarsCompanion.Random(m, n)
	if n then
		-- m = min, n = max
		return AsyncRand(n - m + 1) + m
	else
		-- m = max, min = 0 OR number between 0 and max_int
		return m and AsyncRand(m) or AsyncRand()
	end
end
