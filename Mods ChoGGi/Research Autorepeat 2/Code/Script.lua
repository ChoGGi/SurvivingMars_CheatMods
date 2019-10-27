-- See LICENSE for terms

function OnMsg.TechResearched(tech_id, city)
	-- fires on new game
	if not GameState.gameplay then
--~ 	if GameTime() == 0 then
		return
	end

	local TechDef = TechDef

	if TechDef[tech_id].repeatable then
		if #city.research_queue == 0 then
			city:QueueResearch(tech_id)
		end
		local q = city.research_queue
		if #q == 1 and q[1] == tech_id then
			-- Either we just added one, or there was already one. Either way we want to add another
			-- so that there's always still one in the queue when it completes, to avoid the 'no
			-- active research' notification
			city:QueueResearch(tech_id)
		end
	else
		local q = city.research_queue
		if #q == 1 and TechDef[q[1]].repeatable then
			-- We just completed some normal research, leaving only a single repeatable research in
			-- the queue. Add it again in order to avoid the 'no active research' notification when
			-- it ends the first time
			city:QueueResearch(q[1])
		end
	end

end
