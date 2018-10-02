-- See LICENSE for terms

local r = const.ResourceScale

function OnMsg.ModConfigReady()
  local ModConfig = ModConfig
  local PortableMinerSettings = PortableMinerSettings

  -- setup menu options
  ModConfig:RegisterMod("PortableMinerSettings", "Portable Miner")

  ModConfig:RegisterOption("PortableMinerSettings", "a", {
    name = "Amount per mine anim",
    type = "number",
    min = 0,
    step = 1,
    default = PortableMinerSettings.mine_amount / r,
  })

  ModConfig:RegisterOption("PortableMinerSettings", "b", {
    name = "Amount stored in stockpile manual",
    type = "number",
    min = 0,
    step = 1,
    max = 10000,
    default = PortableMinerSettings.max_res_amount_man / r,
  })
  ModConfig:RegisterOption("PortableMinerSettings", "c", {
    name = "Amount stored in stockpile auto",
    type = "number",
    min = 0,
    step = 1,
    max = 10000,
    default = PortableMinerSettings.max_res_amount_auto / r,
  })

  ModConfig:RegisterOption("PortableMinerSettings", "d", {
    name = "Time to mine concrete anim",
    type = "number",
    min = 0,
    step = 250,
    default = PortableMinerSettings.mine_time_anim.Concrete,
  })
  ModConfig:RegisterOption("PortableMinerSettings", "e", {
    name = "Time to mine concrete idle",
    type = "number",
    min = 0,
    step = 250,
    default = PortableMinerSettings.mine_time_idle.Concrete,
  })

  ModConfig:RegisterOption("PortableMinerSettings", "f", {
    name = "Time to mine metal anim",
    type = "number",
    min = 0,
    step = 250,
    default = PortableMinerSettings.mine_time_anim.Metals,
  })
  ModConfig:RegisterOption("PortableMinerSettings", "g", {
    name = "Time to mine metal idle",
    type = "number",
    min = 0,
    step = 250,
    default = PortableMinerSettings.mine_time_idle.Metals,
  })

  ModConfig:RegisterOption("PortableMinerSettings", "h", {
    name = "Time to mine precious metal anim",
    type = "number",
    min = 0,
    step = 250,
    default = PortableMinerSettings.mine_time_anim.PreciousMetals,
  })
  ModConfig:RegisterOption("PortableMinerSettings", "i", {
    name = "Time to mine precious metal idle",
    type = "number",
    min = 0,
    step = 250,
    default = PortableMinerSettings.mine_time_idle.PreciousMetals,
  })
  ModConfig:RegisterOption("PortableMinerSettings", "j", {
    name = "Paint ground around mine",
    type = "boolean",
    default = PortableMinerSettings.visual_cues,
  })

  -- get saved options
  PortableMinerSettings.mine_amount = r * ModConfig:Get("PortableMinerSettings", "a")
  PortableMinerSettings.max_res_amount_man = r * ModConfig:Get("PortableMinerSettings", "b")
  PortableMinerSettings.max_res_amount_auto = r * ModConfig:Get("PortableMinerSettings", "c")
  PortableMinerSettings.mine_time_anim.Concrete = ModConfig:Get("PortableMinerSettings", "d")
  PortableMinerSettings.mine_time_idle.Concrete = ModConfig:Get("PortableMinerSettings", "e")
  PortableMinerSettings.mine_time_anim.Metals = ModConfig:Get("PortableMinerSettings", "f")
  PortableMinerSettings.mine_time_idle.Metals = ModConfig:Get("PortableMinerSettings", "g")
  PortableMinerSettings.mine_time_anim.PreciousMetals = ModConfig:Get("PortableMinerSettings", "h")
  PortableMinerSettings.mine_time_idle.PreciousMetals = ModConfig:Get("PortableMinerSettings", "i")
  PortableMinerSettings.visual_cues = ModConfig:Get("PortableMinerSettings", "j")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
  if mod_id == "PortableMinerSettings" then
    if option_id == "a" then
      PortableMinerSettings.mine_amount = value * r

    elseif option_id == "b" then
      PortableMinerSettings.max_res_amount_man = value * r
      PortableMinerSettings.max_z_stack_man = value / 10

    elseif option_id == "c" then
      PortableMinerSettings.max_res_amount_auto = value * r
      PortableMinerSettings.max_z_stack_auto = value / 10

    elseif option_id == "d" then
			PortableMinerSettings.mine_time_anim.Concrete = value
    elseif option_id == "e" then
			PortableMinerSettings.mine_time_idle.Concrete = value
    elseif option_id == "f" then
			PortableMinerSettings.mine_time_anim.Metals = value
    elseif option_id == "g" then
			PortableMinerSettings.mine_time_idle.Metals = value
    elseif option_id == "h" then
			PortableMinerSettings.mine_time_anim.PreciousMetals = value
    elseif option_id == "i" then
			PortableMinerSettings.mine_time_idle.PreciousMetals = value
    elseif option_id == "j" then
			PortableMinerSettings.visual_cues = value
    end
  end
end
