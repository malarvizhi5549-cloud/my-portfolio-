<#
.SYNOPSIS
    Applies template color #0B4B77 to Project 3 (Homestead) on:
    1. The Home Page (#pj3 section, card body, tab header, tab curves, corner handles)
    2. The Homestead Case Study template page (tokens, image frame borders, handles, tags, buttons)
#>

$p3ThemeCss = @'
<style id="project3-theme">
/* ==========================================================================
   Project 3 (Homestead) Template Theme Color: #0B4B77
   ========================================================================== */
#pj3 .framer-uaooh,
#pj3 .framer-1iqx81u,
#pj3 .framer-1agqeaq {
  background-color: #0B4B77 !important;
}

#pj3 .framer-skepkl,
#pj3 .framer-ujfd83,
#pj3 .framer-udsone {
  --omwlqg: #0B4B77 !important;
  background-color: #0B4B77 !important;
}

#pj3 .framer-skepkl svg path,
#pj3 .framer-ujfd83 svg path {
  fill: #0B4B77 !important;
}

/* Project 3 Cover Image Frame Corner Handles */
#pj3 .framer-2wtkhw,
#pj3 .framer-17azylh,
#pj3 .framer-pzbn2t,
#pj3 .framer-1a84a36 {
  background-color: #0B4B77 !important;
}
</style>
'@

$homeFiles = @(
    "$PSScriptRoot\nudge-folio-site\site-offline\index.html",
    "$PSScriptRoot\nudge-folio-site\site-live-mirrored\index.html"
)

foreach ($filePath in $homeFiles) {
    if (Test-Path $filePath) {
        Write-Output "Processing Home: $filePath"
        $content = [System.IO.File]::ReadAllText($filePath)
        
        # 1. Insert or update <style id="project3-theme">
        if ($content.Contains('id="project3-theme"')) {
            $regexStyle = [regex]'<style id="project3-theme">[\s\S]*?</style>'
            $content = $regexStyle.Replace($content, $p3ThemeCss, 1)
            Write-Output "Updated existing <style id='project3-theme'>"
        } else {
            $headEnd = $content.IndexOf('</head>')
            if ($headEnd -ge 0) {
                $content = $content.Insert($headEnd, $p3ThemeCss + "`n")
                Write-Output "Inserted <style id='project3-theme'>"
            }
        }
        
        # 2. Update inline background colors inside #pj3
        $p3Idx = $content.IndexOf('id="pj3"')
        $p4Idx = $content.IndexOf('id="pj4"')
        if ($p3Idx -ge 0 -and $p4Idx -gt $p3Idx) {
            $before = $content.Substring(0, $p3Idx)
            $pj3Block = $content.Substring($p3Idx, $p4Idx - $p3Idx)
            $after = $content.Substring($p4Idx)
            
            $oldBg = 'background-color:var(--token-29f9695a-09e2-4c55-ace7-e9873233e207, rgb(133, 77, 14))'
            $newBg = 'background-color:#0B4B77'
            
            $countOld = ([regex]::Matches($pj3Block, [regex]::Escape($oldBg))).Count
            $countPrev = ([regex]::Matches($pj3Block, [regex]::Escape('background-color:#0D6A9E'))).Count
            Write-Output "Found $countOld amber and $countPrev 0D6A9E backgrounds inside #pj3"
            
            $pj3Block = $pj3Block.Replace($oldBg, $newBg)
            $pj3Block = $pj3Block.Replace('background-color:#0D6A9E', $newBg)
            
            $content = $before + $pj3Block + $after
        }
        
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Saved $filePath"
    }
}

# 3. Update Homestead Case Study template pages
$hsFiles = @(
    "$PSScriptRoot\nudge-folio-site\site-offline\case-study\homestead\index.html",
    "$PSScriptRoot\nudge-folio-site\site-live-mirrored\case-study\homestead\index.html"
)

$hsThemeCss = @'
<style id="p3-theme-color">
/* ==========================================================================
   Project 3 (Homestead) Template Theme Color: #0B4B77
   ========================================================================== */
:root, html, body {
  --token-29f9695a-09e2-4c55-ace7-e9873233e207: #0B4B77 !important;
  --token-1892785e-8581-4826-b411-015017430ad3: #0B4B77 !important;
}

/* Homestead Image Frame Borders & Corner Handles */
.framer-y6Rfa [data-border="true"] {
  --border-color: #0B4B77 !important;
}

.framer-y6Rfa .framer-1amt9bm,
.framer-y6Rfa .framer-1jwrlbt,
.framer-y6Rfa .framer-1i39xik,
.framer-y6Rfa .framer-tiogd4 {
  background-color: #0B4B77 !important;
}

/* Homestead Date dot & tags */
.framer-xpo76l {
  background-color: #0B4B77 !important;
}

.framer-1stbt7f .framer-ma96le,
.framer-1stbt7f .framer-evvvbg {
  background-color: #0B4B77 !important;
}

.framer-1stbt7f .framer-udsone {
  --omwlqg: #0B4B77 !important;
  background-color: #0B4B77 !important;
}

.framer-1stbt7f p,
.framer-1stbt7f span {
  color: #FFFFFF !important;
  --framer-text-color: #FFFFFF !important;
}

/* Next Project Folder & Contact button */
.framer-a89j1n {
  --border-color: #0B4B77 !important;
}

.framer-wt6zbe {
  background-color: #0B4B77 !important;
}

/* SVG icon fills */
svg[fill*="token-29f9695a"],
svg *[fill*="token-29f9695a"] {
  fill: #0B4B77 !important;
}
</style>
'@

foreach ($filePath in $hsFiles) {
    if (Test-Path $filePath) {
        Write-Output "Processing Homestead Case Study: $filePath"
        $content = [System.IO.File]::ReadAllText($filePath)
        
        if ($content.Contains('id="p3-theme-color"')) {
            $regexStyle = [regex]'<style id="p3-theme-color">[\s\S]*?</style>'
            $content = $regexStyle.Replace($content, $hsThemeCss, 1)
            Write-Output "Updated existing <style id='p3-theme-color'>"
        } else {
            $headEnd = $content.IndexOf('</head>')
            if ($headEnd -ge 0) {
                $content = $content.Insert($headEnd, $hsThemeCss + "`n")
                Write-Output "Inserted <style id='p3-theme-color'>"
            }
        }
        
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Saved $filePath"
    }
}

Write-Output "Successfully updated Project 3 (Homestead) color to #0B4B77!"
