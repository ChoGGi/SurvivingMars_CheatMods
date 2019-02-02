-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 53
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Auto Empty Waste Storage requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				if p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

function OnMsg.ClassesBuilt()
	local XTemplates = XTemplates

	ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipSubsurfaceDeposit[1],"ChoGGi_MultipleAmount")
	-- check if the buttons were already added (you can have one for each, but meh)
	XTemplates.ipSubsurfaceDeposit[1][#XTemplates.ipSubsurfaceDeposit[1]+1] = PlaceObj("XTemplateTemplate", {
		"ChoGGi_MultipleAmount", true,
		"__template", "InfopanelButton",
		"Icon", "UI/Icons/Sections/Metals_2.tga",
		"Title", [[5 Times the amount]],
		"RolloverText", [[Clicking this once will add 5 times the amount of stored resources.]],
		"RolloverTitle", "",
		"RolloverHint",	"",
		"OnPress", function()
			---
			local objs = UICity.labels.SubsurfaceDeposit or ""
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
			---
		end,
	})

end