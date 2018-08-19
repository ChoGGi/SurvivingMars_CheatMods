AutoEmptyFullWasteStorage = {
  Enabled = true,
  Which = 1
}

--when ModConfig is ready to be used
function OnMsg.ModConfigReady()
  --get options
  AutoEmptyFullWasteStorage.Enabled = ModConfig:Get("AutoEmptyFullWasteStorage", "Enabled")
  AutoEmptyFullWasteStorage.Which = ModConfig:Get("AutoEmptyFullWasteStorage", "Which")

  --setup menu options
  ModConfig:RegisterMod("AutoEmptyFullWasteStorage", "Auto Empty Waste Storage")
  ModConfig:RegisterOption("AutoEmptyFullWasteStorage", "Enabled", {
    name = "Enabled",
    type = "boolean",
    default = true,
    desc = "Toggle emptying waste storage depots."
  })
  ModConfig:RegisterOption("AutoEmptyFullWasteStorage", "Which", {
    name = "How often",
    type = "enum",
    default = 1,
    values = {
      {value = 1, label = "Daily"},
      {value = 2, label = "Hourly"}
    },
    desc = "How often should we empty storage?"
  })
end

function OnMsg.NewDay()
  if AutoEmptyFullWasteStorage.Enabled and AutoEmptyFullWasteStorage.Which == 1 then
    AutoEmptyFullWasteStorage:EmptyAll()
  end
end
function OnMsg.NewHour()
  if AutoEmptyFullWasteStorage.Enabled and AutoEmptyFullWasteStorage.Which == 2 then
    AutoEmptyFullWasteStorage:EmptyAll()
  end
end

function AutoEmptyFullWasteStorage:EmptyAll()
  for _,object in ipairs(UICity.labels.WasteRockDumpSite or empty_table) do
    if object.max_amount_WasteRock == object.GetStoredAmount(object, "WasteRock") then
      object:CheatEmpty()
    end
  end
end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "AutoEmptyFullWasteStorage" then
    if option_id == "Enabled" then
      AutoEmptyFullWasteStorage.Enabled = value
    elseif option_id == "Which" then
      AutoEmptyFullWasteStorage.Which = value
    end
  end
end
