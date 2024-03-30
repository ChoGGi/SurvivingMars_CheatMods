-- See LICENSE for terms

local mod_EnableMod
local mod_UnlockStoryTechs
local mod_ResearchBreakthroughs

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_UnlockStoryTechs = CurrentModOptions:GetProperty("UnlockStoryTechs")
	mod_ResearchBreakthroughs = CurrentModOptions:GetProperty("ResearchBreakthroughs")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function ShuffleUnlockTechs(techs, colony)
	StableShuffle(techs, colony:CreateResearchRand("OmegaTelescope"), 100)
	if mod_ResearchBreakthroughs then
		for i = 1, #techs do
			colony:SetTechResearched(techs[i])
		end
	else
		for i = 1, #techs do
			colony:SetTechDiscovered(techs[i])
		end
	end
end

local ChoOrig_Research_UnlockBreakthroughs = Research.UnlockBreakthroughs
function Research:UnlockBreakthroughs(count, name, ...)
	if not mod_EnableMod then
		return ChoOrig_Research_UnlockBreakthroughs(self, count, name, ...)
	end

	ChoOrig_Research_UnlockBreakthroughs(self, count, name, ...)

	if name == "OmegaTelescope" then
		-- All breathroughs
		ShuffleUnlockTechs(self:GetUnregisteredBreakthroughs(), self)
		-- Stories
		if mod_UnlockStoryTechs then
			local ids = {}
			local bits = Presets.TechPreset.Storybits
			for i = 1, #bits do
				local tech = bits[i]
				local id = tech.id
				-- function Colony:GetUnregisteredBreakthroughs()
				if not table.find(BreakthroughOrder, id) and not self:IsTechDiscovered(id) and self:TechAvailableCondition(tech) then
					ids[#ids + 1] = id
				end
			end
			ShuffleUnlockTechs(ids, self)
		end

	end
end
