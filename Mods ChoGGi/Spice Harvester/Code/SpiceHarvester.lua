--See LICENSE for terms

local Random = SpiceHarvester.ComFuncs.Random

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
	battery_hourly_drain_rate = 0,
	attack_range = 0,
}

DefineClass.MelangerBuilding = {
  __parents = {"BaseRoverBuilding"},
  rover_class = "Melanger",
}


do -- pausey stuff
	if UISpeedState == "pause" then
		SpiceHarvester.game_paused = true
	else
		SpiceHarvester.game_paused = false
	end

	function OnMsg.MarsPause()
		SpiceHarvester.game_paused = true
	end
	function OnMsg.MarsResume()
		SpiceHarvester.game_paused = false
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
	local Sleep = Sleep
  CreateRealTimeThread(function()
    for _ = 1, shuttle_amount do
			Sleep(Random(1000,2500))
      self.hub.shuttle_infos[#self.hub.shuttle_infos + 1] = ShuttleInfo:new{hub = self.hub}
      self.shuttles[#self.shuttles+1] = SpiceHarvester.ComFuncs.SpawnShuttle(self.hub)
			-- delay between launch
    end

    -- should be good by now to start thumping
    Sleep(2500)

		local IsValid = IsValid
		local PlaySound = PlaySound
		local StopSound = StopSound

    local delay = 0
    local snd
    while IsValid(self) do
			-- if I use gametime then it'll speed up the sounds and such, but realtime doesn't pause on pause
			if SpiceHarvester.game_paused then
				Sleep(1000)
			else
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

	-- a slimy trail of sand
	CreateRealTimeThread(function()
		local terrain_type_idx = table.find(TerrainTextures, "name", "Sand_01")
    while IsValid(self) do
			if SpiceHarvester.game_paused then
				Sleep(1000)
			else
				SetTypeCircle(self:GetVisualPos(), 900, terrain_type_idx)
				Sleep(Random(2000,4000))
			end
		end
	end)

end

-- added in DA update?
local Sleep = Sleep
function Melanger:MoveSleep(time)
	Sleep(time)
end

--iddqd
function Melanger:Repair()
	self.battery_current = self.battery_max
	local city = self.city or UICity
	self:DisconnectFromCommandCenters()
	self.current_health = self.max_health
	self.malfunction_idle_state = nil
	self:SetState("idle")
	self.is_repair_request_initialized = false
	city:AddToLabel("HostileAttackRovers", self)
	--hacky cmd exit
	self.command = "" -- so we get around setcmd malf block
	self:SetCommand("Roam")
	Msg("AttackRoverRepaired", self)
	ObjModified(self)
end
Melanger.Malfunction = Melanger.Repair
Melanger.Dead = Melanger.Repair
Melanger.NoBattery = Melanger.Repair
function Melanger:IsDead()
	return false
end
function Melanger:IsMalfunctioned()
	return false
end

function OnMsg.ClassesPostprocess()
  PlaceObj("BuildingTemplate",{
    "Id","MelangerBuilding",
    "template_class","MelangerBuilding",
    -- pricey bit 'o kit
    "construction_cost_Metals",1000,
    "dome_forbidden",true,
    "display_name",[[Spice Harvester]],
    "description",[[Doesn't do jack (unless you count roaming around and thumping).]],
    "Group","Infrastructure",
    "build_category","Infrastructure",
    "display_icon","UI/Icons/Buildings/boomerang_garden.tga",
    "encyclopedia_exclude",true,
    "on_off_button",false,
    "prio_button",false,
    "entity","PumpStationDemo",
  })
end --ClassesPostprocess

local function RemoveXTemplateSections(list,name)
	local idx = table.find(list, name, true)
	if idx then
		table.remove(list,idx)
	end
end
function OnMsg.ClassesBuilt()
	local XTemplates = XTemplates
	RemoveXTemplateSections(XTemplates.ipAttackRover[1],"Melanger_Destroy")
	RemoveXTemplateSections(XTemplates.ipAttackRover[1],"SolariaTelepresence_Melanger_Section")

	XTemplates.ipAttackRover[1][#XTemplates.ipAttackRover[1]+1] = PlaceObj("XTemplateTemplate", {
		"Melanger_Destroy", true,
		"__context_of_kind", "Melanger",
		"__template", "InfopanelSection",
		"Icon", "UI/Icons/Sections/resource_no_accept.tga",
		"Title", [[Destroy]],
		"RolloverText", [[Remove this harvester.]],
		"RolloverTitle", [[Destroy]],
	}, {
		PlaceObj("XTemplateFunc", {
		"name", "OnActivate(self, context)",
		"parent", function(parent, context)
				return parent.parent
			end,
		"func", function(parent, context)
			local function CallBackFunc(answer)
				if answer then
					local Sleep = Sleep
					CreateRealTimeThread(function()
						PlayFX("GroundExplosion", "start", context.fake_obj)
						PlaySound("Mystery Bombardment ExplodeTarget", "ObjectOneshot", nil, 0, false, context.fake_obj, 1000)
						Sleep(50)
						context:SetVisible(false)
						Sleep(5000)
						PlayFX("GroundExplosion", "end", context.fake_obj)
						DoneObject(context)

						for i = 1, #context.shuttles do
							context.shuttles[i]:GoodByeCruelWorld()
							-- delay between launch
							Sleep(Random(1000,2500))
						end

					end)
				end
			end
			SpiceHarvester.ComFuncs.QuestionBox(
				[[There is no escape—we pay for the violence of our ancestors.]],
				CallBackFunc,
				[[Little-death]],
				[[Destroy the poor defenseless harvester]],
				[[Spareth ye sprynge]],
				SpiceHarvester.ComFuncs.Concat(CurrentModPath,"Images/Wormy.png")
			)
		end
		})
	})

end -- ClassesBuilt
