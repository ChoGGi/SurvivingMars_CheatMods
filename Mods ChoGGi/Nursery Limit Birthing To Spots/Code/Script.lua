-- See LICENSE for terms

local Max = Max
local MapGet = MapGet

local mod_GlobalDomeCount
local mod_BypassNoNurseries

-- fired when settings are changed/init
local function ModOptions()
	mod_GlobalDomeCount = CurrentModOptions:GetProperty("GlobalDomeCount")
	mod_BypassNoNurseries = CurrentModOptions:GetProperty("BypassNoNurseries")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local orig_SpawnChild = Dome.SpawnChild
function Dome:SpawnChild(...)
	-- hi Ski
	if self.IncubatorReloc then
		return orig_SpawnChild(self, ...)
	end

	local objs

	-- check all nurseries or per-dome
	if mod_GlobalDomeCount then
		objs = MapGet("map", "Nursery")
	else
		objs = MapGet("map", "Nursery", function(obj)
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
			return orig_SpawnChild(self, ...)
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
		return orig_SpawnChild(self, ...)
	end
end
