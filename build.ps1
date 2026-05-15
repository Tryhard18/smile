param (
    [string]$SrcDir = "src",
    [string]$OutDir = "."
)

Write-Host "Starting Build Process" -ForegroundColor Cyan

# 1. Process CSS Component
# Since the user requested CSS splitting, we'll merge all CSS files in src/css/ into style.css and minify it.
Write-Host "Building CSS..." -ForegroundColor Yellow
$cssFiles = Get-ChildItem -Path "$SrcDir/css" -Filter "*.css" -Recurse
$mergedCss = ""
foreach ($file in $cssFiles) {
    # Only skip if the file is in the OUTPUT directory (though $SrcDir is different, let's be safe)
    # The original check was skipping files named 'style.css' which might be the actual source file
    $mergedCss += Get-Content $file.FullName -Raw
    $mergedCss += "`n"
}
Set-Content -Path "$OutDir/style.css" -Value $mergedCss

# Simple Minification
$minCss = $mergedCss -replace '/\*[\s\S]*?\*/', '' # Multiline comments
$minCss = $minCss -replace '\s+', ' '            # Collapse whitespace
$minCss = $minCss -replace '\s*([{}:;,])\s*', '$1' # Remove spaces around delimiters
Set-Content -Path "$OutDir/style.min.css" -Value $minCss.Trim()
Write-Host "-> Created style.css and style.min.css" -ForegroundColor Green

# 2. Process JS
Write-Host "Building JS..." -ForegroundColor Yellow
if (Test-Path "$SrcDir/../script.js") {
    $jsContent = Get-Content "$SrcDir/../script.js" -Raw
    # Simple JS Minification (Safer)
    # 1. Remove block comments
    $minJs = $jsContent -replace '/\*[\s\S]*?\*/', ''
    # 2. Remove line comments safely (only if not preceded by :)
    $minJs = ($minJs -split "`r?`n" | ForEach-Object { $_ -replace '(?<!:)\/\/.*', '' }) -join "`n"
    # 3. Reduce whitespace
    $minJs = $minJs -replace '\s+', ' ' -replace '\s*([{};:=,+])\s*', '$1'
    Set-Content -Path "$OutDir/script.min.js" -Value $minJs.Trim()
    Write-Host "-> Created script.min.js" -ForegroundColor Green
}

# 3. Process HTML Includes
Write-Host "Building HTML Pages..." -ForegroundColor Yellow

# Read components
$headerHtml = ""
if (Test-Path "$SrcDir/components/header.html") {
    $headerHtml = Get-Content "$SrcDir/components/header.html" -Raw
}

$footerHtml = ""
if (Test-Path "$SrcDir/components/footer.html") {
    $footerHtml = Get-Content "$SrcDir/components/footer.html" -Raw
}

# Process pages
$pages = Get-ChildItem -Path "$SrcDir/pages" -Filter "*.html" -Recurse

foreach ($page in $pages) {
    # Calculate relative path depth
    $relativePath = $page.FullName.Substring((Resolve-Path "$SrcDir/pages").Path.Length).TrimStart('\')
    
    # Determine depth string '../'
    $depth = ($relativePath -split "\\").Count - 1
    $prefix = ""
    for ($i = 0; $i -lt $depth; $i++) {
        $prefix += "../"
    }

    # Adjust paths in header and footer
    $localHeader = $headerHtml -replace 'href="(?!http|mailto|tel|#)([^"]+)"', "href=`"$prefix`$1`"" -replace 'src="(?!http|data)([^"]+)"', "src=`"$prefix`$1`""
    $localFooter = $footerHtml -replace 'href="(?!http|mailto|tel|#)([^"]+)"', "href=`"$prefix`$1`"" -replace 'src="(?!http|data)([^"]+)"', "src=`"$prefix`$1`""

    # Replace includes
    $content = Get-Content $page.FullName -Raw
    $content = $content -replace '(?i)<!--\s*INCLUDE:\s*header\.html\s*-->', $localHeader
    $content = $content -replace '(?i)<!--\s*INCLUDE:\s*footer\.html\s*-->', $localFooter

    # Write to root/subdirectory
    $outPath = Join-Path $OutDir $relativePath
    $outDirInfo = Split-Path $outPath
    if (-not (Test-Path $outDirInfo)) {
        New-Item -ItemType Directory -Path $outDirInfo | Out-Null
    }

    Set-Content -Path $outPath -Value $content
    Write-Host "-> Built: $relativePath" -ForegroundColor Green
}

# 3. Process WebP Conversion (Bonus)
# First we need to get cwebp if it doesn't exist. We'll download the standalone exe safely without installing Python/Node
$cwebpPath = "$SrcDir/tools/cwebp.exe"
if (-not (Test-Path "$SrcDir/tools")) {
    New-Item -ItemType Directory -Path "$SrcDir/tools" | Out-Null
}

if (-not (Test-Path $cwebpPath)) {
    Write-Host "Downloading cwebp converter..." -ForegroundColor Yellow
    # This is a safe direct download link for libwebp windows bin
    $url = "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.2-windows-x64.zip"
    $zipPath = "$SrcDir/tools/libwebp.zip"
    Invoke-WebRequest -Uri $url -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath "$SrcDir/tools/libwebp" -Force
    Copy-Item "$SrcDir/tools/libwebp/*/bin/cwebp.exe" -Destination $cwebpPath
    Remove-Item $zipPath
    Remove-Item "$SrcDir/tools/libwebp" -Recurse -Force
}

if (Test-Path $cwebpPath) {
    Write-Host "Optimizing Images to WebP..." -ForegroundColor Yellow
    $images = Get-ChildItem -Path "assets/images" -Include *.jpg, *.jpeg, *.png -Recurse

    foreach ($img in $images) {
        # Check if corresponding WebP already exists
        $webpName = $img.Name -replace '\.[a-zA-Z0-9]+$', '.webp'
        $webpPath = Join-Path $img.DirectoryName $webpName

        if (-not (Test-Path $webpPath)) {
            Write-Host "   Converting: $($img.Name)"
            & $cwebpPath -quiet -q 80 $img.FullName -o $webpPath
        }
    }

    # Now replace image links in all built HTMLs from .jpg/.png to .webp
    $builtPages = Get-ChildItem -Path $OutDir -Filter "*.html" -Recurse | Where-Object { $_.FullName -notlike "*\src\*" }
    foreach ($builtPage in $builtPages) {
        $content = Get-Content $builtPage.FullName -Raw
        $newContent = $content -replace '\.jpg', '.webp' -replace '\.png', '.webp' -replace '\.jpeg', '.webp'
        if ($content -ne $newContent) {
            Set-Content -Path $builtPage.FullName -Value $newContent
        }
    }
    Write-Host "-> Replaced images with WebP formats!" -ForegroundColor Green
}

Write-Host "Build Complete!" -ForegroundColor Cyan
