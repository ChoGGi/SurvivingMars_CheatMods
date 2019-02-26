-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 56
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Empty Mech Depot requires ChoGGi's Library (at least v%s).
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
	local S = ChoGGi.Strings

	-- list controlled buildings
	ChoGGi.ComFuncs.AddXTemplate("EmptyMechDepot","sectionStorage",{
		__context_of_kind = "MechanizedDepot",
		Icon = "UI/Icons/Sections/storage.tga",
		Title = S[302535920000176--[[Empty Mech Depot--]]],
		RolloverTitle = S[302535920000176--[[Empty Mech Depot--]]],
		RolloverText = S[302535920000177--[[Empties out selected/moused over mech depot into a small depot in front of it.--]]],
		OnContextUpdate = function(self, context)
			if context.stockpiled_amount > 0 then
				self:SetVisible(true)
				self:SetMaxHeight()
			else
				self:SetVisible(false)
				self:SetMaxHeight(0)
			end
		end,
		func = function(_, context)
			ChoGGi.ComFuncs.EmptyMechDepot(context)
		end,
	},true)

end
