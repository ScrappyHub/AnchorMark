param(
  [Parameter(Mandatory=$false)][string]$RepoRoot = "C:\dev\anchormark",
  [Parameter(Mandatory=$false)][string]$RuntimeRoot = "",
  [Parameter(Mandatory=$false)][int]$TimeoutSeconds = 30
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Die([string]$m){ throw $m }
function Ok([string]$m){ Write-Host $m -ForegroundColor Green }
function Warn([string]$m){ Write-Host $m -ForegroundColor Yellow }

function EnsureDir([string]$p){
  if([string]::IsNullOrWhiteSpace($p)){ return }
  if(-not (Test-Path -LiteralPath $p -PathType Container)){
    New-Item -ItemType Directory -Force -Path $p | Out-Null
  }
}

function Write-Utf8NoBomLf([string]$Path,[string]$Text){
  $enc = New-Object System.Text.UTF8Encoding($false)
  $dir = Split-Path -Parent $Path
  if($dir){ EnsureDir $dir }
  $t = $Text -replace "`r`n","`n"
  $t = $t -replace "`r","`n"
  if(-not $t.EndsWith("`n")){ $t += "`n" }
  [System.IO.File]::WriteAllText($Path,$t,$enc)
  if(-not (Test-Path -LiteralPath $Path -PathType Leaf)){ Die ("WRITE_FAILED: " + $Path) }
}

function Parse-GateFile([string]$Path){
  if(-not (Test-Path -LiteralPath $Path -PathType Leaf)){ Die ("PARSEGATE_MISSING: " + $Path) }
  [void][ScriptBlock]::Create((Get-Content -Raw -LiteralPath $Path -Encoding UTF8))
}

function Run-Exe-Capture(
  [string]$Exe,
  [string[]]$ArgList,
  [string]$StdoutPath,
  [string]$StderrPath,
  [int]$TimeoutSec
){
  if(-not (Get-Command $Exe -ErrorAction SilentlyContinue)){ Die ("EXE_NOT_FOUND: " + $Exe) }

  EnsureDir (Split-Path -Parent $StdoutPath)
  EnsureDir (Split-Path -Parent $StderrPath)

  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $Exe
  $psi.UseShellExecute = $false
  $psi.CreateNoWindow = $true
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError  = $true
  $psi.RedirectStandardInput  = $true

  $quoted = New-Object System.Collections.Generic.List[string]
  foreach($a in @($ArgList)){
    if($null -eq $a){
      continue
    }
    elseif($a.Length -eq 0){
      [void]$quoted.Add('""')
    }
    elseif($a -match '[\s"]'){
      $q = $a.Replace('"','\"')
      [void]$quoted.Add('"' + $q + '"')
    }
    else{
      [void]$quoted.Add($a)
    }
  }
  $psi.Arguments = ($quoted.ToArray() -join " ")

  $p = New-Object System.Diagnostics.Process
  $p.StartInfo = $psi
  $null = $p.Start()
  try { $p.StandardInput.Close() } catch {}

  $deadline = [DateTime]::UtcNow.AddSeconds([double]$TimeoutSec)
  while(-not $p.HasExited){
    if([DateTime]::UtcNow -gt $deadline){
      try { $p.Kill() } catch {}
      $stdoutKilled = $p.StandardOutput.ReadToEnd()
      $stderrKilled = $p.StandardError.ReadToEnd()
      Write-Utf8NoBomLf $StdoutPath $stdoutKilled
      Write-Utf8NoBomLf $StderrPath $stderrKilled
      return @{
        exit = 124
        killed = $true
        args = $psi.Arguments
      }
    }
    Start-Sleep -Milliseconds 100
  }

  $stdout = $p.StandardOutput.ReadToEnd()
  $stderr = $p.StandardError.ReadToEnd()
  Write-Utf8NoBomLf $StdoutPath $stdout
  Write-Utf8NoBomLf $StderrPath $stderr

  return @{
    exit = [int]$p.ExitCode
    killed = $false
    args = $psi.Arguments
  }
}

if(-not (Test-Path -LiteralPath $RepoRoot -PathType Container)){ Die ("REPO_ROOT_MISSING: " + $RepoRoot) }
$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path

if([string]::IsNullOrWhiteSpace($RuntimeRoot)){
  $RuntimeRoot = Join-Path $RepoRoot "_runtime_local"
}
EnsureDir $RuntimeRoot
$RuntimeRoot = (Resolve-Path -LiteralPath $RuntimeRoot).Path

$SignPath = Join-Path $RepoRoot "src\nfl\Sign.ps1"
if(-not (Test-Path -LiteralPath $SignPath -PathType Leaf)){ Die ("SIGN_PS1_MISSING: " + $SignPath) }
Parse-GateFile $SignPath

$stamp = [DateTime]::UtcNow.ToString("yyyyMMdd_HHmmss")
$LogRoot = Join-Path $RepoRoot ("proofs\receipts\anchormark_keygen_probe_v1\" + $stamp)
EnsureDir $LogRoot

$KeyDir = Join-Path $RuntimeRoot "keys"
EnsureDir $KeyDir
$ProbeKey = Join-Path $KeyDir ("anchormark_probe_ed25519_" + $stamp)

$stdout = Join-Path $LogRoot "probe_stdout.log"
$stderr = Join-Path $LogRoot "probe_stderr.log"
$argsTxt = Join-Path $LogRoot "probe_args.txt"

$r = Run-Exe-Capture -Exe "ssh-keygen" -ArgList @('-q','-t','ed25519','-f',$ProbeKey,'-N','') -StdoutPath $stdout -StderrPath $stderr -TimeoutSec $TimeoutSeconds

Write-Utf8NoBomLf $argsTxt ($r.args + "`n")

Warn ("PROBE_ARGS=" + $r.args)
Warn ("PROBE_EXIT=" + $r.exit)
Warn ("PROBE_KILLED=" + $r.killed)
Warn ("PROBE_LOGROOT=" + $LogRoot)

if($r.exit -eq 124){ Die ("PROBE_TIMEOUT logs=" + $LogRoot) }
if($r.exit -ne 0){ Die ("PROBE_EXIT_NONZERO exit=" + $r.exit + " logs=" + $LogRoot) }

if(-not (Test-Path -LiteralPath $ProbeKey -PathType Leaf)){ Die ("PROBE_KEY_NOT_CREATED: " + $ProbeKey) }
if(-not (Test-Path -LiteralPath ($ProbeKey + ".pub") -PathType Leaf)){ Die ("PROBE_PUB_NOT_CREATED: " + ($ProbeKey + ".pub")) }

Ok ("PROBE_KEYGEN_OK priv=" + $ProbeKey)
Write-Output $LogRoot
