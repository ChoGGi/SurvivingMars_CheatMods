-- See LICENSE for terms

function School:OnTrainingCompleted(unit)
	local chance = unit.training_points and unit.training_points[self.training_type] or 0
	local rand = self:Random(150)
	if rand<=chance then
		local traits = {}
		for i=1, self.max_traits do
			traits[#traits+1] = self["trait"..i]
		end
		local compatible = FilterCompatibleTraitsWith(traits, unit.traits)
		if #compatible>0 then

			-- remove any perks already attained from compatible list
			for i = #compatible, 1, -1 do
				if unit.traits[compatible[i]] then
					table.remove(compatible, i)
				end
			end
			-- remove any perks already attained from compatible list

			-- and check again just in case...
			if #compatible>0 then
				unit:AddTrait(table.rand(compatible))
			end
		end
	end
	if unit.training_points then
		unit.training_points[self.training_type] = nil
		if not next(unit.training_points) then
			unit.training_points = false
		end
	end
end
