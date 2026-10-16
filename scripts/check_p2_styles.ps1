$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html"
$content = [System.IO.File]::ReadAllText($path)
$p2Idx = $content.IndexOf('id="pj2"')
$p3Idx = $content.IndexOf('id="pj3"')
$pj2 = $content.Substring($p2Idx, $p3Idx - $p2Idx)

$bgMatches = [regex]::Matches($pj2, 'background(-color)?:\s*[^;"]+')
Write-Output "Unique background styles in pj2:"
$bgSeen = @{}
foreach ($m in $bgMatches) {
    if (-not $bgSeen.ContainsKey($m.Value)) {
        $bgSeen[$m.Value] = $true
        Write-Output $m.Value
    }
}

$borderMatches = [regex]::Matches($pj2, '--border-color:\s*[^;"]+')
Write-Output "`nUnique border-color styles in pj2:"
$bSeen = @{}
foreach ($m in $borderMatches) {
    if (-not $bSeen.ContainsKey($m.Value)) {
        $bSeen[$m.Value] = $true
        Write-Output $m.Value
    }
}
