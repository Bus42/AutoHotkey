#Requires AutoHotkey v2.0

^!F22:: ; Ctrl-Alt-F22
    {
        Run "powershell.exe -command Start-Service -Name sshd"
        return
    }

+!F22:: ; Shift-Alt-F22
    {
        ; Define a temporary file path
        local tempFilePath := A_Temp . "\sshd_status.txt"
        ; Correctly format the command with proper escaping for quotes and concatenation
        local command := "powershell.exe -NoProfile -Command ""Get-Service sshd | Select-Object -ExpandProperty Status > '" tempFilePath "'"""
        RunWait(command)
        ; Read the output from the file
        local output := FileRead(tempFilePath)
        ; Display the output as a text string in a tooltip
        ToolTip "sshd service status: " output
        SetTimer "RemoveToolTip", -5000 ; Display tooltip for 5 seconds
        ; Delete the temporary file
        FileDelete(tempFilePath)
        return
    }

RemoveToolTip:
    {
        ToolTip "" ; Clears the tooltip when the timer expires
        return
    }

^+!F22:: ; Ctrl-Shift-Alt-F22
    {
        Run "powershell.exe -command Stop-Service -Name sshd"
        return
    }
