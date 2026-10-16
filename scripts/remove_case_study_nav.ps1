$roots = @(
    "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline",
    "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-live-mirrored"
)

$hideCss = @'
<style id="hide-case-study">
.framer-12hsxtv-container,
a[href*="/case-study"]:not([data-framer-name*="Button"]),
a[href="./case-study"] {
  display: none !important;
}
</style>
'@

foreach ($root in $roots) {
    if (-not (Test-Path $root)) { continue }
    $files = Get-ChildItem -Recurse -Include "*.html" $root
    
    foreach ($file in $files) {
        $c = [System.IO.File]::ReadAllText($file.FullName)
        $modified = $false
        
        # 1. Add CSS hide rule to head
        if ($c.Contains('id="hide-case-study"')) {
            # Already has it
        } else {
            $headIdx = $c.IndexOf('</head>')
            if ($headIdx -ge 0) {
                $c = $c.Insert($headIdx, $hideCss + "`n")
                $modified = $true
            }
        }
        
        # 2. Remove the Case study nav HTML element
        # Pattern covers both with comment markers and without
        $pattern = '(<!--\$-->)?<div class="framer-12hsxtv-container">[\s\S]*?Case\s*study</p></div></a>(<!--/\$-->)?</div>(<!--/\$-->)?'
        if ([regex]::IsMatch($c, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
            $c = [regex]::Replace($c, $pattern, '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            $modified = $true
        }
        
        if ($modified) {
            [System.IO.File]::WriteAllText($file.FullName, $c, [System.Text.Encoding]::UTF8)
            Write-Output "Removed Case study nav from: $($file.FullName.Replace($root, ''))"
        }
    }
}

Write-Output "Done removing Case study from navigation across the website!"
