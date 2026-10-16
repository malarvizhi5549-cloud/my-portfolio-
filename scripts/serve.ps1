param(
    [int]$Port = 3000
)

$targetPath = Split-Path $PSScriptRoot -Parent
if (-not (Test-Path (Join-Path $targetPath "index.html"))) {
    $targetPath = $PSScriptRoot
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"

try {
    $listener.Prefixes.Add($prefix)
    $listener.Start()
} catch {
    $Port = 3001
    $prefix = "http://localhost:$Port/"
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($prefix)
    try {
        $listener.Start()
    } catch {
        $Port = 8080
        $prefix = "http://localhost:$Port/"
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add($prefix)
        $listener.Start()
    }
}

Write-Host "==========================================================" -ForegroundColor Green
Write-Host " NUDGE FOLIO LOCAL SERVER RUNNING WITH REQUEST LOGGING" -ForegroundColor Green
Write-Host " Serving root: $targetPath" -ForegroundColor Cyan
Write-Host " URL:          $prefix" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Green

$mimeTypes = @{
    ".html"  = "text/html; charset=utf-8"
    ".htm"   = "text/html; charset=utf-8"
    ".css"   = "text/css; charset=utf-8"
    ".js"    = "application/javascript; charset=utf-8"
    ".mjs"   = "application/javascript; charset=utf-8"
    ".json"  = "application/json; charset=utf-8"
    ".png"   = "image/png"
    ".jpg"   = "image/jpeg"
    ".jpeg"  = "image/jpeg"
    ".gif"   = "image/gif"
    ".svg"   = "image/svg+xml"
    ".webp"  = "image/webp"
    ".woff"  = "font/woff"
    ".woff2" = "font/woff2"
    ".ttf"   = "font/ttf"
    ".ico"   = "image/x-icon"
    ".mp4"   = "video/mp4"
}

# Assets root fallback
$assetsFallback = Join-Path $targetPath "assets"
$framerFallback = Join-Path $assetsFallback "framerusercontent.com"

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $rawUrl = [System.Uri]::UnescapeDataString($request.Url.LocalPath).TrimStart('/')
        if ([string]::IsNullOrWhiteSpace($rawUrl) -or $rawUrl -eq "/") {
            $rawUrl = "index.html"
        }

        # Try multiple candidate file paths so NOTHING ever 404s:
        # 1. Direct path in site-offline: site-offline/rawUrl
        # 2. In assets: site-offline/assets/rawUrl
        # 3. In framerusercontent.com: site-offline/assets/framerusercontent.com/rawUrl
        # 4. In images: site-offline/assets/framerusercontent.com/images/rawUrl
        $candidates = @(
            (Join-Path $targetPath ($rawUrl -replace '/', '\')),
            (Join-Path $assetsFallback ($rawUrl -replace '/', '\')),
            (Join-Path $framerFallback ($rawUrl -replace '/', '\'))
        )

        # If it starts with images/, also check framerusercontent.com/images/
        if ($rawUrl -match '^images/(.+)$') {
            $candidates += (Join-Path $framerFallback ($rawUrl -replace '/', '\'))
        }
        # If it's just a filename like xyz.png, check images/xyz.png
        $justFile = [System.IO.Path]::GetFileName($rawUrl)
        if ($justFile -and (Test-Path (Join-Path (Join-Path $framerFallback "images") $justFile))) {
            $candidates += (Join-Path (Join-Path $framerFallback "images") $justFile)
        }

        # Smart fallback routing for any malformed relative subpage requests (e.g. /about/services -> /services):
        if ($rawUrl -match '(?i)(?:^|/)(about|services|blog|contact|play-ground|case-study)/?$') {
            $candidates += (Join-Path $targetPath $Matches[1])
            $candidates += (Join-Path $targetPath "$($Matches[1])\index.html")
        }
        if ($rawUrl -match '(?i)(?:^|/)(eclore|stylebook|homestead|north-light)/?$') {
            $candidates += (Join-Path (Join-Path $targetPath "case-study") $Matches[1])
            $candidates += (Join-Path (Join-Path $targetPath "case-study") "$($Matches[1])\index.html")
        }
        if ($rawUrl -match '(?i)(?:^|/)(ideas-need-silence|geometry-builds-trust|everyday-beauty|the-power-of-focus|a-greener-workspace|the-creative-desk|materials-and-memory|beyond-the-screen)/?$') {
            $candidates += (Join-Path (Join-Path $targetPath "blog") $Matches[1])
            $candidates += (Join-Path (Join-Path $targetPath "blog") "$($Matches[1])\index.html")
        }
        if ($rawUrl -match '(?i)assets/(.+)$') {
            $candidates += (Join-Path $assetsFallback ($Matches[1] -replace '/', '\'))
            $candidates += (Join-Path $framerFallback ($Matches[1] -replace '/', '\'))
        }

        $localFilePath = $null
        foreach ($cand in $candidates) {
            if (Test-Path $cand -PathType Leaf) {
                $localFilePath = $cand
                break
            } elseif (Test-Path $cand -PathType Container) {
                $idx = Join-Path $cand "index.html"
                if (Test-Path $idx -PathType Leaf) {
                    $localFilePath = $idx
                    break
                }
            } elseif (Test-Path "$cand\index.html") {
                $localFilePath = "$cand\index.html"
                break
            }
        }

        if ($localFilePath) {
            $ext = [System.IO.Path]::GetExtension($localFilePath).ToLower()
            $mime = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
            $response.ContentType = $mime
                        $response.AddHeader("Access-Control-Allow-Origin", "*")
            if ($ext -eq ".html") {
                if ($rawUrl -match '(?i)eclore|project-?1|meridian') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=ooP4yMWDH&locale=default&var.KVCXsWDZS=eclore"')
                } elseif ($rawUrl -match '(?i)stylebook|project-?2|clo-3d') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=ooP4yMWDH&locale=default&var.KVCXsWDZS=stylebook"')
                } elseif ($rawUrl -match '(?i)homestead|project-?3') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=ooP4yMWDH&locale=default&var.KVCXsWDZS=homestead"')
                } elseif ($rawUrl -match '(?i)north-light|project-?4') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=ooP4yMWDH&locale=default&var.KVCXsWDZS=north-light"')
                } elseif ($rawUrl -match '(?i)about') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=NFldwpxHM&locale=default"')
                } elseif ($rawUrl -match '(?i)services') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=lBEorPn2H&locale=default"')
                } elseif ($rawUrl -match '(?i)blog') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=Ngf4PP48U&locale=default"')
                } elseif ($rawUrl -match '(?i)play-ground') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=OZ8sqXvDF&locale=default"')
                } elseif ($rawUrl -match '(?i)contact') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=rsFYOsZlS&locale=default"')
                } elseif ($rawUrl -match '(?i)case-study') {
                    $response.AddHeader("Server-Timing", 'route;desc="id=xZeukHXrK&locale=default"')
                } else {
                    $response.AddHeader("Server-Timing", 'route;desc="id=IMzwiuEeL&locale=default"')
                }
            }
            $response.AddHeader("Cache-Control", "no-cache, no-store, must-revalidate, max-age=0")
            $response.AddHeader("Pragma", "no-cache")
            $response.AddHeader("Expires", "0")

            $bytes = [System.IO.File]::ReadAllBytes($localFilePath)
            $response.ContentLength64 = $bytes.Length
            $response.StatusCode = 200

            $response.KeepAlive = $false
            if ($request.HttpMethod -ne "HEAD") {
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
                $response.OutputStream.Flush()
            }
            Write-Host "[200 OK]  $rawUrl -> $(Split-Path $localFilePath -Leaf)" -ForegroundColor Green
        } else {
            $response.StatusCode = 404
            $errBytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $rawUrl")
            $response.ContentType = "text/plain; charset=utf-8"
            $response.ContentLength64 = $errBytes.Length
            $response.KeepAlive = $false
            if ($request.HttpMethod -ne "HEAD") {
                $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
                $response.OutputStream.Flush()
            }
            Write-Host "[404 ERR] $rawUrl (NOT FOUND)" -ForegroundColor Red
        }
        $response.Close()
    } catch {
        Write-Host "Request error: $_" -ForegroundColor Yellow
        try { $response.Close() } catch {}
    }
}
