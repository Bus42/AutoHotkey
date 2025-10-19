#Requires AutoHotkey v2.0
#SingleInstance Force

; ===== CONFIGURATION =====
StartTime := "00:00"                 ; 24-hour format (midnight)
MinInterval := 3660000               ; 61 minutes in milliseconds
MaxInterval := 4500000               ; 75 minutes in milliseconds
ChannelURL := "discord://discord.com/channels/1313437447098732594/1357356263763214529"
Message := "/work"
LoadDelay := 5000                    ; Wait 5 seconds for Discord to load
WindowTitle := "Discord"             ; Window title to verify Discord is active
; ===========================

#Requires AutoHotkey v2.0
#SingleInstance Force

; ===== CONFIGURATION =====
; ... your configuration here ...

; Startup notification
TrayTip("Discord Script", "Script loaded! Press Shift+Ctrl+F23 to start.", 3)
ToolTip("Discord Script Ready - Press Shift+Ctrl+F23")
SetTimer(() => ToolTip(), -5000)  ; Clear after 5 seconds

; Global state variable
global ScriptRunning := false

; ===== HOTKEYS =====
; Toggle script on/off with Shift+Ctrl+F23
+^F23:: {
    global ScriptRunning
    
    if (ScriptRunning) {
        ; Stop the script
        ScriptRunning := false
        SetTimer(CheckStartTime, 0)
        SetTimer(SendAndReschedule, 0)
        TrayTip("Discord Script", "Script STOPPED", 1)
        ToolTip("Discord Script: STOPPED")
        SetTimer(() => ToolTip(), -3000)  ; Clear tooltip after 3 seconds
    } else {
        ; Start the script
        ScriptRunning := true
        SetTimer(CheckStartTime, 60000)
        TrayTip("Discord Script", "Script STARTED - Waiting for " StartTime, 1)
        ToolTip("Discord Script: STARTED")
        SetTimer(() => ToolTip(), -3000)
    }
}

; Emergency stop with Shift+Ctrl+Esc (alternative hotkey)
+^Esc:: {
    global ScriptRunning
    ScriptRunning := false
    SetTimer(CheckStartTime, 0)
    SetTimer(SendAndReschedule, 0)
    TrayTip("Discord Script", "EMERGENCY STOP", 1)
    ToolTip("Discord Script: EMERGENCY STOPPED")
    SetTimer(() => ToolTip(), -3000)
}

; Manual trigger with Shift+Ctrl+F24 (sends message immediately)
+^F24:: {
    global ScriptRunning
    if (ScriptRunning) {
        TrayTip("Discord Script", "Sending message now...", 1)
        SendDiscordMsg()
    } else {
        TrayTip("Discord Script", "Script is not running. Press Shift+Ctrl+F23 to start.", 1)
    }
}
; ===========================

CheckStartTime() {
    global ScriptRunning
    if (!ScriptRunning)  ; Don't proceed if script was stopped
        return
        
    CurrentTime := FormatTime(, "HH:mm")
    if (CurrentTime = StartTime) {
        SetTimer(CheckStartTime, 0)  ; Turn off this timer
        SendDiscordMsg()              ; Send first message
        ScheduleNextMessage()         ; Schedule with random interval
    }
}

ScheduleNextMessage() {
    global ScriptRunning
    if (!ScriptRunning)  ; Don't schedule if script was stopped
        return
    
    ; Generate random interval between min and max
    RandomInterval := Random(MinInterval, MaxInterval)
    
    ; Convert to minutes for display
    Minutes := Round(RandomInterval / 60000, 1)
    NextTime := FormatTime(DateAdd(A_Now, RandomInterval // 1000, "Seconds"), "HH:mm:ss")
    
    TrayTip("Discord Script", "Next message at: " NextTime " (" Minutes " min)", 1)
    
    ; Schedule next message
    SetTimer(SendAndReschedule, RandomInterval)
}

SendAndReschedule() {
    global ScriptRunning
    if (!ScriptRunning)  ; Don't proceed if script was stopped
        return
        
    SetTimer(SendAndReschedule, 0)  ; Turn off this timer
    SendDiscordMsg()                 ; Send the message
    ScheduleNextMessage()            ; Schedule next one with new random interval
}

SendDiscordMsg() {
    global ScriptRunning
    if (!ScriptRunning)  ; Don't send if script was stopped
        return
    
    ; Open Discord channel
    Run(ChannelURL)
    Sleep(LoadDelay)
    
    ; Wait for Discord window to be active (up to 10 seconds)
    try {
        WinWait(WindowTitle, , 10)
        WinActivate(WindowTitle)
        WinWaitActive(WindowTitle, , 5)
    } catch {
        TrayTip("Discord Script", "Failed to activate Discord window", 1)
        return
    }
    
    ; Send the message
    Send(Message)
    Sleep(100)  ; Small delay before Enter
    Send("{Enter}")
    
    TrayTip("Discord Script", "Message sent!", 1)
}