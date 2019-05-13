-- See LICENSE for terms

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

local function CleanUp()
	if AutoEmptyWasteStorage.Enabled and AutoEmptyWasteStorage.Which == 1 then
		EmptyAll()
	end
end

OnMsg.NewDay = CleanUp
OnMsg.NewHour = CleanUp

function OnMsg.ClassesBuilt()

	ChoGGi.ComFuncs.AddXTemplate("AutoEmptyWasteStorage_customWasteRockDumpBig1", "customWasteRockDumpBig", {
		__context_of_kind = "WasteRockDumpSite",
		Icon = "UI/Icons/Upgrades/build_2.tga",
		RolloverTitle = [[Auto Empty]],
		OnContextUpdate = function(self)
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
		func = function(_, context)
				---
				AutoEmptyWasteStorage.Enabled = not AutoEmptyWasteStorage.Enabled
--~ 				print(AutoEmptyWasteStorage.Enabled)
				---
				ObjModified(context)
		end,
	})

	ChoGGi.ComFuncs.AddXTemplate("AutoEmptyWasteStorage_customWasteRockDumpBig2", "customWasteRockDumpBig", {
		__context_of_kind = "WasteRockDumpSite",
		Icon = "UI/Icons/Upgrades/build_2.tga",
		RolloverTitle = [[Auto Empty]],
		OnContextUpdate = function(self)
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
		func = function(_, context)
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
