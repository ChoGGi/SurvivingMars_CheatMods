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
ParseLuaFiles("Dlc")
ParseLuaFiles("Lua")

; very spammy
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

BuildName(str,start_str,end_str,occurrence := 1)
  {
	; get msg name + length of start string
	local start_of_msg := InStr(str,start_str,true,,occurrence) + StrLen(start_str)
	; search from next char
	local end_of_msg := InStr(str,end_str, false, start_of_msg)
	; and we gotta name
	local name := SubStr(str, start_of_msg , end_of_msg - start_of_msg)
	; send 'er back
	return name
	}

AddNameToList(name := false,str := false,start_str := false,end_str := false)
  {
	If !(name)
		name := BuildName(str,start_str,end_str)
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
			;~ WaitMsg("ExampleMsg")
			If InStr(A_LoopField,"WaitMsg(""",true)
				AddNameToList(,A_LoopField,"WaitMsg(""","""")

			;~ function OnMsg.ExampleMsg
			Else If InStr(A_LoopField, "function OnMsg.", true)
				AddNameToList(,A_LoopField,"function OnMsg.","(")

			;~ Msg(\"ExampleMsg\")
			Else If InStr(A_LoopField,"""Msg(\""", true)
				AddNameToList(,A_LoopField,"""Msg(\""","\""")

			;~ Msg("ExampleMsg")
			Else If InStr(A_LoopField, "Msg(""", true)
				AddNameToList(,A_LoopField,"Msg(""","""")

			;~ DefineStoryBitTrigger("Skip text", "ExampleMsg")
			Else If InStr(A_LoopField, "DefineStoryBitTrigger(""", true)
				AddNameToList(BuildName(BuildName(A_LoopField,"DefineStoryBitTrigger(",")"),"""","""",3))
			}
		}
	}
