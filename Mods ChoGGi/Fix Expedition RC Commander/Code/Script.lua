-- See LICENSE for terms

local MapGet = MapGet
local ipairs = ipairs
local ObjModified = ObjModified
local Sleep = Sleep

function RocketExpedition:ExpeditionLoadRover(class)
	local rover
	while not self.expedition.rover do
--~ 		local list = MapGet("map", class, function(o, class) return o.class == class end, class) or empty_table
		-- not sure what's up with the " or empty_table" since MapGet always returns a table?
		local list = MapGet("map", class) or empty_table
		local dist
		for _, unit in ipairs(list) do
			if unit:CanBeControlled() and unit.command == "Idle" then
				local d = self:GetDist2D(unit)
				if not dist or d < dist then
					rover, dist = unit, d
				end
			end
		end

		if rover then
			self.rover_summon_fail = nil
			ObjModified(self)

			if rover == SelectedObj then
				SelectObj()
			end
			self.expedition.rover = rover
			rover:SetHolder(self)
			rover:SetCommand("Disappear", "keep in holder")
		else
			self.rover_summon_fail = true
			ObjModified(self)
			Sleep(1000)
		end
	end
	ObjModified(self)
end