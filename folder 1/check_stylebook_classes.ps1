$path = "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\case-study\stylebook\index.html"
$content = [System.IO.File]::ReadAllText($path)

$classes = @("framer-53jf28", "framer-1lqle49", "framer-mls9vv", "framer-dkpmtr", "framer-2ibhow", "framer-1spfgd6", "framer-1ssjtfy")
foreach ($c in $classes) {
    if ($content.Contains($c)) {
        Write-Output "Found $c in stylebook"
    }
}
