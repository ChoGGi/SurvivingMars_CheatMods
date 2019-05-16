#NoEnv
#KeyHistory 0
#NoTrayIcon
#SingleInstance Force
SetBatchLines -1
ListLines Off
AutoTrim Off
Process Priority,,N

SetWorkingDir %A_ScriptDir%

Loop Files,*,D
	{
	FileDelete %A_LoopFileName%\Pack\ModContent.hpk
	FileRemoveDir %A_LoopFileName%\Pack
	FileDelete ModContent.hpk
	RunWait hpk.exe create --cripple-lua-files "%A_LoopFileName%" ModContent.hpk
	FileCreateDir %A_LoopFileName%\Pack
	FileMove ModContent.hpk, %A_LoopFileName%\Pack\ModContent.hpk
	}
FileDelete ModContent.hpk

SoundPlay %A_WinDir%\Media\notify.wav,Wait
