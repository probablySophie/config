# Let me run my scripts!!!
# I want to live dangerously
$_pol = Get-ExecutionPolicy;
if ( ( $_pol -ne "Bypass" ) -and ( $_pol -ne "Unrestricted" ) ) {
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
}

# Having tab show all of the options
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# A quality of life q -> exit
function Quit { Invoke-command -ScriptBlock {exit} }
Set-Alias -Name q -Value Quit

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_prompts
function prompt {
    # "hostname drive: current_folder> "
    "$( $ENV:COMPUTERNAME ) $( (get-date -Format 'HH:mmtt').ToLower() ) `n$(
        $ExecutionContext.SessionState.Path.CurrentLocation.Drive.Name
    ): $(
        $ExecutionContext.SessionState.Path.CurrentLocation.Path.Split('\')[-1]
    )> " 
}
# # Nicer prompt (especially if running powershell inside WSL)
# function prompt{"$((get-date -Format 'HH:mmtt').ToLower()) $([char]27)[93mPS$([char]27)[0m → "}

# A little welcome
if ( [System.Environment]::UserInteractive ) {
    Write-Output "Hello :)"
    $_=[string](quser) -match "(\d+/\d+/\d+) (\d+.\d+ \w\w)";
    Write-Output "Logon time: $($matches[2]) $($matches[1])";

    if ( ( Get-Command edit -ErrorAction Ignore ) -ne $null ) { SetAlias -Name e -Value edit }
}
