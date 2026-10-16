$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\case-study\stylebook\index.html"
$content = [System.IO.File]::ReadAllText($path)

$idx = $content.IndexOf('framer-53jf28')
if ($idx -ge 0) {
    Write-Output $content.Substring($idx - 50, 600)
}
