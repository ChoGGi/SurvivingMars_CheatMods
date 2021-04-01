-- See LICENSE for terms

local IsValid = IsValid

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

function OnMsg.ClassesPostprocess()
	--
	local orig_Colonist_EnterBuilding = Colonist.EnterBuilding
	function Colonist:EnterBuilding(building, ...)
		if mod_EnableMod and self.daily_interest ~= "" and IsValid(building)
			and building:HasMember("IsOneOfInterests") and building:IsOneOfInterests(self.daily_interest)
		then
--~ 			printC("daily_interest CLEARED", self.daily_interest)
			self.daily_interest = ""
			-- here ya go
			self.daily_interest_fail = 0
		end

		return orig_Colonist_EnterBuilding(self, building, ...)
	end
	--
end
