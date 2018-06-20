--See LICENSE for terms

local Sleep = Sleep
local DeleteThread = DeleteThread
local Random = Random
local IsValid = IsValid
local DoneObject = DoneObject
local point = point
local CreateGameTimeThread = CreateGameTimeThread
local CreateRealTimeThread = CreateRealTimeThread
local XTemplates = XTemplates
local PlaySound = PlaySound
local StopSound = StopSound

local terrain_SetTypeCircle = terrain.SetTypeCircle
local terrain_GetHeight = terrain.GetHeight

DefineClass.Melanger = {
  __parents = {
    "AttackRover",
    "PinnableObject",
    "ComponentAttach",
    "Demolishable",
    "Constructable",
  },
  hub = false,
  name = false,
  fake_obj = false,
  shuttles = {},
}

DefineClass.MelangerBuilding = {
  __parents = {"BaseRoverBuilding"},
  rover_class = "Melanger",
}

function Melanger:GameInit()
  self:ChangeEntity("PumpStationDemo")
  self:SetScale(500)

  self:SetColorModifier(SpiceHarvester.UserSettings.Color or -11328253)

  --needed for sidepanel
  self.name = "Spice Harvester"

  --still pretty slow, faster?
  self:SetMoveSpeed(750 * 1000)

  local shuttle_amount = Random(2,4)

  self.hub = ShuttleHub:new({
    starting_shuttles = shuttle_amount,
    ChoGGi_SlotAmount = shuttle_amount,
    ChoGGi_Parent = self,
  })
  self.hub:SetVisible()
  self:Attach(self.hub)
  self.hub.shuttle_infos = {}

  self.fake_obj = CargoShuttle:new()
  self:Attach(self.fake_obj)
  self.fake_obj:SetVisible(true)
  --needed?
  self.fake_obj:SetScale(25)
--~ 	s.fake_obj:PlayFX("TakeOff", "mid")
--~ 	s.fake_obj:PlayFX("Land", "mid")

  self:SetCommand("Roam")

  --needs a slight delay for the shuttlehub to do it's thing
  CreateRealTimeThread(function()
    Sleep(100)
    for _ = 1, shuttle_amount do
      self.hub.shuttle_infos[#self.hub.shuttle_infos + 1] = ShuttleInfo:new({hub = self.hub})
      self.shuttles[#self.shuttles+1] = SpiceHarvester.CodeFuncs.SpawnShuttle(self.hub)
    end

    Sleep(900)
    local terrain_type_idx = table.find(TerrainTextures, "name", "Sand_01")
    --should be good by now
    Sleep(1500)
    local delay = 0
    local snd
    while IsValid(self) do
      local pos = self:GetVisualPos()
      --a slimy trail of sand
      terrain_SetTypeCircle(pos, 900, terrain_type_idx)
      Sleep(50)
      delay = delay + 1
      if delay > 125 then
        delay = 0
        self.fake_obj:PlayFX("Dust", "start")
        Sleep(250)
        snd = PlaySound("Object PreciousExtractor LoopPeaks", "ObjectOneshot", nil, 0, false, self, 50)
--~         PlaySound(sound, _type, volume, fade_time, looping, point_or_object, loud_distance)
        Sleep(2250)
        StopSound(snd)
        self.fake_obj:PlayFX("Dust", "end")
      end
    end
  end)
end


function OnMsg.ClassesPostprocess()

  PlaceObj("BuildingTemplate",{
    "name","MelangerBuilding",
    "template_class","MelangerBuilding",
    --pricey
    "construction_cost_Metals",1000,
    "dome_forbidden",true,
    "display_name","Spice Harvester",
    "display_name_pl","Spice Harvester",
    "description","Doesn't do jack (unless you count roaming around).",
    "build_category","Infrastructure",
    "display_icon","UI/Icons/Buildings/boomerang_garden.tga",
    "encyclopedia_exclude",true,
    "on_off_button",false,
    "prio_button",false,
    "entity","PumpStationDemo",
--~     "palettes","AttackRoverBlue"
  })

end --ClassesPostprocess

function OnMsg.ClassesBuilt()

  if not XTemplates.ipAttackRover.Melanger_Section then
    XTemplates.ipAttackRover.Melanger_Section = true

    XTemplates.ipAttackRover[1][#XTemplates.ipAttackRover[1]+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "Melanger",
      "__template", "InfopanelSection",
      "Icon", "UI/Icons/traits_disapprove.tga",
      "Title", "Destroy",
      "RolloverText", "Remove this harvester.",
      "RolloverTitle", "Destroy",
    }, {
      PlaceObj("XTemplateFunc", {
      "name", "OnActivate(self, context)",
      "parent", function(parent, context)
          return parent.parent
        end,
      "func", function(parent, context)
        DoneObject(context)
        PlayFX("GroundExplosion", "start", context.fake_obj)
      end
      })
    })

  end --XTemplates

  --guess this is what happens when you spawn and attach a hub to a random vehicle
  local orig_ShuttleHub_InitLandingSpots = ShuttleHub.InitLandingSpots
  function ShuttleHub:InitLandingSpots()
    if self.ChoGGi_SlotAmount then
      --define the landing spots
      local slots = {}
      local spot_name = self.landing_spot_name or ""
      if spot_name ~= "" then
        for _ = 1, self.ChoGGi_SlotAmount do
          slots[#slots + 1] = {
            reserved_by = false,
            pos = self.ChoGGi_Parent:GetSpotPos(1),
          }
        end
      end
      self.landing_slots = slots
      self.free_landing_slots = #slots
      self.has_free_landing_slots = #slots > 0
    else
      orig_ShuttleHub_InitLandingSpots(self)
    end
  end

  function CargoShuttle:SpiceHarvester_IsFollower()
    if not self.SpiceHarvester_FollowHarvesterShuttle then
      self:SetCommand("Idle")
    end
  end

  function CargoShuttle:SpiceHarvester_FollowHarvester()
    self:SpiceHarvester_IsFollower()
    local x,y,z

    local dusty = CreateGameTimeThread(function()
      while IsValid(self.SpiceHarvester_Harvester) do
        Sleep(1000)
        local pos1 = self:GetVisualPos()
        if pos1:z() - terrain_GetHeight(pos1) < 1500 then
          self:PlayFX("Dust", "start")
          while true do
            Sleep(1000)
            local pos2 = self:GetVisualPos()
            if pos2:z() - terrain_GetHeight(pos2) > 1500 then
              break
            end
          end
          self:PlayFX("Dust", "end")
        end
      end
    end)

    repeat
      self.hover_height = Random(900,15000)
      if IsValid(self.SpiceHarvester_Harvester) then
        x,y,z = self.SpiceHarvester_Harvester:GetVisualPosXYZ()
        self:FollowPathCmd(self:CalcPath(self:GetVisualPos(), point(x+Random(-25000,25000),y+Random(-25000,25000))))
        Sleep(Random(2500,10000))
      else
        self.SpiceHarvester_FollowHarvesterShuttle = false
      end
    until not self.SpiceHarvester_FollowHarvesterShuttle or not self.SpiceHarvester_Harvester
    self:PlayFX("GroundExplosion", "start")

    DeleteThread(dusty)
    self:PlayFX("Dust", "end")

    self:PlayFX("GroundExplosion", "end")
    DoneObject(self)
  end

end
