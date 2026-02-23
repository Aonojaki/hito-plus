param(
    [switch]$SkipBuild,
    [switch]$NoInstaller,
    [string]$FlutterExecutable = "flutter"
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[Hito+ Package] $Message"
}

function Get-RelativePathNormalized {
    param(
        [string]$BasePath,
        [string]$TargetPath
    )

    $baseFullPath = (Resolve-Path -Path $BasePath).Path.TrimEnd('\') + '\'
    $targetFullPath = (Resolve-Path -Path $TargetPath).Path
    $baseUri = New-Object System.Uri($baseFullPath)
    $targetUri = New-Object System.Uri($targetFullPath)
    $relativeUri = $baseUri.MakeRelativeUri($targetUri).ToString()
    return [System.Uri]::UnescapeDataString($relativeUri).Replace('\', '/')
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$pubspecPath = Join-Path $repoRoot "pubspec.yaml"
$pubspecContent = Get-Content -Raw $pubspecPath
$versionLine = ($pubspecContent -split "`n" | Where-Object { $_ -match '^version:\s*' } | Select-Object -First 1)
if (-not $versionLine) {
    throw "Could not read version from pubspec.yaml"
}
$appVersion = ($versionLine -replace '^version:\s*', '').Trim()
if ($appVersion -match '\+') {
    $appVersion = $appVersion.Split('+')[0]
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$releaseDir = Join-Path $repoRoot "build\windows\x64\runner\Release"
$distRoot = Join-Path $repoRoot "dist"
$distDir = Join-Path $distRoot ("hito+_{0}_{1}" -f $appVersion, $timestamp)
$zipPath = "$distDir.zip"

if (-not $SkipBuild) {
    Write-Step "Building Windows release..."
    & $FlutterExecutable build windows --release
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter build failed with exit code $LASTEXITCODE"
    }
}

if (-not (Test-Path $releaseDir)) {
    throw "Release directory not found: $releaseDir"
}

Write-Step "Preparing distribution folder: $distDir"
New-Item -ItemType Directory -Force $distDir | Out-Null
Copy-Item (Join-Path $releaseDir "*") $distDir -Recurse -Force

if (-not $NoInstaller) {
    $iscc = $null
    $isccCommand = Get-Command "ISCC.exe" -ErrorAction SilentlyContinue
    if ($isccCommand) {
        $iscc = $isccCommand.Source
    } else {
        $commonPaths = @(
            "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
            "C:\Program Files\Inno Setup 6\ISCC.exe",
            "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
        )
        foreach ($path in $commonPaths) {
            if (Test-Path $path) {
                $iscc = $path
                break
            }
        }
    }

    if ($iscc) {
        Write-Step "Building installer via Inno Setup..."
        $issPath = Join-Path $repoRoot "installer\hito_plus.iss"
        $versionDefine = "/DMyAppVersion=$appVersion"
        $sourceDefine = "/DSourceDir=""$releaseDir"""
        $outputDefine = "/DOutputDir=""$distDir"""
        & $iscc $versionDefine $sourceDefine $outputDefine $issPath
        if ($LASTEXITCODE -ne 0) {
            throw "ISCC failed with exit code $LASTEXITCODE"
        }
    } else {
        Write-Step "ISCC.exe not found; skipped installer build. Install Inno Setup 6 to enable installer output."
    }
}

$packageFiles = Get-ChildItem -Path $distDir -File -Recurse | Sort-Object FullName
$fileEntries = @(
    foreach ($file in $packageFiles) {
        $hash = (Get-FileHash -Algorithm SHA256 -Path $file.FullName).Hash.ToLowerInvariant()
        [PSCustomObject][ordered]@{
            path = Get-RelativePathNormalized -BasePath $distDir -TargetPath $file.FullName
            sizeBytes = [int64]$file.Length
            sha256 = $hash
            lastWriteUtc = $file.LastWriteTimeUtc.ToString("o")
        }
    }
)

$checksumsPath = Join-Path $distDir "checksums.sha256"
$checksumLines = @(
    foreach ($entry in $fileEntries) {
        "$($entry.sha256) *$($entry.path)"
    }
)
$checksumLines | Set-Content -Path $checksumsPath -Encoding ASCII

$totalBytes = ($fileEntries | Measure-Object -Property sizeBytes -Sum).Sum
if ($null -eq $totalBytes) {
    $totalBytes = 0
}

$manifestPath = Join-Path $distDir "release_manifest.json"
$manifest = [ordered]@{
    appName = "Hito+"
    appVersion = $appVersion
    platform = "windows-x64"
    packageTimestamp = $timestamp
    generatedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    fileCount = $fileEntries.Count
    totalBytes = [int64]$totalBytes
    checksumsFile = "checksums.sha256"
    files = $fileEntries
}
$manifest | ConvertTo-Json -Depth 8 | Set-Content -Path $manifestPath -Encoding UTF8

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}
Write-Step "Creating zip package: $zipPath"
Compress-Archive -Path (Join-Path $distDir "*") -DestinationPath $zipPath -CompressionLevel Optimal

$zipShaPath = "$zipPath.sha256"
$zipSha = (Get-FileHash -Algorithm SHA256 -Path $zipPath).Hash.ToLowerInvariant()
"$zipSha *$(Split-Path -Leaf $zipPath)" | Set-Content -Path $zipShaPath -Encoding ASCII

Write-Step "Done"
Write-Host "Dist folder: $distDir"
Write-Host "Zip file:    $zipPath"
Write-Host "Manifest:    $manifestPath"
Write-Host "Checksums:   $checksumsPath"
Write-Host "Zip SHA256:  $zipShaPath"
