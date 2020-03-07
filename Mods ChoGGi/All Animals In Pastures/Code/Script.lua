-- See LICENSE for terms

if not g_AvailableDlc.shepard then
	print("All Animals In Pastures needs DLC Installed: Project Laika!")
	return
end

local mod_OpenOnSelect

-- fired when settings are changed/init
local function ModOptions()
	mod_OpenOnSelect = CurrentModOptions:GetProperty("OpenOnSelect")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local table_find = table.find
local table_rand = table.rand

-- return all pasture animals to all pastures (in/out)
local animals_origcount = #(Presets and Presets.Animal and Presets.Animal.Pasture or "12345678")
local pasture_animals
local animal_presets
local function StartupCode()
	animal_presets = Presets.Animal.Pasture
	pasture_animals = table.copy(animal_presets)
	table.sortby(pasture_animals, "infopanel_pos")
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function ReturnAllPastures()
	return pasture_animals
end

InsidePasture.GetAnimalsInfo = ReturnAllPastures
OpenPasture.GetAnimalsInfo = ReturnAllPastures
Pasture.GetAnimalsInfo = ReturnAllPastures

InsidePasture.GetHarvestTypesTable = ReturnAllPastures
OpenPasture.GetHarvestTypesTable = ReturnAllPastures
Pasture.GetHarvestTypesTable = ReturnAllPastures

local drone_entities = {"Drone", "Drone_Trailblazer", "DroneMaintenance", "DroneMiner", "DroneWorker"}
if g_AvailableDlc.gagarin then
	local c = #drone_entities
	c = c + 1
	drone_entities[c] = "DroneJapanFlying"
	c = c + 1
	drone_entities[c] = "DroneJapanFlying_02"
	c = c + 1
	drone_entities[c] = "DroneJapanFlying_03"
end

