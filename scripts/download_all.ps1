<#
.SYNOPSIS
    Downloads https://nudge-folio.framer.website/ completely, including all HTML pages,
    JavaScript/React/Framer modules, functions, CSS, fonts, images, SVGs, and JSON indexes.
#>

param(
    [string]$OutputDir = "nudge-folio-site"
)

$targetPath = Join-Path $PSScriptRoot $OutputDir
$assetsDir = Join-Path $targetPath "assets"
$pagesDir = Join-Path $targetPath "pages"
$originalDir = Join-Path $targetPath "site-live-mirrored"
$offlineDir = Join-Path $targetPath "site-offline"

New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null
New-Item -ItemType Directory -Path $pagesDir -Force | Out-Null
New-Item -ItemType Directory -Path $originalDir -Force | Out-Null
New-Item -ItemType Directory -Path $offlineDir -Force | Out-Null

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " NUDGE FOLIO WEBSITE FULL ASSET & CODE DOWNLOADER" -ForegroundColor Cyan
Write-Host " Target directory: $targetPath" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Fetch sitemap
$sitemapUrl = "https://nudge-folio.framer.website/sitemap.xml"
Write-Host "`n[1/4] Fetching sitemap..." -ForegroundColor Yellow
$sitemapXml = curl.exe -s -L $sitemapUrl
$routes = [regex]::Matches($sitemapXml, '<loc>(https://nudge-folio\.framer\.website[^<]*)</loc>') | 
    ForEach-Object { $_.Groups[1].Value.Trim() } | 
    Select-Object -Unique

if ($routes.Count -eq 0) {
    $routes = @("https://nudge-folio.framer.website/")
}

Write-Host "Discovered $($routes.Count) pages in sitemap." -ForegroundColor Green

# Save sitemap and robots.txt
curl.exe -s -L "https://nudge-folio.framer.website/sitemap.xml" -o (Join-Path $targetPath "sitemap.xml")
curl.exe -s -L "https://nudge-folio.framer.website/robots.txt" -o (Join-Path $targetPath "robots.txt")

# Set up tracking collections
$downloadedAssets = [System.Collections.Generic.HashSet[string]]::new()
$assetQueue = [System.Collections.Generic.Queue[string]]::new()
$pageHtmlMap = @{}

# Helper function to sanitize a URL into a safe relative local file path
function Get-LocalAssetRelPath([string]$urlStr) {
    try {
        $uri = [System.Uri]$urlStr
        $hostName = $uri.Host.ToLower()
        $path = $uri.AbsolutePath.TrimStart('/')
        if ([string]::IsNullOrWhiteSpace($path)) {
            $path = "index"
        }
        
        # Strip illegal windows filename characters from path
        $cleanPath = $path -replace '[:\*?"<>|]', '_'
        return "$hostName/$cleanPath"
    } catch {
        $clean = $urlStr -replace 'https?://', '' -replace '[:\*?"<>|]', '_'
        return "other/$clean"
    }
}

# 2. Download all HTML pages
Write-Host "`n[2/4] Downloading all HTML pages..." -ForegroundColor Yellow
foreach ($route in $routes) {
    $uri = [System.Uri]$route
    $path = $uri.AbsolutePath.Trim('/')
    if ([string]::IsNullOrWhiteSpace($path)) {
        $subFolder = ""
        $fileName = "index.html"
    } else {
        $subFolder = $path
        $fileName = "index.html"
    }

    $destFolderOriginal = if ($subFolder) { Join-Path $originalDir $subFolder } else { $originalDir }
    $destFolderOffline = if ($subFolder) { Join-Path $offlineDir $subFolder } else { $offlineDir }
    
    New-Item -ItemType Directory -Path $destFolderOriginal -Force | Out-Null
    New-Item -ItemType Directory -Path $destFolderOffline -Force | Out-Null

    $destFileOriginal = Join-Path $destFolderOriginal $fileName
    $destFileOffline = Join-Path $destFolderOffline $fileName

    Write-Host "  -> Fetching: $route" -ForegroundColor Gray
    curl.exe -s -L $route -o $destFileOriginal

    $htmlContent = Get-Content -Path $destFileOriginal -Raw -Encoding UTF8
    $pageHtmlMap[$route] = $htmlContent

    # Also extract any URLs from this HTML
    # Matches URLs with extensions or framerusercontent / fonts
    $urlMatches = [regex]::Matches($htmlContent, 'https?://[a-zA-Z0-9\-\._~:\/\?#\[\]@!$&''\(\)\*\+,;=%]+') |
        ForEach-Object { $_.Value } |
        Where-Object { 
            $_ -match 'framerusercontent\.com' -or 
            $_ -match 'fonts\.gstatic\.com' -or 
            $_ -match 'fonts\.googleapis\.com' -or
            $_ -match 'events\.framer\.com' -or
            $_ -match '\.(mjs|js|css|woff2|woff|ttf|png|jpg|jpeg|webp|svg|gif|mp4|webm|json)(\?|$)'
        } | Select-Object -Unique

    foreach ($u in $urlMatches) {
        # Clean URL of trailing quotes or brackets
        $cleaned = $u.TrimEnd('"', "'", ')', '>', ';')
        if (-not $downloadedAssets.Contains($cleaned)) {
            $downloadedAssets.Add($cleaned) | Out-Null
            $assetQueue.Enqueue($cleaned)
        }
    }
}

