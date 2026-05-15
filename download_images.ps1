$images = @{
    "hero_home.jpg" = "http://smilecomunicacao.pt/wp-content/uploads/2022/01/banner-1.jpg"
    "hero_sobre.jpg" = "https://images.unsplash.com/photo-1497366216548-37526070297c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80"
    "hero_solucoes.jpg" = "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80"
    "hero_contactos.jpg" = "https://images.unsplash.com/photo-1534536281715-e28d76689b4d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80"
    "equipa.jpg" = "http://smilecomunicacao.pt/wp-content/uploads/2022/01/banner-2.jpg"
    "eventos.jpg" = "http://smilecomunicacao.pt/wp-content/uploads/elementor/thumbs/53212896_2304193136532941_9154626463897485312_n-pjuf3jezai0xnllyw3gcswgjzjde1xaul52rnetc90.jpg"
    "ativacao.jpg" = "https://images.unsplash.com/photo-1551818255-e6e10975bc17?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
    "impressoes.jpg" = "https://images.unsplash.com/photo-1563986768609-322da13575f3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
    "movel.jpg" = "http://smilecomunicacao.pt/wp-content/uploads/elementor/thumbs/59039536_2343826702569584_6830710133517975552_n-pjuf3kcthc27z7klqluzde80kx8r9mekx9q94ory2s.jpg"
    "guerrilha.jpg" = "http://smilecomunicacao.pt/wp-content/uploads/elementor/thumbs/asdds-pjuf3n6c1u62y1gia52v2vied2uuwpprxnopkinrk4.jpg"
    "sociais.jpg" = "https://images.unsplash.com/photo-1611162617474-5b21e879e113?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
    "logo_meo.png" = "http://smilecomunicacao.pt/wp-content/uploads/2022/02/Meo_logo_pt.png"
    "logo_pingodoce.png" = "http://smilecomunicacao.pt/wp-content/uploads/2022/02/Pingo_Doce_logo.svg.png"
    "logo_sumolcompal.png" = "http://smilecomunicacao.pt/wp-content/uploads/2022/02/512px-Logo_SumolCompal.svg.png"
    "logo_remax.png" = "http://smilecomunicacao.pt/wp-content/uploads/2022/02/pngwing.com_.png"
    "logo_light.png" = "http://smilecomunicacao.pt/wp-content/uploads/2022/01/logo-smile_light-180x45.png"
}

foreach ($name in $images.Keys) {
    $url = $images[$name]
    $path = "c:\Users\Diana\Desktop\site_smile\assets\images\$name"
    Write-Host "Downloading $name..."
    Invoke-WebRequest -Uri $url -OutFile $path
}

Write-Host "Download Complete!"
