--stuff only loaded when ChoGGi.Temp.Testing = true


local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cMsgFuncs = ChoGGi.MsgFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

if ChoGGi.Temp.Testing then
  info = debug.getinfo

  --tell me if traits are different
  local StartupMsgs = ChoGGi.Temp.StartupMsgs
  local const = const
  local startT = "<color 255 0 0>"
  local endT = " is different length</color>"
  if #const.SchoolTraits ~= 5 then
    StartupMsgs[#StartupMsgs+1] = startT .. "SchoolTraits" .. endT
  end
  if #const.SanatoriumTraits ~= 7 then
    StartupMsgs[#StartupMsgs+1] = startT .. "SanatoriumTraits" .. endT
  end
  local fulllist = TraitsCombo()
  if #fulllist ~= 55 then
    StartupMsgs[#StartupMsgs+1] = startT .. "TraitsCombo" .. endT
  end

end

function cMsgFuncs.TestingFunc_ClassesGenerate()
end

function cMsgFuncs.TestingFunc_ClassesBuilt()
  --stops confirmation dialog about missing mods (still lets you know they're missing)
  function GetMissingMods()
    return "", false
  end

  --used to skip mystery parts
  cComFuncs.SaveOrigFunc("SA_WaitMarsTime","StopWait")
  function SA_WaitMarsTime:StopWait()
    print("SA_WaitMarsTime_StopWait")
    local cTemp = ChoGGi.Temp

    print(ChoGGi.Temp.SkipNext_SA_Wait)

    if cTemp.SkipNext_SA_Wait and cTemp.SkipNext_SA_Wait == self.meta.player.seq_list.file_name then
      print("skipnext")
      --reset it for next time
      cTemp.SkipNext_SA_Wait = false
      print(ChoGGi.Temp.SkipNext_SA_Wait)
      --return true to skip
      return true
    end

    return cOrigFuncs.SA_WaitMarsTime_StopWait(self)
  end

  cComFuncs.SaveOrigFunc("SA_WaitTime","StopWait")
  function SA_WaitTime:StopWait()
    print("SA_WaitTime_StopWait")
    return cOrigFuncs.SA_WaitTime_StopWait(self)
  end

--[[
  cComFuncs.SaveOrigFunc("SA_WaitTime","StopWait")
  function SA_WaitTime:StopWait()
    print("SA_WaitTime_StopWait")
    print(ChoGGi.Temp.SkipNext_SA_WaitMarsTime_StopWait)
    local skipnext = ChoGGi.Temp.SkipNext_SA_WaitMarsTime_StopWait
    if skipnext and skipnext == self.meta.player.seq_list.file_name then
      print("-------------")
      print(ChoGGi.Temp.SkipNext_SA_WaitMarsTime_StopWait)
      print(self.meta.player.seq_list.file_name)
      ex(self)

      --list.file_name
      skipnext = nil
      return 1
      --return true
    end
    return 1
    --return cOrigFuncs.SA_WaitTime_StopWait(self)
  end

  --see about changing maps
  cComFuncs.SaveOrigFunc("ChangeMap")
  function ChangeMap(map)
    print("---------------------")
    print(map)
    cOrigFuncs.ChangeMap(map)
  end


cComFuncs.SaveOrigFunc("_InternalTranslate")
function _InternalTranslate(T, context_obj, check)
  local ret = cOrigFuncs._InternalTranslate(T, context_obj, check)
  --if ChoGGi.Temp.IsGameLoaded and context_obj and context_obj.class and s and s.class and context_obj.class ~= s.class then
  if ChoGGi.Temp.IsGameLoaded and context_obj then
    ex(context_obj)
  end
  return ret
end

function SequenceListPlayer:UpdateCurrentIP(seq)

  local seq_state = self.seq_states[seq.name]
  local action = seq_state and seq_state.action
  if action then
    local new_ip = table.find(seq, action) or table.find(seq, getmetatable(action))
    seq_state.ip = new_ip or seq_state.ip - 1
  end
  if type(ChoGGi.Temp.SkipNext_Sequence) == "number" then
    seq_state.ip = ChoGGi.Temp.SkipNext_Sequence
    ChoGGi.Temp.SkipNext_Sequence = nil
  end
end
--]]
end

function cMsgFuncs.TestingFunc_LoadingScreenPreClose()
end
