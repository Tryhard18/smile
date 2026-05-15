Param(
    [string]$source = "assets/images",
    [string]$dest = "assets/images/optimized",
    [int]$quality = 75,
    [int]$maxWidth = 1600
)

if (-not (Test-Path $source)) {
    Write-Host "Source folder '$source' not found." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest | Out-Null }

$sourcePath = (Resolve-Path $source).Path
$images = Get-ChildItem -Path $source -Include *.jpg, *.jpeg, *.png -Recurse

foreach ($img in $images) {
    $relative = $img.FullName.Substring($sourcePath.Length).TrimStart('\')
    $out = Join-Path $dest $relative
    $outDir = Split-Path $out
    if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

    if (Get-Command magick -ErrorAction SilentlyContinue) {
        magick "${img.FullName}" -resize "${maxWidth}x>" -strip -interlace Plane -quality $quality "${out}"
        Write-Host "Optimized: $relative"
    } else {
        Write-Host "ImageMagick 'magick' not found. Copying original to optimized folder: $relative" -ForegroundColor Yellow
        Copy-Item $img.FullName $out -Force
    }
}

Write-Host "Done. Optimized images are in: $dest" -ForegroundColor Green
