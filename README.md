# Bus42's AHK Scripts

I just wiped out my old scripts to start fresh and give the repo a new structure. I've only got one for now, but I'll add more.

## Discord MEE6 Work Script

This AutoHotkey v2 script automates sending the `/work` command to a specified Discord channel at random intervals (1 hour + configured delay). It is designed to interact with the MEE6 bot for work rewards. The script features:

- Configurable hotkeys and Discord channel/server IDs via an `.ini` file
- Tray menu controls for starting, stopping, and exiting
- Randomized delay between messages (default: 61–75 minutes)
- Manual trigger and status check hotkeys
- Opens Discord, activates the correct channel, and sends the message as if typed by the user
- No Discord API or bot token required—works by simulating user input

Edit `dgm_work.ini` to change hotkeys, intervals, or Discord channel/server IDs without modifying the script itself.

For convenience, I've included a .zip file containing the ahk script converted to an .exe file. This will simplify launching with Stream Deck, G-Keys, or any many other methods.

