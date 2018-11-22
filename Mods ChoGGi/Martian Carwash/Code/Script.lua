-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 37
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Martian Carwash requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

--~ s:SetDust(1000, const.DustMaterialExterior)

local CreateGameTimeThread = CreateGameTimeThread
local DeleteThread = DeleteThread
local DoneObject = DoneObject
local IsValid = IsValid
local IsValidThread = IsValidThread
local NearestObject = NearestObject
local Sleep = Sleep
local Wakeup = Wakeup

--~ function OnMsg.ClassesGenerate()
local Farm = Farm
DefineClass.Carwash = {
  __parents = {
    "Building",
    "ElectricityConsumer",
    "LifeSupportConsumer",

    "OutsideBuildingWithShifts",

    "ColdSensitive",
  },

  -- stuff from water tanks
  building_update_time = 10000,

  -- stuff from farm
  properties = {
    { template = true, id = "water_consumption", name = T{656, "Water consumption"},  category = "Consumption", editor = "number", default = 0, scale = const.ResourceScale, read_only = true, modifiable = true },
    { template = true, id = "air_consumption",   name = T{657, "Oxygen Consumption"}, category = "Consumption", editor = "number", default = 0, scale = const.ResourceScale, read_only = true, modifiable = true },
  },
  interior = Farm.interior,
  spots = Farm.spots,
  anims = Farm.anims,
  -- conventional farm
  anim_thread = false,

  nearby_thread = false,
	marker = false,

}

local function SprinklerColour(s,color)
	s:SetColorModifier(color or 6579300)
end

local DustMaterialExterior = const.DustMaterialExterior
function Carwash:GameInit()
  FarmConventional.StartAnimThread(self)
	self.sprinkler = self:GetAttach("FarmSprinkler")

  self.nearby_thread = CreateGameTimeThread(function()
    while IsValid(self) and not self.destroyed do
      if self.working then
        local obj = nil
        -- check for anything on the "tarmac"
        obj = NearestObject(self,UICity.labels.Unit or {},1000)
        -- if so clean them
        if obj then
          -- get dust amount, and convert to percentage
          local dust_amt = (obj:GetDust() + 0.0) / 100
          if dust_amt ~= 0.0 then
            local value = 100
						self.sprinkler:ForEachAttach(SprinklerColour,8528128)
            while true do
              if value == 0 then
                break
              end
              value = value - 1
              obj:SetDust(dust_amt * value, DustMaterialExterior)
              Sleep(100)
            end
						self.sprinkler:ForEachAttach(SprinklerColour)
          end
        end
      end
      Sleep(1000)
    end
  end)

  -- make it look like not farm colours
  self:SetColorModifier(0)

  -- remove the lights/etc
	self:ForEachAttach(function(a)
    if a.class == "DecorInt_10" or a.class == "LampInt_04" then
      a:delete()
    end
	end)

  -- remove collision so we can drive over it
  self:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
end

function Carwash:OnSetWorking(working)
  OutsideBuildingWithShifts.OnSetWorking(self, working)
  ElectricityConsumer.OnSetWorking(self, working)

  if IsValidThread(self.anim_thread) then
    Wakeup(self.anim_thread)
	else
		FarmConventional.StartAnimThread(self)
  end
--~   if IsValidThread(self.nearby_thread) then
--~     Wakeup(self.nearby_thread)
--~   end
end

function Carwash:UpdateAttachedSigns()
  ElectricityConsumer.UpdateAttachedSigns(self)
end

function Carwash:Done()
--~   self:SetEnumFlags(const.efCollision + const.efApplyToGrids)
  FarmConventional.Done(self)
  if IsValidThread(self.nearby_thread) then
    DeleteThread(self.nearby_thread)
  end
end

-- we want main points, but no dust
Carwash.SetDust = empty_func

function Carwash:OnDestroyed()
	-- delete the threads
	self:Done()

	-- make sure sprinkler is stopped
	if self.sprinkler then
		PlayFX("FarmWater", "end", self.sprinkler)
		self.sprinkler:SetAnim(1, "workingEnd")
	end

	if not IsValid(self.marker) then
		self.marker = PlaceObject("Hex1_Placeholder")
		self.marker:SetScale(50)
		self:Attach(self.marker)
	end
end

-- add building to building template list
function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.Carwash then
		PlaceObj("BuildingTemplate", {
			"Id", "Carwash",
			"template_class", "Carwash",
			"dome_forbidden", true,
			"display_name", [[Martian Carwash]],
			"display_name_pl", [[Martian Carwash]],
			"description", [[Working at the car wash
Working at the car wash, yeah
Come on and sing it with me, car wash
Sing it with the feeling now, car wash, yeah]],
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", string.format("%sUI/carwash.png",CurrentModPath),
			"entity", "Farm",
			"electricity_consumption", 2500,
			"water_consumption", 0,
			"air_consumption", 0,
			"construction_cost_Concrete", 20000,
			"construction_cost_Metals", 15000,
			"construction_cost_Electronics", 1000,
			"construction_cost_Polymers", 1000,
			"maintenance_resource_type", "Metals",
			"maintenance_resource_amount", 1000,
		})
	end
end --ClassesPostprocess
