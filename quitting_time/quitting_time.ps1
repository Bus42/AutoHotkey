# Ensure the BurntToast module is loaded
Import-Module BurntToast

# Variables for your notification
$Title = "The Dude abides!"
$Message = "Time to unwind, Dude!"
$Image = "C:\Users\gbrew\Pictures\Stream Deck Screen Savers\Minerva.png" # Change to the path of your image

# Display the toast notification
New-BurntToastNotification -Text $Title, $Message -AppLogo $Image -Sound "Alarm2" -SnoozeAndDismiss
