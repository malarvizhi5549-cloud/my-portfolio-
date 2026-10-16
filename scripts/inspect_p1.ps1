$c = [System.IO.File]::ReadAllText("c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html")

Write-Host "--- Matches for Project 1 ---"
$matches = [regex]::Matches($c, '(?i).{0,50}(Project\s*1|View\s*Project|pj1).{0,50}')
foreach ($m in $matches) {
    Write-Host $m.Value
}

Write-Host "`n--- Card 1 markup around pj1 ---"
$idx = $c.IndexOf('id="pj1"')
if ($idx -ge 0) {
    Write-Host $c.Substring([Math]::Max(0, $idx - 200), 2500)
} else {
    Write-Host "id='pj1' not found!"
}
