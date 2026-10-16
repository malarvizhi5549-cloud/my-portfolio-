$text150 = @"
<div class="framer-sxbmzy" data-framer-component-type="RichTextContainer" style="transform:none;width:80%;max-width:800px;margin-top:32px;margin-bottom:48px">
  <h4 dir="auto" class="framer-text framer-styles-preset-jjv5nu" style="margin-bottom:16px">Project Overview &amp; Impact</h4>
  <p dir="auto" class="framer-text framer-styles-preset-163ovsm" style="margin-bottom:16px">Therapists at Meridian Health documented 3 to 5 client sessions daily, losing notes and navigating a fragmented 12-screen flow lacking progress cues or autosave. To resolve this, I mapped the complete clinical journey and restructured information architecture around practitioners' mental models. We consolidated 12 disjointed screens into 7 intuitive, cohesive stages, added a persistent progress indicator, and implemented reliable autosaving with instant status confirmations. Collaborating closely with clinical specialists and engineering within tight 8-week deadlines, we iterated rapidly while ensuring strict HIPAA compliance.</p>
  <p dir="auto" class="framer-text framer-styles-preset-163ovsm">The redesign cut documentation time in half—from 20 minutes down to under 10 minutes per session—while eliminating lost note reports completely. By transforming a cumbersome administrative chore into an effortless digital assistant, clinicians gained renewed workflow confidence. The modernized interface reduced cognitive fatigue, boosted charting speed, and empowered healthcare providers to focus on what matters most: delivering attentive, compassionate patient care.</p>
</div>
"@

$files = @(
    "$PSScriptRoot\nudge-folio-site\site-offline\case-study\meridian-health\index.html",
    "$PSScriptRoot\nudge-folio-site\site-live-mirrored\case-study\meridian-health\index.html"
)

$classNames = @("framer-sxbmzy", "framer-u1mcci", "framer-nqiyyb", "framer-1qjcz2f", "framer-rt4ik2", "framer-15wylng")

foreach ($file in $files) {
    if (-not (Test-Path $file)) { continue }
    $content = [System.IO.File]::ReadAllText($file)
    
    # 1. Remove the 6 text containers between the images
    foreach ($cls in $classNames) {
        $pattern = '<div class="' + $cls + '" data-framer-component-type="RichTextContainer" style="transform:none">[\s\S]*?</p></div>'
        if ([regex]::IsMatch($content, $pattern)) {
            $content = [regex]::Replace($content, $pattern, '')
            Write-Host "Removed container $cls from $file"
        }
    }
    
    # 2. Insert the 150-word consolidated text after image 7 (before Next Case Study)
    $nextCsIdx = $content.IndexOf('data-framer-name="Next Case Study"')
    if ($nextCsIdx -ge 0) {
        # Find opening tag of Next Case Study container
        $insertPoint = $content.LastIndexOf('<div class="framer-181gwqx"', $nextCsIdx)
        if ($insertPoint -ge 0) {
            $content = $content.Insert($insertPoint, $text150 + "`n")
            Write-Host "Inserted 150-word story after last image in $file"
        }
    }
    
    [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
}

Write-Host "Project 1 text restructuring complete!"
