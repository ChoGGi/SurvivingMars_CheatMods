-- See LICENSE for terms

local max_int = max_int
local function BumpAmount(self)
	local objs = UICity.labels[self.context.class] or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- bump the amounts
		local new_amount = obj.max_amount * 5
		if new_amount >= max_int then
			obj.max_amount = max_int
		else
			obj.max_amount = new_amount
		end
		-- and fill them up
		obj.amount = obj.max_amount
		-- just for you XxUnkn0wnxX
		obj.grade = "Very High"
	end
end

function OnMsg.ClassesBuilt()
	local XTemplates = XTemplates

	local template = PlaceObj("XTemplateTemplate", {
		"ChoGGi_MultipleAmount", true,
		"__template", "InfopanelButton",
		"Icon", "UI/Icons/Sections/Metals_2.tga",
		"Title", [[5 Times the amount1]],
		"RolloverText", [[Clicking this once will add 5 times the amount of stored resources to all deposits of the same type.]],
		"RolloverTitle", "Info",
		"RolloverHint",	T(0,"Activate <left_click>"),
		"OnPress", BumpAmount,
	})

	local d = XTemplates.ipSubsurfaceDeposit[1]
	ChoGGi.ComFuncs.RemoveXTemplateSections(d,"ChoGGi_MultipleAmount")
	-- check if the buttons were already added (you can have one for each, but meh)
	d[#d+1] = template

	d = XTemplates.ipTerrainDeposit[1]
	ChoGGi.ComFuncs.RemoveXTemplateSections(d,"ChoGGi_MultipleAmount")
	d[#d+1] = template


end