local CurrentModPath = CurrentModPath
local animals = {
	-- spots are needed (for out vs in)
	Cow = {
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Cow",
	},
	Goat = {
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Goat",
	},
	Ostrich = {
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Ostrich",
	},
	Pig = {
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Pig",
	},

	Chicken = {
		grazing_spot_in = "Chicken",
		grazing_spot_out = "Goat",
	},
	Goose = {
		grazing_spot_in = "Goose",
		grazing_spot_out = "Goat",
	},
	RabbitPasture = {
		grazing_spot_in = "RabbitPasture",
		grazing_spot_out = "Goat",
	},
	Turkey = {
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Goat",
	},

	Cat = {
		description = T(381255823464, "Rabbits provide much better Food gain than chickens, but need more sustenance and need twice more time to grow."),
		display_icon = CurrentModPath .. "UI/animal_cat.tga",
		display_name = T(12557, "Cat"),
		entities = {"Cat_Large_01", "Cat_Large_02", "Cat_Small_01", "Cat_Small_02", "Cat_Small_03", },
		food = 600,
		grazing_spot_in = "Chicken",
		grazing_spot_out = "Goat",
		health = 24,
		herd_size = 25,
		air_consumption = 600,
		lifetime = 1440000,
		water_consumption = 600,
		infopanel_pos = animals_origcount+1,
	},
	Deer = {
		description = T(820966277286, "Ostriches are a great alternative of cattle, as they need less sustenance and fatten faster."),
		display_icon = CurrentModPath .. "UI/animal_deer.tga",
		display_name = T(409677371105, "Deer"),
		entities = {"Deer"},
		food = 10000,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Cow",
		health = 36,
		herd_size = 15,
		air_consumption = 3000,
		lifetime = 5760000,
		water_consumption = 2000,
		infopanel_pos = animals_origcount+2,
	},
	Dog = {
		description = T(143479109880, "Goats don't need much of a sustenance and provide a stable supply of Food over a relatively short time."),
		display_icon = CurrentModPath .. "UI/animal_dog.tga",
		display_name = T(346450684177,"Dog"),
		entities = {"Dog_Large_01", "Dog_Medium_01", "Dog_Medium_02", "Dog_Small_01", "Dog_Small_02", },
--~ 		entities = {"Dog_Large_02", },
		food = 4500,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Goat",
		health = 48,
		herd_size = 20,
		air_consumption = 2000,
		lifetime = 4320000,
		water_consumption = 1500,
		infopanel_pos = animals_origcount+3,
	},
	Llama = {
		description = T(715006788708, "Pigs consume a lot of Oxygen and a huge amount of Water, but provide a lot of Food over a short time."),
		display_icon = CurrentModPath .. "UI/animal_llama.tga",
		display_name = T(808881013020,"Llama"),
--~ 		entities = {"Lama", },
		entities = {"Lama_Ambient", },
		food = 10000,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Ostrich",
		health = 24,
		herd_size = 10,
		air_consumption = 2500,
		lifetime = 3600000,
		water_consumption = 4000,
		infopanel_pos = animals_origcount+4,
	},
	Penguin = {
		description = T(947790430318, "Chickens grow fast and have a small Oxygen and Water consumption, providing a fast and reliable Food source."),
		display_icon = CurrentModPath .. "UI/animal_penguin.tga",
		display_name = T(397432391921,"Penguin"),
		entities = {"Penguin_01", "Penguin_02", "Penguin_03", },
		food = 200,
		grazing_spot_in = "Goose",
		grazing_spot_out = "Goat",
		health = 20,
		herd_size = 25,
		air_consumption = 300,
		lifetime = 720000,
		water_consumption = 300,
		infopanel_pos = animals_origcount+5,
	},
	Platypus = {
		description = T(119708952644, "Geese consume a lot of Water and need more time to fatten, though they have a very good Food output."),
		display_icon = CurrentModPath .. "UI/animal_platypus.tga",
		display_name = T(210528297343,"Platypus"),
		entities = {"Platypus", },
		food = 2250,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Goat",
		health = 24,
		herd_size = 20,
		air_consumption = 600,
		lifetime = 2880000,
		water_consumption = 1200,
		infopanel_pos = animals_origcount+6,
	},
	Pony = {
		description = T(852087468296, "Cattle consume a huge amount of Oxygen and a lot of Water over a long time, but provide Food enough to sustain an average colony."),
		display_icon = CurrentModPath .. "UI/animal_pony.tga",
		display_name = T(176071455701,"Pony"),
		entities = {"Pony_01", "Pony_02", "Pony_03", },
		food = 30000,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Ostrich",
		health = 36,
		herd_size = 10,
		air_consumption = 4500,
		lifetime = 8640000,
		water_consumption = 3000,
		infopanel_pos = animals_origcount+7,
	},
	Tortoise = {
		description = T(414083950199, "Turkeys need a lot of sustenance and time, but provide the best Food output."),
		display_icon = CurrentModPath .. "UI/animal_tortoise.tga",
		display_name = T(768070368933,"Tortoise"),
		entities = {"Tortoise", },
		food = 4000,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Ostrich",
		health = 24,
		herd_size = 15,
		air_consumption = 900,
		lifetime = 3600000,
		water_consumption = 900,
		infopanel_pos = animals_origcount+8,
	},
	-- What? long pig is an animal.
	Child = {
--~ 4776,"Too young to work but can study at a School"
		description = T(852087468296, "Cattle consume a huge amount of Oxygen and a lot of Water over a long time, but provide Food enough to sustain an average colony."),
		display_icon = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Child_01.tga",
		display_name = T(4775,"Child"),
		entities = {
			"Unit_Colonist_Female_Af_Child_01",
			"Unit_Colonist_Female_Af_Child_02",
			"Unit_Colonist_Female_Ar_Child_01",
			"Unit_Colonist_Female_Ar_Child_02",
			"Unit_Colonist_Female_As_Child_01",
			"Unit_Colonist_Female_As_Child_02",
			"Unit_Colonist_Female_Ca_Child_01",
			"Unit_Colonist_Female_Ca_Child_02",
			"Unit_Colonist_Female_Hs_Child_01",
			"Unit_Colonist_Female_Hs_Child_02",
			"Unit_Colonist_Male_Af_Child_01",
			"Unit_Colonist_Male_Af_Child_02",
			"Unit_Colonist_Male_Ar_Child_01",
			"Unit_Colonist_Male_Ar_Child_02",
			"Unit_Colonist_Male_As_Child_01",
			"Unit_Colonist_Male_As_Child_02",
			"Unit_Colonist_Male_Ca_Child_01",
			"Unit_Colonist_Male_Ca_Child_02",
			"Unit_Colonist_Male_Hs_Child_01",
			"Unit_Colonist_Male_Hs_Child_02",
		},
		food = 20000,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Ostrich",
		health = 26,
		herd_size = 14,
		air_consumption = 3500,
		lifetime = 6640000,
		water_consumption = 2000,
		infopanel_pos = animals_origcount+9,
	},
--~ 4780,"An adult Colonist"
	Adult = {
		description = T(852087468296, "Cattle consume a huge amount of Oxygen and a lot of Water over a long time, but provide Food enough to sustain an average colony."),
		display_icon = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Adult_02.tga",
		display_name = T(4779,"Adult"),
		entities = {
			"Unit_Colonist_Female_Af_Adult_01",
			"Unit_Colonist_Female_Af_Adult_02",
			"Unit_Colonist_Female_Af_Adult_03",
			"Unit_Colonist_Female_Af_Adult_04",
			"Unit_Colonist_Female_Ar_Adult_01",
			"Unit_Colonist_Female_Ar_Adult_02",
			"Unit_Colonist_Female_Ar_Adult_03",
			"Unit_Colonist_Female_Ar_Adult_04",
			"Unit_Colonist_Female_As_Adult_01",
			"Unit_Colonist_Female_As_Adult_02",
			"Unit_Colonist_Female_As_Adult_03",
			"Unit_Colonist_Female_As_Adult_04",
			"Unit_Colonist_Female_Ca_Adult_01",
			"Unit_Colonist_Female_Ca_Adult_02",
			"Unit_Colonist_Female_Ca_Adult_03",
			"Unit_Colonist_Female_Ca_Adult_04",
			"Unit_Colonist_Female_Hs_Adult_01",
			"Unit_Colonist_Female_Hs_Adult_02",
			"Unit_Colonist_Female_Hs_Adult_03",
			"Unit_Colonist_Female_Hs_Adult_04",
			"Unit_Colonist_Male_Af_Adult_01",
			"Unit_Colonist_Male_Af_Adult_02",
			"Unit_Colonist_Male_Af_Adult_03",
			"Unit_Colonist_Male_Af_Adult_04",
			"Unit_Colonist_Male_Ar_Adult_01",
			"Unit_Colonist_Male_Ar_Adult_02",
			"Unit_Colonist_Male_Ar_Adult_03",
			"Unit_Colonist_Male_Ar_Adult_04",
			"Unit_Colonist_Male_As_Adult_01",
			"Unit_Colonist_Male_As_Adult_02",
			"Unit_Colonist_Male_As_Adult_03",
			"Unit_Colonist_Male_As_Adult_04",
			"Unit_Colonist_Male_Ca_Adult_01",
			"Unit_Colonist_Male_Ca_Adult_02",
			"Unit_Colonist_Male_Ca_Adult_03",
			"Unit_Colonist_Male_Ca_Adult_04",
			"Unit_Colonist_Male_Hs_Adult_01",
			"Unit_Colonist_Male_Hs_Adult_02",
			"Unit_Colonist_Male_Hs_Adult_03",
			"Unit_Colonist_Male_Hs_Adult_04",
		},
		food = 30000,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Ostrich",
		health = 46,
		herd_size = 14,
		air_consumption = 4500,
		lifetime = 8640000,
		water_consumption = 3000,
		infopanel_pos = animals_origcount+10,
	},
--~ 4784,"A senior Colonist retired from active duty"
	Senior = {
		description = T(852087468296, "Cattle consume a huge amount of Oxygen and a lot of Water over a long time, but provide Food enough to sustain an average colony."),
		display_icon = "UI/Icons/Colonists/Pin/Unit_Male_Ca_Retiree_01.tga",
		display_name = T(4783,"Senior"),
		entities = {
			"Unit_Colonist_Female_Af_Retiree_01",
			"Unit_Colonist_Female_Af_Retiree_02",
			"Unit_Colonist_Female_Ar_Retiree_01",
			"Unit_Colonist_Female_Ar_Retiree_02",
			"Unit_Colonist_Female_As_Retiree_01",
			"Unit_Colonist_Female_As_Retiree_02",
			"Unit_Colonist_Female_Ca_Retiree_01",
			"Unit_Colonist_Female_Ca_Retiree_02",
			"Unit_Colonist_Female_Hs_Retiree_01",
			"Unit_Colonist_Female_Hs_Retiree_02",
			"Unit_Colonist_Male_Af_Retiree_01",
			"Unit_Colonist_Male_Af_Retiree_02",
			"Unit_Colonist_Male_Ar_Retiree_01",
			"Unit_Colonist_Male_Ar_Retiree_02",
			"Unit_Colonist_Male_As_Retiree_01",
			"Unit_Colonist_Male_As_Retiree_02",
			"Unit_Colonist_Male_Ca_Retiree_01",
			"Unit_Colonist_Male_Ca_Retiree_02",
			"Unit_Colonist_Male_Hs_Retiree_01",
			"Unit_Colonist_Male_Hs_Retiree_02",
		},
		food = 30000,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Ostrich",
		health = 36,
		herd_size = 14,
		air_consumption = 4500,
		lifetime = 2640000,
		water_consumption = 2500,
		infopanel_pos = animals_origcount+11,
	},

	GreenMan = {
		description = T(381255823464, "Rabbits provide much better Food gain than chickens, but need more sustenance and need twice more time to grow."),
		display_icon = CurrentModPath .. "UI/animal_greenman.tga",
		display_name = T(302535920011391, "Alien"),
		entities = {
			"GreenMan",
		},
		food = 600,
		grazing_spot_in = "Chicken",
		grazing_spot_out = "Goat",
		health = 24,
		herd_size = 25,
		air_consumption = 600,
		lifetime = 1440000,
		water_consumption = 600,
		infopanel_pos = animals_origcount+12,
	},
	Drone = {
		description = T(947790430318, "Chickens grow fast and have a small Oxygen and Water consumption, providing a fast and reliable Food source."),
		display_icon = "UI/Icons/Buildings/drone.tga",
		display_name = T(1681, "Drone"),
		entities = drone_entities,
		food = 200,
		grazing_spot_in = "Turkey",
		grazing_spot_out = "Cow",
		health = 20,
		herd_size = 25,
		air_consumption = 300,
		lifetime = 720000,
		water_consumption = 300,
		infopanel_pos = animals_origcount+13,
	},
}

