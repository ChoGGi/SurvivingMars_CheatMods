-- See LICENSE for terms

local mod_EnableMod
local mod_DepositAmount
local mod_VistaEffectAmount
local mod_ResearchSitePercent
local mod_AnomalyResourceAmount

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DepositAmount = CurrentModOptions:GetProperty("DepositAmount") * 1000
	mod_VistaEffectAmount = CurrentModOptions:GetProperty("VistaEffectAmount") * 1000
	mod_ResearchSitePercent = CurrentModOptions:GetProperty("ResearchSitePercent")
	mod_AnomalyResourceAmount = CurrentModOptions:GetProperty("AnomalyResourceAmount") * 1000
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

DefineClass.ChoGGi_SubsurfaceDepositMarker = {
	__parents = {
		"SubsurfaceDepositMarker",
		"Building",
	},
	build_category = "ChoGGi_Deposits",
	Group = "ChoGGi_Deposits",

	grade = "Very High",
	instant_build = true,

	disabled_in_environment1 = "",
	disabled_in_environment2 = "",
	disabled_in_environment3 = "",
	disabled_in_environment4 = "",
}

DefineClass.ChoGGi_TerrainDepositMarker = {
	__parents = {
		"TerrainDepositMarker",
		"Building",
	},
	build_category = "ChoGGi_Deposits",
	Group = "ChoGGi_Deposits",

	grade = "Very High",
	instant_build = true,

	disabled_in_environment1 = "",
	disabled_in_environment2 = "",
	disabled_in_environment3 = "",
	disabled_in_environment4 = "",
}

DefineClass.ChoGGi_EffectDepositMarker = {
	__parents = {
		"EffectDepositMarker",
		"Building",
	},
	build_category = "ChoGGi_Deposits",
	Group = "ChoGGi_Deposits",

	instant_build = true,

	disabled_in_environment1 = "",
	disabled_in_environment2 = "",
	disabled_in_environment3 = "",
	disabled_in_environment4 = "",
}

DefineClass.ChoGGi_SubsurfaceAnomalyMarker = {
	__parents = {
		"SubsurfaceAnomalyMarker",
		"Building",
	},
	build_category = "ChoGGi_Deposits",
	Group = "ChoGGi_Deposits",

	instant_build = true,

	disabled_in_environment1 = "",
	disabled_in_environment2 = "",
	disabled_in_environment3 = "",
	disabled_in_environment4 = "",
}

local deposit_lookup = {
	-- It defaults to metal anyhoo
	ChoGGi_SubsurfaceDepositMarker_Metals = "Metals",
	ChoGGi_SubsurfaceDepositMarker_PreciousMetals = "PreciousMetals",
	ChoGGi_SubsurfaceDepositMarker_Water = "Water",
	ChoGGi_TerrainDepositMarker_Concrete = "Concrete",
	ChoGGi_SubsurfaceDepositMarker_PreciousMinerals = "PreciousMinerals",

	ChoGGi_EffectDepositMarker_Comfort = "BeautyEffectDeposit",
	ChoGGi_EffectDepositMarker_Morale = "MoraleEffectDeposit",
	ChoGGi_EffectDepositMarker_ResearchE = "ResearchEffectDeposit",

	ChoGGi_SubsurfaceAnomalyMarker_Breakthrough = "breakthrough",
	ChoGGi_SubsurfaceAnomalyMarker_Tech = "unlock",
	ChoGGi_SubsurfaceAnomalyMarker_ResearchA = "complete",
	ChoGGi_SubsurfaceAnomalyMarker_Resources = "resources",
}

local function GameInit_Resource(self)
	-- Change to correct resource
	self.resource = deposit_lookup[self.fx_actor_class]

	-- Spawn actual deposit
	local deposit = self:SpawnDeposit()
	deposit:SetPos(self:GetVisualPos())
	if deposit.resource ~= "Concrete" then
		deposit:SetRevealed(true)
		deposit.amount = mod_DepositAmount
	end

	deposit.max_amount = mod_DepositAmount

	-- No need for the marker anymore
	self:delete()
end
ChoGGi_SubsurfaceDepositMarker.GameInit = GameInit_Resource
ChoGGi_TerrainDepositMarker.GameInit = GameInit_Resource

local function GameInit_Effect(self)
	-- Change to correct "resource"
	self.deposit_type = deposit_lookup[self.fx_actor_class]

	-- Spawn actual deposit
	local deposit = self:SpawnDeposit()
	deposit:SetPos(self:GetVisualPos())
	deposit:SetRevealed(true)

	-- I have to do them both, since one is for ui and the other is actual amount
	-- (it's updated on Init instead of GameInit, but I can't call SpawnDeposit in Init)
	if self.deposit_type == "ResearchEffectDeposit" then
		deposit.research_increase = mod_ResearchSitePercent
		deposit.modifier.percent = mod_ResearchSitePercent
	elseif self.deposit_type == "MoraleEffectDeposit" then
		deposit.morale_increase = mod_VistaEffectAmount
		deposit.modifier.amount = mod_VistaEffectAmount
	elseif self.deposit_type == "BeautyEffectDeposit" then
		deposit.comfort_increase = mod_VistaEffectAmount
		deposit.modifier.amount = mod_VistaEffectAmount
	end

	-- No need for the marker anymore
	self:delete()
end
ChoGGi_EffectDepositMarker.GameInit = GameInit_Effect

