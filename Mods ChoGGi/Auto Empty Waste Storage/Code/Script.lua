-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 61
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Auto Empty Waste Storage requires ChoGGi's Library (at least v" .. min_version .. [[).
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

AutoEmptyWasteStorage = {
  Enabled = true,
  Which = 1
}
local AutoEmptyWasteStorage = AutoEmptyWasteStorage

local function EmptyAll()
	local objs = UICity.labels.WasteRockDumpSite or ""
	for i = 1, #objs do
		objs[i]:CheatEmpty()
  end
end

function OnMsg.NewDay()
  if AutoEmptyWasteStorage.Enabled and AutoEmptyWasteStorage.Which == 1 then
    EmptyAll()
  end
end

function OnMsg.NewHour()
  if AutoEmptyWasteStorage.Enabled and AutoEmptyWasteStorage.Which == 2 then
    EmptyAll()
  end
end

function OnMsg.ClassesBuilt()

	ChoGGi.ComFuncs.AddXTemplate("AutoEmptyWasteStorage_customWasteRockDumpBig1","customWasteRockDumpBig",{
		__context_of_kind = "WasteRockDumpSite",
		Icon = "UI/Icons/Upgrades/build_2.tga",
		RolloverTitle = [[Auto Empty]],
		OnContextUpdate = function(self, context)
			---
			if AutoEmptyWasteStorage.Enabled then
				self:SetRolloverText([[Will empty all waste rock sites.]])
				self:SetTitle([[Enabled Auto Empty]])
				self:SetIcon("UI/Icons/traits_approve.tga")
			else
				self:SetRolloverText([[Will not empty waste rock sites.]])
				self:SetTitle([[Disabled Auto Empty]])
				self:SetIcon("UI/Icons/traits_disapprove.tga")
			end
			---
		end,
		func = function(self, context)
				---
				AutoEmptyWasteStorage.Enabled = not AutoEmptyWasteStorage.Enabled
--~ 				print(AutoEmptyWasteStorage.Enabled)
				---
				ObjModified(context)
		end,
	})

	ChoGGi.ComFuncs.AddXTemplate("AutoEmptyWasteStorage_customWasteRockDumpBig2","customWasteRockDumpBig",{
		__context_of_kind = "WasteRockDumpSite",
		Icon = "UI/Icons/Upgrades/build_2.tga",
		RolloverTitle = [[Auto Empty]],
		OnContextUpdate = function(self, context)
			---
			if AutoEmptyWasteStorage.Which == 1 then
				self:SetRolloverText([[Will empty all waste rock sites every Sol.]])
				self:SetTitle([[Daily Empty]])
				self:SetIcon("UI/Icons/traits_random_approve.tga")
			else
				self:SetRolloverText([[Will empty all waste rock sites every in-game Hour.]])
				self:SetTitle([[Hourly Empty]])
				self:SetIcon("UI/Icons/traits_random_disapprove.tga")
			end
			---
		end,
		func = function(self, context)
				---
				if AutoEmptyWasteStorage.Which == 1 then
					AutoEmptyWasteStorage.Which = 2
				else
					AutoEmptyWasteStorage.Which = 1
				end
--~ 				print(AutoEmptyWasteStorage.Which)
				---
				ObjModified(context)
		end,
	})

end
