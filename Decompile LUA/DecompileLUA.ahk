#NoEnv
#KeyHistory 0
#SingleInstance Off
SetBatchLines -1
ListLines Off
AutoTrim Off
Process Priority, , B
SetWorkingDir, %A_ScriptDir%

;get script filename
SplitPath A_ScriptName, , , , sProgName
;get settings filename
sProgIni := A_ScriptDir "\" sProgName ".ini"

IniRead bFirstRun, %sProgIni%, Settings, FirstRun, 1
If (bFirstRun = 1)
	{
	MsgBox 4096, , You need to edit %sProgName%.ini`n`nInclude a copy of unluac_2015_06_13.jar in current folder`n`nSet path to java exe
	IniWrite 0, %sProgIni%, Settings, FirstRun
	ExitApp
	}

sConvert := "F"
MsgBox 4099, WARNING, WARNING`n`nDecompiles all *.lua in current folder (skips decompiled files)`nShows message when all files converted`n`n`nYes to recursively decompile all *.lua (goes through all child folders)`nNo to decompile all *.lua (just this folder)`n`nWARNING
IfMsgBox Yes
	sConvert := "RF"
Else IfMsgBox Cancel
	ExitApp

;get needed paths...
IniRead sJavaPath, %sProgIni%, Settings, JavaPath, %A_Space%
IniRead sUnluacPath, %sProgIni%, Settings, UnluacPath, %A_Space%

If (!FileExist(sJavaPath) || !FileExist(sUnluacPath))
	{
	MsgBox 4096, Error, You need to setup paths in %sProgIni%, or files are missing...
	ExitApp
	}

Loop Files, *.lua, %sConvert%
	{
	;check for correct header and skip if not
	File := FileOpen(A_LoopFileLongPath, "r")
	;probably not needed
	File.Seek(1)
	;check if it's a compiled lua
	If (File.Read(4) = "LuaS")
	; omerta lua files
	;~ If (File.Read(4) = "LuaQ")
		{
		;need to close the file before we open it again below
		File.Close()
		;decompile lua
		DeCompiledLUA := StdOutToVar("""" sJavaPath """" A_Space "-jar" A_Space """" sUnluacPath """" A_Space """" A_LoopFileLongPath """")
		;delete original so we can append new
		FileDelete %A_LoopFileLongPath%
		FileAppend %DeCompiledLUA%, %A_LoopFileLongPath%
		}
	;already decompiled
	Else
		{
		File.Close()
		}
	}

;all done
MsgBox 4096, Done, Files Decompiled

;not needed just letting you know there's only functions below here
ExitApp

;https://github.com/cocobelgica/AutoHotkey-Util/blob/master/StdOutToVar.ahk (3541fbe on 25 Aug 2014)
StdOutToVar(sCmd, sBreakOnString := 0, sBreakOnStringAdd := 0, iBreakDelay := 0)
	{
	Static sPtr := (A_PtrSize ? "Ptr" : "UInt")
				, sPtrP := (A_PtrSize ? "Ptr*" : "Int*")
				, iPtrSize16 := (A_PtrSize == 4 ? 16 : 24)
				, iPtrSize68 := (A_PtrSize == 4 ? 68 : 104)
				, iPtrSize44 := (A_PtrSize == 4 ? 44 : 60)
				, iPtrSize60 := (A_PtrSize == 4 ? 60 : 88)
				, iPtrSize64 := (A_PtrSize == 4 ? 64 : 96)
				, iPtrSizeX2 := 2 * A_PtrSize
				, CREATE_NO_WINDOW := 0x08000000
				, HANDLE_FLAG_INHERIT := 0x00000001

	DllCall("CreatePipe", sPtrP, hReadPipe, sPtrP, hWritePipe, sPtr, 0, "UInt", 0)
	DllCall("SetHandleInformation", sPtr, hWritePipe
				, "UInt", HANDLE_FLAG_INHERIT, "UInt", HANDLE_FLAG_INHERIT)

	VarSetCapacity(PROCESS_INFORMATION, iPtrSize16, 0)		; http://goo.gl/dymEhJ
	cbSize := VarSetCapacity(STARTUPINFO, iPtrSize68, 0) ; http://goo.gl/QiHqq9
	NumPut(cbSize, STARTUPINFO, 0, "UInt")																; cbSize
	NumPut(0x100, STARTUPINFO, iPtrSize44, "UInt")				; dwFlags
	NumPut(hWritePipe, STARTUPINFO, iPtrSize60, sPtr)		; hStdOutput
	NumPut(hWritePipe, STARTUPINFO, iPtrSize64, sPtr)		; hStdError

	if !DllCall(
	(Join Q C
		"CreateProcess", 						; http://goo.gl/9y0gw
		sPtr, 	0, 									 ; lpApplicationName
		sPtr, 	&sCmd, 							 ; lpCommandLine
		sPtr, 	0, 									 ; lpProcessAttributes
		sPtr, 	0, 									 ; lpThreadAttributes
		"UInt", true, 							 ; bInheritHandles
		"UInt", CREATE_NO_WINDOW, 	 ; dwCreationFlags
		sPtr, 	0, 									 ; lpEnvironment
		sPtr, 	0, 									 ; lpCurrentDirectory
		sPtr, 	&STARTUPINFO, 				; lpStartupInfo
		sPtr, 	&PROCESS_INFORMATION ; lpProcessInformation
	)) {
		DllCall("CloseHandle", sPtr, hWritePipe)
		DllCall("CloseHandle", sPtr, hReadPipe)
		return ""
	}

	DllCall("CloseHandle", sPtr, hWritePipe)
	VarSetCapacity(buffer, 4096, 0)
	If sBreakOnString
		{
		;exit during process execution
		While DllCall("ReadFile", sPtr, hReadPipe, sPtr, &buffer, "UInt", 4096, "UIntP", dwRead, sPtr, 0)
			{
			sOutput .= StrGet(&buffer, dwRead, "CP0")

			If (!sBreakOnStringAdd && InStr(sOutput, sBreakOnString))
				{
				;got what we want so kill off process
				Process Close, % NumGet(PROCESS_INFORMATION, iPtrSizeX2, "UInt")
				Break
				}
			Else If (InStr(sOutput, sBreakOnString) && InStr(sOutput, sBreakOnStringAdd))
				{
				Process Close, % NumGet(PROCESS_INFORMATION, iPtrSizeX2, "UInt")
				Break
				}
			;wait a bit
			Sleep %iBreakDelay%
			}
		}
	Else
		{
		While DllCall("ReadFile", sPtr, hReadPipe, sPtr, &buffer, "UInt", 4096, "UIntP", dwRead, sPtr, 0)
			sOutput .= StrGet(&buffer, dwRead, "CP0")
		}

	DllCall("CloseHandle", sPtr, NumGet(PROCESS_INFORMATION, 0))				 ; hProcess
	DllCall("CloseHandle", sPtr, NumGet(PROCESS_INFORMATION, A_PtrSize)) ; hThread
	DllCall("CloseHandle", sPtr, hReadPipe)
	Return sOutput
	}
