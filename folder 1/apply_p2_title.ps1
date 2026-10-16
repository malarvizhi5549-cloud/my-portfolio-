<#
.SYNOPSIS
    Updates Project 2 Title from StyleBook to "DESI AFTER DARK" across the site:
    1. Home Page (#pj2 H3 animated letter spans across Desktop, Tablet, Mobile)
    2. StyleBook Case Study Page (Page title, meta tags, and main H2 animated letter spans)
    3. Case Studies Listing Page (Project 2 card H4 titles)
    4. Related/Next project cards (meridian-health, about pages)
    5. Client-side hydration JS bundle
#>

$p2TitleHomeInner = @'
<span style="white-space:nowrap"><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">D</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">E</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">S</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">I</span></span> <span style="white-space:nowrap"><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">A</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">F</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">T</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">E</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">R</span></span> <span style="white-space:nowrap"><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">D</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">A</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">R</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">K</span></span>
'@

$p2TitleCsInner = @'
<span style="white-space:nowrap"><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">D</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">E</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">S</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">I</span></span> <span style="white-space:nowrap"><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">A</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">F</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">T</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">E</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">R</span></span> <span style="white-space:nowrap"><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">D</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">A</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">R</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">K</span></span>
'@

$oldSbHomeLetters = '<span style="white-space:nowrap"><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">S</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">t</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">y</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">l</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">e</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">B</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">o</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">o</span><span style="display:inline-block;opacity:0.001;transform:translateX(0px) translateY(40px) scale(1) rotate(0deg) skewX(0deg) skewY(0deg)">k</span></span>'

$oldSbCsLetters = '<span style="white-space:nowrap"><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">S</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">t</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">y</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">l</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">e</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">B</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">o</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">o</span><span style="display:inline-block;opacity:0.001;transform:translateX(40px) translateY(0px) scale(0.9) rotate(0deg) skewX(0deg) skewY(0deg)">k</span></span>'

$roots = @(
    "$PSScriptRoot\nudge-folio-site\site-offline",
    "$PSScriptRoot\nudge-folio-site\site-live-mirrored"
)

foreach ($r in $roots) {
    if (-not (Test-Path $r)) { continue }
    
    # 1. Update index.html
    $homePath = Join-Path $r "index.html"
    if (Test-Path $homePath) {
        $hc = [System.IO.File]::ReadAllText($homePath)
        $p2Idx = $hc.IndexOf('id="pj2"')
        $p3Idx = $hc.IndexOf('id="pj3"')
        if ($p2Idx -ge 0 -and $p3Idx -gt $p2Idx) {
            $before = $hc.Substring(0, $p2Idx)
            $pj2 = $hc.Substring($p2Idx, $p3Idx - $p2Idx)
            $after = $hc.Substring($p3Idx)
            
            $pj2Replaced = $pj2.Replace($oldSbHomeLetters, $p2TitleHomeInner)
            $hc = $before + $pj2Replaced + $after
            [System.IO.File]::WriteAllText($homePath, $hc, [System.Text.Encoding]::UTF8)
            Write-Host "Updated index.html in $r"
        }
    }
    
    # 2. Update case-study/stylebook/index.html
    $sbPath = Join-Path $r "case-study\stylebook\index.html"
    if (Test-Path $sbPath) {
        $sbc = [System.IO.File]::ReadAllText($sbPath)
        $sbc = $sbc.Replace($oldSbCsLetters, $p2TitleCsInner)
        $sbc = $sbc.Replace("<title>StyleBook - My Framer Site</title>", "<title>DESI AFTER DARK - My Framer Site</title>")
        $sbc = $sbc.Replace('content="StyleBook - My Framer Site"', 'content="DESI AFTER DARK - My Framer Site"')
        [System.IO.File]::WriteAllText($sbPath, $sbc, [System.Text.Encoding]::UTF8)
        Write-Host "Updated case-study/stylebook/index.html in $r"
    }
    
    # 3. Update case-study/index.html
    $csIndexPath = Join-Path $r "case-study\index.html"
    if (Test-Path $csIndexPath) {
        $csc = [System.IO.File]::ReadAllText($csIndexPath)
        $csc = $csc.Replace(">StyleBook</h4>", ">DESI AFTER DARK</h4>")
        [System.IO.File]::WriteAllText($csIndexPath, $csc, [System.Text.Encoding]::UTF8)
        Write-Host "Updated case-study/index.html in $r"
    }
    
    # 4. Update case-study/meridian-health/index.html
    $mhPath = Join-Path $r "case-study\meridian-health\index.html"
    if (Test-Path $mhPath) {
        $mhc = [System.IO.File]::ReadAllText($mhPath)
        $mhc = $mhc.Replace(">StyleBook</h4>", ">DESI AFTER DARK</h4>")
        [System.IO.File]::WriteAllText($mhPath, $mhc, [System.Text.Encoding]::UTF8)
        Write-Host "Updated case-study/meridian-health/index.html in $r"
    }
    
    # 5. Update about/index.html
    $abPath = Join-Path $r "about\index.html"
    if (Test-Path $abPath) {
        $abc = [System.IO.File]::ReadAllText($abPath)
        $abc = $abc.Replace(">StyleBook</h4>", ">DESI AFTER DARK</h4>")
        [System.IO.File]::WriteAllText($abPath, $abc, [System.Text.Encoding]::UTF8)
        Write-Host "Updated about/index.html in $r"
    }
}

# 6. Update JS chunk if exists
$jsChunk = "$PSScriptRoot\nudge-folio-site\site-offline\assets\framerusercontent.com\sites\5m1IdKzbH9qlRGKoqc19kU\ebcPKwnxLArQv7NWmWepjkjnomHrDSOje0je1g8Eyp0.BiwAFclO.mjs"
if (Test-Path $jsChunk) {
    $jc = [System.IO.File]::ReadAllText($jsChunk)
    if ($jc.Contains('xLqLyNMp1:`StyleBook`')) {
        $jc = $jc.Replace('xLqLyNMp1:`StyleBook`', 'xLqLyNMp1:`DESI AFTER DARK`')
        [System.IO.File]::WriteAllText($jsChunk, $jc, [System.Text.Encoding]::UTF8)
        Write-Host "Updated JS chunk ebcPKwnxLArQv7NWmWepjkjnomHrDSOje0je1g8Eyp0.BiwAFclO.mjs"
    }
}

Write-Host "Successfully applied DESI AFTER DARK across all portfolio files!"
