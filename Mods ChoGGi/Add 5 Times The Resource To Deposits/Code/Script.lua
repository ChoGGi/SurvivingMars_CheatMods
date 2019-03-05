-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 57
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Auto Empty Waste Storage requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

function TerrainDeposit:CheatRefill()
  self.amount = self.max_amount
end

local MapGet = MapGet
local max_int = max_int
local function BumpAmount(self)
--~ 	local objs = UICity.labels[self.context.class] or ""
	local objs = MapGet("map",self.context.class)
	for i = 1, #objs do
		-- bump the amounts
		local new_amount = objs[i].max_amount * 5
		if new_amount >= max_int then
			objs[i].max_amount = max_int
		else
			objs[i].max_amount = new_amount
		end
		-- and fill them up
		objs[i]:CheatRefill()
		-- just for you XxUnkn0wnxX
		objs[i].grade = "Very High"
	end
end

function OnMsg.ClassesBuilt()
	local XTemplates = XTemplates

	local d = XTemplates.ipSubsurfaceDeposit[1]
	ChoGGi.ComFuncs.RemoveXTemplateSections(d,"ChoGGi_MultipleAmount")
	-- check if the buttons were already added (you can have one for each, but meh)
	d[#d+1] = PlaceObj("XTemplateTemplate", {
		"ChoGGi_MultipleAmount", true,
		"__template", "InfopanelButton",
		"Icon", "UI/Icons/Sections/Metals_2.tga",
		"Title", [[5 Times the amount1]],
		"RolloverText", [[Clicking this once will add 5 times the amount of stored resources to all deposits of the same type.]],
		"RolloverTitle", "Info",
		"RolloverHint",	T(0,"Activate <left_click>"),
		"OnPress", BumpAmount,
	})

	d = XTemplates.ipTerrainDeposit[1]
	ChoGGi.ComFuncs.RemoveXTemplateSections(d,"ChoGGi_MultipleAmount2")
	-- check if the buttons were already added (you can have one for each, but meh)
	d[1][#d+1] = PlaceObj("XTemplateTemplate", {
		"ChoGGi_MultipleAmount2", true,
		"__template", "InfopanelButton",
		"Icon", "UI/Icons/Sections/Metals_2.tga",
		"Title", [[5 Times the amount2]],
		"RolloverText", [[Clicking this once will add 5 times the amount of stored resources to all deposits of the same type.]],
		"RolloverTitle", "Info",
		"RolloverHint",	T(0,"Activate <left_click>"),
		"OnPress", BumpAmount,
	})

end