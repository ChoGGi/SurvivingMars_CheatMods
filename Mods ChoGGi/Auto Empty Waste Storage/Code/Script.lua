-- See LICENSE for terms

-- tell people know how to get the library
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true
	local min_version = 23

	local ModsLoaded = ModsLoaded
	-- we need a version check to remind Nexus/GoG users
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		-- steam updates automatically
		if not Platform.steam and min_version > ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(2500)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: Auto Empty Waste Storage requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
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
