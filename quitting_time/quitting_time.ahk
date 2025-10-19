#Requires AutoHotkey v2.0

; This script triggers when F13 is pressed.
; F13 is not on the keyboard. This script is intended
; to be used with a programmable input device like a
; Stream Deck or a gaming mouse.
F13::
    {
        Run "powershell -ExecutionPolicy Bypass -File C:\Users\gbrew\OneDrive\Documents\AutoHotkey\quitting_time\quitting_time.ps1"
    }
return

