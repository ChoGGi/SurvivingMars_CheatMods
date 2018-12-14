; This script searches through the decompiled lua files and finds all the Msg,WaitMsg,OnMsg

#NoEnv
#KeyHistory 0
#NoTrayIcon
#SingleInstance Force
SetBatchLines -1
ListLines Off
AutoTrim Off
Process Priority,,A

SetWorkingDir %A_ScriptDir%

; we get a list of all Msg and add them to here with a print func
global msg_list := []

ParseLuaFiles("CommonLua")
ParseLuaFiles("Data")
ParseLuaFiles("DLC")
ParseLuaFiles("Lua")

; spammy
msg_list.Delete("OnRender")
msg_list.Delete("ObjModified")
msg_list.Delete("UIPropertyChanged")
msg_list.Delete("ConsoleLine")
msg_list.Delete("PrefabCacheUnloaded")

output_str := "print(""*Mod starts loading (Code/Script.lua)*"")`r`n`r`n"
; merge msgs into a string and output to file
For key, value in msg_list
	output_str .= value

FileDelete PrintMsgFuncs.lua
FileAppend %output_str%,PrintMsgFuncs.lua

ExitApp

AddNameToList(start_str,end_str)
  {
	; get msg name + length of start string
	start_of_msg := InStr(A_LoopField,start_str,true) + StrLen(start_str)
	; search from next char
	end_of_msg := InStr(A_LoopField,end_str, false, start_of_msg)
	; and we gotta name
	name := SubStr(A_LoopField, start_of_msg , end_of_msg - start_of_msg)
	; skip dupes
	If !(msg_list[name])
		msg_list[name] := "function OnMsg." name "(...)`r`n`tprint(""Msg." name """,...)`r`nend`r`n"
	}

ParseLuaFiles(folder)
  {
	Loop Files,%folder%\*.lua,RF
		{
		FileRead, temptext, %A_LoopFileLongPath%
		Loop, parse, temptext, `n, `r
			{
			If InStr(A_LoopField,"WaitMsg(""",true)
				AddNameToList("WaitMsg(""","""")
			Else If InStr(A_LoopField, "function OnMsg.", true)
				AddNameToList("function OnMsg.","(")
			Else If InStr(A_LoopField,"""Msg(\""", true)
				AddNameToList("""Msg(\""","\""")
			Else If InStr(A_LoopField, "Msg(""", true)
				AddNameToList("Msg(""","""")
			}
		}
	}
