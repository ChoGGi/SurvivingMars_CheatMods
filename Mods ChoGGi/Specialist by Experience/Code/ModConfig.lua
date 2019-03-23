function OnMsg.ModConfigReady()
  local ModConfig = ModConfig
  local SpecialistByExperience = SpecialistByExperience

  -- get options
  SpecialistByExperience.IgnoreSpec = ModConfig:Get("SpecialistByExperience", "IgnoreSpec") or SpecialistByExperience.IgnoreSpec
  SpecialistByExperience.SolsToTrain = ModConfig:Get("SpecialistByExperience", "SolsToTrain") or  SpecialistByExperience.SolsToTrain

  -- setup menu options
  ModConfig:RegisterMod("SpecialistByExperience", "Specialist By Experience")

  ModConfig:RegisterOption("SpecialistByExperience", "IgnoreSpec", {
    name = "Colonists who already have a spec are changed as well.",
    type = "boolean",
    default = SpecialistByExperience.IgnoreSpec,
  })
  ModConfig:RegisterOption("SpecialistByExperience", "SolsToTrain", {
    name = "How many Sols before getting new spec.",
    type = "number",
    default = SpecialistByExperience.SolsToTrain,
  })

end
function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "SpecialistByExperience" then
		if option_id == "IgnoreSpec" then
			SpecialistByExperience.IgnoreSpec = value
		elseif option_id == "SolsToTrain" then
			SpecialistByExperience.SolsToTrain = value
		end
  end
end

