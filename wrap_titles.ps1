$files = Get-ChildItem -Path "c:\Users\Diana\Desktop\site_smile" -Filter "*.html" -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Identify section-title divs that are not immediately inside a container
    # This regex looks for section-title that is a direct child of a section or main (not inside container)
    # Note: This is an approximation since regex with nested HTML is tricky
    
    # Let's try to match the common pattern:
    # <section ...>
    #    <div class="section-title">...</div>
    $newContent = [regex]::Replace($content, '(<section[^>]*>\s+)(<div class="section-title">.*?</div>)', '$1<div class="container">$2</div>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    
    if ($content -ne $newContent) {
        $newContent | Set-Content $file.FullName
        Write-Host "Updated: $($file.FullName)"
    }
}
