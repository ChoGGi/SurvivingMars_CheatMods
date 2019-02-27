-- See LICENSE for terms

-- unlock the tech at start
function OnMsg.CityStart()
	UnlockBuilding("DefenceTower")
end

function OnMsg.LoadGame()
	UnlockBuilding("DefenceTower")
end

local next,pairs = next,pairs
local IsValid = IsValid
local IsValidThread = IsValidThread
local CreateRealTimeThread = CreateRealTimeThread
local PlayFX = PlayFX
local PlaySound = PlaySound
local GetSoundDuration = GetSoundDuration
local Sleep = Sleep

function OnMsg.ClassesBuilt()

	-- list of devil handles we're attacking
	local devils = {}

	-- replace orig func with mine
	local orig_DefenceTower_DefenceTick = DefenceTower.DefenceTick
	function DefenceTower:DefenceTick(...)

		-- place at end of function to have it protect dustdevils before meteors
		orig_DefenceTower_DefenceTick(self,...)

		-- copied from orig func
		if IsValidThread(self.track_thread) then
			return
		end
		-- list of dustdevils on map
		local dustdevils = g_DustDevils or ""
		for i = 1, #dustdevils do
			local obj = dustdevils[i]

			-- get dist (added * 10 as it didn't see to target at the range of it's hex grid)
			-- it could be from me increasing protection radius, or just how it targets meteors
			if IsValid(obj) and self:GetVisualDist2D(obj) <= self.shoot_range * 10 then
				-- make sure tower is working
				if not IsValid(self) or not self.working or self.destroyed then
					return
				end

				-- .follow = small ones attached to majors (they go away if major is gone)
				if not obj.follow and not devils[obj.handle] then
					-- aim the tower at the dustdevil
					self:OrientPlatform(obj:GetVisualPos(), 7200)
					-- fire in the hole
					local rocket = self:FireRocket(nil, obj)
					-- store handle so we only launch one per devil
					devils[obj.handle] = obj
					-- seems like safe bets to set
					self.meteor = obj
					self.is_firing = true
					-- sleep till rocket explodes
					CreateRealTimeThread(function()
						while rocket.move_thread do
							Sleep(500)
						end
						-- make it pretty
						if IsValid(obj) then
							local snd = PlaySound("Mystery Bombardment ExplodeAir", "ObjectOneshot", nil, 0, false, obj)
							PlayFX("AirExplosion", "start", obj, obj:GetAttaches()[1], obj:GetPos())
							Sleep(GetSoundDuration(snd))
							-- kill the devil object
							obj:delete()
						end
						self.meteor = false
						self.is_firing = false
					end)
					-- back to the usual stuff
					Sleep(self.reload_time)
					return true
				end
			end
		end

		-- only remove devil handles if they're actually gone
		if next(devils) then
			for handle,obj in pairs(devils) do
				if not IsValid(obj) then
					devils[handle] = nil
				end
			end
		end

	end -- DefenceTick
end -- ClassesBuilt

--[[
-- spawn a bunch of dustdevils to test
	for _ = 1, 15 do
		local data = DataInstances.MapSettings_DustDevils
		local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
		GenerateDustDevil(GetTerrainCursor(), descr, nil, "major"):Start()
	end
	for _ = 1, 15 do
		local data = DataInstances.MapSettings_DustDevils
		local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
		GenerateDustDevil(GetTerrainCursor(), descr, nil):Start()
	end
--]]
