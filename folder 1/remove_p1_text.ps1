$files = @(
    "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline\case-study\meridian-health\index.html",
    "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-live-mirrored\case-study\meridian-health\index.html"
)

foreach ($f in $files) {
    if (-not (Test-Path $f)) { continue }
    $c = [System.IO.File]::ReadAllText($f)
    
    # 1. Remove the 150-word text block after the last image
    $pattern150 = '<div class="framer-sxbmzy" data-framer-component-type="RichTextContainer" style="transform:none;width:80%;max-width:800px;margin-top:32px;margin-bottom:48px">[\s\S]*?</p>\s*</div>'
    if ([regex]::IsMatch($c, $pattern150)) {
        $c = [regex]::Replace($c, $pattern150, '')
        Write-Output "Removed 150-word story from $f"
    } else {
        # Fallback check
        $idx = $c.IndexOf('Project Overview &amp; Impact')
        if ($idx -ge 0) {
            $start = $c.LastIndexOf('<div class="framer-sxbmzy"', $idx)
            $end = $c.IndexOf('</div>', $c.IndexOf('delivering attentive, compassionate patient care.', $idx))
            if ($start -ge 0 -and $end -gt $start) {
                $c = $c.Remove($start, $end - $start + 6)
                Write-Output "Removed 150-word story via index fallback from $f"
            }
        }
    }
    
    # 2. Also remove the leftover therapist subtitle under ECLORE
    $patternSub = '<div class="framer-lcr6b3" data-framer-component-type="RichTextContainer" style="transform:none">[\s\S]*?When therapists spend less time clicking[\s\S]*?</div>'
    if ([regex]::IsMatch($c, $patternSub)) {
        $c = [regex]::Replace($c, $patternSub, '')
        Write-Output "Removed therapist subtitle from $f"
    }
    
    [System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
}

Write-Output "Done removing all text from Project 1!"
