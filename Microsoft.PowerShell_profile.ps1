Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chort Ctrl+RightArrow -Function AcceptNextSuggestionWord
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Adjust colors to fit light theme
Set-PSReadLineOption -Colors @{ InlinePrediction = '#AAAAAA'}
Set-PSReadLineOption -Colors @{ Selection = '#AAAAAA'}
Set-PSReadLineOption -Colors @{ ContinuationPrompt = '#AAAAAA'}
Set-PSReadLineOption -Colors @{ Default = '#000000'}
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

$GitCommands = (git --list-cmds=main,others,alias,nohelpers)
Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  
  $command = $commandAst.ToString()

  $result = Invoke-Command -ScriptBlock {
    if ($command -match "^git add") {
      $addableFiles = git ls-files --others --exclude-standard -m 
      $addableFiles 
    } elseif ($command -match "^git rm") {
      $removableFiles = git ls-files
      $removableFiles 
    } elseif ($command -match "^git restore") {
      $restorableFiles = git ls-files -m
      $restorableFiles 
    } elseif ($command -match "^git (switch|checkout)") {
      $switchableBranches = git branch -a --format "%(refname:lstrip=2)"
      $switchableBranches 
    } elseif ($command -match "^git") {
      $GitCommands
    }
  }

  $result = @($result)
  $result -like "*$wordToComplete*"
}

Set-PSReadLineKeyHandler -Chord Alt+c -ScriptBlock {
  fd -t d | ForEach-Object { $_ } | fzf "--height=40% " | ForEach-Object { Set-Location $_ } 

  $previousOutputEncoding = [Console]::OutputEncoding
  [Console]::OutputEncoding = [Text.Encoding]::UTF8
  
  try {
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  } finally {
    [Console]::OutputEncoding = $previousOutputEncoding
  }
}

