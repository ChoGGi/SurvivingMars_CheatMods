-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 57
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Spice Harvester requires ChoGGi's Library (at least v" .. min_version .. [[).
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

local Random
local IsValid = IsValid
local PlaySound = PlaySound
local StopSound = StopSound
local GetSoundDuration = GetSoundDuration

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()
	Random = ChoGGi.ComFuncs.Random
end

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

	radius = 24*guim,
	collision_radius = 24*guim,
	orient_mode = "terrain_large",
}

DefineClass.MelangerBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "Melanger",
}

-- for painting the terrain
local terrain_type_idx = table.find(TerrainTextures, "name", "Sand_01")
local SetTypeCircle = terrain.SetTypeCircle

function Melanger:GameInit()
	self.shuttles = {}

	self:ChangeEntity("PumpStationDemo")
	self:SetScale(500)

	self:SetColorModifier(SpiceHarvester.Color or -11328253)

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
			self.shuttles[#self.shuttles+1] = SpiceHarvester.SpawnShuttle(self.hub)
			-- delay between launch
		end

		-- should be good by now to start thumping
		Sleep(2500)


		local delay = 0
		local snd
		while IsValid(self) do
			-- if I use gametime then it'll speed up the sounds and such, but realtime doesn't pause on pause
			if UISpeedState == "pause" then
				WaitMsg("MarsResume")
			end

			Sleep(50)
			delay = delay + 1
			if delay > 125 then
				delay = 0
				self.fake_obj:PlayFX("Dust", "start")
				Sleep(250)
				StopSound(snd)
				snd = PlaySound("Object PreciousExtractor LoopPeaks", "ObjectOneshot", nil, 0, false, self, 50)
				-- PlaySound(sound, _type, volume, fade_time, looping, point_or_object, loud_distance)
				Sleep(GetSoundDuration(snd))
				StopSound(snd)
				self.fake_obj:PlayFX("Dust", "end")
			end
		end
	end)

	-- a slimy trail of sand
	CreateRealTimeThread(function()
		while IsValid(self) do
			if UISpeedState == "pause" then
				WaitMsg("MarsResume")
			end

			SetTypeCircle(self:GetVisualPos(), 900, terrain_type_idx)
			Sleep(Random(2000,4000))
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
		"build_category","ChoGGi",
		"Group", "ChoGGi",
		"display_icon","UI/Icons/Buildings/boomerang_garden.tga",
		"encyclopedia_exclude",true,
		"on_off_button",false,
		"prio_button",false,
		"entity","PumpStationDemo",
	})
end --ClassesPostprocess

function OnMsg.ClassesBuilt()
	local ChoGGi = ChoGGi

	local XTemplates = XTemplates
	ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipAttackRover[1],"Melanger_Destroy")
	ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.ipAttackRover[1],"SolariaTelepresence_Melanger_Section")

	ChoGGi.ComFuncs.AddXTemplate(XTemplates.ipAttackRover[1],"Melanger_Destroy",nil,{

--~ 	ChoGGi.ComFuncs.AddXTemplate("Melanger_Destroy","ipAttackRover",{
		__context_of_kind = "Melanger",
		Icon = "UI/Icons/Sections/resource_no_accept.tga",
		Title = [[Destroy]],
		RolloverTitle = [[Destroy]],
		RolloverText = [[Remove this harvester.]],
		OnContextUpdate = function(self, context)
		end,
		func = function(self, context)
			---
			local function CallBackFunc(answer)
				if answer then
					local Sleep = Sleep
					local Random = Random
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
			ChoGGi.ComFuncs.QuestionBox(
				[[There is no escape-we pay for the violence of our ancestors.]],
				CallBackFunc,
				[[Little-death]],
				[[Destroy the poor defenseless harvester]],
				[[Spareth ye sprynge]],
				CurrentModPath .. "UI/Wormy.png",
			)
			---
		end,
	})

end -- ClassesBuilt
