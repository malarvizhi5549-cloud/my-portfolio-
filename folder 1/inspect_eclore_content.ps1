$c = [System.IO.File]::ReadAllText("c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\case-study\eclore\index.html")

Write-Host "--- Images in case-study/eclore/index.html ---"
$imgs = [regex]::Matches($c, '<img\b[^>]*src="([^"]+)"[^>]*>')
foreach ($img in $imgs) {
    Write-Host "IMG src: $($img.Groups[1].Value)"
}

Write-Host "`n--- Text blocks in case-study/eclore/index.html ---"
$paragraphs = [regex]::Matches($c, '<p\b[^>]*>(.*?)</p>')
foreach ($p in $paragraphs) {
    $t = $p.Groups[1].Value -replace '<[^>]+>', ''
    if ($t.Trim()) {
        Write-Host "P: $t"
    }
}
