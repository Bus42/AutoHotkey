#Requires AutoHotkey v2.0
#SingleInstance Force

; Customize tray icon
TraySetIcon("Shell32.dll", 168)
A_IconTip := "Discord Auto-Poster (Inactive)"

; ===== CONFIGURATION =====
MinInterval := 3660000               ; 61 minutes in milliseconds
MaxInterval := 4500000               ; 75 minutes in milliseconds
ChannelURL := "discord://discord.com/channels/1313437447098732594/1428411530348724344" ; DGM server, dgm-clockin-clockout channel
Message := "/work"
LoadDelay := 5000                    ; Wait 5 seconds for Discord to load
WindowTitle := "Discord"             ; Window title to verify Discord is active
; ===========================

global ScriptRunning := false

; Custom tray menu

; Remove tray menu controls and set interval for auto-posting
PostInterval := 60000 ; 60 seconds

; Update tray icon based on state
UpdateTrayIcon() {
    global ScriptRunning
    if (ScriptRunning) {
        A_IconTip := "DGM Auto-Poster (ACTIVE)"
        TraySetIcon("Shell32.dll", 166)
    } else {
        A_IconTip := "DGM Auto-Poster (Inactive)"
        TraySetIcon("Shell32.dll", 168)
    }
}

ToggleScript() {
    global ScriptRunning
    if (ScriptRunning) {
        StopScript()
    } else {
        StartScript()
    }
}

StartScript() {
    global ScriptRunning
    ScriptRunning := true
    TrayTip("Discord Script", "Script STARTED - Sending first message now...", 1)
    UpdateTrayIcon()
    
    ; Send first message immediately
    SendDiscordMsg()
    
    ; Schedule the next message with random interval
    ScheduleNextMessage()
}

StopScript() {
    global ScriptRunning
    ScriptRunning := false
    SetTimer(SendAndReschedule, 0)
    TrayTip("Discord Script", "Script STOPPED", 1)
    UpdateTrayIcon()
}


; ===== AUTO STARTUP =====
ScriptRunning := true
TrayTip("Discord Script", "Script STARTED - Sending first message now...", 1)
UpdateTrayIcon()
SendDiscordMsg()
ScheduleNextMessage()

; ===== MAIN FUNCTIONS =====

ScheduleNextMessage() {
    global ScriptRunning
    if (!ScriptRunning)
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
    if (!ScriptRunning)
        return
        
    SetTimer(SendAndReschedule, 0)  ; Turn off this timer
    SendDiscordMsg()                 ; Send the message
    ScheduleNextMessage()            ; Schedule next one with new random interval
}

SendDiscordMsg() {
    global ScriptRunning
    if (!ScriptRunning)
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
    
    ; Send the message (first Enter selects command, second sends it)
    Send(Message)
    Sleep(100)
    Send("{Enter}")
    Sleep(250)
    Send("{Enter}")
    
    TrayTip("Discord Script", "Message sent!", 1)
}

