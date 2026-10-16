<#
.SYNOPSIS
    Applies font/letter color #0D2D49 to Project 1 on the Home Page.
#>

$oldFontSection = @'
/* ==========================================================================
   Project 1 (ECLORE) Cover Page Font Color: #C7C7AE
   ========================================================================== */
#pj1,
#pj1 *,
.framer-uaooh,
.framer-uaooh * {
  --framer-text-color: #C7C7AE !important;
  --extracted-r6o4lv: #C7C7AE !important;
  --extracted-a0htzi: #C7C7AE !important;
  --extracted-1of0zx5: #C7C7AE !important;
  --variable-reference-JDs6Ey0E7-vqnJudyFq: #C7C7AE !important;
  --variable-reference-Ha3WZBmxl-jUfJHCvjJ: #C7C7AE !important;
  --variable-reference-w9lvJIC3K-vqnJudyFq: #C7C7AE !important;
}

#pj1 .framer-text,
#pj1 p,
#pj1 h1,
#pj1 h2,
#pj1 h3,
#pj1 h4,
#pj1 span,
#pj1 a,
.framer-uaooh .framer-text,
.framer-uaooh p,
.framer-uaooh h1,
.framer-uaooh h2,
.framer-uaooh h3,
.framer-uaooh h4,
.framer-uaooh span,
.framer-uaooh a {
  color: #C7C7AE !important;
  --framer-text-color: #C7C7AE !important;
}

/* Date dot next to Mar 19, 2026 */
#pj1 .framer-1tdrzuz,
.framer-uaooh .framer-1tdrzuz {
  background-color: #C7C7AE !important;
}

/* "View Project" link underline border & arrow icon */
#pj1 [data-framer-name="Dark Button"],
.framer-uaooh [data-framer-name="Dark Button"] {
  border-color: #C7C7AE !important;
  --border-color: #C7C7AE !important;
}

#pj1 [data-framer-name="Dark Button"] svg path,
.framer-uaooh [data-framer-name="Dark Button"] svg path {
  fill: #C7C7AE !important;
}

/* "project 01" number icon */
#pj1 [data-framer-name="Number"] svg path,
#pj1 .framer-4y8o6z svg path {
  fill: #C7C7AE !important;
}

/* Cover Image tag badge icon */
#pj1 .framer-4g5dgx svg path,
.framer-uaooh .framer-4g5dgx svg path {
  fill: #C7C7AE !important;
}
'@

$newFontSection = @'
/* ==========================================================================
   Project 1 (ECLORE) Cover Page Font Color: #0D2D49
   ========================================================================== */
#pj1,
#pj1 *,
#pj1 .framer-uaooh,
#pj1 .framer-uaooh * {
  --framer-text-color: #0D2D49 !important;
  --extracted-r6o4lv: #0D2D49 !important;
  --extracted-a0htzi: #0D2D49 !important;
  --extracted-1of0zx5: #0D2D49 !important;
  --variable-reference-JDs6Ey0E7-vqnJudyFq: #0D2D49 !important;
  --variable-reference-Ha3WZBmxl-jUfJHCvjJ: #0D2D49 !important;
  --variable-reference-w9lvJIC3K-vqnJudyFq: #0D2D49 !important;
}

#pj1 .framer-text,
#pj1 p,
#pj1 h1,
#pj1 h2,
#pj1 h3,
#pj1 h4,
#pj1 span,
#pj1 a,
#pj1 strong,
#pj1 time,
#pj1 .framer-uaooh .framer-text,
#pj1 .framer-uaooh p,
#pj1 .framer-uaooh h1,
#pj1 .framer-uaooh h2,
#pj1 .framer-uaooh h3,
#pj1 .framer-uaooh h4,
#pj1 .framer-uaooh span,
#pj1 .framer-uaooh a {
  color: #0D2D49 !important;
  --framer-text-color: #0D2D49 !important;
}

/* Date dot next to Mar 19, 2026 */
#pj1 .framer-1tdrzuz,
#pj1 .framer-uaooh .framer-1tdrzuz {
  background-color: #0D2D49 !important;
}

/* "View Project" link underline border & arrow icon */
#pj1 [data-framer-name="Dark Button"],
#pj1 .framer-uaooh [data-framer-name="Dark Button"] {
  border-color: #0D2D49 !important;
  --border-color: #0D2D49 !important;
}

#pj1 [data-framer-name="Dark Button"] svg path,
#pj1 .framer-uaooh [data-framer-name="Dark Button"] svg path {
  fill: #0D2D49 !important;
}

/* "project 01" number icon and tab text */
#pj1 [data-framer-name="Number"] svg path,
#pj1 .framer-4y8o6z svg path,
#pj1 .framer-1crst57-container svg path {
  fill: #0D2D49 !important;
}

#pj1 .framer-qzezvq p,
#pj1 [data-framer-name="Project Number"] p {
  color: #0D2D49 !important;
}

/* Cover Image tag badge icon */
#pj1 .framer-4g5dgx svg path,
#pj1 .framer-uaooh .framer-4g5dgx svg path {
  fill: #0D2D49 !important;
}
'@

$homeFiles = @(
    "$PSScriptRoot\nudge-folio-site\site-offline\index.html",
    "$PSScriptRoot\nudge-folio-site\site-live-mirrored\index.html"
)

foreach ($filePath in $homeFiles) {
    if (Test-Path $filePath) {
        Write-Output "Processing Home: $filePath"
        $content = [System.IO.File]::ReadAllText($filePath)
        
        if ($content.Contains($oldFontSection)) {
            $content = $content.Replace($oldFontSection, $newFontSection)
            Write-Output "Replaced exact old font section with #0D2D49"
        } else {
            # Regex replacement fallback
            $pattern = '(?s)/\* =+\s*Project 1 \(ECLORE\) Cover Page Font Color:.*?(?=/\* =+\s*Project 1 \(ECLORE\) Template Theme Color)'
            if ($content -match $pattern) {
                $content = [regex]::Replace($content, $pattern, $newFontSection + "`n`n")
                Write-Output "Replaced font section via regex with #0D2D49"
            } else {
                Write-Warning "Could not find Project 1 Font Color section in $filePath"
            }
        }
        
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Saved $filePath"
    }
}

Write-Output "Successfully updated Project 1 letter color to #0D2D49!"
