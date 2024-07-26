-- See LICENSE for terms

local mod_EnableMod
local mod_DisableStoryBitSuicides
local mod_ColdWaveSanityDamage
local mod_DustStormSanityDamage
local mod_MeteorSanityDamage
local mod_MysteryDreamSanityDamage

-- Some stuff checks one some other...
local SetConsts = ChoGGi_Funcs.Common.SetConsts

local function UpdateConsts()
	if not mod_EnableMod then
		return
	end

	SetConsts("ColdWaveSanityDamage", mod_ColdWaveSanityDamage)
	SetConsts("DustStormSanityDamage", mod_DustStormSanityDamage)
	SetConsts("MeteorSanityDamage", mod_MeteorSanityDamage)
	SetConsts("MysteryDreamSanityDamage", mod_MysteryDreamSanityDamage)
end
OnMsg.CityStart = UpdateConsts
OnMsg.LoadGame = UpdateConsts

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DisableStoryBitSuicides = CurrentModOptions:GetProperty("DisableStoryBitSuicides")
	mod_ColdWaveSanityDamage = CurrentModOptions:GetProperty("ColdWaveSanityDamage")
	mod_DustStormSanityDamage = CurrentModOptions:GetProperty("DustStormSanityDamage")
	mod_MeteorSanityDamage = CurrentModOptions:GetProperty("MeteorSanityDamage")
	mod_MysteryDreamSanityDamage = CurrentModOptions:GetProperty("MysteryDreamSanityDamage")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	UpdateConsts()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_Colonist_Idle = Colonist.Idle
function Colonist:Idle(...)
	if not mod_EnableMod then
		return ChoOrig_Colonist_Idle(self, ...)
	end

	-- This gets flipped by the ForceSuicide class def effect
	if mod_DisableStoryBitSuicides and self.force_suicide then
		self.force_suicide = false
	end

	-- Presto! No more suicide! Wasn't that easy?
	if self.stat_sanity == 0 then
		self.traits.Religious = true
	end

	return ChoOrig_Colonist_Idle(self, ...)
end