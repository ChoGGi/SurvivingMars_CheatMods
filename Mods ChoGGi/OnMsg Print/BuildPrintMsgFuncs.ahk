#NoEnv
#KeyHistory 0
#NoTrayIcon
#SingleInstance Force
SetBatchLines -1
ListLines Off
AutoTrim Off
Process Priority,,A

; this script expects to be in a folder with these folders: CommonLua,Data,Lua
SetWorkingDir %A_ScriptDir%

; we get a list of all Msg(" and add them to here with a print func
global msg_list := []

ParseLuaFiles("CommonLua")
ParseLuaFiles("Data")
ParseLuaFiles("Lua")

; spammy
msg_list.Delete("OnRender")
msg_list.Delete("ObjModified")
msg_list.Delete("UIPropertyChanged")
msg_list.Delete("ConsoleLine")
msg_list.Delete("PrefabCacheUnloaded")

; merge msgs into a string and output to file
For key, value in msg_list
	output_str .= value

FileDelete PrintMsgFuncs.lua
FileAppend %output_str%,PrintMsgFuncs.lua

ParseLuaFiles(folder)
  {
	Loop Files,%folder%\*.lua,RF
		{
		FileRead, temptext, %A_LoopFileLongPath%
		Loop, parse, temptext, `n, `r
			{
			start_of_msg := InStr(A_LoopField, "Msg(""", true)
			If start_of_msg & !InStr(A_LoopField,"WaitMsg(",true)
				{
				; get msg name
				start_of_msg += 5 ; 5 is length of Msg("
				end_of_msg := InStr(A_LoopField, """" , false, start_of_msg)
				name := SubStr(A_LoopField, start_of_msg , end_of_msg - start_of_msg)
				; skip dupes
				If !msg_list[name]
					msg_list[name] := "function OnMsg." name "(...)`r`n`tprint(""Msg." name """,...)`r`nend`r`n"
				}
			}
		}
	}
