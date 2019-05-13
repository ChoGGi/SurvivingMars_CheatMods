-- See LICENSE for terms

function OnMsg.ClassesBuilt()
	ChoGGi.ComFuncs.AddXTemplate("ShowAmountPerRareOnRockets", "customSupplyRocket", {
		Icon = "UI/Icons/res_precious_metals.tga",
		RolloverText = [[Amount received per rare/precious exported.]],
		OnContextUpdate = function(self, context)
			---
			self:SetTitle("Per Rare: " .. context.city:CalcBaseExportFunding(1000))
			---
		end,
	})
end
