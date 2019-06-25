-- See LICENSE for terms

local options
local mod_Default10

-- fired when settings are changed and new/load
local function ModOptions()
	mod_Default10 = options.Default10
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_GoldenStorage" then
		return
	end

	ModOptions()
end


local table_remove = table.remove
local Sleep = Sleep
local IsValid = IsValid
local RebuildInfopanel = RebuildInfopanel

DefineClass.GoldenStorage = {
	__parents = {
		"UniversalStorageDepot",
	},
	metals_thread = false,
	max_x = 5,
	max_y = 2,
	max_z = 5,

	-- proper placement for cubes
	switch_fill_order = false,
	fill_group_idx = 1,
}

function GoldenStorage:GameInit()
	-- start off with all resource demands blocked
	for i = #self.resource, 1, -1 do
		local res = self.resource[i]
		if res == "PreciousMetals" then
			self:ToggleAcceptResource(res, "startup")
		elseif res ~= "Metals" then
			self:ToggleAcceptResource(res, "startup")
			table_remove(self.resource, i)
		end
	end

	-- proper placement for cubes
	self:ReInitBoxSpots()

	if mod_Default10 then
		self:SetDesiredAmount(10000)
	end

	-- make sure it isn't mistaken for a regular depot
	self:SetColorModifier(-6262526)

	self.metals_thread = CreateGameTimeThread(function()
		while IsValid(self) and not self.destroyed do

			local storedM = self:GetStored_Metals()
			local maxM = self:GetMaxAmount_Metals()
			local storedP = self:GetStored_PreciousMetals()
			local maxP = self:GetMaxAmount_PreciousMetals()
			-- we need at least 10
			if storedM >= 10000 and maxP - storedP > 1000 then
				local new_amount = (storedM - 10000)

				self.supply.Metals:SetAmount(new_amount)
				self.demand.Metals:SetAmount(maxM - new_amount)
				self.stockpiled_amount.Metals = new_amount
				self:SetCount(new_amount, "Metals")

				self:AddResource(1000, "PreciousMetals")

				RebuildInfopanel(self)
			else
				self.supply.Metals:SetAmount(storedM)
				self.demand.Metals:SetAmount(maxM - storedM)
				self.stockpiled_amount.Metals = storedM
				self:SetCount(storedM, "Metals")
				self.stockpiled_amount.PreciousMetals = storedP
				self:SetCount(storedP, "PreciousMetals")
			end

			Sleep(5000)
		end
	end)
end

-- only show metals in selection panel
function GoldenStorage:DoesAcceptResource(res)
	return res == "Metals"
end

-- stop metals from flipping out when 10 of them
function GoldenStorage:SetCountInternal(new_count, count, resource, placed_cubes, _, _, _, ...)
	return UniversalStorageDepot.SetCountInternal(self, new_count, count, resource, placed_cubes, self.placement_offset, 0, 90*60, ...)
end

-- only allowed to toggle metals
function GoldenStorage:ToggleAcceptResource(res, startup, ...)
	if startup ~= "startup" and res ~= "Metals" then
		return
	end
	UniversalStorageDepot.ToggleAcceptResource(self, res, ...)
end

function GoldenStorage:Done()
	if IsValidThread(self.metals_thread) then
		DeleteThread(self.metals_thread)
	end
end

-- add building to building template list
function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.GoldenStorage then
		PlaceObj("BuildingTemplate", {
			"Id", "GoldenStorage",
			"template_class", "GoldenStorage",
			"instant_build", true,
			"display_name", T(302535920011084, "Golden Storage"),
			"display_name_pl", T(302535920011085, "Golden Storages"),
			"description", T(302535920011086, "Converts 10 <resource('Metals')> to 1 <resource('PreciousMetals')>."),
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"display_icon", CurrentModPath .. "UI/golden_storage.png",
			"entity", "ResourcePlatform",
			"on_off_button", false,
			"prio_button", false,
			"count_as_building", false,
		})
	end
end --ClassesPostprocess
