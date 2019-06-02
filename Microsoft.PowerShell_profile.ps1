function GitUntracked {
  $Raw = git ls-files --other --exclude-standard 2>$null
  $Raw.Length -gt 0
}
function GitBranch {
  $Branch = git symbolic-ref --short HEAD 2>$null
  if ($Branch.Length -eq 0) {
    ""
  } else {
    $Branch
  }
}
function GitUnchanged {
  $Raw = git ls-files -m 2>$null
  $Raw.Length -gt 0
}

function Wrap {
  if ($args.Length -eq 0) {
    ""
  } else {
    $JoinedArgs = $args -join ", "
    "(${JoinedArgs})"
  }
}

function GetParenthesis {
  $ToWrap = @()

  $Branch = GitBranch
  if ($Branch.Length -gt 0) {
    $ToWrap += $Branch
  }
  #$Untracked = GitUntracked
  #if ($Untracked) {
  #  $ToWrap += "+"
  #}
  #$Unchanged = GitUnchanged
  #if ($Unchanged) {
  #  $ToWrap += "*"
  #}

  Wrap @ToWrap
}

function GetCWD {
  $Path = (Get-Location).Path
  if ($Path.StartsWith($Home)) {
    $Path = "~" + $Path.Substring($Home.Length)
  }
  $Path
}

function Prompt {
  $Esc = [char]27
  $Yellow = "$Esc[33m"
  $Magenta = "$Esc[35m"
  $Green = "$Esc[32m"
  $R = "$Esc[39;49m"

  $User = $env:UserName
  $HostName = hostname
  $CWD = GetCWD
  $Parenthesis = GetParenthesis

  "${Yellow}${User}${R} at ${Magenta}${HostName}${R} in ${Green}${CWD} ${R}${Parenthesis}`n➡ "
}
Set-PSReadLineOption -EditMode "Vi"
