$c = [System.IO.File]::ReadAllText("c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html")

$p1Start = $c.IndexOf('id="pj1"')
$p2Start = $c.IndexOf('id="pj2"')
Write-Host "p1Start: $p1Start, p2Start: $p2Start"

if ($p1Start -ge 0 -and $p2Start -gt $p1Start) {
    $p1Chunk = $c.Substring($p1Start, $p2Start - $p1Start)
    $matches = [regex]::Matches($p1Chunk, '<a\b[^>]*>')
    foreach ($m in $matches) {
        Write-Host "P1 Link: $($m.Value)"
    }
}
