-- See LICENSE for terms

local T = T
local floatfloor = floatfloor

local InfobarObj_FmtRes = InfobarObj.FmtRes
local ResourceScale = const.ResourceScale

function OnMsg.ClassesPostprocess()
	ChoGGi.ComFuncs.AddXTemplate("ShowAmountPerRareOnRockets", "customSupplyRocket", {
		Icon = "UI/Icons/res_precious_metals.tga",
		RolloverText = T(302535920011265, "Amount received per rare/precious exported."),
		OnContextUpdate = function(self, context)
			---
			local loaded = context:GetStoredExportResourceAmount()
			if loaded > 0 then
				local funding = context.city.colony.funds:CalcBaseExportFunding(1000)
				local count = floatfloor(loaded / ResourceScale)

				self:SetTitle(T{302535920011825,
					"Per Rare: <amount>,   <count> * <amount> = <green><added></green>",
					amount = InfobarObj_FmtRes(nil, funding),
					count = count,
					added = InfobarObj_FmtRes(nil, count * funding),
				})
			else
				self:SetTitle(T{302535920011266,
					"Per Rare: <amount>",
					amount = InfobarObj_FmtRes(nil, context.city.colony.funds:CalcBaseExportFunding(1000)),
				})
			end
			---
		end,
	})
end
