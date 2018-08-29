--See LICENSE for terms

local Random = SpiceHarvester.ComFuncs.Random

local Sleep = Sleep
local DeleteThread = DeleteThread
local IsValid = IsValid
local DoneObject = DoneObject
local point = point
local CreateGameTimeThread = CreateGameTimeThread
local CreateRealTimeThread = CreateRealTimeThread
local XTemplates = XTemplates
local PlaySound = PlaySound
local StopSound = StopSound

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
  shuttles = false,
	display_icon = "UI/Icons/Buildings/boomerang_garden.tga",
}

DefineClass.MelangerBuilding = {
  __parents = {"BaseRoverBuilding"},
  rover_class = "Melanger",
}

local game_paused
do -- pausey stuff
	if UISpeedState == "pause" then
		game_paused = true
	else
		game_paused = false
	end

	function OnMsg.MarsPause()
		game_paused = true
	end
	function OnMsg.MarsResume()
		game_paused = false
	end
end -- do

local SetTypeCircle = terrain.SetTypeCircle
function Melanger:GameInit()
  self.shuttles = {}

  self:ChangeEntity("PumpStationDemo")
  self:SetScale(500)

  self:SetColorModifier(SpiceHarvester.UserSettings.Color or -11328253)

  -- needed for sidepanel
  self.name = "Spice Harvester"

  -- still pretty slow, faster?
  self:SetMoveSpeed(750000)

  local shuttle_amount = Random(2,4)

  self.hub = SpiceHarvester_ShuttleHub:new{
    starting_shuttles = shuttle_amount,
    ChoGGi_SlotAmount = shuttle_amount,
    ChoGGi_Parent = self,
  }
  self.hub:SetVisible(false)
  self:Attach(self.hub)
  self.hub.shuttle_infos = {}

  self.fake_obj = SpiceHarvester_CargoShuttle:new()
  self:Attach(self.fake_obj)
  self.fake_obj:SetVisible(true)
  self.fake_obj:SetScale(25)

  self:SetCommand("Roam")

  -- needs a slight delay for the shuttlehub to do it's thing
  CreateRealTimeThread(function()
    Sleep(100)
    for _ = 1, shuttle_amount do
      self.hub.shuttle_infos[#self.hub.shuttle_infos + 1] = ShuttleInfo:new{hub = self.hub}
      self.shuttles[#self.shuttles+1] = SpiceHarvester.ComFuncs.SpawnShuttle(self.hub)
			-- delay between launch
			Sleep(Random(1000,2500))
    end

    Sleep(900)
    local terrain_type_idx = table.find(TerrainTextures, "name", "Sand_01")
    -- should be good by now to start thumping
    Sleep(1500)

    local delay = 0
    local snd
    while IsValid(self) do
			-- if I use gametime then it'll speed up the sounds and such, but realtime doesn't pause on pause
			if game_paused then
				Sleep(500)
			else
				local pos = self:GetVisualPos()
				-- a slimy trail of sand
				SetTypeCircle(pos, 900, terrain_type_idx)
				Sleep(50)
				delay = delay + 1
				if delay > 125 then
					delay = 0
					self.fake_obj:PlayFX("Dust", "start")
					Sleep(250)
					StopSound(snd)
					snd = PlaySound("Object PreciousExtractor LoopPeaks", "ObjectOneshot", nil, 0, false, self, 50)
					-- PlaySound(sound, _type, volume, fade_time, looping, point_or_object, loud_distance)
					Sleep(2250)
					StopSound(snd)
					self.fake_obj:PlayFX("Dust", "end")
				end
			end
    end
  end)
end

-- added in DA update?
function Melanger:MoveSleep(time)
	Sleep(time)
--~ 	PlayFX("Moving", "move", self)
--~ 'Particles', "RCRover_Trail",
--~ 'Offset', point(0, 800, 0),
end

function OnMsg.ClassesPostprocess()

  PlaceObj("BuildingTemplate",{
    "Id","MelangerBuilding",
    "template_class","MelangerBuilding",
    -- pricey bit 'o kit
    "construction_cost_Metals",1000,
    "dome_forbidden",true,
    "display_name",[[Spice Harvester]],
--~     "display_name_pl","Spice Harvester",
    "description",[[Doesn't do jack (unless you count roaming around and thumping).]],
    "Group","Infrastructure",
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
      "SolariaTelepresence_Melanger_Section", true,
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
				CreateRealTimeThread(function()
					PlayFX("GroundExplosion", "start", context.fake_obj)
					PlaySound("Mystery Bombardment ExplodeTarget", "ObjectOneshot", nil, 0, false, context.fake_obj, 1000)
					Sleep(50)
					context:SetVisible(false)
					Sleep(2500)
					DoneObject(context)
				end)
      end
      })
    })

  end --XTemplates

end
