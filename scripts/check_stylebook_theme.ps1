$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\case-study\stylebook\index.html"
$content = [System.IO.File]::ReadAllText($path)

Write-Output "File length: $($content.Length)"
$tokens = [regex]::Matches($content, '--token-[a-f0-9\-]+:\s*[^;]+') | ForEach-Object { $_.Value } | Select-Object -Unique
Write-Output "Unique token definitions in stylebook:"
$tokens

