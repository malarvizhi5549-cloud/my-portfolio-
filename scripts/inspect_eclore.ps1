$c = [System.IO.File]::ReadAllText("c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\case-study\eclore\index.html")

Write-Host "Title: $([regex]::Match($c, '<title>(.*?)</title>').Groups[1].Value)"
Write-Host "H1: $([regex]::Matches($c, '<h1\b[^>]*>(.*?)</h1>') | ForEach-Object { $_.Groups[1].Value -replace '<[^>]+>', '' })"
Write-Host "H2: $([regex]::Matches($c, '<h2\b[^>]*>(.*?)</h2>') | ForEach-Object { $_.Groups[1].Value -replace '<[^>]+>', '' })"
Write-Host "H3: $([regex]::Matches($c, '<h3\b[^>]*>(.*?)</h3>') | ForEach-Object { $_.Groups[1].Value -replace '<[^>]+>', '' })"

$text = $c -replace '<[^>]+>', ' '
$text = [regex]::Replace($text, '\s+', ' ')
Write-Host "First 500 chars of text content:"
Write-Host $text.Substring(0, [Math]::Min(500, $text.Length))
