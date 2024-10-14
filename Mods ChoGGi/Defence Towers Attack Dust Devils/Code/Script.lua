-- See LICENSE for terms

local pairs = pairs
local Sleep = Sleep
local IsValidThread = IsValidThread
local IsValid = IsValid

local mod_EnableMod
local mod_UnlockDefenseTowers
local mod_IgnoreMeteors

-- Unlock the tech at start
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
	mod_IgnoreMeteors = CurrentModOptions:GetProperty("IgnoreMeteors")

	-- make sure we're in-game
	if not UIColony then
		return
	end

	UnlockTowers()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- List of devil handles we're attacking
local attacked_devils = {}

-- 	Replace orig func with mine
local ChoOrig_DefenceTower_DefenceTick = DefenceTower.DefenceTick
function DefenceTower:DefenceTick(...)

	-- Place at end of function to have it protect dustdevils before meteors
	if not mod_IgnoreMeteors then
		ChoOrig_DefenceTower_DefenceTick(self, ...)
	end

	if not mod_EnableMod then
		return
	end

	-- If a track thread is running wait for it to finish (copied from orig func)
	if IsValidThread(self.track_thread) then
		return
	end

	-- List of dustdevils on map
	local dustdevils = g_DustDevils or ""
	for i = 1, #dustdevils do
		local devil = dustdevils[i]

		-- Get dist (added * 10 as tower didn't see to target at the range of its hex grid)
		-- It could be from me increasing protection radius, or just how it targets meteors
		if IsValid(devil) and self:GetVisualDist(devil) <= self.shoot_range * 10 then
			-- Make sure tower is working
			if not IsValid(self) or not self.working or self.destroyed then
				return
			end

			-- .follow = small ones attached to major ones (they go away if major is gone)
			if not devil.follow and not attacked_devils[devil.handle] then
				-- Aim the tower at the dustdevil
				-- 7200 = 120*60
				self:OrientPlatform(devil:GetVisualPos(), 7200)
				-- Fire in the hole
				local rocket = self:FireRocket(nil, devil)
				-- Store handle so we only launch one per devil
				attacked_devils[devil.handle] = devil
				-- Seems like safe bets to set
				self.meteor = devil
				self.is_firing = true
				-- Sleep till rocket explodes
				CreateRealTimeThread(function()
					while rocket.move_thread do
						Sleep(250)
					end
					-- Make it pretty
					if IsValid(devil) then
						local snd = PlaySound("Mystery Bombardment ExplodeAir", "ObjectOneshot", nil, 0, false, devil)
						PlayFX("AirExplosion", "start", devil, devil:GetAttaches()[1], devil:GetPos())
						Sleep(GetSoundDuration(snd))
						-- Kill the devil object
						devil:delete()
					end
					self.meteor = false
					self.is_firing = false
				end)
				-- Back to the usual stuff
				Sleep(self.reload_time)
				-- DefenceTick needs it for defence_thread
				return true
			end
		end
	end

	-- Only remove devil handles if they're actually gone
	for handle, devil in pairs(attacked_devils) do
		if not IsValid(devil) then
			attacked_devils[handle] = nil
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
