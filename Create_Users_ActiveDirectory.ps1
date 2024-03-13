#Sur le serveur MARIADB ne pas oublier de GRANT ACCESS à l'IP du serveur WEB

Import-Module ActiveDirectory
$cheminCSV = "users_data.csv"
$adServerName = "FR-AD22-1"  
$dossierPartageNom = "HomeDirectories"
$dossierPartageChemin = "\\$adServerName\$dossierPartageNom"
if (!(Test-Path $dossierPartageChemin -PathType Container)) {
    New-Item -Path $dossierPartageChemin -ItemType Directory
    Write-Output "Dossier partagé créé : $dossierPartageChemin"
}
$donnees = Import-Csv $cheminCSV -Delimiter ";"
foreach ($utilisateur in $donnees) {
    $login = ($utilisateur.Prenom.Substring(0, 1) + $utilisateur.Nom).ToLower()
    $email = ($utilisateur.Prenom.ToLower() + "." + $utilisateur.Nom.ToLower() + "@grpmedilab.fr")
    $motDePasse = $utilisateur.Motdepasse
    New-ADUser -SamAccountName $login -GivenName $utilisateur.Prenom -Surname $utilisateur.Nom -Department $utilisateur.Laboratoire -UserPrincipalName $email -EmailAddress $email -Name $login -Enabled $true -AccountPassword (ConvertTo-SecureString -AsPlainText $motDePasse -Force)
    Set-ADUser -Identity $login -OfficePhone $utilisateur.Telephone -AccountExpirationDate $utilisateur.Fincontrat -Enabled $true
    $homeDirectoryPath = Join-Path $dossierPartageChemin $login
    New-Item -Path $homeDirectoryPath -ItemType Directory
    Set-ADUser -Identity $login -HomeDirectory $homeDirectoryPath
}
