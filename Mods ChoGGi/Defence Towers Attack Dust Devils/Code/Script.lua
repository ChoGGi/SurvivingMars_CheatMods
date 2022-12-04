-- See LICENSE for terms

local pairs = pairs
local Sleep = Sleep
local IsValidThread = IsValidThread

local mod_EnableMod
local mod_UnlockDefenseTowers

-- unlock the tech at start
local function UnlockTowers()
	if mod_EnableMod and mod_UnlockDefenseTowers then
		UnlockBuilding("DefenceTower")
	end
end
OnMsg.CityStart = UnlockTowers
OnMsg.LoadGame = UnlockTowers

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_UnlockDefenseTowers = CurrentModOptions:GetProperty("UnlockDefenseTowers")

	-- make sure we're in-game
	if not MainCity then
		return
	end

	UnlockTowers()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- list of devil handles we're attacking
local devils = {}

-- replace orig func with mine
local ChoOrig_DefenceTower_DefenceTick = DefenceTower.DefenceTick
function DefenceTower:DefenceTick(...)

	-- place at end of function to have it protect dustdevils before meteors
	ChoOrig_DefenceTower_DefenceTick(self, ...)

	if not mod_EnableMod then
		return
	end

	-- copied from orig func
	if IsValidThread(self.track_thread) then
		return
	end

	-- list of dustdevils on map
	local dustdevils = g_DustDevils or ""
	for i = 1, #dustdevils do
		local devil = dustdevils[i]

		-- get dist (added * 10 as tower didn't see to target at the range of its hex grid)
		-- It could be from me increasing protection radius, or just how it targets meteors
		if IsValid(devil) and self:GetVisualDist(devil) <= self.shoot_range * 10 then
			-- make sure tower is working
			if not IsValid(self) or not self.working or self.destroyed then
				return
			end

			-- .follow = small ones attached to majors (they go away if major is gone)
			if not devil.follow and not devils[devil.handle] then
				-- aim the tower at the dustdevil
				self:OrientPlatform(devil:GetVisualPos(), 7200)
				-- fire in the hole
				local rocket = self:FireRocket(nil, devil)
				-- store handle so we only launch one per devil
				devils[devil.handle] = devil
				-- seems like safe bets to set
				self.meteor = devil
				self.is_firing = true
				-- sleep till rocket explodes
				CreateRealTimeThread(function()
					while rocket.move_thread do
						Sleep(500)
					end
					-- make it pretty
					if IsValid(devil) then
						local snd = PlaySound("Mystery Bombardment ExplodeAir", "ObjectOneshot", nil, 0, false, devil)
						PlayFX("AirExplosion", "start", devil, devil:GetAttaches()[1], devil:GetPos())
						Sleep(GetSoundDuration(snd))
						-- kill the devil object
						devil:delete()
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
	for handle, devil in pairs(devils) do
		if not IsValid(devil) then
			devils[handle] = nil
		end
	end

end -- DefenceTick

--[[
	local mapdata = ActiveMapData

	-- spawn a bunch of dustdevils to test
	for _ = 1, 15 do
		local data = DataInstances.MapSettings_DustDevils
		local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
		GenerateDustDevil(GetCursorWorldPos(), descr, nil, "major"):Start()
	end
	for _ = 1, 15 do
		local data = DataInstances.MapSettings_DustDevils
		local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
		GenerateDustDevil(GetCursorWorldPos(), descr, nil):Start()
	end
]]
