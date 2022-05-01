-- See LICENSE for terms

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

-- last checked picard
local ChoOrig_CanUnlockAchievement = CanUnlockAchievement
function CanUnlockAchievement(...)
	if not mod_EnableMod then
		return ChoOrig_CanUnlockAchievement(...)
	end

--~   return ActiveMapID ~= "Mod" and not g_Tutorial and not IsGameRuleActive("FreeConstruction") and not IsGameRuleActive("EasyMaintenance") and not IsGameRuleActive("IronColonists") and not IsGameRuleActive("EasyResearch") and not IsGameRuleActive("RichCoffers") and not IsGameRuleActive("EndlessSupply")
  return ActiveMapID ~= "Mod" and not g_Tutorial
end
