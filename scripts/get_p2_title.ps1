$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html"
$content = [System.IO.File]::ReadAllText($path)
$p2Idx = $content.IndexOf('id="pj2"')
$h3Idx = $content.IndexOf('<h3', $p2Idx)
$endH3 = $content.IndexOf('</h3>', $h3Idx)
$raw = $content.Substring($h3Idx, $endH3 - $h3Idx + 5)
Write-Output "H3 HTML:"
Write-Output $content.Substring($h3Idx - 100, 350)

