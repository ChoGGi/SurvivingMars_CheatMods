-- See LICENSE for terms

function OnMsg.ModsLoaded()
	if not table.find(ModsLoaded,"id","ChoGGi_Library") then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,[[Error: This mod requires ChoGGi's Library.
Press Ok to download it or check Mod Manager to make sure it's enabled.]]) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

function OnMsg.ClassesBuilt()
	local S = ChoGGi.Strings

	-- list controlled buildings
	ChoGGi.CodeFuncs.AddXTemplate("EmptyMechDepot","sectionStorage",{
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
			ChoGGi.CodeFuncs.EmptyMechDepot(context)
		end,
	},true)

end
