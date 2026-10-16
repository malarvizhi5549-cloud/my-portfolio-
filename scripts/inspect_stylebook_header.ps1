$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\case-study\stylebook\index.html"
$content = [System.IO.File]::ReadAllText($path)

$idx = $content.IndexOf('<body')
$snippet = $content.Substring($idx, 4000)

$borderMatches = [regex]::Matches($snippet, 'data-border="true"[^>]*')
Write-Output "Border elements in stylebook header:"
foreach ($m in $borderMatches) {
    Write-Output $m.Value
}
