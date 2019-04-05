-- See LICENSE for terms

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

end
