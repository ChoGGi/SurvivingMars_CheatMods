-- See LICENSE for terms

local mod_EnableMod
local mod_MultiplyAmount
local mod_SetGrade
local mod_AllDeposits

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_MultiplyAmount = CurrentModOptions:GetProperty("MultiplyAmount")
	mod_SetGrade = CurrentModOptions:GetProperty("SetGrade")
	mod_AllDeposits = CurrentModOptions:GetProperty("AllDeposits")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local grades = {
	"Depleted",
	"Very Low",
	"Low",
	"Average",
	"High",
	"Very High",
}

local max_int = max_int

local function UpdateDeposit(obj)

	if mod_MultiplyAmount == 0 then
		obj.max_amount = 1000
		obj.amount = 1000
	else
		-- bump the amounts
		local new_amount = obj.max_amount * mod_MultiplyAmount
		if new_amount >= max_int then
			obj.max_amount = max_int
		else
			obj.max_amount = new_amount
		end
		-- and fill them up
		obj.amount = obj.max_amount
	end

	-- just for you XxUnkn0wnxX
	if mod_SetGrade > 0 then
		obj.grade = grades[mod_SetGrade]
	end
end

local function BumpAmount(self)
	if mod_AllDeposits then
		-- hey guys, lets just remove some labels, I'm sure no modders would ever use them
		local objs = GetRealm(self.context):MapGet("map", self.context.class)
		for i = 1, #objs do
			UpdateDeposit(objs[i])
		end
	else
		UpdateDeposit(self.context)
	end
end

function OnMsg.ClassesPostprocess()
	local template = PlaceObj("XTemplateTemplate", {
		"ChoGGi_MultipleAmount", true,
		"Id", "ChoGGi_MultipleAmount",
		"__template", "InfopanelButton",
		"Icon", "UI/Icons/Sections/Metals_2.tga",
		"Title", T(302535920011001, "Multiply The Amount"),
		"RolloverText", T(302535920011002, "Clicking this once will multiply the amount of stored resources (and set grade/all deposits depending on mod options)."),
		"RolloverTitle", T(126095410863,"Info"),
		"RolloverHint", T(608042494285, "<left_click> Activate"),
		"__condition", function (_, context)
			return mod_EnableMod
		end,
		"OnPress", BumpAmount,
	})

	local XTemplates = XTemplates
	local d = XTemplates.ipSubsurfaceDeposit[1]
	ChoGGi_Funcs.Common.RemoveXTemplateSections(d, "ChoGGi_MultipleAmount")
	-- check if the buttons were already added (you can have one for each, but meh)
	d[#d+1] = template

	d = XTemplates.ipTerrainDeposit[1]
	ChoGGi_Funcs.Common.RemoveXTemplateSections(d, "ChoGGi_MultipleAmount")
	d[#d+1] = template
end
