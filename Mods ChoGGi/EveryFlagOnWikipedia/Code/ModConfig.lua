function OnMsg.ModConfigReady()
  local ModConfig = ModConfig

  -- setup menu option
  ModConfig:RegisterMod("EveryFlagOnWikipedia", "Every Flag On Wikipedia")

  ModConfig:RegisterOption("EveryFlagOnWikipedia", "RandomBirthplace", {
    name = "Randomise Birthplace",
    type = "boolean",
		default = EveryFlagOnWikipedia.RandomBirthplace,
  })

  -- get option
  EveryFlagOnWikipedia.RandomBirthplace = ModConfig:Get("EveryFlagOnWikipedia", "RandomBirthplace")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "EveryFlagOnWikipedia" and option_id == "RandomBirthplace" then
		EveryFlagOnWikipedia.RandomBirthplace = value
  end
end

local AsyncRand = AsyncRand
local NameUnit = NameUnit

local orig_GenerateColonistData = GenerateColonistData
function GenerateColonistData(...)
  if EveryFlagOnWikipedia.RandomBirthplace then
    local Nations = Nations
    local c = orig_GenerateColonistData(...)
--~     c.birthplace = Nations[Random(1,#Nations)].value
    c.birthplace = Nations[AsyncRand(#Nations - 1 + 1) + 1].value
    NameUnit(c)
    return c
  else
    return orig_GenerateColonistData(...)
  end
end
