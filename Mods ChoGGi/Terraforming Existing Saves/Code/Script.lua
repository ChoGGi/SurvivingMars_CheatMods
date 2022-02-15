-- See LICENSE for terms

if not g_AvailableDlc.armstrong then
	print(CurrentModDef.title, ": Green Planet DLC not installed!")
	return
end

local function RestoreMissingTableValues(old,new)
	for key, value in pairs(old) do
		if not new[key] then
			new[key] = value
		end
	end
end

function OnMsg.LoadGame()
	-- we need a slight delay before checking g_NoTerraforming
	CreateRealTimeThread(function()

		-- enabled already
		if g_NoTerraforming == false or IsGameRuleActive("NoTerraforming") then
			return
		end
		g_NoTerraforming = false

		local UICity = UICity
		local UIColony = UIColony

		-- backup some tables before we call InitResearch
		local research_queue = UIColony.research_queue
		local tech_status = UIColony.tech_status
		local tech_field = UIColony.tech_field
		local TechBoostPerField = UIColony.TechBoostPerField
		local TechBoostPerTech = UIColony.TechBoostPerTech
		local OutsourceResearchPoints = UIColony.OutsourceResearchPoints
		local OutsourceResearchOrders = UIColony.OutsourceResearchOrders

		-- we want this func to just return the new field so it skips the other ones
		local ChoOrig_GetAvailablePresets = GetAvailablePresets
		function GetAvailablePresets()
			return {TechFields.Terraforming}
		end

		UIColony:InitResearch()

		-- restore old func
		GetAvailablePresets = ChoOrig_GetAvailablePresets

		-- and restore tables
		UIColony.research_queue = research_queue
		UIColony.OutsourceResearchPoints = OutsourceResearchPoints
		UIColony.OutsourceResearchOrders = OutsourceResearchOrders

		RestoreMissingTableValues(tech_status, UIColony.tech_status)
		RestoreMissingTableValues(tech_field, UIColony.tech_field)
		RestoreMissingTableValues(TechBoostPerField, UIColony.TechBoostPerField)
		RestoreMissingTableValues(TechBoostPerTech, UIColony.TechBoostPerTech)

		-- City:GameInitResearch copy pasta
		-- we're already in a thread, but since it's a realtime one there might be some issues so gametime it is
		local thread = CreateGameTimeThread(function()
			local TechDef = TechDef
			for id, status in pairs(UIColony.tech_status) do
				if status.field == "Terraforming" then
					TechDef[id]:EffectsInit(UICity)
				end
			end
		end)
		-- can't hurt to wait till it's done
		local IsValidThread = IsValidThread
		local WaitMsg = WaitMsg
		while IsValidThread(thread) do
			WaitMsg("OnRender")
		end

		-- update StorableResources etc (shuttles ignoring seed depots, thanks LukeH)
		BuildStorableResourcesArray()
		local supply_queues = LRManagerInstance.supply_queues
		local demand_queues = LRManagerInstance.demand_queues
		local StorableResources = StorableResources
		for i = 1, #StorableResources do
			local resource = StorableResources[i]
			if not supply_queues[resource] then
				supply_queues[resource] = {}
			end
			if not demand_queues[resource] then
				demand_queues[resource] = {}
			end
		end

		-- update infobar to show the extra info
		local infobar = GetDialog("Infobar")
		if infobar then
			infobar:Close()
			UpdateInfobarVisibility(true)
		end

		-- rain disasters
		local RainsDisasterThreads = RainsDisasterThreads
		local RainsDisasters = DataInstances.MapSettings_RainsDisaster
		for i = 1, #RainsDisasters do
			local settings = RainsDisasters[i]
			local rain_type = settings.type
			if not RainsDisasterThreads[rain_type] then
				RainsDisasterThreads[rain_type] = {
					name = settings.name,
					last_name = false,
					activation_thread = false,
					main_thread = false,
					soil_thread = false
				}
			end
		end

		-- rocket cargo
		RocketPayload_Init()

		-- time series (ccc)
		SavegameFixups.InitTSTerraforming()
		SavegameFixups.RestartAtmosphereDecayThread()
		-- can't hurt?
		SavegameFixups.StopInfiniteRains()

		-- make sure any existing rockets have seed funcs (pods seem fine without this)
		local rockets = UICity.labels.SupplyRocket or ""
		for i = 1, #rockets do
			local r = rockets[i]
			if r.demand and not r.demand.Seeds then
				if r.resource then
					if not table.find(r.resource,"Seeds") then
						r.resource[#r.resource+1] = "Seeds"
					end
				end
				-- eeeh, I'm lazy
				if type(r.task_requests) == "table" then
					table.iclear(r.task_requests)
				end
				r:CreateResourceRequests()
			end
		end

		-- show terraform intro msg
		local id = "TerraformingIntro"
		AddOnScreenNotification(id)

		WaitMsg("OnRender")
		-- for some reason it doesn't get added to g_ActiveOnScreenNotifications (so dismiss don't work)
		local aosn = g_ActiveOnScreenNotifications
		local idx = table.find(aosn, 1, id)
		if not idx then
			aosn[#aosn+1] = {
				[1] = id,
				[3] = {preset_id = id},
				n = 3,
			}
		end


	end)
end
