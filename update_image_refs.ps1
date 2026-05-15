Param(
    [string]$htmlFolder = ".",
    [string]$from = "assets/images/",
    [string]$to = "assets/images/optimized/",
    [switch]$backup
)

$files = Get-ChildItem -Path $htmlFolder -Include *.html -Recurse
foreach ($f in $files) {
    $path = $f.FullName
    $content = Get-Content -Raw -Path $path
    if ($content -like "*${from}*") {
        if ($backup) { Copy-Item -Path $path -Destination "$path.bak" -Force }
        $new = $content -replace [regex]::Escape($from), $to
        Set-Content -Path $path -Value $new -Force
        Write-Host "Updated: $path"
    }
}
Write-Host "Done. HTML files updated to use: $to" -ForegroundColor Green
