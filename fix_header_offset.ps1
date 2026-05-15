$files = Get-ChildItem -Path "c:\Users\Diana\Desktop\site_smile" -Filter "*.html" -Recurse
foreach ($file in $files) {
    (Get-Content $file.FullName) -replace 'padding-top: 100px', 'padding-top: 180px' | Set-Content $file.FullName
    Write-Host "Updated offset: $($file.Name)"
}
