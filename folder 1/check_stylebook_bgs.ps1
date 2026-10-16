$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\case-study\stylebook\index.html"
$content = [System.IO.File]::ReadAllText($path)

$matches = [regex]::Matches($content, 'background-color:[^;"]+')
$seen = @{}
foreach ($m in $matches) {
    if (-not $seen.ContainsKey($m.Value)) {
        $seen[$m.Value] = $true
        Write-Output $m.Value
    }
}
