<#
.SYNOPSIS
    Applies template color #0D2D49 to Project 4 (North Light) on:
    1. The Home Page (#pj4 section, card body, tab header, tab curves, corner handles)
    2. The North Light Case Study template page (tokens, image frame borders, handles, tags, buttons)
#>

$p4ThemeCss = @'
<style id="project4-theme">
/* ==========================================================================
   Project 4 (North Light) Template Theme Color: #0D2D49
   ========================================================================== */
#pj4 .framer-uaooh,
#pj4 .framer-1iqx81u,
#pj4 .framer-1jk9lsi {
  background-color: #0D2D49 !important;
}

#pj4 .framer-6w51yr,
#pj4 .framer-tbl449,
#pj4 .framer-udsone {
  --omwlqg: #0D2D49 !important;
  background-color: #0D2D49 !important;
}

#pj4 .framer-6w51yr svg path,
#pj4 .framer-tbl449 svg path {
  fill: #0D2D49 !important;
}

/* Project 4 Cover Image Frame Corner Handles */
#pj4 .framer-2wtkhw,
#pj4 .framer-17azylh,
#pj4 .framer-pzbn2t,
#pj4 .framer-1a84a36 {
  background-color: #0D2D49 !important;
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
        
        # 1. Insert or update <style id="project4-theme">
        if ($content.Contains('id="project4-theme"')) {
            $regexStyle = [regex]'<style id="project4-theme">[\s\S]*?</style>'
            $content = $regexStyle.Replace($content, $p4ThemeCss, 1)
            Write-Output "Updated existing <style id='project4-theme'>"
        } else {
            $headEnd = $content.IndexOf('</head>')
            if ($headEnd -ge 0) {
                $content = $content.Insert($headEnd, $p4ThemeCss + "`n")
                Write-Output "Inserted <style id='project4-theme'>"
            }
        }
        
        # 2. Update inline background colors inside #pj4
        $p4Idx = $content.IndexOf('id="pj4"')
        $next = $content.IndexOf('id="template-overlay"', $p4Idx)
        if ($next -lt 0) { $next = $content.IndexOf('</main>', $p4Idx) }
        if ($next -lt 0) { $next = $content.Length }
        
        if ($p4Idx -ge 0 -and $next -gt $p4Idx) {
            $before = $content.Substring(0, $p4Idx)
            $pj4Block = $content.Substring($p4Idx, $next - $p4Idx)
            $after = $content.Substring($next)
            
            $oldBg = 'background-color:var(--token-e22e0fe6-83a6-4381-a625-c6f173619c49, rgb(230, 57, 155))'
            $newBg = 'background-color:#0D2D49'
            
            $countOld = ([regex]::Matches($pj4Block, [regex]::Escape($oldBg))).Count
            Write-Output "Found $countOld inline pink backgrounds inside #pj4"
            
            $pj4Block = $pj4Block.Replace($oldBg, $newBg)
            
            $content = $before + $pj4Block + $after
        }
        
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Saved $filePath"
    }
}

# 3. Update North Light Case Study template pages
$nlFiles = @(
    "$PSScriptRoot\nudge-folio-site\site-offline\case-study\north-light\index.html",
    "$PSScriptRoot\nudge-folio-site\site-live-mirrored\case-study\north-light\index.html"
)

$nlThemeCss = @'
<style id="p4-theme-color">
/* ==========================================================================
   Project 4 (North Light) Template Theme Color: #0D2D49
   ========================================================================== */
:root, html, body {
  --token-e22e0fe6-83a6-4381-a625-c6f173619c49: #0D2D49 !important;
  --token-1892785e-8581-4826-b411-015017430ad3: #0D2D49 !important;
}

/* North Light Image Frame Borders & Corner Handles */
.framer-y6Rfa [data-border="true"] {
  --border-color: #0D2D49 !important;
}

.framer-y6Rfa .framer-1amt9bm,
.framer-y6Rfa .framer-1jwrlbt,
.framer-y6Rfa .framer-1i39xik,
.framer-y6Rfa .framer-tiogd4 {
  background-color: #0D2D49 !important;
}

/* North Light Date dot & tags */
.framer-xpo76l {
  background-color: #0D2D49 !important;
}

.framer-1stbt7f .framer-ma96le,
.framer-1stbt7f .framer-evvvbg {
  background-color: #0D2D49 !important;
}

.framer-1stbt7f .framer-udsone {
  --omwlqg: #0D2D49 !important;
  background-color: #0D2D49 !important;
}

.framer-1stbt7f p,
.framer-1stbt7f span {
  color: #FFFFFF !important;
  --framer-text-color: #FFFFFF !important;
}

/* Next Project Folder & Contact button */
.framer-a89j1n {
  --border-color: #0D2D49 !important;
}

.framer-wt6zbe {
  background-color: #0D2D49 !important;
}

/* Accent icons */
.framer-15e3fym, .framer-qcrqyc, .framer-r77rjk, .framer-1ml90n7,
.framer-1j9zgno, .framer-14figy6, .framer-1mpqecq, .framer-1tct7va {
  background-color: #0D2D49 !important;
}
</style>
'@

foreach ($filePath in $nlFiles) {
    if (Test-Path $filePath) {
        Write-Output "Processing North Light Case Study: $filePath"
        $content = [System.IO.File]::ReadAllText($filePath)
        
        if ($content.Contains('id="p4-theme-color"')) {
            $regexStyle = [regex]'<style id="p4-theme-color">[\s\S]*?</style>'
            $content = $regexStyle.Replace($content, $nlThemeCss, 1)
            Write-Output "Updated existing <style id='p4-theme-color'>"
        } else {
            $headEnd = $content.IndexOf('</head>')
            if ($headEnd -ge 0) {
                $content = $content.Insert($headEnd, $nlThemeCss + "`n")
                Write-Output "Inserted <style id='p4-theme-color'>"
            }
        }
        
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Saved $filePath"
    }
}

Write-Output "Successfully applied #0D2D49 to Project 4 (North Light) template and home card!"
