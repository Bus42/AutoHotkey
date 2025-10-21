# Discord MEE6 Auto-Posting Script

This script automates sending the `/work` command to a specified Discord channel at random intervals, helping you maximize MEE6 work rewards. You can use it by running the provided `.ahk` script or by unzipping and running the included `.zip` package.

## Features
- Configurable hotkeys and Discord channel/server IDs via `dgm_work.ini`
- Tray menu controls for starting, stopping, and exiting
- Randomized delay between messages (default: 61–75 minutes)
- Manual trigger and status check hotkeys
- Opens Discord, activates the correct channel, and sends the message as if typed by the user
- No Discord API or bot token required—works by simulating user input

## Getting Started

### Option 1: Run the .ahk Script
1. Make sure you have AutoHotkey v2 installed: https://www.autohotkey.com/
2. Edit `dgm_work.ini` to set your Discord server/channel IDs and preferred hotkeys.
3. Double-click `dgm_work.ahk` to start the script.
4. Use the tray icon or hotkeys to control the script.

### Option 2: Use the .zip Package
1. Unzip the provided `.zip` file to a folder of your choice.
2. Edit `dgm_work.ini` to set your Discord server/channel IDs and preferred hotkeys.
3. Run the included executable (`dgm_work.exe`)

## Configuration
Edit `dgm_work.ini` to change:
- `ACTIVATE_TOGGLE_HOTKEY` — Start/stop hotkey
- `STATUS_CHECK_HOTKEY` — Status check hotkey
- `EMERGENCY_STOP_HOTKEY` — Emergency stop hotkey
- `SERVER_ID` — Discord server ID
- `CHANNEL_ID` — Discord channel ID
- `MAX_DELAY_INTERVAL` — Maximum delay between messages (ms)
- `MIN_DELAY_INTERVAL` — Minimum delay between messages (ms)

## Usage
- Start the script using the tray menu or hotkey.
- The script will open Discord, activate the specified channel, and send `/work` at random intervals.
- You can manually trigger a message or check status using hotkeys.
- Stop the script at any time using the tray menu or hotkey.

## Notes
- The script simulates user input and requires the Discord desktop app to be installed and logged in.
- Make sure `dgm_work.ini` is in the same folder as the script or executable.
- You can recompile the script to `.exe` using AHK2EXE if desired.

## Troubleshooting
- If the script fails to send messages, check your hotkey and channel/server ID settings in `dgm_work.ini`.
- Ensure Discord is running and accessible.
- For compilation errors, use named functions for hotkey handlers (already implemented).

## License
MIT License
