$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Invoke-RoboCopy {
  param(
    [Parameter(Mandatory = $true)][string]$Source,
    [Parameter(Mandatory = $true)][string]$Destination,
    [string[]]$ExtraArgs = @()
  )

  $argsList = @($Source, $Destination, '/E', '/XD', '.git') + $ExtraArgs
  & robocopy @argsList | Out-Null

  # Robocopy uses bitflag exit codes; <= 7 means success.
  if ($LASTEXITCODE -gt 7) {
    throw "robocopy failed (exit=$LASTEXITCODE): $Source -> $Destination"
  }
}

function Remove-IfExists {
  param([Parameter(Mandatory = $true)][string]$Path)
  if (Test-Path -LiteralPath $Path) {
    Remove-Item -LiteralPath $Path -Force -Recurse
  }
}

$siteRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$twitterSrc = (Resolve-Path -LiteralPath (Join-Path $siteRoot '..\\twitter-simulator-v2-static')).Path
$chSrc = (Resolve-Path -LiteralPath (Join-Path $siteRoot '..\\2ch-generator')).Path

Write-Host "Site root:   $siteRoot"
Write-Host "Twitter src: $twitterSrc"
Write-Host "2ch src:     $chSrc"

# Rebuild publish outputs for apps only.
Remove-IfExists (Join-Path $siteRoot 'twi')
Remove-IfExists (Join-Path $siteRoot '2ch')

New-Item -ItemType Directory -Path (Join-Path $siteRoot 'twi') | Out-Null
Invoke-RoboCopy -Source $twitterSrc -Destination (Join-Path $siteRoot 'twi')

New-Item -ItemType Directory -Path (Join-Path $siteRoot '2ch') | Out-Null
Invoke-RoboCopy -Source $chSrc -Destination (Join-Path $siteRoot '2ch')

# Remove nested domain binding file from app subfolder.
$nestedCname = Join-Path $siteRoot 'twi\\CNAME'
if (Test-Path -LiteralPath $nestedCname) {
  Remove-Item -LiteralPath $nestedCname -Force
}

# Fix cross-app links for aggregated deployment.
$twiIndexPath = Join-Path $siteRoot 'twi\\index.html'
if (Test-Path -LiteralPath $twiIndexPath) {
  $twiIndex = Get-Content -LiteralPath $twiIndexPath -Raw
  $twiIndex = $twiIndex.Replace('href="hub/"', 'href="../"')
  $twiIndex = $twiIndex.Replace('href="2ch/"', 'href="../2ch/"')
  Set-Content -LiteralPath $twiIndexPath -Value $twiIndex -Encoding UTF8
}

$chAppPath = Join-Path $siteRoot '2ch\\js\\app.js'
if (Test-Path -LiteralPath $chAppPath) {
  $chApp = Get-Content -LiteralPath $chAppPath -Raw
  $chApp = $chApp.Replace('<a href="../hub/">Hub</a><span class="sep">|</span><a href="../">Twitter</a>', '<a href="../">入口</a><span class="sep">|</span><a href="../twi/">Twitter</a>')
  Set-Content -LiteralPath $chAppPath -Value $chApp -Encoding UTF8
}

Write-Host 'Done.'