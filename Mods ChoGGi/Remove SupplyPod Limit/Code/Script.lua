-- See LICENSE for terms

local CreateGameTimeThread = CreateGameTimeThread
local PlaceObjectIn = PlaceObjectIn
local GetRandomPassableAround = GetRandomPassableAround

LaunchModeCargoExceeded = empty_func

local rovers = {
	RCRover = true,
	RCSensor = true,
	RCSolar = true,
	ExplorerRover = true,
	RCTransport = true,
	RCConstructor = true,
	RCHarvester = true,
	RCSafari = true,
	RCDriller = true,
	RCTerraformer = true,
}

local function OverrideUnload(func, self, ...)
  local map_id = self:GetMapID() or ActiveMapID

	-- get drone cargo item
	local cargo = self.cargo[table.find(self.cargo, "class", "Drone")]
	-- there's 10 drone spots for pods, if over than it'll skip the rest (orig func)
	if cargo and cargo.amount > 10 then
		local first, last = self:GetSpotRange("Drone")
		local city = self.city
		for _ = 1, cargo.amount do
			local pos, angle = self:GetSpotLoc(city.Random(city, first, last))
			local obj = PlaceObjectIn(cargo.class, map_id, {
				city = city,
				is_orphan = true
			})
			obj:SetPos(GetRandomPassableAround(pos, 5000, 1000, city))
			obj:SetAngle(angle)
		end

		-- stop orig func from spawning any drones
		cargo.amount = 0
	end

	-- rovers
	for i = 1, #(self.cargo or "") do
		cargo = self.cargo[i]
		if cargo and rovers[cargo.class] then
			local amt = cargo.amount
			if amt > 1 then
				for _ = 1, amt-1 do
					local pos, angle = self:GetSpotLoc(self:GetSpotBeginIndex("Rover"))
					local obj = PlaceObjectIn(cargo.class, map_id, {
						city = self.city
					})
					obj:SetPos(pos)
					obj:SetAngle(angle)
					CreateGameTimeThread(function()
						obj:SetCommand("Goto_NoDestlock", GetRandomPassableAround(pos, 2000, 500, city))
					end)
				end
			end

		end
	end

	return func(self, ...)
end


-- override the drone spawning part of the func
local ChoOrig_SupplyPod_Unload = SupplyPod.Unload
function SupplyPod:Unload(...)
	return OverrideUnload(ChoOrig_SupplyPod_Unload, self, ...)
end
local ChoOrig_RocketBase_Unload = RocketBase.Unload
function RocketBase:Unload(...)
	return OverrideUnload(ChoOrig_RocketBase_Unload, self, ...)
end

local function StartupCode()
	local max_int = max_int
	local defs = ResupplyItemDefinitions
	for i = 1, #defs do
		defs[i].max = max_int
	end
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
