$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\index.html"
$content = [System.IO.File]::ReadAllText($path)

$classes = @("framer-k3lm5r", "framer-b3njjt", "framer-twvxzw")
foreach ($cls in $classes) {
    Write-Output "=== $cls ==="
    $regex = [regex]"[^{};]*\.$cls[^{]*\{[^}]*\}"
    $matches = $regex.Matches($content)
    foreach ($m in $matches) {
        Write-Output $m.Value
    }
}
