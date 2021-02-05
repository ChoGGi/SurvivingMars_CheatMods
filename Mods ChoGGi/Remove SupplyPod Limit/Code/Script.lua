-- See LICENSE for terms (one-liner mods show an error in the log after being packed in an hpk archive)

LaunchModeCargoExceeded = empty_func

-- override the drone spawning part of the func
local orig_SupplyPod_Unload = SupplyPod.Unload
function SupplyPod:Unload(...)
	-- get drone cargo item
	local cargo = table.find(self.cargo, "class", "Drone")
	cargo = self.cargo[cargo]

	-- there's 10 drone spots for pods, if over than it'll skip the rest (orig func)
	if cargo.amount > 10 then
		local PlaceObject = PlaceObject
		local first, last = self:GetSpotRange("Drone")
		local city = self.city
		local Random = city.Random
		for i = 1, cargo.amount do
			local pos, angle = self:GetSpotLoc(Random(city, first, last))
			local obj = PlaceObject(cargo.class, {city = city, is_orphan = true})
			obj:SetPos(pos)
			obj:SetAngle(angle)
		end

		-- stop orig func from spawning any drones
		cargo.amount = 0
	end

	return orig_SupplyPod_Unload(self, ...)
end
