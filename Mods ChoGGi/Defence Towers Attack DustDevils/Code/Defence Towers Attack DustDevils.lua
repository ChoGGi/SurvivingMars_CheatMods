-- See LICENSE for terms

function OnMsg.ModsLoaded()
	if not table.find(ModsLoaded,"id","ChoGGi_Library") then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,[[Error: This mod requires ChoGGi's Library.
Press Ok to download it or check Mod Manager to make sure it's enabled.]]) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- nope not hacky at all
local is_loaded
function OnMsg.ClassesGenerate()
	Msg("ChoGGi_Library_Loaded","ChoGGi_DefenceTowersAttackDustDevils")
end
function OnMsg.ChoGGi_Library_Loaded(mod_id)
	if is_loaded or mod_id and mod_id ~= "ChoGGi_DefenceTowersAttackDustDevils" then
		return
	end
	is_loaded = true
	-- nope nope nope

	local RocketFiredDustDevil = {}
	local Sleep = Sleep
	local IsValid = IsValid
	local CreateRealTimeThread = CreateRealTimeThread
	local PlayFX = PlayFX

	function OnMsg.ClassesBuilt()

		--save orig func
		ChoGGi.ComFuncs.SaveOrigFunc("DefenceTower","DefenceTick")
		local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
		--replace orig func with mine
		function DefenceTower:DefenceTick()

			--place at end of function to have it protect dustdevils before meteors
			ChoGGi_OrigFuncs.DefenceTower_DefenceTick(self)

			--if DTADD.UserSettings.DefenceTowersAttackDustDevils then
				--copied from orig func
				if IsValidThread(self.track_thread) then
					return
				end
				--list of devil handles we attacked
				local devils = RocketFiredDustDevil
				--list of dustdevils on map
				local hostile = g_DustDevils or empty_table
				for i = 1, #hostile do
					local obj = hostile[i]

					--get dist (added * 10 as it didn't see to target at the range of it's hex grid)
					--it could be from me increasing protection radius, or just how it targets meteors
					if IsValid(obj) and self:GetVisualDist2D(obj) <= self.shoot_range * 10 then
						--check if tower is working
						if not IsValid(self) or not self.working or self.destroyed then
							return
						end

						--follow = skip small ones attached to majors
						if (not obj.follow and not devils[obj.handle]) then
							--aim the tower at the dustdevil
							self:OrientPlatform(obj:GetVisualPos(), 7200)
							--fire in the hole
							local rocket = self:FireRocket(nil, obj)
							--store handle so we only launch one per devil
							devils[obj.handle] = obj.handle
							--seems like safe bets to set
							self.meteor = obj
							self.is_firing = true
							--sleep till rocket explodes
							CreateRealTimeThread(function()
								while rocket.move_thread do
									Sleep(500)
								end
								--make it pretty
								PlayFX("AirExplosion", "start", obj, obj:GetAttaches()[1], obj:GetPos())
								--kill the devil object
								obj:delete()
								self.meteor = false
								self.is_firing = false
							end)
							--back to the usual stuff
							Sleep(self.reload_time)
							return true
						end
					end
				end
				--remove only remove devil handles if they're actually gone
				if #devils > 0 then
					CreateRealTimeThread(function()
						local HandleToObject = HandleToObject
						for i = #devils, 1, -1 do
							if not IsValid(HandleToObject[devils[i]]) then
								devils[i] = nil
							end
						end
					end)
				end
			--end --if active

			--end of function
		end

	end

	--[[
	--spawn a bunch of dustdevils to test
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

end