local orig_PastureAnimal_GameInit = PastureAnimal.GameInit
function PastureAnimal:GameInit(...)
	if self.animal_type:sub(1,21) == "ChoGGi_PastureAnimal_" then
		self.ChoGGi_animal = true
	end
	return orig_PastureAnimal_GameInit(self, ...)
end

-- make drones smaller
local orig_PastureAnimal_Spawn = PastureAnimal.Spawn
function PastureAnimal:Spawn(...)
	orig_PastureAnimal_Spawn(self, ...)
	if self.animal_type == "ChoGGi_PastureAnimal_Drone" then
		self:SetScale(50)
	end
end
local orig_Pasture_ScaleAnimals = Pasture.ScaleAnimals
function Pasture:ScaleAnimals(...)
	local herd = self.current_herd
	if herd[1] and herd[1].animal_type == "ChoGGi_PastureAnimal_Drone" then
		for i = 1, #herd do
			local animal = herd[i]
			if animal.animal_type == "ChoGGi_PastureAnimal_Drone" then
				animal:SetScale(50)
			end
		end
	else
		orig_Pasture_ScaleAnimals(self, ...)
	end
end

-- set anim when grazing
local graze_rand1 = {"pee", "jump"}
local graze_rand2 = {"playGround1", "playGround2"}
local orig_PastureAnimal_SetGrazingState = PastureAnimal.SetGrazingState
function PastureAnimal:SetGrazingState(duration, ...)
	if self.ChoGGi_animal then
		local states = self:GetStates()
		local state = "idle"
		local table_find = table.find
		if table_find(states,"graze") then
			state = "graze"
		-- the pees have jump
		elseif table_find(states,"pee") then
			state = table.rand(graze_rand1)
		-- long pig
		elseif table_find(states,"standEnjoySurfaceIdle") then
			state = "standEnjoySurface"
		-- shorter long pig
		elseif table_find(states,"playGround1Idle") then
			state = table.rand(graze_rand2)
		-- crunchy pig
		elseif table_find(states,"rechargeDroneIdle") then
			state = "gather"
		end

		if state == "graze" then
			local tEnd = GameTime() + duration
			while tEnd - GameTime() > 0 do
				self:PlayState(state)
				self:SetState("idle","ChoGGi_skip")
				Sleep(1000)
			end
		-- start idle end
		elseif state == "standEnjoySurface"
				or state == "playGround1" or state == "playGround2"
				or state == "gather" then
			local anim_time = self:SetState(state .. "Start","ChoGGi_skip")
			Sleep(anim_time)
			self:SetState(state .. "Idle","ChoGGi_skip")
			Sleep(duration)
			anim_time = self:SetState(state .. "End","ChoGGi_skip")
			Sleep(anim_time)

			self:SetState("idle","ChoGGi_skip")
		else
			self:SetState(state,"ChoGGi_skip")
			Sleep(duration)
			self:SetState("idle","ChoGGi_skip")
		end
	end

	return orig_PastureAnimal_SetGrazingState(self, duration, ...)
