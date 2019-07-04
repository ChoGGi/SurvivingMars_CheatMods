-- See LICENSE for terms

local options
local mod_GlobalDomeCount
local mod_RespectIncubator
local mod_BypassNoNurseries
local mod_UltimateNursery

-- fired when settings are changed/init
local function ModOptions()
	mod_GlobalDomeCount = options.GlobalDomeCount
	mod_RespectIncubator = options.RespectIncubator
	mod_BypassNoNurseries = options.BypassNoNurseries
	mod_UltimateNursery = options.UltimateNursery
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_NurseryLimitBirthingToSpots" then
		return
	end

	ModOptions()
end

local Max = Max

local orig_SpawnChild = Dome.SpawnChild
function Dome:SpawnChild(...)
	-- hi Ski
	if mod_RespectIncubator and self.IncubatorReloc then
		return orig_SpawnChild(self, ...)
	end

	local class = mod_UltimateNursery and "UltimateNursery" or "Nursery"

	local objs_g = (self.city or UICity).labels[class]
	local objs

	-- not global so use dome count
	if mod_GlobalDomeCount then
		objs = objs_g
	else
		objs = self.labels[class]
	end

	-- no nursery so abort
	if not objs then
		-- if there's no nurseries at all and then send back orig func
		if not objs_g and mod_BypassNoNurseries then
			return orig_SpawnChild(self, ...)
		end
		return
	end

	-- cut down copy of function Dome:GetFreeLivingSpace()
	local used = 0
	local capacity = 0
	for i = 1, #objs do
		local obj = objs[i]
		if not obj.destroyed then
			capacity = capacity + (obj.capacity - obj.closed)
			used = used + (#obj.colonists + #obj.reserved)
		end
	end
	local free_space = Max(0, capacity - used)

--~ 	print(free_space,ChoGGi.ComFuncs.RetName(self))

	-- fire up the babby factory
	if free_space > 0 then
		return orig_SpawnChild(self, ...)
	end
end
