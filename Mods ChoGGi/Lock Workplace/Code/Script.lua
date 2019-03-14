-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 60
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Lock Workplace requires ChoGGi's Library (at least v" .. min_version .. [[).
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
LockWorkplace = {
	NeverChange = false,
}

-- make the value the below buttons set actually do something
local orig_Colonist_SetWorkplace = Colonist.SetWorkplace
function Colonist:SetWorkplace(building, shift, ...)
	if self.ChoGGi_Lockworkplace and (building or LockWorkplace.NeverChange) then
		return
	end
	-- we only fire the func if the lock isn't there, yeah i'm sure this won't cause any issues :)
	return orig_Colonist_SetWorkplace(self, building, shift, ...)
end

function OnMsg.ClassesBuilt()
	local IsValid = IsValid
	local ObjModified = ObjModified
	local RetName = ChoGGi.ComFuncs.RetName

	local function LoopWorkplace(context,which)
		for i = 1, #context.workers do
			local workers = context.workers[i]
			for j = 1, #workers do
				workers[j].ChoGGi_Lockworkplace = which
			end
		end
	end

	-- add button to colonists
	ChoGGi.ComFuncs.AddXTemplate(XTemplates.ipColonist[1],"LockworkplaceColonist",nil,{
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
				self:SetRolloverText([[Remove the lock on this colonist.]])
				self:SetTitle([[Unlock Workplace]])
				self:SetIcon("UI/Icons/traits_approve.tga")
			else
				self:SetRolloverText(string.format([[Lock this colonist to always work at %s.]],RetName(context.workplace)))
				self:SetTitle([[Lock Workplace]])
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

	ChoGGi.ComFuncs.AddXTemplate(XTemplates.sectionWorkplace,"LockworkplaceWorkplace",nil,{
		__context_of_kind = "Workplace",
		OnContextUpdate = function(self, context)
			---
			if context.ChoGGi_Lockworkplace then
				self:SetRolloverText([[Remove the lock on this workplace.]])
				self:SetTitle([[Unlock Workers]])
				self:SetIcon("UI/Icons/traits_approve.tga")
			else
				self:SetRolloverText([[Lock all workers to this workplace (if more workers are added you'll need to toggle this or lock each of them).]])
				self:SetTitle([[Lock Workers]])
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
				LoopWorkplace(context,true)
			end
			ObjModified(context)
			---
		end,
	})
end
