$root = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline"
$files = Get-ChildItem -Recurse -Include *.html $root

$brokenReport = @()

foreach ($f in $files) {
    $relFile = $f.FullName.Substring($root.Length).TrimStart('\')
    # Determine the browser path for this file
    # e.g., index.html -> /
    # about\index.html -> /about/
    # case-study\eclore\index.html -> /case-study/eclore/
    $dirPart = [System.IO.Path]::GetDirectoryName($relFile).Replace('\', '/')
    $baseUri = if ([string]::IsNullOrEmpty($dirPart)) { "http://localhost:3000/" } else { "http://localhost:3000/$dirPart/" }
    
    $c = [System.IO.File]::ReadAllText($f.FullName)
    $links = [regex]::Matches($c, '<a\b[^>]+href="([^"]+)"[^>]*>')
    
    foreach ($m in $links) {
        $href = $m.Groups[1].Value
        if ($href -match '^(https?://|mailto:|tel:|#)') { continue }
        
        # Resolve URL relative to baseUri
        try {
            $resolvedUri = [System.Uri]::new([System.Uri]$baseUri, $href)
            $resolvedPath = $resolvedUri.AbsolutePath.TrimStart('/')
            if ([string]::IsNullOrEmpty($resolvedPath) -or $resolvedPath -eq "/") {
                $checkPath = Join-Path $root "index.html"
            } else {
                $clean = $resolvedPath.TrimEnd('/') -replace '/', '\'
                $checkPath1 = Join-Path $root $clean
                $checkPath2 = Join-Path $root "$clean\index.html"
                $checkPath3 = Join-Path $root "$clean.html"
                $exists = (Test-Path $checkPath1) -or (Test-Path $checkPath2) -or (Test-Path $checkPath3)
                if (-not $exists) {
                    $brokenReport += [PSCustomObject]@{
                        File = $relFile
                        Href = $href
                        ResolvedUrl = $resolvedUri.AbsolutePath
                    }
                }
            }
        } catch {}
    }
}

Write-Output "Total broken links found: $($brokenReport.Count)"
$brokenReport | Group-Object File | ForEach-Object {
    Write-Output "`nIn file: $($_.Name)"
    $_.Group | ForEach-Object {
        Write-Output "   href='$($_.Href)' => resolves to '$($_.ResolvedUrl)' [404]"
    }
}
