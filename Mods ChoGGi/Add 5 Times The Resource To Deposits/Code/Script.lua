-- See LICENSE for terms

local max_int = max_int
local function BumpAmount(self)

	-- hey guys, lets just remove some labels, I'm sure no modders would ever use them
--~ 	local objs = UICity.labels[self.context.class] or ""
	local objs = GetRealm(self):MapGet("map",self.context.class)
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

function OnMsg.ClassesPostprocess()
	local template = PlaceObj("XTemplateTemplate", {
		"ChoGGi_MultipleAmount", true,
		"Id", "ChoGGi_MultipleAmount",
		"__template", "InfopanelButton",
		"Icon", "UI/Icons/Sections/Metals_2.tga",
		"Title", T(302535920011001, "5* The Amount"),
		"RolloverText", T(302535920011002, "Clicking this once will add 5 times the amount of stored resources to all deposits of the same type (and make the grade very high)."),
		"RolloverTitle", T(126095410863,"Info"),
		"RolloverHint", T(608042494285, "<left_click> Activate"),
		"OnPress", BumpAmount,
	})

	local XTemplates = XTemplates
	local d = XTemplates.ipSubsurfaceDeposit[1]
	ChoGGi.ComFuncs.RemoveXTemplateSections(d, "ChoGGi_MultipleAmount")
	-- check if the buttons were already added (you can have one for each, but meh)
	d[#d+1] = template

	d = XTemplates.ipTerrainDeposit[1]
	ChoGGi.ComFuncs.RemoveXTemplateSections(d, "ChoGGi_MultipleAmount")
	d[#d+1] = template
end
