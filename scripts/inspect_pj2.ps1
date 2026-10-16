$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html"
$content = [System.IO.File]::ReadAllText($path)

$p2Idx = $content.IndexOf('id="pj2"')
$p3Idx = $content.IndexOf('id="pj3"')
$pj2 = $content.Substring($p2Idx, $p3Idx - $p2Idx)

Write-Output "pj2 length: $($pj2.Length)"
Write-Output "First 2500 chars of pj2:"
Write-Output $pj2.Substring(0, 2500)
