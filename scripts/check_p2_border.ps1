$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html"
$content = [System.IO.File]::ReadAllText($path)

$p2Idx = $content.IndexOf('id="pj2"')
$p3Idx = $content.IndexOf('id="pj3"')
$pj2 = $content.Substring($p2Idx, $p3Idx - $p2Idx)

$borderIdx = $pj2.IndexOf('data-framer-name="Border"')
if ($borderIdx -ge 0) {
    Write-Output $pj2.Substring($borderIdx - 100, 1500)
} else {
    Write-Output "Border not found in pj2"
}
