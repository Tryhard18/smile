$files = Get-ChildItem -Path "c:\Users\Diana\Desktop\site_smile" -Filter "*.html" -Recurse
foreach ($file in $files) {
    (Get-Content $file.FullName) -replace 'assets/images/optimized/', 'assets/images/' | Set-Content $file.FullName
    Write-Host "Fixed: $($file.Name)"
}
