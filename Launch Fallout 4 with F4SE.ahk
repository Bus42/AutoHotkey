#Requires AutoHotkey v2.0

; Launch Steam
Run "C:\Gaming\Steam\steam.exe"

; Wait for the Steam window to be active
WinWaitActive "Steam"

; Minimize the Steam window
WinMinimize "Steam"

; Launch Fallout 4 via F4SELoader
Run "C:\Gaming\Steam\steamapps\common\Fallout 4\f4se_loader.exe"

; Wait for Fallout 4 window to appear
WinWaitActive "Fallout4"
