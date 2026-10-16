$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html"
$content = [System.IO.File]::ReadAllText($path)

$p2Idx = $content.IndexOf('id="pj2"')
$p3Idx = $content.IndexOf('id="pj3"')
$pj2 = $content.Substring($p2Idx, $p3Idx - $p2Idx)

$allMatches = ([regex]::Matches($pj2, 'token-4f4ed186')).Count
Write-Output "Found $allMatches total occurrences of token-4f4ed186 in pj2"

$allProperties = [regex]::Matches($pj2, '[a-zA-Z\-]+:var\(--token-4f4ed186[^\)]+\)') | ForEach-Object { $_.Value } | Select-Object -Unique
Write-Output "Unique usages:"
$allProperties

