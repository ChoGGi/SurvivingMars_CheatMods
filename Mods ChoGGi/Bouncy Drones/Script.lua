BouncyDrones = {
  Default = 2000
}

--set all drone gravity on load
function OnMsg.LoadGame()
  WaitMsg("ModConfigReady")
  for _,object in ipairs(UICity.labels.Drone or empty_table) do
    object:SetGravity(BouncyDrones.Gravity)
  end
end

function OnMsg.UIReady()
  if rawget(_G, "ModConfig") then
    BouncyDrones.Gravity = ModConfig:Get("BouncyDrones", "Gravity")
  end
end

function OnMsg.ModConfigReady()
  ModConfig:RegisterMod("BouncyDrones", "Bouncy Drones")
  ModConfig:RegisterOption("BouncyDrones", "Gravity", {
    name = "Gravity",
    type = "number",
    min = 0,
    step = 100,
    default = BouncyDrones.Default,
  })
end

function BouncyDrones:Update()
  for _,object in ipairs(UICity.labels.Drone or empty_table) do
    object:SetGravity(BouncyDrones.Gravity)
  end
end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "BouncyDrones" and option_id == "Gravity" then
    BouncyDrones.Gravity = value
    BouncyDrones:Update()
  end
end
