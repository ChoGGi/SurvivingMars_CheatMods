function OnMsg.ModConfigReady()
  local ModConfig = ModConfig

  --get options
  EveryFlagOnWikipedia.RandomBirthplace = ModConfig:Get("EveryFlagOnWikipedia", "RandomBirthplace") or false

  --setup menu options
  ModConfig:RegisterMod("EveryFlagOnWikipedia", "Every Flag On Wikipedia")

  ModConfig:RegisterOption("EveryFlagOnWikipedia", "RandomBirthplace", {
    name = "Randomise Birthplace",
    type = "boolean",
  })

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "EveryFlagOnWikipedia" then
    if option_id == "RandomBirthplace" then
      EveryFlagOnWikipedia.RandomBirthplace = value
    end
  end
end

local Random = Random
local NameUnit = NameUnit

local orig_GenerateColonistData = GenerateColonistData
function GenerateColonistData(...)
  if EveryFlagOnWikipedia.RandomBirthplace then
    local Nations = Nations
    local c = orig_GenerateColonistData(...)
    c.birthplace = Nations[Random(1,#Nations)].value
    NameUnit(c)
    return c
  else
    return orig_GenerateColonistData(...)
  end
end
