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

; Start checking for start time
SetTimer(CheckStartTime, 60000)

CheckStartTime() {
    CurrentTime := FormatTime(, "HH:mm")
    if (CurrentTime = StartTime) {
        SetTimer(CheckStartTime, 0)  ; Turn off this timer
        SendDiscordMsg()              ; Send first message
        ScheduleNextMessage()         ; Schedule with random interval
    }
}

ScheduleNextMessage() {
    ; Generate random interval between min and max
    RandomInterval := Random(MinInterval, MaxInterval)
    
    ; Convert to minutes for display (optional - for debugging)
    Minutes := Round(RandomInterval / 60000, 1)
    
    ; Schedule next message
    SetTimer(SendAndReschedule, RandomInterval)
}

SendAndReschedule() {
    SetTimer(SendAndReschedule, 0)  ; Turn off this timer
    SendDiscordMsg()                 ; Send the message
    ScheduleNextMessage()            ; Schedule next one with new random interval
}

SendDiscordMsg() {
    ; Open Discord channel
    Run(ChannelURL)
    Sleep(LoadDelay)
    
    ; Wait for Discord window to be active (up to 10 seconds)
    try {
        WinWait(WindowTitle, , 10)
        WinActivate(WindowTitle)
        WinWaitActive(WindowTitle, , 5)
    } catch {
        MsgBox("Failed to activate Discord window")
        return
    }
    
    ; Send the message
    Send(Message)
    Sleep(100)  ; Small delay before Enter
    Send("{Enter}")
}