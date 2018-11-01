-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 29
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Show Amount Per Rare On Rockets requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
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
