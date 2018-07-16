function OnMsg.ModConfigReady()
  local ModConfig = ModConfig

  --get options
  FlattenGround.FlattenGroundHeightDiff = ModConfig:Get("FlattenGround", "FlattenGroundHeightDiff") or 100
  FlattenGround.FlattenGroundRadiusDiff = ModConfig:Get("FlattenGround", "FlattenGroundRadiusDiff") or 100

  --setup menu options
  ModConfig:RegisterMod("FlattenGround", "Flatten Ground")

  ModConfig:RegisterOption("FlattenGround", "FlattenGroundHeightDiff", {
    name = "Height change per press",
    type = "number",
    min = 0,
    step = 10,
    default = 100,
  })

  ModConfig:RegisterOption("FlattenGround", "FlattenGroundRadiusDiff", {
    name = "Radius change per press",
    type = "number",
    min = 0,
    step = 10,
    default = 100,
  })

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "FlattenGround" then
    if option_id == "FlattenGroundHeightDiff" then
      FlattenGround.FlattenGroundHeightDiff = value
    elseif option_id == "FlattenGroundRadiusDiff" then
      FlattenGround.FlattenGroundRadiusDiff = value
    end
  end
end
