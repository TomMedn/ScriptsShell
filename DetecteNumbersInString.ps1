<#
Ce script est utilisé dans le cadre de la recherche de NAC sur les switch. Les switchs extreme renvoient à la commande "show netlogin" une liste des ports avec du NAC. 
Ce script détécte les nombres de 1 à 52 dans tout le fichier texte et affiche si ils s'y trouvent ou non dans un format qui est directement exploitable dans excel" 
#> 


$fichier = "listeDeChaines.txt"

# Vérifier si le fichier existe
if (-not (Test-Path $fichier)) {
    Write-Host "Le fichier n'existe pas."
    exit
}

# Lire le contenu du fichier
$texte = Get-Content $fichier -Raw

# Parcourir chaque chiffre de 1 à 52
for ($i = 1; $i -le 52; $i++) {
    # Convertir le chiffre en chaîne de caractères
    $chiffreString = $i.ToString()

    # Vérifier si le chiffre complet apparaît dans le texte
    if ($texte -match "\b$chiffreString\b") {
        Write-Host "$i(ok)"
    } else {
        Write-Host "$i(pasok)"
    }
}
