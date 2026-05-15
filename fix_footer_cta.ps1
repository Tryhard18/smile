$files = Get-ChildItem -Path "c:\Users\Diana\Desktop\site_smile" -Filter "*.html" -Recurse
$oldCta = '<a href="contactos.html" class="btn btn-primary footer-cta">Peça o Seu Orçamento</a>'
$newCta = @"
            <div class="footer-cta-section reveal">
                <div class="footer-cta-text">
                    <h3>Pronto para dar o próximo passo?</h3>
                    <p>Vamos criar impacto juntos e elevar a sua marca.</p>
                </div>
                <div class="footer-cta">
                    <a href="contactos.html" class="btn-footer">Peça o Seu Orçamento</a>
                </div>
            </div>
"@

foreach ($file in $files) {
    (Get-Content $file.FullName -Raw) -replace [regex]::Escape($oldCta), $newCta | Set-Content $file.FullName
    Write-Host "Updated footer CTA in: $($file.Name)"
}
