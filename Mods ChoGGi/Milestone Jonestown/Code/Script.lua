-- See LICENSE for terms

--[[
I killed 908 colonists and the UnnaturalDeaths var was 1816
I could do a /2 with UnnaturalDeaths and gag dlc but then I'd need to update mod if devs fix it

Lua\Units\Colonist.lua > function Colonist:Die(reason)
Dlc\gagarin\Code\Achievements.lua > function OnMsg.ColonistDie(colonist, reason)
Both add +1 to the UnnaturalDeaths var...
]]
GlobalVar("ChoGGi_Milestone_Jonestown_count", 0)
function OnMsg.ColonistDie(_, reason)
	if not NaturalDeathReasons[reason] then
		ChoGGi_Milestone_Jonestown_count = ChoGGi_Milestone_Jonestown_count + 1
	end
end

function OnMsg.ClassesPostprocess()
	if Presets.Milestone.Default.ChoGGi_Jonestown then
		return
	end

	PlaceObj("Milestone", {
		Complete = function(self)
			CreateGameTimeThread(function()
				-- keep looping till we hit it
				while true do
					WaitMsg("ColonistDie")
					if ChoGGi_Milestone_Jonestown_count > 908 then
						Msg("ChoGGi_Milestone_Jonestown")
						break
					end
				end
			end)

			WaitMsg("ChoGGi_Milestone_Jonestown")
			return true
		end,
		SortKey = 1,
		reward_research = 909,
		base_score = 909,
		bonus_score = 909,
		bonus_score_expiration = 909,
		display_name = T(302535920011998, "Pull a Jim Jones"),
		group = "Default",
		id = "ChoGGi_Jonestown",
	})

end
