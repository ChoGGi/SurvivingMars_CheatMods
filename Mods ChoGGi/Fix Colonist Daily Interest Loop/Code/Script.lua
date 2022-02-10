-- See LICENSE for terms

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

-- last checked picard 1010999 Colonist:Idle()
-- https://forum.paradoxplaza.com/forum/threads/surviving-mars-colonists-repeatedly-satisfy-daily-interests.1464969/
function OnMsg.ClassesPostprocess()
	--
	local ChoOrig_Colonist_EnterBuilding = Colonist.EnterBuilding
	function Colonist:EnterBuilding(building, ...)
		if mod_EnableMod and self.daily_interest ~= "" and IsValid(building)
			and building:HasMember("IsOneOfInterests") and building:IsOneOfInterests(self.daily_interest)
		then
--~ 			printC("daily_interest CLEARED", self.daily_interest)
			self.daily_interest = ""
			self.daily_interest_fail = 0
		end

		return ChoOrig_Colonist_EnterBuilding(self, building, ...)
	end
	--
end
