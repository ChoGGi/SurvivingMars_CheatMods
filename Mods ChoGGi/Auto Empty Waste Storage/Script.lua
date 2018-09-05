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


local function RemoveXTemplateSections(list,name)
	local idx = table.find(list, name, true)
	if idx then
		table.remove(list,idx)
	end
end

function OnMsg.ClassesBuilt()

	RemoveXTemplateSections(XTemplates.customWasteRockDumpBig[1],"AutoEmptyWasteStorage_customWasteRockDumpBig1")
	XTemplates.customWasteRockDumpBig[1][#XTemplates.customWasteRockDumpBig[1]+1] = PlaceObj("XTemplateTemplate", {
		"AutoEmptyWasteStorage_customWasteRockDumpBig1", true,
		"__context_of_kind", "WasteRockDumpSite",
		"__template", "InfopanelSection",
		"Icon", "",
		"Title", "",
		"RolloverText", "",
		"RolloverTitle", [[Auto Empty]],
		"RolloverHint",  "",
		"OnContextUpdate", function(self, context)
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
	}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnActivate(self, context)",
			"parent", function(parent, context)
				return parent.parent
			end,
			"func", function(self, context)
				---
				AutoEmptyWasteStorage.Enabled = not AutoEmptyWasteStorage.Enabled
				print(AutoEmptyWasteStorage.Enabled)
				---
				ObjModified(context)
			end
		})
	})

	RemoveXTemplateSections(XTemplates.customWasteRockDumpBig[1],"AutoEmptyWasteStorage_customWasteRockDumpBig2")
	XTemplates.customWasteRockDumpBig[1][#XTemplates.customWasteRockDumpBig[1]+1] = PlaceObj("XTemplateTemplate", {
		"AutoEmptyWasteStorage_customWasteRockDumpBig2", true,
		"__context_of_kind", "WasteRockDumpSite",
		"__template", "InfopanelSection",
		"Icon", "",
		"Title", "",
		"RolloverText", "",
		"RolloverTitle", [[Auto Empty]],
		"RolloverHint",  "",
		"OnContextUpdate", function(self, context)
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
	}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnActivate(self, context)",
			"parent", function(parent, context)
				return parent.parent
			end,
			"func", function(self, context)
				---
				if AutoEmptyWasteStorage.Which == 1 then
					AutoEmptyWasteStorage.Which = 2
				else
					AutoEmptyWasteStorage.Which = 1
				end
				print(AutoEmptyWasteStorage.Which)
				---
				ObjModified(context)
			end
		})
	})
end
