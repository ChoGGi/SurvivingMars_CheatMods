-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 55
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Golden Storage requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				if p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

DefineClass.GoldenStorage = {
  __parents = {
    "UniversalStorageDepot"
  },
  metals_thread = false,
  max_z = 1,
}

function GoldenStorage:GameInit()
  -- fire off the usual GameInit
  UniversalStorageDepot.GameInit(self)
  -- and start off with all resource demands blocked
  for i = 1, #self.resource do
    if self.resource[i] ~= "Metals" then
      self:ToggleAcceptResource(self.resource[i],true)
    end
  end

  -- make sure it isn't mistaken for a regular depot
  self:SetColorModifier(-6262526)

  self.metals_thread = CreateGameTimeThread(function()
    while IsValid(self) and not self.destroyed do

      local storedM = self:GetStored_Metals()
      local maxM = self:GetMaxAmount_Metals()
      local storedP = self:GetStored_PreciousMetals()
      local maxP = self:GetMaxAmount_PreciousMetals()
      --we need at least 10
      if storedM >= 10000 and maxP - storedP > 1000 then
        local new_amount = (storedM - 10000)

        self.supply.Metals:SetAmount(new_amount)
        self.demand.Metals:SetAmount(maxM - new_amount)
        self.stockpiled_amount.Metals = new_amount
        self:SetCount(new_amount, "Metals")

        self:AddResource(1000, "PreciousMetals")

        --PlayFX("MeteorExplosion", "start", self)

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

-- only allowed to toggle metals
function GoldenStorage:ToggleAcceptResource(res,startup)
  if not startup and res ~= "Metals" then
    return
  end
  UniversalStorageDepot.ToggleAcceptResource(self, res)
end

function GoldenStorage:Done()
  UniversalStorageDepot.Done(self)
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
			"dome_forbidden", true,
			"display_name", [[Golden Storage]],
			"display_name_pl", [[Golden Storage]],
			"description", [[Converts Metals to PreciousMetals.]],
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", string.format("%suniversal_storage.tga",CurrentModPath),
			"entity", "ResourcePlatform",
			"on_off_button", false,
			"prio_button", false,
			"count_as_building", false,
			"switch_fill_order", false,
			"fill_group_idx", 9,
		})
	end
end --ClassesPostprocess
