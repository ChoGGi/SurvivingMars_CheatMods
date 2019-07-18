-- See LICENSE for terms

if not g_AvailableDlc.shepard then
	return
end

--~ Lama Petgraze
--~ Penguin Petidle

--~ for _=1, 50 do
--~ 	SpawnAnimal(s)
--~ end

local roaming_pets = {
	Tortoise = {
		display_name = T(768070368933,"Tortoise"),
		ambient = "Penguin",
		entities = {"Tortoise"},
	},
	Platypus = {
		display_name = T(210528297343,"Platypus"),
		ambient = "Penguin",
		entities = {"Platypus"},
	},
	Chicken = {
		display_name = T(299174615385,"Chicken"),
		ambient = "Lama",
		entities = {"Chicken"},
	},
	Turkey = {
		display_name = T(977344055059,"Turkey"),
		ambient = "Lama",
		entities = {"Turkey"},
	},
	Pig = {
		display_name = T(221418710774,"Pig"),
		ambient = "Lama",
		entities = {"Pig"},
	},
	Ostrich = {
		display_name = T(929526939780,"Ostrich"),
		ambient = "Lama",
		entities = {"Ostrich"},
	},
	Goose = {
		display_name = T(319767019420,"Goose"),
		ambient = "Lama",
		entities = {"Goose"},
	},
	GreenMan = {
		display_name = T(0,"GreenMan"),
		ambient = "Penguin",
		entities = {"GreenMan"},
	},
}
for id in pairs(roaming_pets) do
	DefineClass["ChoGGi_RoamingPet_" .. id] = {
		__parents = {"RoamingPet"}
	}
end

local pet_pets = {
	Tortoise = roaming_pets.Tortoise,
	Platypus = roaming_pets.Platypus,
	Chicken = roaming_pets.Chicken,
	Turkey = roaming_pets.Turkey,
	Pig = roaming_pets.Pig,
	Ostrich = roaming_pets.Ostrich,
	Goose = roaming_pets.Goose,
	GreenMan = roaming_pets.GreenMan,
	Deer = {
		display_name = T(409677371105,"Deer"),
		entities = {"Deer"},
	},
	Penguin = {
		display_name = T(397432391921,"Penguin"),
		entities = {"Penguin_01", "Penguin_02", "Penguin_03"},
	},
	Rabbit = {
		display_name = T(520473377733,"Rabbit"),
		entities = {"Rabbit_01", "Rabbit_02"},
	},
	Pony = {
		display_name = T(176071455701,"Pony"),
		entities = {"Pony_01", "Pony_02", "Pony_03"},
	},
	Llama = {
		display_name = T(808881013020,"Llama"),
		entities = {"Lama_Ambient"},
	},
}
for id in pairs(pet_pets) do
	DefineClass["ChoGGi_Pet_" .. id] = {
		__parents = {"Pet"}
	}
end

-- add preset objs
function OnMsg.ClassesPostprocess()
	if Animals.ChoGGi_RoamingPet_Tortoise then
		return
	end

	for id, pet in pairs(roaming_pets) do
		PlaceObj("Animal", {
			id = "ChoGGi_RoamingPet_" .. id,
			group = "Roaming",
			AnimalClass = "RoamingPet",
			save_in = "shepard",

			display_name = pet.display_name,
			entities = pet.entities,
			ambient_life_suffix = pet.ambient,
		})
	end

	for id, pet in pairs(pet_pets) do
		PlaceObj("Animal", {
			id = "ChoGGi_Pet_" .. id,
			group = "Pet",
			AnimalClass = "Pet",
			save_in = "shepard",
			ambient_life_suffix = "Pet",

			display_name = pet.display_name,
			entities = pet.entities,
		})
	end
end

-- remove sponsor limit for Platypus
local orig_GetMissionSponsor = GetMissionSponsor
local function fake_GetMissionSponsor(...)
	local sponsor = orig_GetMissionSponsor(...)
	sponsor.id = "paradox"
	return sponsor
end
local orig_SpawnAnimal = SpawnAnimal
function SpawnAnimal(...)
	GetMissionSponsor = fake_GetMissionSponsor
	orig_SpawnAnimal(...)
	GetMissionSponsor = orig_GetMissionSponsor
end
