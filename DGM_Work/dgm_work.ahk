#Requires AutoHotkey v2.0
#SingleInstance Force

; Customize tray icon
TraySetIcon("Shell32.dll", 168)
A_IconTip := "Discord Auto-Poster (Inactive)"


; ===== CONFIGURATION FROM INI =====
IniFile := A_ScriptDir "\dgm_work.ini"
Section := "Config"

; Default values
DefaultActivateHotkey := "+^F23" ; Shift+Ctrl+F23
DefaultStatusHotkey := "+^F22"   ; Shift+Ctrl+F22
DefaultEmergencyHotkey := "+^Esc" ; Shift+Ctrl+Esc
DefaultServerID := "1313437447098732594"
DefaultChannelID := "1427795772614901801"
DefaultMaxDelay := "4500000"      ; 75 min in ms
DefaultMinDelay := "3660000"      ; 61 min in ms

; Write defaults if missing
IniWrite(DefaultActivateHotkey, IniFile, Section, "ACTIVATE_TOGGLE_HOTKEY")
IniWrite(DefaultStatusHotkey, IniFile, Section, "STATUS_CHECK_HOTKEY")
IniWrite(DefaultEmergencyHotkey, IniFile, Section, "EMERGENCY_STOP_HOTKEY")
IniWrite(DefaultServerID, IniFile, Section, "SERVER_ID")
IniWrite(DefaultChannelID, IniFile, Section, "CHANNEL_ID")
IniWrite(DefaultMaxDelay, IniFile, Section, "MAX_DELAY_INTERVAL")
IniWrite(DefaultMinDelay, IniFile, Section, "MIN_DELAY_INTERVAL")

; Read config from INI
ActivateHotkey := IniRead(IniFile, Section, "ACTIVATE_TOGGLE_HOTKEY", DefaultActivateHotkey)
StatusHotkey := IniRead(IniFile, Section, "STATUS_CHECK_HOTKEY", DefaultStatusHotkey)
EmergencyHotkey := IniRead(IniFile, Section, "EMERGENCY_STOP_HOTKEY", DefaultEmergencyHotkey)
ServerID := IniRead(IniFile, Section, "SERVER_ID", DefaultServerID)
ChannelID := IniRead(IniFile, Section, "CHANNEL_ID", DefaultChannelID)
MaxInterval := IniRead(IniFile, Section, "MAX_DELAY_INTERVAL", DefaultMaxDelay)
MinInterval := IniRead(IniFile, Section, "MIN_DELAY_INTERVAL", DefaultMinDelay)
ChannelURL := "discord://discord.com/channels/" ServerID "/" ChannelID
Message := "/work"
LoadDelay := 5000
WindowTitle := "Discord"
; ===========================

global ScriptRunning := false


; Custom tray menu
A_TrayMenu.Delete()
A_TrayMenu.Add("Start Script (" ActivateHotkey ")", (*) => ToggleScript())
A_TrayMenu.Add("Stop Script", (*) => StopScript())
A_TrayMenu.Add()
A_TrayMenu.Add("Exit", (*) => ExitApp())

; Update tray icon based on state
UpdateTrayIcon() {
    global ScriptRunning
    if (ScriptRunning) {
        A_IconTip := "Discord Auto-Poster (ACTIVE)"
        TraySetIcon("Shell32.dll", 166)
    } else {
        A_IconTip := "Discord Auto-Poster (Inactive)"
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


; ===== HOTKEYS =====
Hotkey(ActivateHotkey, ToggleScript)
Hotkey(EmergencyHotkey, StopScript)
Hotkey(StatusHotkey, StatusHotkeyHandler)
Hotkey("+^F24", ManualTriggerHandler)

StatusHotkeyHandler() {
    global ScriptRunning
    Status := ScriptRunning ? "RUNNING" : "STOPPED"
    TrayTip("Discord Script", "Script is alive! State: " Status, 2)
}

ManualTriggerHandler() {
    global ScriptRunning
    if (ScriptRunning) {
        TrayTip("Discord Script", "Sending message now...", 1)
        SendDiscordMsg()
    } else {
        TrayTip("Discord Script", "Script is not running. Press " ActivateHotkey " to start.", 1)
    }
}

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
    Send("{Enter}{Enter}")
    
    TrayTip("Discord Script", "Message sent!", 1)
}

; Startup notification
TrayTip("Discord Script", "Loaded! Press Shift+Ctrl+F23 to start.", 3)
ToolTip("Discord Script Ready - Press Shift+Ctrl+F23")
SetTimer(() => ToolTip(), -5000)