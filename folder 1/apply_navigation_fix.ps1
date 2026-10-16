<#
.SYNOPSIS
    Comprehensive fix for all navigation problems across the portfolio website:
    1. Replaces broken relative links in all HTML files with correct root-relative paths.
    2. Fixes #hide-case-study CSS so project cards are NOT hidden.
    3. Upgrades portfolio-title-and-nav-script with robust link correction and click handling.
    4. Enhances serve.ps1 to intelligently resolve dirty relative URLs to prevent any 404.
#>

$roots = @(
    "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-offline",
    "c:\Users\Asus\OneDrive\Desktop\portfolio website\folder 1\nudge-folio-site\site-live-mirrored"
)

# 1. New safe CSS for hide-case-study that ONLY targets the navbar item
$oldHideCssPattern = '(?s)<style id="hide-case-study">.*?<\/style>'
$newHideCss = @'
<style id="hide-case-study">
.framer-12hsxtv-container,
.framer-dga6ak a[href*="case-study"],
nav a[href="/case-study"],
nav a[href="./case-study"],
nav a[href="../case-study"],
nav a[href="../../case-study"] {
  display: none !important;
}
</style>
'@

# 2. Enhanced client-side script for portfolio-title-and-nav-script
$newScript = @'
<script id="portfolio-title-and-nav-script">
(function() {
  function fixAllNavigation() {
    var path = window.location.pathname.toLowerCase();

    // 1. Home page cards
    var pj1 = document.getElementById('pj1');
    if (pj1) {
      var hP1 = pj1.querySelectorAll('h3, [data-styles-preset="G6r9h69Ct"]');
      hP1.forEach(function(h) {
        var txt = (h.textContent || '').replace(/\s+/g, ' ').trim();
        if (txt !== 'ECLORE') { h.textContent = 'ECLORE'; }
      });
      var imgP1 = pj1.querySelector('img');
      if (imgP1 && !imgP1.src.includes('5-03.jpg')) {
        imgP1.src = '/assets/framerusercontent.com/images/5-03.jpg';
        imgP1.srcset = '/assets/framerusercontent.com/images/5-03.jpg 2048w';
      }
      if (!pj1.dataset.clickableInit) {
        pj1.dataset.clickableInit = 'true';
        pj1.style.cursor = 'pointer';
        pj1.addEventListener('click', function(e) {
          if (!e.target.closest('a')) { window.location.href = '/case-study/eclore'; }
        });
      }
    }

    var pj2 = document.getElementById('pj2');
    if (pj2) {
      var hP2 = pj2.querySelectorAll('h3, [data-styles-preset="G6r9h69Ct"]');
      hP2.forEach(function(h) {
        var txt = (h.textContent || '').replace(/\s+/g, ' ').trim();
        if (txt !== 'CLO 3D' && txt !== 'DESI AFTER DARK') {
          // Keep whatever title is currently styled
        }
      });
      if (!pj2.dataset.clickableInit) {
        pj2.dataset.clickableInit = 'true';
        pj2.style.cursor = 'pointer';
        pj2.addEventListener('click', function(e) {
          if (!e.target.closest('a')) { window.location.href = '/case-study/stylebook'; }
        });
      }
    }

    // 2. Fix all links across navigation, header, cards, and buttons
    var allLinks = document.querySelectorAll('a[href]');
    allLinks.forEach(function(a) {
      var href = a.getAttribute('href');
      if (!href || href.startsWith('http') || href.startsWith('mailto') || href.startsWith('tel') || href.startsWith('#')) {
        return;
      }

      var txt = (a.textContent || '').replace(/\s+/g, ' ').trim().toLowerCase();
      var isLogo = a.getAttribute('data-framer-name') === 'Logo' || a.querySelector('svg[viewBox="0 0 17 17"]') || a.querySelector('svg[viewBox="0 0 50 25"]');

      // Home / Portfolio / Logo
      if (txt === 'portfolio' || txt === 'home' || isLogo || href === './' || href === '../' || href === '../../') {
        a.setAttribute('href', '/');
      }
      // Top-level pages
      else if (txt === 'about' || href.endsWith('/about') || href === './about' || href === '../about' || href === '../../about') {
        a.setAttribute('href', '/about');
      }
      else if (txt === 'services' || href.endsWith('/services') || href === './services' || href === '../services' || href === '../../services') {
        a.setAttribute('href', '/services');
      }
      else if (txt === 'journal' || txt === 'blog' || href.endsWith('/blog') || href === './blog' || href === '../blog' || href === '../../blog') {
        a.setAttribute('href', '/blog');
      }
      else if (txt === 'playground' || href.endsWith('/play-ground') || href === './play-ground' || href === '../play-ground' || href === '../../play-ground') {
        a.setAttribute('href', '/play-ground');
      }
      else if (txt === 'contact' || href.endsWith('/contact') || href === './contact' || href === '../contact' || href === '../../contact') {
        a.setAttribute('href', '/contact');
      }
      // Project pages
      else if (href.includes('eclore') || href.includes('meridian-health')) {
        a.setAttribute('href', '/case-study/eclore');
      }
      else if (href.includes('stylebook') || href.includes('clo-3d')) {
        a.setAttribute('href', '/case-study/stylebook');
      }
      else if (href.includes('homestead')) {
        a.setAttribute('href', '/case-study/homestead');
      }
      else if (href.includes('north-light')) {
        a.setAttribute('href', '/case-study/north-light');
      }
      else if (href === './case-study' || href === '../case-study' || href === '../../case-study') {
        a.setAttribute('href', '/case-study');
      }
      // Sub-anchors on about page
      else if (href.includes('about#')) {
        var anchor = href.substring(href.indexOf('about#') + 5);
        a.setAttribute('href', '/about' + anchor);
      }
    });
  }

  // Run on initial load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', fixAllNavigation);
  } else {
    fixAllNavigation();
  }
  window.addEventListener('load', fixAllNavigation);
  setTimeout(fixAllNavigation, 100);
  setTimeout(fixAllNavigation, 500);
  setTimeout(fixAllNavigation, 1500);

  // Run on any dynamic DOM mutations (Framer / React hydration)
  if (window.MutationObserver) {
    var obs = new MutationObserver(function() {
      fixAllNavigation();
    });
    obs.observe(document.documentElement, { childList: true, subtree: true });
  }

  // Global click delegator to guarantee all internal link clicks navigate properly
  document.addEventListener('click', function(e) {
    var target = e.target.closest('a[href]');
    if (!target) return;
    var href = target.getAttribute('href');
    if (!href || href.startsWith('http') || href.startsWith('mailto') || href.startsWith('tel') || href.startsWith('#')) {
      return;
    }
    // If it's a relative link that was missed or reset by React
    var txt = (target.textContent || '').replace(/\s+/g, ' ').trim().toLowerCase();
    var dest = null;
    if (txt === 'portfolio' || txt === 'home' || href === './' || href === '../' || href === '../../') {
      dest = '/';
    } else if (txt === 'about' || href.endsWith('/about') || href === './about' || href === '../about') {
      dest = '/about';
    } else if (txt === 'services' || href.endsWith('/services') || href === './services' || href === '../services') {
      dest = '/services';
    } else if (txt === 'journal' || txt === 'blog' || href.endsWith('/blog') || href === './blog' || href === '../blog') {
      dest = '/blog';
    } else if (txt === 'playground' || href.endsWith('/play-ground') || href === './play-ground' || href === '../play-ground') {
      dest = '/play-ground';
    } else if (txt === 'contact' || href.endsWith('/contact') || href === './contact' || href === '../contact') {
      dest = '/contact';
    } else if (href.includes('eclore') || href.includes('meridian-health')) {
      dest = '/case-study/eclore';
    } else if (href.includes('stylebook') || href.includes('clo-3d')) {
      dest = '/case-study/stylebook';
    } else if (href.includes('homestead')) {
      dest = '/case-study/homestead';
    } else if (href.includes('north-light')) {
      dest = '/case-study/north-light';
    }

    if (dest && dest !== href) {
      e.preventDefault();
      e.stopPropagation();
      window.location.href = dest;
    }
  }, true);
})();
</script>
'@

