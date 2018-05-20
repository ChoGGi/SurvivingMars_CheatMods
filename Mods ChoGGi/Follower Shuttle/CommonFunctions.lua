--keep everything stored in
ChoGGiX = {
  email = "ECM@ChoGGiXX.org",
  --orig funcs that we replace
  OrigFuncs = {},
  --CommonFunctions.lua
  ComFuncs = {},
  --OnMsgs.lua
  MsgFuncs = {},
  --/Code/_Functions.lua
  CodeFuncs = {},
  --InfoPaneCheats.lua
  InfoFuncs = {},
  --Defaults.lua
  SettingFuncs = {},
  --temporary settings that aren't saved to SettingsFile
  Temp = {StartupMsgs = {}, RocketFiredDustDevil = {}},
}

local cConsts = ChoGGiX.Consts
local cComFuncs = ChoGGiX.ComFuncs

function cComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  if Func then
    local newname = ClassOrFunc .. "_" .. Func
    if not ChoGGiX.OrigFuncs[newname] then
      ChoGGiX.OrigFuncs[newname] = _G[ClassOrFunc][Func]
    end
  else
    if not ChoGGiX.OrigFuncs[ClassOrFunc] then
      ChoGGiX.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end
