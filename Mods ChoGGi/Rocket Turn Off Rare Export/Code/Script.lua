-- See LICENSE for terms

local skip_rockets = {
	ForeignTradeRocket = true,
	RefugeeRocket = true,
	TradeRocket = true,
}

local function TurnOffRares(rocket)
	-- only want rockets from buildinginit
	if not rocket:IsKindOf("RocketBase")
		-- ignore these rockets...
		or skip_rockets[rocket.class]
		-- It's an export rocket, abort!
		or rocket.name:sub(-6) == "Export"
	then
		return
	end

	CreateGameTimeThread(function()
		-- needs a delay or CTD
		WaitMsg("OnRender")

		if rocket.allow_export then
			rocket:ToggleAllowExport()
		end
	end)
end

OnMsg.BuildingInit = TurnOffRares
OnMsg.RocketLandAttempt = TurnOffRares
