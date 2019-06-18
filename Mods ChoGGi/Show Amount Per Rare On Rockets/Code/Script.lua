-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	ChoGGi.ComFuncs.AddXTemplate("ShowAmountPerRareOnRockets", "customSupplyRocket", {
		Icon = "UI/Icons/res_precious_metals.tga",
		RolloverText = T(302535920011265, [[Amount received per rare/precious exported.]]),
		OnContextUpdate = function(self, context)
			---
			self:SetTitle(T{302535920011266,
				"Per Rare: <amount>",
				amount = context.city:CalcBaseExportFunding(1000),
			})
			---
		end,
	})
end
