-- See LICENSE for terms

local IsValid = IsValid
local ObjModified = ObjModified
local RetName = ChoGGi.ComFuncs.RetName

local function LoopWorkplace(context, which)
	for i = 1, #context.workers do
		local workers = context.workers[i]
		for j = 1, #workers do
			workers[j].ChoGGi_Lockworkplace = which
		end
	end
end

local mod_NeverChange

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_NeverChange = CurrentModOptions:GetProperty("NeverChange")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- make the value the below buttons set actually do something
local ChoOrig_Colonist_SetWorkplace = Colonist.SetWorkplace
function Colonist:SetWorkplace(building, ...)
	if self.ChoGGi_Lockworkplace and (building or mod_NeverChange) then
		-- single shift building (farm) == crash
		-- active_shift > 0 ~= single shift
		if building and building.active_shift == 0 then
			return
		end
	end
	-- we only fire the func if the lock isn't there, yeah i'm sure this won't cause any issues :)
	return ChoOrig_Colonist_SetWorkplace(self, building, ...)
end

function OnMsg.ClassesPostprocess()

	-- add button to colonists
	ChoGGi.ComFuncs.AddXTemplate(XTemplates.ipColonist[1], "LockworkplaceColonist", nil, {
		__context_of_kind = "Colonist",
		OnContextUpdate = function(self, context)
			---
			-- hide button if not working, and make sure to remove the lock (just in case)
			if IsValid(context.workplace) and not context.workplace:IsKindOf("TrainingBuilding") then
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

	ChoGGi.ComFuncs.AddXTemplate(XTemplates.sectionWorkplace, "LockworkplaceWorkplace", nil, {
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
