
Invoke-Expression (&starship init powershell)

# Set vi mode
Set-PSReadLineOption -EditMode Vi
$env:VISUAL='nvim'
# Changes cursor depending on PSReadLines Vi Mode
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange
Write-Host -NoNewLine "`e[5 q"

# Must be set after Vi mode
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineOption -PredictionSource History 
