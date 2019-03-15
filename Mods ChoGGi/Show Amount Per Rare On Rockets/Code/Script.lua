-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 61
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Show Amount Per Rare On Rockets requires ChoGGi's Library (at least v" .. min_version .. [[).
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

function OnMsg.ClassesBuilt()
	local XTemplates = XTemplates
	local str = [[Per Rare: %s]]

	ChoGGi.ComFuncs.AddXTemplate("ShowAmountPerRareOnRockets","customSupplyRocket",{
		Icon = "UI/Icons/res_precious_metals.tga",
		RolloverText = [[Amount received per rare/precious exported.]],
		OnContextUpdate = function(self, context)
			---
			self:SetTitle(str:format(context.city:CalcBaseExportFunding(1000)))
			---
		end,
	})

end --OnMsg
