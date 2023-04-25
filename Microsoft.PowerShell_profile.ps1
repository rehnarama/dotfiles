Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource HistoryAndPlugin 
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward   
Set-PSReadLineKeyHandler -Chord "Ctrl+n" -Function NextHistory
Set-PSReadLineKeyHandler -Chord "Ctrl+p" -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Adjust colors to fit light theme
Set-PSReadLineOption -Colors @{ InlinePrediction = '#AAAAAA'}
Set-PSReadLineOption -Colors @{ Selection = '#AAAAAA'}
Set-PSReadLineOption -Colors @{ Member = "$([char]0x1b)[94m" }
Set-PSReadLineOption -Colors @{ Number = "$([char]0x1b)[94m" }
(Get-PSReadLineOption).ListPredictionSelectedColor = "$([char]0x1b)[48;2;189;189;189m"
(Get-PSReadLineOption).DefaultTokenColor = "$([char]0x1b)[90m"

$env:VISUAL='nvim'
$env:EDITOR='nvim'

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

if (Test-Path "C:\Users\v-astridrehn\.jabba\jabba.ps1") { . "C:\Users\v-astridrehn\.jabba\jabba.ps1" }

Import-Module PSFzf
Set-PSReadLineKeyHandler -Chord "alt+c" -ScriptBlock { 
  fd -t d | Invoke-Fzf | Set-Location
  InvokePrompt
}
function InvokePrompt()
{
	$previousOutputEncoding = [Console]::OutputEncoding
	[Console]::OutputEncoding = [Text.Encoding]::UTF8
	
	try {
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
	} finally {
		[Console]::OutputEncoding = $previousOutputEncoding
	}
}

function Clean-LocalBranches() {
  git switch main
  git fetch --prune
  $remoteBranches = git branch -l -r --format "%(refname:lstrip=3)"
  $localBranches = git branch -l --format "%(refname:lstrip=2)"

  $difference = Compare-Object -ReferenceObject $localBranches -DifferenceObject $remoteBranches | Where-Object { $_.SideIndicator -eq "<=" } | ForEach-Object { $_.InputObject }

  Write-Output "Will delete the following local branches:"
  Write-Output $difference
  $confirmation = Read-Host "Are you Sure You Want To Proceed (y/n)"
  if ($confirmation -eq 'y') {
    $difference | ForEach-Object { git branch -D $_ }
  } else {
      Write-Output "No action taken"
  }
}

function Get-Hash {
  param (
    [string]
    $Input,
    [ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
    $Algorithm = 'MD5'
  )

  $stringAsStream = [System.IO.MemoryStream]::new()
  $writer = [System.IO.StreamWriter]::new($stringAsStream)
  $writer.write($Input)
  $writer.Flush()
  $stringAsStream.Position = 0

  Get-FileHash -InputStream $stringAsStream -Algorithm $Algorithm 
    | Select -Property Algorithm, Hash
}

function ConvertFrom-Base64 {
  param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string[]]
    $Text
  )

  Process {
    [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($Text))
  }
}

function ConvertTo-Base64 {
  param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string[]]
    $Text
  )

  Process {
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
    [Convert]::ToBase64String($Bytes)
  }
}

$env:BAT_THEME="OneHalfLight"

function Invoke-Starship-PreCommand {
  $host.ui.Write("`e]0; PS> $env:USERNAME@USERNAME@$env:COMPUTERNAME`: $pwd `a")

  if (Test-Path .nvmrc) {
    Set-NodeVersion
  }
}

Invoke-Expression (&starship init powershell)

Register-GitCompletion



if ($IsLinux) {
  Set-Alias ls Get-ChildItem
  Set-Alias rm Remove-Item
  Set-Alias cp Copy-Item
  Set-Alias mv Move-Item
}