end

-- inf loop if the grazing spot is missing (hello fallback...)
local orig_PastureAnimal_Graze = PastureAnimal.Graze
function PastureAnimal:Graze(...)
	local item
	if self.ChoGGi_animal then
		item = animals[self.animal_type:sub(22)]
	else
		item = animals[self.animal_type]
	end
	if self.pasture:IsKindOf("InsidePasture") then
		self.grazing_spot = item.grazing_spot_in
		pasture_animals[self.animal_type].grazing_spot = item.grazing_spot_in
	else
		self.grazing_spot = item.grazing_spot_out
		pasture_animals[self.animal_type].grazing_spot = item.grazing_spot_out
	end

	return orig_PastureAnimal_Graze(self, ...)
end

local roam_rand1 = {"layGrassIdle", "standIdle", "standPanicIdle",
 "standDrawIdle",
	}
local roam_rand2 = {"layGrassIdle", "standIdle", "standPanicIdle", "playDance",
 "playVideoGames", "standShop",
	}
local roam_rand3 = {"breakDownIdle", "chargingStationIdle", "cleanBuildingIdle",
 "constructIdle",  "noBatteryIdle",  "rechargeDroneIdle",  "repairBuildingIdle",
 "repairDroneIdle", "rogueIdle",
	}

-- add new non-pasture animal objects
function OnMsg.ClassesPostprocess()
	-- set idle anim
	local orig_PastureAnimal_SetState = PastureAnimal.SetState
	function PastureAnimal:SetState(state, skip, ...)
		if skip ~= "ChoGGi_skip" and self.ChoGGi_animal then
			local states = self:GetStates()
			-- long pig
			if table_find(states,"standDrawIdle") then
				state = table_rand(roam_rand1)
			-- shorter long pig
			elseif table_find(states,"playGround1Idle") then
				state = table_rand(roam_rand2)
			-- crunchy pig
			elseif table_find(states,"rechargeDroneIdle") then
				state = table_rand(roam_rand3)
			end

			if skip == "ChoGGi_skip" then
				skip = nil
			end
			local anim_time = orig_PastureAnimal_SetState(self, state, skip, ...)
			if anim_time < 6000 then
				anim_time = 6000
			end
			return anim_time
		end

		if skip == "ChoGGi_skip" then
			skip = nil
		end

		return orig_PastureAnimal_SetState(self, state, skip, ...)
	end

	if Animals.ChoGGi_PastureAnimal_Cat then
		return
	end

	for id, item in pairs(animals) do
		-- skip default animals (we just need them for the spots)
		if item.display_name then
			PlaceObj("Animal", {
				AnimalClass = "ChoGGi_PastureAnimal",
				PastureClass = "InsidePasture",
				group = "Pasture",
				id = "ChoGGi_PastureAnimal_" .. id,
				save_in = "shepard",

				infopanel_pos = item.infopanel_pos,
				description = item.description,
				display_icon = item.display_icon,
				display_name = item.display_name,
				entities = item.entities,
				food = item.food,
				health = item.health,
				herd_size = item.herd_size,
				air_consumption = item.air_consumption,
				lifetime = item.lifetime,
				water_consumption = item.water_consumption,
			})
		end
	end

end

-- change to opened when selected
local orig_OpenPasture_OnSelected = OpenPasture.OnSelected
function OpenPasture:OnSelected(...)
	if mod_OpenOnSelect and self.entity == "OpenPasture" then
		self:ChangeEntity("OpenPasture_Open")
	end
  return orig_OpenPasture_OnSelected(self, ...)
end
-- revert back when unselected
function OnMsg.SelectionRemoved(obj)
	if obj.entity == "OpenPasture_Open" and obj:IsKindOf("OpenPasture") and not OpenAirBuildings then
		obj:ChangeEntity("OpenPasture")
	end
end

-- limit crop dialog size
local GetScreenSize = UIL.GetScreenSize
local width = GetScreenSize():x() - 100
function OnMsg.SystemSize()
	width = GetScreenSize():x() - 100
end

local orig_InfopanelItems_Open = InfopanelItems.Open
function InfopanelItems:Open(...)
	self:SetMaxWidth(width - Dialogs.Infopanel.box:sizex())
	return orig_InfopanelItems_Open(self, ...)
end
