-- See LICENSE for terms

local ValidateBuilding = ValidateBuilding
local ObjModified = ObjModified
local RetName = ChoGGi_Funcs.Common.RetName

local function LoopResidence(context, which)
	for i = 1, #context.colonists do
		context.colonists[i].ChoGGi_LockResidence = which
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
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- make the value the below buttons set actually do something
local ChoOrig_Colonist_SetResidence = Colonist.SetResidence
function Colonist:SetResidence(...)
	if ValidateBuilding(self.residence)
		and (mod_NeverChange or self.ChoGGi_LockResidence)
	then
		return
	end
	-- we only fire the func if the lock isn't there, yeah i'm sure this won't cause any issues :)
	return ChoOrig_Colonist_SetResidence(self, ...)
end

function OnMsg.ClassesPostprocess()

	-- add button to colonists
	ChoGGi_Funcs.Common.AddXTemplate(XTemplates.ipColonist[1], "LockResidenceColonist", nil, {
		__context_of_kind = "Colonist",
		OnContextUpdate = function(self, context)
			--
			-- hide button if not working, and make sure to remove the lock (just in case)
			if ValidateBuilding(context.residence) then
				self:SetVisible(true)
				self:SetMaxHeight()
			else
				self:SetMaxHeight(0)
				self:SetVisible()
				context.ChoGGi_LockResidence = nil
			end

			if context.ChoGGi_LockResidence then
				self:SetRolloverText(T(302535920011088, [[Remove the lock on this colonist.]]))
				self:SetTitle(T(302535920011089, [[Unlock Residence]]))
				self:SetIcon("UI/Icons/traits_approve.tga")
			else
				self:SetRolloverText(T{302535920011090, [[Lock this colonist to always live at <name>.]], name = RetName(context.residence)})
				self:SetTitle(T(30253592001191, [[Lock Residence]]))
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			end
			--
		end,
		func = function(self, context)
			--
			if context.ChoGGi_LockResidence then
				context.ChoGGi_LockResidence = nil
			else
				context.ChoGGi_LockResidence = true
			end
			ObjModified(context)
			--
		end,
	})

	ChoGGi_Funcs.Common.AddXTemplate(XTemplates.sectionResidence, "LockResidenceResidence", nil, {
		__context_of_kind = "Residence",
		OnContextUpdate = function(self, context)
			--
			if context.ChoGGi_LockResidence then
				self:SetRolloverText(T(302535920011092, [[Remove the lock on this residence.]]))
				self:SetTitle(T(302535920011093, [[Unlock Residents]]))
				self:SetIcon("UI/Icons/traits_approve.tga")
			else
				self:SetRolloverText(T(302535920011094, [[Lock all residents to this residence (if more residents are added you'll need to toggle this or lock each of them).]]))
				self:SetTitle(T(302535920011095, [[Lock Residents]]))
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			end
			--
		end,
		func = function(self, context)
			--
			if context.ChoGGi_LockResidence then
				context.ChoGGi_LockResidence = nil
				LoopResidence(context)
			else
				context.ChoGGi_LockResidence = true
				LoopResidence(context, true)
			end
			ObjModified(context)
			--
		end,
	})
end