Write-Host "Downloaded $($routes.Count) HTML pages." -ForegroundColor Green
Write-Host "Initial asset queue size: $($assetQueue.Count) items." -ForegroundColor Green

# 3. Recursively download all assets and modules
Write-Host "`n[3/4] Recursively downloading all assets, scripts, modules & functions..." -ForegroundColor Yellow

$assetCount = 0

while ($assetQueue.Count -gt 0) {
    $currentUrl = $assetQueue.Dequeue()
    $assetCount++

    # Calculate local target path
    $relPath = Get-LocalAssetRelPath $currentUrl
    $fullDestPath = Join-Path $assetsDir $relPath
    $parentDir = Split-Path -Parent $fullDestPath
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    $ext = [System.IO.Path]::GetExtension(([System.Uri]$currentUrl).AbsolutePath).ToLower()

    # Download if not already downloaded or if stub
    $isStub = (Test-Path $fullDestPath) -and ((Get-Item $fullDestPath).Length -lt 200)
    if (-not (Test-Path $fullDestPath) -or (Get-Item $fullDestPath).Length -eq 0 -or $isStub) {
        try {
            $ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
            $ref = "https://nudge-folio.framer.website/"
            curl.exe -s -L -H "User-Agent: $ua" -H "Referer: $ref" $currentUrl -o $fullDestPath
        } catch {
            Write-Host "    [!] Failed to download: $currentUrl" -ForegroundColor Red
            continue
        }
    }

    if ($assetCount % 20 -eq 0) {
        Write-Host "  Downloaded $assetCount assets (Queue remaining: $($assetQueue.Count))..." -ForegroundColor Cyan
    }

    # If it's a JS/MJS/CSS/JSON file, inspect it for more imports or asset URLs!
    if ($ext -in @('.mjs', '.js', '.css', '.json')) {
        try {
            $code = Get-Content -Path $fullDestPath -Raw -Encoding UTF8
            $currentUri = [System.Uri]$currentUrl
            $baseUriStr = $currentUrl.Substring(0, $currentUrl.LastIndexOf('/') + 1)

            # Match relative imports: import ... from "./foo.mjs" or import("./foo.mjs")
            $relImports = [regex]::Matches($code, '[\"''`]((\.\.?\/)[^\"''`\r\n]+?\.(mjs|js|woff2|png|jpg|webp|svg|css))[\"''`]') |
                ForEach-Object { $_.Groups[1].Value } |
                Select-Object -Unique

            foreach ($rel in $relImports) {
                try {
                    $resolved = [System.Uri]::new($currentUri, $rel).AbsoluteUri
                    if (-not $downloadedAssets.Contains($resolved)) {
                        $downloadedAssets.Add($resolved) | Out-Null
                        $assetQueue.Enqueue($resolved)
                    }
                } catch {}
            }

            # Match full URLs inside code:
            $codeUrls = [regex]::Matches($code, 'https?://[a-zA-Z0-9\-\._~:\/\?#\[\]@!$&''\(\)\*\+,;=%]+') |
                ForEach-Object { $_.Value } |
                Where-Object {
                    $_ -match 'framerusercontent\.com' -or 
                    $_ -match 'fonts\.gstatic\.com' -or 
                    $_ -match 'fonts\.googleapis\.com' -or
                    $_ -match '\.(mjs|js|css|woff2|woff|ttf|png|jpg|jpeg|webp|svg|gif|mp4|webm|json)(\?|$)'
                } | Select-Object -Unique

            foreach ($cu in $codeUrls) {
                $cleaned = $cu.TrimEnd('"', "'", ')', '>', ';', '`', '\')
                if (-not $downloadedAssets.Contains($cleaned)) {
                    $downloadedAssets.Add($cleaned) | Out-Null
                    $assetQueue.Enqueue($cleaned)
                }
            }
        } catch {}
    }
}

Write-Host "All assets downloaded! Total assets downloaded: $assetCount" -ForegroundColor Green

# 4. Generate the offline-ready version
Write-Host "`n[4/4] Generating offline-capable site..." -ForegroundColor Yellow

# Helper to calculate relative path between two directories
function Get-RelativePath([string]$fromDir, [string]$toDir) {
    $fromUri = [System.Uri]((Get-Item $fromDir).FullName.TrimEnd('\') + '\')
    $toUri = [System.Uri]((Get-Item $toDir).FullName.TrimEnd('\') + '\')
    $relative = $fromUri.MakeRelativeUri($toUri).ToString()
    return $relative.Replace('\', '/')
}

# In each page HTML for site-offline, rewrite asset URLs to point to local assets
foreach ($route in $routes) {
    $uri = [System.Uri]$route
    $path = $uri.AbsolutePath.Trim('/')
    $subFolder = if ([string]::IsNullOrWhiteSpace($path)) { "" } else { $path }
    $pageDir = if ($subFolder) { Join-Path $offlineDir $subFolder } else { $offlineDir }
    if (-not (Test-Path $pageDir)) {
        New-Item -ItemType Directory -Path $pageDir -Force | Out-Null
    }
    $pageFile = Join-Path $pageDir "index.html"

    # Compute relative path from pageDir to assetsDir
    # e.g., for root: "./assets/", for /about: "../assets/", for /blog/xxx: "../../assets/"
    $depth = if ([string]::IsNullOrWhiteSpace($path)) { 0 } else { ($path -split '/').Count }
    $relPrefix = if ($depth -eq 0) { "./assets/" } else { ("../" * $depth) + "assets/" }

    $srcDir = if ($subFolder) { Join-Path $originalDir $subFolder } else { $originalDir }
    $srcFile = Join-Path $srcDir "index.html"
    $html = Get-Content -Path $srcFile -Raw -Encoding UTF8

    # Replace known asset URLs with relative path
    foreach ($assetUrl in $downloadedAssets) {
        $localRel = Get-LocalAssetRelPath $assetUrl
        $offlineAssetPath = $relPrefix + $localRel
        $html = $html.Replace($assetUrl, $offlineAssetPath)
    }

    # Also rewrite framerusercontent.com base URLs if any remain
    $html = [regex]::Replace($html, 'https://framerusercontent\.com/', "${relPrefix}framerusercontent.com/")
    $html = [regex]::Replace($html, 'https://fonts\.gstatic\.com/', "${relPrefix}fonts.gstatic.com/")

    Set-Content -Path $pageFile -Value $html -Encoding UTF8
}

# Copy assets folder into site-offline so site-offline is self-contained!
Write-Host "Linking / copying assets into site-offline folder..." -ForegroundColor Gray
$offlineAssetsDest = Join-Path $offlineDir "assets"
if (Test-Path $offlineAssetsDest) {
    Remove-Item -Path $offlineAssetsDest -Recurse -Force | Out-Null
}
Copy-Item -Path $assetsDir -Destination $offlineAssetsDest -Recurse -Force

# Create summary report
$allFiles = Get-ChildItem -Path $assetsDir -Recurse -File
$fileStats = $allFiles | Group-Object Extension | Sort-Object Count -Descending

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " DOWNLOAD COMPLETE!" -ForegroundColor Green
Write-Host " Total unique assets downloaded: $($allFiles.Count)" -ForegroundColor Green
$fileStats | Format-Table Count, Name -AutoSize | Out-String | Write-Host -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Green
