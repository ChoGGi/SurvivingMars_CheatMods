-- See LICENSE for terms

local IsValid = IsValid
local Sleep = Sleep

local function CleanupShuttles()
	-- in case this func gets called again for some reason
	local old_pos = {}
	local c = 0
	local FlyingObjs = FlyingObjs

	-- get list of any shuttles on the GoHome command (all stuck ones are)
	for i = 1, #FlyingObjs do
		local shuttle = FlyingObjs[i]
		-- store
		if shuttle.command == "GoHome" then
			c = c + 1
			old_pos[c] = {
				pos = shuttle:GetVisualPos(),
				obj = shuttle,
			}
		end
	end

	-- wait for it...
	Sleep(1000)

	-- now we loop through all the stored ones and see if the pos is any diff
	for i = 1, #old_pos do
		local shuttle = old_pos[i]
		-- same place, so probably a stuck shuttle
		if shuttle.pos == shuttle.obj:GetVisualPos() then
			-- send it the idle command which'll reset it, and send it on it's merry way
			shuttle.obj:Idle()
		end
		-- give up waiting after 10s
		local timer = 10000
		-- if we do them all at once then it does a funky flipper dance
		while IsValid(shuttle.obj) and timer > 0 do
			Sleep(250)
			timer = timer - 250
		end
	end
end

local function OnLoad()
	CleanupShuttles()
	-- just in case
	Sleep(60000)
	CleanupShuttles()
end

function OnMsg.LoadGame()
	CreateRealTimeThread(OnLoad)
end
