#Sur le serveur MARIADB ne pas oublier de GRANT ACCESS à l'IP du serveur WEB

# Importer le module Active Directory
Import-Module ActiveDirectory

# Chemin vers le fichier CSV
$cheminCSV = "users_data.csv"

# Définir le nom du serveur Active Directory
$adServerName = "FR-AD22-1"  # Remplacer par le nom réel du serveur AD

# Définir le nom du dossier partagé
$dossierPartageNom = "HomeDirectories"

# Définir le chemin du dossier partagé complet
$dossierPartageChemin = "\\$adServerName\$dossierPartageNom"

# Créer le dossier partagé s'il n'existe pas
if (!(Test-Path $dossierPartageChemin -PathType Container)) {
    New-Item -Path $dossierPartageChemin -ItemType Directory
    Write-Output "Dossier partagé créé : $dossierPartageChemin"
}

# Charger les données du CSV
$donnees = Import-Csv $cheminCSV -Delimiter ";"

# Parcourir les données et créer les utilisateurs dans Active Directory
foreach ($utilisateur in $donnees) {
    # Construire le login
    $login = ($utilisateur.Prenom.Substring(0, 1) + $utilisateur.Nom).ToLower()

    # Construire l'adresse e-mail
    $email = ($utilisateur.Prenom.ToLower() + "." + $utilisateur.Nom.ToLower() + "@grpmedilab.fr")

    # Utiliser le mot de passe du CSV directement (sans le hacher)
    $motDePasse = $utilisateur.Motdepasse

    # Créer l'utilisateur dans Active Directory avec le mot de passe en clair
    New-ADUser -SamAccountName $login -GivenName $utilisateur.Prenom -Surname $utilisateur.Nom -Department $utilisateur.Laboratoire -UserPrincipalName $email -EmailAddress $email -Name $login -Enabled $true -AccountPassword (ConvertTo-SecureString -AsPlainText $motDePasse -Force)

    # Définir d'autres propriétés de l'utilisateur comme nécessaire
    Set-ADUser -Identity $login -OfficePhone $utilisateur.Telephone -AccountExpirationDate $utilisateur.Fincontrat -Enabled $true

    # Créer le dossier personnel dans le dossier partagé
    $homeDirectoryPath = Join-Path $dossierPartageChemin $login
    New-Item -Path $homeDirectoryPath -ItemType Directory
    Set-ADUser -Identity $login -HomeDirectory $homeDirectoryPath
}
