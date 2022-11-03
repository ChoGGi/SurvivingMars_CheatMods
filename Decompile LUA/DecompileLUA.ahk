#NoEnv
#KeyHistory 0
#SingleInstance Off
SetBatchLines -1
ListLines Off
AutoTrim Off
Process Priority, , B
SetWorkingDir, %A_ScriptDir%

; Get script filename
SplitPath A_ScriptName ,,,, AhkFileName
; Get settings filename
AhkFileIni := A_ScriptDir "\" AhkFileName ".ini"

; Let user know what needs to be done
IniRead FirstRun, %AhkFileIni%, Settings, FirstRun, 1
If (FirstRun = 1)
	{
	MsgBox 4096 ,, You need to edit %AhkFileName%.ini`n`nInclude a copy of unluac_2022_01_12.jar (or whatever is current) in current folder`n`nSet path to java exe
	IniWrite 0, %AhkFileIni%, Settings, FirstRun
	IniWrite 0, %AhkFileIni%, Settings, IgnoreWarning
	ExitApp
	}

; Make sure we can start
IniRead IgnoreWarning, %AhkFileIni%, Settings, IgnoreWarning, 0
ConvertDeep := "F"
If (IgnoreWarning = 1)
	{
	ConvertDeep := "RF"
	}
Else
	{
	MsgBox 4099, WARNING, WARNING`n`nDecompiles all *.lua in current folder (skips decompiled files)`nShows message when all files converted`n`n`nYes to recursively decompile all *.lua (goes through all child folders)`nNo to decompile all *.lua (just this folder)`n`nWARNING
	IfMsgBox Yes
		ConvertDeep := "RF"
	Else IfMsgBox Cancel
		ExitApp
	}

; Get needed paths...
IniRead JavaPath, %AhkFileIni%, Settings, JavaPath, %A_Space%
IniRead UnluacPath, %AhkFileIni%, Settings, UnluacPath, %A_Space%

; Error out if no java/unluac
If (!FileExist(JavaPath) || !FileExist(UnluacPath))
	{
	MsgBox 4096, Error, You need to setup paths in %AhkFileIni%, or files are missing...
	ExitApp
	}

Loop Files, *.lua, %ConvertDeep%
	{
	; Check for correct header
	File := FileOpen(A_LoopFileLongPath, "r")
	; Probably not needed
	File.Seek(1)
	; Check if it's a compiled lua (LuaS == newer, LuaQ older)
	FileReadFour := File.Read(4)
	If (FileReadFour = "LuaS" || FileReadFour = "LuaQ")
		{
		; Need to close the file before we open it again below
		File.Close()
		; Call java/unluac
		DeCompiledLUA := StdOutToVar("""" JavaPath """" A_Space "-jar" A_Space """" UnluacPath """" A_Space """" A_LoopFileLongPath """")
		;delete original so we can append new
		FileDelete %A_LoopFileLongPath%
		FileAppend %DeCompiledLUA%, %A_LoopFileLongPath%
		}
	; Already decompiled
	Else
		{
		File.Close()
		}
	}

; All done
MsgBox 4096, Done, Files Decompiled

; Not needed just letting you know there's only functions below here
ExitApp

;https://github.com/cocobelgica/AutoHotkey-Util/blob/master/StdOutToVar.ahk (3541fbe on 25 Aug 2014)
StdOutToVar(Cmd, BreakOnString := 0, BreakOnStringAdd := 0, BreakDelay := 0)
	{
	Static Ptr := (A_PtrSize ? "Ptr" : "UInt")
				,PtrP := (A_PtrSize ? "Ptr*" : "Int*")
				,iPtrSize16 := (A_PtrSize == 4 ? 16 : 24)
				,iPtrSize68 := (A_PtrSize == 4 ? 68 : 104)
				,iPtrSize44 := (A_PtrSize == 4 ? 44 : 60)
				,iPtrSize60 := (A_PtrSize == 4 ? 60 : 88)
				,iPtrSize64 := (A_PtrSize == 4 ? 64 : 96)
				,PtrSizeX2 := 2 * A_PtrSize
				,CREATE_NO_WINDOW := 0x08000000
				,HANDLE_FLAG_INHERIT := 0x00000001

	DllCall("CreatePipe", PtrP, ReadPipeHandle, PtrP, hWritePipe, Ptr, 0, "UInt", 0)
	DllCall("SetHandleInformation", Ptr, hWritePipe
				, "UInt", HANDLE_FLAG_INHERIT, "UInt", HANDLE_FLAG_INHERIT)

	VarSetCapacity(PROCESS_INFORMATION, iPtrSize16, 0)		; http://goo.gl/dymEhJ
	cbSize := VarSetCapacity(STARTUPINFO, iPtrSize68, 0) ; http://goo.gl/QiHqq9
	NumPut(cbSize, STARTUPINFO, 0, "UInt")																; cbSize
	NumPut(0x100, STARTUPINFO, iPtrSize44, "UInt")				; dwFlags
	NumPut(hWritePipe, STARTUPINFO, iPtrSize60, Ptr)		; hStdOutput
	NumPut(hWritePipe, STARTUPINFO, iPtrSize64, Ptr)		; hStdError

	if !DllCall(
	(Join Q C
		"CreateProcess",						; http://goo.gl/9y0gw
		Ptr,	0,									 ; lpApplicationName
		Ptr,	&Cmd,							 ; lpCommandLine
		Ptr,	0,									 ; lpProcessAttributes
		Ptr,	0,									 ; lpThreadAttributes
		"UInt", true,							 ; bInheritHandles
		"UInt", CREATE_NO_WINDOW,	 ; dwCreationFlags
		Ptr,	0,									 ; lpEnvironment
		Ptr,	0,									 ; lpCurrentDirectory
		Ptr,	&STARTUPINFO,				; lpStartupInfo
		Ptr,	&PROCESS_INFORMATION ; lpProcessInformation
	)) {
		DllCall("CloseHandle", Ptr, hWritePipe)
		DllCall("CloseHandle", Ptr, ReadPipeHandle)
		return ""
	}

	DllCall("CloseHandle", Ptr, hWritePipe)
	VarSetCapacity(buffer, 4096, 0)
	If BreakOnString
		{
		;exit during process execution
		While DllCall("ReadFile", Ptr, ReadPipeHandle, Ptr, &buffer, "UInt", 4096, "UIntP", dwRead, Ptr, 0)
			{
			Output .= StrGet(&buffer, dwRead, "CP0")

			If (!BreakOnStringAdd && InStr(Output, BreakOnString))
				{
				;got what we want so kill off process
				Process Close,% NumGet(PROCESS_INFORMATION, PtrSizeX2, "UInt")
				Break
				}
			Else If (InStr(Output, BreakOnString) && InStr(Output, BreakOnStringAdd))
				{
				Process Close, % NumGet(PROCESS_INFORMATION, PtrSizeX2, "UInt")
				Break
				}
			;wait a bit
			Sleep %BreakDelay%
			}
		}
	Else
		{
		While DllCall("ReadFile", Ptr, ReadPipeHandle, Ptr, &buffer, "UInt", 4096, "UIntP", dwRead, Ptr, 0)
			Output .= StrGet(&buffer, dwRead, "CP0")
		}

	DllCall("CloseHandle", Ptr, NumGet(PROCESS_INFORMATION, 0))				 ; hProcess
	DllCall("CloseHandle", Ptr, NumGet(PROCESS_INFORMATION, A_PtrSize)) ; hThread
	DllCall("CloseHandle", Ptr, ReadPipeHandle)
	Return Output
	}
