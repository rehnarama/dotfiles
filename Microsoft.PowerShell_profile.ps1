Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Adjust colors to fit light theme
Set-PSReadLineOption -Colors @{ InlinePrediction = '#AAAAAA'}
Set-PSReadLineOption -Colors @{ Selection = '#AAAAAA'}
Set-PSReadLineOption -Colors @{ Member = "$([char]0x1b)[94m" }
Set-PSReadLineOption -Colors @{ Number = "$([char]0x1b)[94m" }

$env:VISUAL='nvim'

Invoke-Expression (&starship init powershell)

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


#you have to put this in $profile or $profile.currentuserallhosts
$esc = [char]27

if($env:WT_SESSION){
	$prevprompt = $Function:prompt
	function prompt {
		if ($pwd.provider.name -eq "FileSystem") {
			$p = $pwd.ProviderPath
			Write-host "$esc]9;9;`"$p`"$esc\" -NoNewline
		}
		return $prevprompt.invoke()
	}
}

Set-Alias ".." "cd.."
