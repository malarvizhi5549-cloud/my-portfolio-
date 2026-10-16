$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html"
$content = [System.IO.File]::ReadAllText($path)

$p2Idx = $content.IndexOf('id="pj2"')
$p3Idx = $content.IndexOf('id="pj3"')
$pj2 = $content.Substring($p2Idx, $p3Idx - $p2Idx)

$badgeIdx = $pj2.IndexOf('framer-4g5dgx')
if ($badgeIdx -ge 0) {
    Write-Output $pj2.Substring($badgeIdx - 50, 400)
}