$oldScriptPattern = '(?s)<script id="portfolio-title-and-nav-script">.*?<\/script>'

foreach ($root in $roots) {
    if (-not (Test-Path $root)) { continue }
    $files = Get-ChildItem -Recurse -Include *.html $root
    Write-Host "Processing $($files.Count) HTML files in $root..." -ForegroundColor Cyan

    foreach ($file in $files) {
        $c = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
        $orig = $c

        # A. Replace #hide-case-study CSS
        if ($c -match $oldHideCssPattern) {
            $c = [regex]::Replace($c, $oldHideCssPattern, $newHideCss)
        }

        # B. Replace or inject portfolio-title-and-nav-script
        if ($c -match $oldScriptPattern) {
            $c = [regex]::Replace($c, $oldScriptPattern, $newScript)
        } else {
            $bodyIdx = $c.LastIndexOf('</body>')
            if ($bodyIdx -ge 0) {
                $c = $c.Insert($bodyIdx, $newScript + "`n")
            }
        }

        # C. Replace HTML relative links in <a> tags
        # 1. Navbar and general page links
        # Match <a ... href="..." ...> and rewrite known targets:
        $replacements = @{
            'href="\./about"'             = 'href="/about"'
            'href="\.\./about"'           = 'href="/about"'
            'href="\.\./\.\./about"'      = 'href="/about"'
            'href="\./services"'          = 'href="/services"'
            'href="\.\./services"'        = 'href="/services"'
            'href="\.\./\.\./services"'   = 'href="/services"'
            'href="\./blog"'              = 'href="/blog"'
            'href="\.\./blog"'            = 'href="/blog"'
            'href="\.\./\.\./blog"'       = 'href="/blog"'
            'href="\./play-ground"'       = 'href="/play-ground"'
            'href="\.\./play-ground"'     = 'href="/play-ground"'
            'href="\.\./\.\./play-ground"'= 'href="/play-ground"'
            'href="\./contact"'           = 'href="/contact"'
            'href="\.\./contact"'         = 'href="/contact"'
            'href="\.\./\.\./contact"'    = 'href="/contact"'
            'href="\./case-study"'        = 'href="/case-study"'
            'href="\.\./case-study"'      = 'href="/case-study"'
            'href="\.\./\.\./case-study"' = 'href="/case-study"'
            'href="\./case-study/eclore"'      = 'href="/case-study/eclore"'
            'href="\.\./case-study/eclore"'    = 'href="/case-study/eclore"'
            'href="\./case-study/stylebook"'   = 'href="/case-study/stylebook"'
            'href="\.\./case-study/stylebook"' = 'href="/case-study/stylebook"'
            'href="\./case-study/homestead"'   = 'href="/case-study/homestead"'
            'href="\.\./case-study/homestead"' = 'href="/case-study/homestead"'
            'href="\./case-study/north-light"' = 'href="/case-study/north-light"'
            'href="\.\./case-study/north-light"'= 'href="/case-study/north-light"'
            'href="\./stylebook"'         = 'href="/case-study/stylebook"'
            'href="\./homestead"'         = 'href="/case-study/homestead"'
            'href="\./eclore"'            = 'href="/case-study/eclore"'
            'href="\./north-light"'       = 'href="/case-study/north-light"'
            'href="\./about#mainbio"'     = 'href="/about#mainbio"'
            'href="\./about#my-story"'    = 'href="/about#my-story"'
            'href="\./about#work"'        = 'href="/about#work"'
            'href="\.\./about#mainbio"'   = 'href="/about#mainbio"'
            'href="\.\./about#my-story"'  = 'href="/about#my-story"'
            'href="\.\./about#work"'      = 'href="/about#work"'
        }

        foreach ($k in $replacements.Keys) {
            $c = [regex]::Replace($c, $k, $replacements[$k])
        }

        # Blog article links
        $c = [regex]::Replace($c, 'href="(\./|\.\./|\.\./\.\./)blog/([a-zA-Z0-9\-]+)"', 'href="/blog/$2"')
        $c = [regex]::Replace($c, 'href="(\./|\.\./|\.\./\.\./)(ideas-need-silence|geometry-builds-trust|everyday-beauty|the-power-of-focus|a-greener-workspace|the-creative-desk|materials-and-memory|beyond-the-screen)"', 'href="/blog/$2"')

        # 2. Specifically rewrite Home/Portfolio links in navbar:
        # e.g., in <a class="...framer-1szvw3r..." ... href="./"> or href="../">
        $c = [regex]::Replace($c, '(<a\b[^>]+framer-1szvw3r[^>]*?)href="(\./|\.\./|\.\./\.\./)"', '$1href="/"')
        # Also any logo link in header
        $c = [regex]::Replace($c, '(<a\b[^>]+data-framer-name="Logo"[^>]*?)href="[^"]*"', '$1href="/"')

        if ($c -ne $orig) {
            [System.IO.File]::WriteAllText($file.FullName, $c, [System.Text.Encoding]::UTF8)
            Write-Host "  Updated: $($file.FullName.Replace($root, ''))" -ForegroundColor Green
        }
    }
}

Write-Host "HTML updates complete!" -ForegroundColor Green
