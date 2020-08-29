-- See LICENSE for terms

local skip_rockets = {
	ForeignTradeRocket = true,
	RefugeeRocket = true,
	TradeRocket = true,
}

function OnMsg.RocketLandAttempt(rocket)
	if skip_rockets[rocket.class]
		-- it's an export rocket, abort!
		or rocket.name:sub(-6) == "Export"
	then
		return
	end

	CreateGameTimeThread(function()
		-- needs a delay or CTD
		Sleep(1000)
		if rocket.allow_export then
			rocket:ToggleAllowExport()
		end
	end)
end
