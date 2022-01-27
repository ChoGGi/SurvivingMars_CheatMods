-- See LICENSE for terms

local Max = Max
local GetRealm = GetRealm

local mod_GlobalDomeCount
local mod_BypassNoNurseries

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_GlobalDomeCount = CurrentModOptions:GetProperty("GlobalDomeCount")
	mod_BypassNoNurseries = CurrentModOptions:GetProperty("BypassNoNurseries")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_SpawnChild = Community.SpawnChild
function Community:SpawnChild(...)
	-- hi Ski
	if self.IncubatorReloc then
		return ChoOrig_SpawnChild(self, ...)
	end

	local objs

	-- check all nurseries or per-dome
	if mod_GlobalDomeCount then
		objs = GetRealm(self):MapGet("map", "Nursery")
	else
		objs = GetRealm(self):MapGet("map", "Nursery", function(obj)
			if obj.parent_dome == self then
				return true
			end
		end)
	end

	local objs_count = #objs

	-- no nursery so abort
	if objs_count == 0 then
		-- If there's no nurseries then send back orig func so births still work
		if mod_BypassNoNurseries then
			return ChoOrig_SpawnChild(self, ...)
		end
		return
	end

	-- cut down copy of function Dome:GetFreeLivingSpace()
	local used = 0
	local capacity = 0
	for i = 1, objs_count do
		local obj = objs[i]
		if not obj.destroyed then
			capacity = capacity + (obj.capacity - obj.closed)
			used = used + (#obj.colonists + #obj.reserved)
		end
	end
	local free_space = Max(0, capacity - used)

	-- fire up the babby factory
	if free_space > 0 then
		return ChoOrig_SpawnChild(self, ...)
	end
end
