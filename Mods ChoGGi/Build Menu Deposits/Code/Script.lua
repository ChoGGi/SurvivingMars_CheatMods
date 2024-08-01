-- See LICENSE for terms

local mod_EnableMod
local mod_DepositAmount

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DepositAmount = CurrentModOptions:GetProperty("DepositAmount") * 1000
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
}

local resource_lookup = {
	-- It defaults to metal anyhoo
	SignMetalsDeposit = "Metals",

	SignWaterDeposit = "Water",
	SignPreciousMetalsDeposit = "PreciousMetals",
	SignPreciousMineralsDeposit = "PreciousMinerals",

	SignConcreteDeposit = "Concrete",
}

local function GameInit(self)
	-- Change to correct resource (defaults to metal)
	self.resource = resource_lookup[self.entity]

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

ChoGGi_SubsurfaceDepositMarker.GameInit = GameInit
ChoGGi_TerrainDepositMarker.GameInit = GameInit

local function AddTemplate(obj, class, resource)
	PlaceObj("BuildingTemplate", {
		"Id", class .. resource,
		"template_class", class,

		"display_name", obj.display_name,
		"display_name_pl", obj.display_name,
		"description", obj.description,
		"display_icon", obj.display_icon,
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
