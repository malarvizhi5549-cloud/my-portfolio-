<#
.SYNOPSIS
    Applies template color #0D6A9E to Project 2 (StyleBook) on:
    1. The Home Page (#pj2 section, card body, tab header, tab curves, corner handles)
    2. The StyleBook Case Study template page (tokens, image frame borders, handles, tags, buttons)
#>

$p2ThemeCss = @'
<style id="project2-theme">
/* ==========================================================================
   Project 2 (StyleBook) Template Theme Color: #0D6A9E
   ========================================================================== */
#pj2 .framer-uaooh,
#pj2 .framer-1iqx81u,
#pj2 .framer-k3lm5r {
  background-color: #0D6A9E !important;
}

#pj2 .framer-b3njjt,
#pj2 .framer-1wgs5fj {
  --omwlqg: #0D6A9E !important;
  background-color: #0D6A9E !important;
}

#pj2 .framer-b3njjt svg path,
#pj2 .framer-1wgs5fj svg path {
  fill: #0D6A9E !important;
}

/* Project 2 Cover Image Frame Corner Handles */
#pj2 .framer-2wtkhw,
#pj2 .framer-17azylh,
#pj2 .framer-pzbn2t,
#pj2 .framer-1a84a36 {
  background-color: #0D6A9E !important;
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
        
        # 1. Insert or update <style id="project2-theme">
        if ($content.Contains('id="project2-theme"')) {
            $regexStyle = [regex]'<style id="project2-theme">[\s\S]*?</style>'
            $content = $regexStyle.Replace($content, $p2ThemeCss, 1)
            Write-Output "Updated existing <style id='project2-theme'>"
        } else {
            $headEnd = $content.IndexOf('</head>')
            if ($headEnd -ge 0) {
                $content = $content.Insert($headEnd, $p2ThemeCss + "`n")
                Write-Output "Inserted <style id='project2-theme'>"
            }
        }
        
        # 2. Update inline background colors inside #pj2
        $p2Idx = $content.IndexOf('id="pj2"')
        $p3Idx = $content.IndexOf('id="pj3"')
        if ($p2Idx -ge 0 -and $p3Idx -gt $p2Idx) {
            $before = $content.Substring(0, $p2Idx)
            $pj2Block = $content.Substring($p2Idx, $p3Idx - $p2Idx)
            $after = $content.Substring($p3Idx)
            
            $oldBg = 'background-color:var(--token-4f4ed186-9023-4858-830a-5202d69249c1, rgb(17, 18, 18))'
            $newBg = 'background-color:#0D6A9E'
            $count = ([regex]::Matches($pj2Block, [regex]::Escape($oldBg))).Count
            Write-Output "Found $count inline dark backgrounds inside #pj2"
            $pj2Block = $pj2Block.Replace($oldBg, $newBg)
            
            $content = $before + $pj2Block + $after
        }
        
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Saved $filePath"
    }
}

# 3. Update StyleBook Case Study template pages
$sbFiles = @(
    "$PSScriptRoot\nudge-folio-site\site-offline\case-study\stylebook\index.html",
    "$PSScriptRoot\nudge-folio-site\site-live-mirrored\case-study\stylebook\index.html"
)

$sbThemeCss = @'
<style id="p2-theme-color">
/* ==========================================================================
   Project 2 (StyleBook) Template Theme Color: #0D6A9E
   ========================================================================== */
:root, html, body {
  --token-1892785e-8581-4826-b411-015017430ad3: #0D6A9E !important;
}

/* StyleBook Image Frame Borders & Corner Handles */
.framer-y6Rfa [data-border="true"] {
  --border-color: #0D6A9E !important;
}

.framer-y6Rfa .framer-1amt9bm,
.framer-y6Rfa .framer-1jwrlbt,
.framer-y6Rfa .framer-1i39xik,
.framer-y6Rfa .framer-tiogd4 {
  background-color: #0D6A9E !important;
}

/* StyleBook Date dot & tags */
.framer-xpo76l {
  background-color: #0D6A9E !important;
}

.framer-1stbt7f .framer-ma96le,
.framer-1stbt7f .framer-evvvbg {
  background-color: #0D6A9E !important;
}

.framer-1stbt7f .framer-udsone {
  --omwlqg: #0D6A9E !important;
  background-color: #0D6A9E !important;
}

.framer-1stbt7f p,
.framer-1stbt7f span {
  color: #FFFFFF !important;
  --framer-text-color: #FFFFFF !important;
}

/* Next Project Folder & Contact button */
.framer-a89j1n {
  --border-color: #0D6A9E !important;
}

.framer-wt6zbe {
  background-color: #0D6A9E !important;
}
</style>
'@

foreach ($filePath in $sbFiles) {
    if (Test-Path $filePath) {
        Write-Output "Processing StyleBook Case Study: $filePath"
        $content = [System.IO.File]::ReadAllText($filePath)
        
        if ($content.Contains('id="p2-theme-color"')) {
            $regexStyle = [regex]'<style id="p2-theme-color">[\s\S]*?</style>'
            $content = $regexStyle.Replace($content, $sbThemeCss, 1)
            Write-Output "Updated existing <style id='p2-theme-color'>"
        } else {
            $headEnd = $content.IndexOf('</head>')
            if ($headEnd -ge 0) {
                $content = $content.Insert($headEnd, $sbThemeCss + "`n")
                Write-Output "Inserted <style id='p2-theme-color'>"
            }
        }
        
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Saved $filePath"
    }
}

Write-Output "Successfully applied #0D6A9E to Project 2 (StyleBook) template and home card!"
