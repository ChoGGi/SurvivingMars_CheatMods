function OnMsg.ModConfigReady()
  local ModConfig = ModConfig

  -- setup menu option
  ModConfig:RegisterMod("EveryFlagOnWikipedia", "Every Flag On Wikipedia")

  ModConfig:RegisterOption("EveryFlagOnWikipedia", "RandomBirthplace", {
    name = "Randomise Birthplace",
    desc = "Randomly picks birthplace for martians (so they don't all have martian names).",
    type = "boolean",
		default = EveryFlagOnWikipedia.RandomBirthplace,
  })

  ModConfig:RegisterOption("EveryFlagOnWikipedia", "DefaultNationNames", {
    name = "Default Nation Names",
    desc = "Existing Earth nations will not use the expanded names list.",
    type = "boolean",
		default = EveryFlagOnWikipedia.DefaultNationNames,
  })

  -- get option
  EveryFlagOnWikipedia.RandomBirthplace = ModConfig:Get("EveryFlagOnWikipedia", "RandomBirthplace")
  EveryFlagOnWikipedia.DefaultNationNames = ModConfig:Get("EveryFlagOnWikipedia", "DefaultNationNames")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "EveryFlagOnWikipedia" then
		if option_id == "RandomBirthplace" then
			EveryFlagOnWikipedia.RandomBirthplace = value
		elseif option_id == "DefaultNationNames" then
			EveryFlagOnWikipedia.DefaultNationNames = value
		end
  end
end

local AsyncRand = AsyncRand
local NameUnit = NameUnit

local orig_GenerateColonistData = GenerateColonistData
function GenerateColonistData(...)
  if EveryFlagOnWikipedia.RandomBirthplace then
    local Nations = Nations
    local c = orig_GenerateColonistData(...)
    c.birthplace = Nations[AsyncRand(#Nations - 1 + 1) + 1].value
    NameUnit(c)
    return c
  else
    return orig_GenerateColonistData(...)
  end
end
