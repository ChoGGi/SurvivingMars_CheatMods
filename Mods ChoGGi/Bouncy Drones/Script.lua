BouncyDrones = {}

local function SomeCode()
  --set options
  for _,object in ipairs(UICity.labels.Drone or empty_table) do
    object:SetGravity(BouncyDrones.Gravity or 2000)
  end
  for _,object in ipairs(UICity.labels.Rover or empty_table) do
    object:SetGravity(BouncyDrones.GravityRC or 0)
  end
  for _,object in ipairs(UICity.labels.Colonist or empty_table) do
    object:SetGravity(BouncyDrones.GravityColonist or 0)
  end

end

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end

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

function BouncyDrones:Update()
  for _,object in ipairs(UICity.labels.Drone or empty_table) do
    object:SetGravity(BouncyDrones.Gravity)
  end
  for _,object in ipairs(UICity.labels.Rover or empty_table) do
    object:SetGravity(BouncyDrones.GravityRC)
  end
  for _,object in ipairs(UICity.labels.Colonist or empty_table) do
    object:SetGravity(BouncyDrones.GravityColonist)
  end
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
    BouncyDrones:Update()
  end
end
