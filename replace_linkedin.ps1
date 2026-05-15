$files = Get-ChildItem -Path "c:\Users\Diana\Desktop\site_smile" -Filter "*.html" -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Target the specific LinkedIn link structure in the footer
    $target = '<a href="https://linkedin.com/company/smilecomunicacao" target="_blank"\s+rel="noopener noreferrer" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>'
    $replacement = '<a href="https://wa.me/351263711413" target="_blank" rel="noopener noreferrer" aria-label="WhatsApp"><i class="fab fa-whatsapp"></i></a>'
    
    # Use regex replace for the multiline/whitespace flexible search
    $newContent = [regex]::Replace($content, $target, $replacement)
    
    if ($content -ne $newContent) {
        $newContent | Set-Content $file.FullName
        Write-Host "Updated: $($file.FullName)"
    }
}
