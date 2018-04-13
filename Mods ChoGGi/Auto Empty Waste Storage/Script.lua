AutoEmptyWasteStorage = {}

--when ModConfig is ready to be used
function OnMsg.ModConfigReady()
  --get options
  AutoEmptyWasteStorage.Enabled = ModConfig:Get("AutoEmptyWasteStorage", "Enabled")
  AutoEmptyWasteStorage.Which = ModConfig:Get("AutoEmptyWasteStorage", "Which")

  --setup menu options
  ModConfig:RegisterMod("AutoEmptyWasteStorage", "Auto Empty Waste Storage")
  ModConfig:RegisterOption("AutoEmptyWasteStorage", "Enabled", {
    name = "Enabled",
    type = "boolean",
    default = true,
    desc = "Toggle emptying waste storage depots."
  })
  ModConfig:RegisterOption("AutoEmptyWasteStorage", "Which", {
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
  if AutoEmptyWasteStorage.Enabled and AutoEmptyWasteStorage.Which == 1 then
    AutoEmptyWasteStorage:EmptyAll()
  end
end
function OnMsg.NewHour()
  if AutoEmptyWasteStorage.Enabled and AutoEmptyWasteStorage.Which == 2 then
    AutoEmptyWasteStorage:EmptyAll()
  end
end

function AutoEmptyWasteStorage:EmptyAll()
  for _,object in ipairs(UICity.labels.WasteRockDumpSite or empty_table) do
      object:CheatEmpty()
  end
end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "AutoEmptyWasteStorage" then
    if option_id == "Enabled" then
      AutoEmptyWasteStorage.Enabled = value
    elseif option_id == "Which" then
      AutoEmptyWasteStorage.Which = value
    end
  end
end
