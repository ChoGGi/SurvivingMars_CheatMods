-- See LICENSE for terms

local ValidateBuilding = ValidateBuilding
local ObjModified = ObjModified
local RetName = ChoGGi_Funcs.Common.RetName

local mod_NeverChange
local mod_SeniorsOverride

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_NeverChange = CurrentModOptions:GetProperty("NeverChange")
	mod_SeniorsOverride = CurrentModOptions:GetProperty("SeniorsOverride")

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Make the value the below buttons set actually do something
local ChoOrig_Colonist_CheckForcedWorkplace = Colonist.CheckForcedWorkplace
function Colonist:CheckForcedWorkplace(...)
	local workplace = self.workplace

	if mod_SeniorsOverride and self.age_trait ~= "Senior" then
		if ValidateBuilding(workplace)
			and (mod_NeverChange or self.ChoGGi_Lockworkplace)
		then

			-- if it isn't forced yet then force it.
			local current_shift, time
			if not self.user_forced_workplace then
				-- lua rev 1011166
				-- function Workplace:ColonistInteract(col)
				if workplace.active_shift == 0 then
					current_shift = CurrentWorkshift --should be the shift @ click moment
					for i = 1, 3 do
						if workplace:HasFreeWorkSlots(current_shift) then
							break
						end
						current_shift = current_shift + 1
						current_shift = current_shift > 3 and current_shift % 3 or current_shift
					end
				else
					current_shift = workplace.active_shift
				end
				col.user_forced_workplace = {workplace, current_shift, GameTime()}
			else
				workplace, current_shift, time = table.unpack(self.user_forced_workplace)
			end

			-- lua rev 1011166
			-- function Colonist:CheckForcedWorkplace()
			local dome = self:CheckForcedDome() or self.dome
			local service_dome = workplace:CheckServicedDome(dome)
			if AreDomesConnected(service_dome, dome) then
				local remaining_time = time or const.Scale.sols -- or whatever
				return workplace, current_shift, remaining_time
			end

		end
	end

	return ChoOrig_Colonist_CheckForcedWorkplace(self, ...)
end

local function LoopWorkplace(context, which)
	for i = 1, #(context and context.workers or "") do
		local workers = context.workers[i]
		for j = 1, #workers do
			workers[j].ChoGGi_Lockworkplace = which
		end
	end
end

function OnMsg.ClassesPostprocess()

	-- add button to colonists
	ChoGGi_Funcs.Common.AddXTemplate(XTemplates.ipColonist[1], "LockworkplaceColonist", nil, {
		__context_of_kind = "Colonist",
		OnContextUpdate = function(self, context)
			---
			-- hide button if not working, and make sure to remove the lock (just in case)
			if ValidateBuilding(context.workplace) and not context.workplace:IsKindOf("TrainingBuilding") then
				self:SetVisible(true)
				self:SetMaxHeight()
			else
				self:SetMaxHeight(0)
				self:SetVisible()
				context.ChoGGi_Lockworkplace = nil
			end

			if context.ChoGGi_Lockworkplace then
				self:SetRolloverText(T(302535920011097, "Remove the lock on this colonist."))
				self:SetTitle(T(302535920011098, "Unlock Workplace"))
				self:SetIcon("UI/Icons/traits_approve.tga")
			else
				self:SetRolloverText(T{302535920011099, "Lock this colonist to always work at <name>.", name = RetName(context.workplace)})
				self:SetTitle(T(302535920011100, "Lock Workplace"))
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			end
			---
		end,
		func = function(self, context)
			---
			if context.ChoGGi_Lockworkplace then
				context.ChoGGi_Lockworkplace = nil
			else
				context.ChoGGi_Lockworkplace = true
			end
			ObjModified(context)
			---
		end,
	})

	ChoGGi_Funcs.Common.AddXTemplate(XTemplates.sectionWorkplace, "LockworkplaceWorkplace", nil, {
		__context_of_kind = "Workplace",
		OnContextUpdate = function(self, context)
			---
			if context.ChoGGi_Lockworkplace then
				self:SetRolloverText(T(302535920011101, "Remove the lock on this workplace."))
				self:SetTitle(T(302535920011102, "Unlock Workers"))
				self:SetIcon("UI/Icons/traits_approve.tga")
			else
				self:SetRolloverText(T(302535920011103, "Lock all workers to this workplace (if more workers are added you'll need to toggle this or lock each of them)."))
				self:SetTitle(T(302535920011104, "Lock Workers"))
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			end
			---
		end,
		func = function(self, context)
			---
			if context.ChoGGi_Lockworkplace then
				context.ChoGGi_Lockworkplace = nil
				LoopWorkplace(context)
			else
				context.ChoGGi_Lockworkplace = true
				LoopWorkplace(context, true)
			end
			ObjModified(context)
			---
		end,
	})
end
