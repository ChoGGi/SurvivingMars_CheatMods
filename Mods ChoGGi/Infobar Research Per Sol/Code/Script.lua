-- See LICENSE for terms

function OnMsg.AddResearchRolloverTexts(ret)
	ret[#ret+1] = "<newline>" .. T{445070088246,
		"Research per Sol<right><research(EstimatedDailyProduction)>",
		EstimatedDailyProduction = ResourceOverviewObj:GetEstimatedRP(),
	}
end
