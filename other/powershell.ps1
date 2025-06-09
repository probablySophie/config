
# Nicer prompt (especially if running powershell inside WSL)
function prompt{"$((get-date -Format 'HH:mmtt').ToLower()) $([char]27)[93mPS$([char]27)[0m → "}

# Let me run my scripts!!!
# I want to live dangerously
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

# Make sure we're in <tab> menu complete
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# A quality of life q -> exit
function ex{ Invoke-Command { Exit } }
new-alias q ex
