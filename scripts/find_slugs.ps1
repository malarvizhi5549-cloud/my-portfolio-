$c = [System.IO.File]::ReadAllText("c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\assets\framerusercontent.com\sites\5m1IdKzbH9qlRGKoqc19kU\hu3yniggG.Cp6pugB6.mjs")
$matches = [regex]::Matches($c, '["`]([a-zA-Z0-9_\-]+)["`]')
$found = @()
foreach ($m in $matches) {
    $v = $m.Groups[1].Value
    if ($v -match 'eclore|meridian|stylebook|homestead|north-light|project') {
        $found += $v
    }
}
$found | Select-Object -Unique | ForEach-Object { Write-Host $_ }
