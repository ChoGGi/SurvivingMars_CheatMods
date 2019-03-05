-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 57
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Lock Residence requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

-- put this in script or change load order in metadata
LockResidence = {
	NeverChange = false,
}

-- make the value the below buttons set actually do something
local orig_Colonist_SetResidence = Colonist.SetResidence
function Colonist:SetResidence(home, ...)
	if self.ChoGGi_LockResidence and (home or LockResidence.NeverChange) then
		return
	end
	-- we only fire the func if the lock isn't there, yeah i'm sure this won't cause any issues :)
	return orig_Colonist_SetResidence(self, home, ...)
end

function OnMsg.ClassesBuilt()
	local IsValid = IsValid
	local ObjModified = ObjModified

	local RetName = ChoGGi.ComFuncs.RetName

	local function LoopResidence(context,which)
		for i = 1, #context.colonists do
			context.colonists[i].ChoGGi_LockResidence = which
		end
	end

	-- add button to colonists
	ChoGGi.ComFuncs.AddXTemplate(XTemplates.ipColonist[1],"LockResidenceColonist",nil,{
		__context_of_kind = "Colonist",
		OnContextUpdate = function(self, context)
			---
			-- hide button if not working, and make sure to remove the lock (just in case)
			if IsValid(context.residence) then
				self:SetVisible(true)
				self:SetMaxHeight()
			else
				self:SetMaxHeight(0)
				self:SetVisible()
				context.ChoGGi_LockResidence = nil
			end

			if context.ChoGGi_LockResidence then
				self:SetRolloverText([[Remove the lock on this colonist.]])
				self:SetTitle([[Unlock Residence]])
				self:SetIcon("UI/Icons/traits_approve.tga")
			else
				self:SetRolloverText(string.format([[Lock this colonist to always live at %s.]],RetName(context.residence)))
				self:SetTitle([[Lock Residence]])
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			end
			---
		end,
		func = function(self, context)
			---
			if context.ChoGGi_LockResidence then
				context.ChoGGi_LockResidence = nil
			else
				context.ChoGGi_LockResidence = true
			end
			ObjModified(context)
			---
		end,
	})

	ChoGGi.ComFuncs.AddXTemplate(XTemplates.sectionResidence,"LockResidenceResidence",nil,{
		__context_of_kind = "Residence",
		OnContextUpdate = function(self, context)
			---
			if context.ChoGGi_LockResidence then
				self:SetRolloverText([[Remove the lock on this residence.]])
				self:SetTitle([[Unlock Residents]])
				self:SetIcon("UI/Icons/traits_approve.tga")
			else
				self:SetRolloverText([[Lock all residents to this residence (if more residents are added you'll need to toggle this or lock each of them).]])
				self:SetTitle([[Lock Residents]])
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			end
			---
		end,
		func = function(self, context)
			---
			if context.ChoGGi_LockResidence then
				context.ChoGGi_LockResidence = nil
				LoopResidence(context)
			else
				context.ChoGGi_LockResidence = true
				LoopResidence(context,true)
			end
			ObjModified(context)
			---
		end,
	})
end
