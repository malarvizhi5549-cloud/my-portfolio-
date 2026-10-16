$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html"
$content = [System.IO.File]::ReadAllText($path)

$p2Idx = $content.IndexOf('id="pj2"')
$p3Idx = $content.IndexOf('id="pj3"')
$pj2 = $content.Substring($p2Idx, $p3Idx - $p2Idx)

$linkIdx = $pj2.IndexOf('./case-study/')
if ($linkIdx -ge 0) {
    Write-Output "Case study link: $($pj2.Substring($linkIdx, 100))"
}

$titleIdx = $pj2.IndexOf('<h3')
if ($titleIdx -ge 0) {
    Write-Output "Title: $($pj2.Substring($titleIdx, 200))"
}
