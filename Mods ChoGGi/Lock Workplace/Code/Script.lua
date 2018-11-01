-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 29
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Lock Workplace requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local RetName = ChoGGi.ComFuncs.RetName

	local function LoopWorkplace(context,which)
		for i = 1, #context.workers do
			for j = 1, #context.workers[i] do
				context.workers[i][j].ChoGGi_Lockworkplace = which
			end
		end
	end

	-- make the value the below buttons set actually do something
	local orig_Colonist_SetWorkplace = Colonist.SetWorkplace
	function Colonist:SetWorkplace(building, shift)
		if building and self.ChoGGi_Lockworkplace then
			return
		end
		-- we only fire the func if the lock isn't there, yeah i'm sure this won't cause any issues :)
		return orig_Colonist_SetWorkplace(self, building, shift)
	end

	function OnMsg.ClassesBuilt()

		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipColonist[1],"ChoGGi_LockworkplaceColonist")
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.sectionWorkplace[1],"ChoGGi_LockworkplaceWorkplace")

		-- add button to colonists
		ChoGGi.ComFuncs.AddXTemplate("LockworkplaceColonist","ipColonist",{
			__context_of_kind = "Colonist",
			OnContextUpdate = function(self, context)
				---
				-- hide button if not working, and make sure to remove the lock (just in case)
				if context.workplace and not context.workplace:IsKindOf("TrainingBuilding") then
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

		ChoGGi.ComFuncs.AddXTemplate("LockworkplaceWorkplace","sectionWorkplace",{
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

end
