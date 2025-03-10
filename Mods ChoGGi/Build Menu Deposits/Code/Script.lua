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
	grade = "Very High",
}

DefineClass.ChoGGi_TerrainDepositMarker = {
	__parents = {
		"TerrainDepositMarker",
		"Building",
	},
	grade = "Very High",
}

DefineClass.ChoGGi_EffectDepositMarker = {
	__parents = {
		"EffectDepositMarker",
		"Building",
	},
	instant_build = true,
}

DefineClass.ChoGGi_SubsurfaceAnomalyMarker = {
	__parents = {
		"SubsurfaceAnomalyMarker",
		"Building",
	},
	instant_build = true,
}

local deposit_lookup = {
	-- It defaults to metal anyhoo
	ChoGGi_SubsurfaceDepositMarker_Metals = "Metals",
	ChoGGi_SubsurfaceDepositMarker_PreciousMetals = "PreciousMetals",
	ChoGGi_SubsurfaceDepositMarker_Water = "Water",
	ChoGGi_SubsurfaceDepositMarker_PreciousMinerals = "PreciousMinerals",
	ChoGGi_TerrainDepositMarker_Concrete = "Concrete",

	ChoGGi_EffectDepositMarker_Comfort = "BeautyEffectDeposit",
	ChoGGi_EffectDepositMarker_Morale = "MoraleEffectDeposit",
	ChoGGi_EffectDepositMarker_ResearchEff = "ResearchEffectDeposit",

	ChoGGi_SubsurfaceAnomalyMarker_Breakthrough = "breakthrough",
	ChoGGi_SubsurfaceAnomalyMarker_Tech = "unlock",
	ChoGGi_SubsurfaceAnomalyMarker_ResearchAnom = "complete",
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

local function GameInit_Anomaly(self)
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
ChoGGi_SubsurfaceAnomalyMarker.GameInit = GameInit_Anomaly

local effect_icons = {
	_Morale = "UI/Icons/Buildings/dome.tga",
	_Comfort = "UI/Icons/Buildings/dome.tga",
	_ResearchEff = "UI/Icons/Buildings/research.tga",
}
local lookup_names = {
	_Breakthrough = T(1--[[Unlock Breakthrough]]),
	_Tech = T(2--[[Unlock Tech]]),
	_ResearchAnom = T(3--[[Grant Research]]),
	_Resources = T(8693--[[Grant Resources]]),
	_Comfort = T(4295--[[Comfort]]),
	_Morale = T(4297--[[Morale]]),
	-- Easier to add this one then figure out some way to just change the other two
	_ResearchEff = T(11461--[[Research Site]]),
}

local function AddTemplate(obj, params)

	-- I mean... it's kinda ugly but
	local description = obj.description
	local display_icon = params.display_icon or obj.display_icon
	local display_name = obj.display_name

	if params.info == "effect_info" then
		description = obj.IPDescription
		display_icon = effect_icons[params.deposit_type]
		display_name = lookup_names[params.deposit_type]
	elseif params.info == "anomaly_info" then
		description = obj.description or T(8693--[[Grant Resources]])
		display_name = lookup_names[params.deposit_type]
	end

	PlaceObj("BuildingTemplate", {
		"Id", params.class .. params.deposit_type,
		"template_class", params.class,

		"display_name", display_name,
		"display_name_pl", display_name,
		"description", description or SubsurfaceAnomaly:GetDescription(),
		"display_icon", display_icon,
		"disabled_entity", obj.disabled_entity,
		"entity", obj.entity,
		"build_pos", params.build_pos,

		"build_category", "ChoGGi_Deposits",
		"Group", "ChoGGi_Deposits",
		"instant_build", true,

		-- "Asteroid","Underground","Surface",
		-- defaults to surface only!
		-- use the below to remove realm limitation
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",
	})
end

function OnMsg.ClassesPostprocess()
	-- Add build cat
	if not BuildMenuSubcategories.ChoGGi_Deposits then
		PlaceObj('BuildMenuSubcategory', {
			build_pos = 9,
			category = "Storages",
			description = T(0000, "Free Resources"),
			display_name = T(0000, "Deposits"),
			group = "Default",
			icon = "UI/Icons/Buildings/res_all.tga",
			category_name = "ChoGGi_Deposits",
			id = "ChoGGi_Deposits",
		})
	end

	if BuildingTemplates.ChoGGi_SubsurfaceDepositMarker_Metals then
		return
	end

	-- Resource
	AddTemplate(TerrainDepositConcrete, {
		class = "ChoGGi_TerrainDepositMarker",
		deposit_type = "_Concrete",
		build_pos = 1,
	})
	AddTemplate(SubsurfaceDepositWater, {
		class = "ChoGGi_SubsurfaceDepositMarker",
		deposit_type = "_Water",
		build_pos = 2,
	})
	AddTemplate(SubsurfaceDepositMetals, {
		class = "ChoGGi_SubsurfaceDepositMarker",
		deposit_type = "_Metals",
		build_pos = 3,
	})
	AddTemplate(SubsurfaceDepositPreciousMetals, {
		class = "ChoGGi_SubsurfaceDepositMarker",
		deposit_type = "_PreciousMetals",
		build_pos = 4,
	})
	if g_AvailableDlc.picard then
		AddTemplate(SubsurfaceDepositPreciousMinerals, {
			class = "ChoGGi_SubsurfaceDepositMarker",
			deposit_type = "_PreciousMinerals",
			build_pos = 5,
		})
	end

	-- Anomaly
	AddTemplate(SubsurfaceAnomaly, {
		class = "ChoGGi_SubsurfaceAnomalyMarker",
		deposit_type = "",
		build_pos = 6,
		display_icon = "UI/Icons/Anomaly_Custom.tga",
	})
	AddTemplate(SubsurfaceAnomaly_complete, {
		class = "ChoGGi_SubsurfaceAnomalyMarker",
		deposit_type = "_ResearchAnom",
		info = "anomaly_info",
		build_pos = 7,
		display_icon = "UI/Icons/Anomaly_Research.tga",
	})
	AddTemplate(SubsurfaceAnomaly, {
		class = "ChoGGi_SubsurfaceAnomalyMarker",
		deposit_type = "_Resources",
		info = "anomaly_info",
		build_pos = 8,
		display_icon = "UI/Icons/Anomaly_Event.tga",
	})
	AddTemplate(SubsurfaceAnomaly_unlock, {
		class = "ChoGGi_SubsurfaceAnomalyMarker",
		deposit_type = "_Tech",
		info = "anomaly_info",
		build_pos = 9,
		display_icon = "UI/Icons/Anomaly_Tech.tga",
	})
	AddTemplate(SubsurfaceAnomaly_breakthrough, {
		class = "ChoGGi_SubsurfaceAnomalyMarker",
		deposit_type = "_Breakthrough",
		info = "anomaly_info",
		build_pos = 10,
		display_icon = "UI/Icons/Anomaly_Breakthrough.tga",
	})

	-- Effect
	AddTemplate(BeautyEffectDeposit, {
		class = "ChoGGi_EffectDepositMarker",
		deposit_type = "_Comfort",
		info = "effect_info",
		build_pos = 11,
	})
	AddTemplate(MoraleEffectDeposit, {
		class = "ChoGGi_EffectDepositMarker",
		deposit_type = "_Morale",
		info = "effect_info",
		build_pos = 12,
	})
	AddTemplate(ResearchEffectDeposit, {
		class = "ChoGGi_EffectDepositMarker",
		deposit_type = "_ResearchEff",
		info = "effect_info",
		build_pos = 13,
	})

end

-- Fix single image icons
local lookup_icons = {
	["UI/Icons/Anomaly_Custom.tga"] = true,
	["UI/Icons/Anomaly_Research.tga"] = true,
	["UI/Icons/Anomaly_Event.tga"] = true,
	["UI/Icons/Anomaly_Tech.tga"] = true,
	["UI/Icons/Anomaly_Breakthrough.tga"] = true,
}

local ChoOrig_XBuildMenu_GetItems = XBuildMenu.GetItems
function XBuildMenu.GetItems(...)
	if not mod_EnableMod then
		return ChoOrig_XBuildMenu_GetItems(...)
	end

	local buttons = ChoOrig_XBuildMenu_GetItems(...)

	for i = 1, #buttons do
		local button = buttons[i]
		if lookup_icons[button.icon] then
			button.idButton:SetColumns(1)
			button.idButton.RolloverZoom = 1100
			button.idButton.SetRollover = function(this, ...)
--~ 				button:SetRollover(...)
				XWindow.OnSetRollover(button, true)
				button.idButton.idShine:SetRollover(...)
--~ 				XTextButton.SetRollover(this, ...)
			end
		end
	end
--~ 	ex(buttons)
	return buttons
end