-- Easier to just make my own list then figure out a table to get them from
local storable_resources = {
	"Concrete",
	"Electronics",
	"Food",
	"Fuel",
	"MachineParts",
	"Metals",
	"Polymers",
	"PreciousMetals",
}
local c = #storable_resources
-- No seeds if no green planet
if g_AvailableDlc.armstrong then
	c = c + 1
	storable_resources[c] = "Seeds"
end
-- etc
if g_AvailableDlc.picard then
	c = c + 1
	storable_resources[c] = "PreciousMinerals"
end

local function GameInit_Effect(self)
	-- Change to correct "resource"
	self.tech_action = deposit_lookup[self.fx_actor_class]

		-- Spawn actual deposit
	local deposit = self:SpawnDeposit()
	deposit:SetPos(self:GetVisualPos())
	deposit:SetRevealed(true)

	if self.tech_action == "breakthrough" then
		deposit.breakthrough_tech = table.rand(UIColony:GetUnregisteredBreakthroughs())
	elseif self.tech_action == "resources" then
		deposit.granted_resource = table.rand(storable_resources)
		deposit.granted_amount = mod_AnomalyResourceAmount
	end

	-- No need for the marker anymore
	self:delete()
end
ChoGGi_SubsurfaceAnomalyMarker.GameInit = GameInit_Effect

local effect_icons = {
	_Morale = "UI/Icons/Buildings/dome.tga",
	_Comfort = "UI/Icons/Buildings/dome.tga",
	_ResearchE = "UI/Icons/Buildings/research.tga",
}
local lookup_names = {
	_Breakthrough = T(1--[[Unlock Breakthrough]]),
	_Tech = T(2--[[Unlock Tech]]),
	_ResearchA = T(3--[[Grant Research]]),
	_Resources = T(8693--[[Grant Resources]]),
	_Comfort = T(4295--[[Comfort]]),
	_Morale = T(4297--[[Morale]]),
	-- Easier to add this one then figure out some way to just change the other two
	_ResearchE = T(11461--[[Research Site]]),
}

local function AddTemplate(obj, class, deposit_type, info)
	-- I mean... it's kinda ugly but
	local description = obj.description
	local display_icon = obj.display_icon
	local display_name = obj.display_name

	if info == "effect_info" then
		description = obj.IPDescription
		display_icon = effect_icons[deposit_type]
		display_name = lookup_names[deposit_type]
	elseif info == "anomaly_info" then
		description = obj.description or T(8693--[[Grant Resources]])
		display_name = lookup_names[deposit_type]
	end

	PlaceObj("BuildingTemplate", {
		"Id", class .. deposit_type,
		"template_class", class,

		"display_name", display_name,
		"display_name_pl", display_name,
		"description", description,
		"display_icon", display_icon,
		"disabled_entity", obj.disabled_entity,
		"entity", obj.entity,
	})
end

function OnMsg.ClassesPostprocess()
	-- Add build cat
	local bms = BuildMenuSubcategories
	if not bms.ChoGGi_Deposits then
		PlaceObj('BuildMenuSubcategory', {
			build_pos = 9,
			category = "Storages",
			description = T(0000, "Free Resources"),
			display_name = T(0000, "Deposits"),
			group = "Default",
			icon = "UI/Icons/Buildings/depots.tga",
			category_name = "ChoGGi_Deposits",
			id = "ChoGGi_Deposits",
		})
	end

	if BuildingTemplates.ChoGGi_SubsurfaceDepositMarker_Metals then
		return
	end

	-- Anomaly
	AddTemplate(SubsurfaceAnomaly_breakthrough,
		"ChoGGi_SubsurfaceAnomalyMarker", "_Breakthrough", "anomaly_info"
	)
	AddTemplate(SubsurfaceAnomaly_unlock,
		"ChoGGi_SubsurfaceAnomalyMarker", "_Tech", "anomaly_info"
	)
	AddTemplate(SubsurfaceAnomaly_complete,
		"ChoGGi_SubsurfaceAnomalyMarker", "_ResearchA", "anomaly_info"
	)
	AddTemplate(SubsurfaceAnomaly,
		"ChoGGi_SubsurfaceAnomalyMarker", "_Resources", "anomaly_info"
	)

	-- Effect
	AddTemplate(BeautyEffectDeposit,
		"ChoGGi_EffectDepositMarker", "_Comfort", "effect_info"
	)
	AddTemplate(ResearchEffectDeposit,
		"ChoGGi_EffectDepositMarker", "_ResearchE", "effect_info"
	)
	AddTemplate(MoraleEffectDeposit,
		"ChoGGi_EffectDepositMarker", "_Morale", "effect_info"
	)

	-- Resource
	AddTemplate(SubsurfaceDepositMetals,
		"ChoGGi_SubsurfaceDepositMarker", "_Metals"
	)
	AddTemplate(SubsurfaceDepositPreciousMetals,
		"ChoGGi_SubsurfaceDepositMarker", "_PreciousMetals"
	)
	AddTemplate(SubsurfaceDepositWater,
		"ChoGGi_SubsurfaceDepositMarker", "_Water"
	)
	AddTemplate(TerrainDepositConcrete,
		"ChoGGi_TerrainDepositMarker", "_Concrete"
	)
	if g_AvailableDlc.picard then
		AddTemplate(SubsurfaceDepositPreciousMinerals,
			"ChoGGi_SubsurfaceDepositMarker", "_PreciousMinerals"
		)
	end

end
