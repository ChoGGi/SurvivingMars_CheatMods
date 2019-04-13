BouncyDrones = {}

-- set options at start
BouncyDrones.Update = function()
	local labels = UICity.labels

	local label = labels.Drone or ""
	for i = 1, #label do
    label[i]:SetGravity(BouncyDrones.Gravity or 2000)
	end

	label = labels.Rover or ""
	for i = 1, #label do
    label[i]:SetGravity(BouncyDrones.GravityRC or 0)
	end

	label = labels.Colonist or ""
	for i = 1, #label do
    label[i]:SetGravity(BouncyDrones.GravityColonist or 0)
	end
end

OnMsg.CityStart = BouncyDrones.Update
OnMsg.LoadGame = BouncyDrones.Update


function OnMsg.ModConfigReady()
  --get options
  BouncyDrones.Gravity = ModConfig:Get("BouncyDrones", "Gravity")
  BouncyDrones.GravityRC = ModConfig:Get("BouncyDrones", "GravityRC")
  BouncyDrones.GravityColonist = ModConfig:Get("BouncyDrones", "GravityColonist")

  --setup menu options
  ModConfig:RegisterMod("BouncyDrones", "Bouncy Drones")
  ModConfig:RegisterOption("BouncyDrones", "Gravity", {
    name = "Gravity Drone",
    type = "number",
    min = 0,
    step = 100,
    default = 2000,
  })
  ModConfig:RegisterOption("BouncyDrones", "GravityRC", {
    name = "Gravity RC",
    type = "number",
    min = 0,
    step = 100,
    default = 10000,
  })
  ModConfig:RegisterOption("BouncyDrones", "GravityColonist", {
    name = "Gravity Colonist",
    type = "number",
    min = 0,
    step = 50,
    default = 250,
  })
end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "BouncyDrones" then
    if option_id == "Gravity" then
      BouncyDrones.Gravity = value
    elseif option_id == "GravityRC" then
      BouncyDrones.GravityRC = value
    elseif option_id == "GravityColonist" then
      BouncyDrones.GravityColonist = value
    end
    BouncyDrones.Update()
  end
end
