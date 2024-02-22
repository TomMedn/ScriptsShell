# Importer le module Active Directory
Import-Module ActiveDirectory

# Chemin vers le fichier CSV
$cheminCSV = "chemin_vers_votre_fichier.csv"

# Charger les données du CSV
$donnees = Import-Csv $cheminCSV -Delimiter ";"

# Parcourir les données et supprimer les utilisateurs de l'Active Directory
foreach ($utilisateur in $donnees) {
    # Construire le login
    $login = ($utilisateur.Prenom.Substring(0, 1) + $utilisateur.Nom).ToLower()

    # Supprimer l'utilisateur de l'Active Directory
    Remove-ADUser -Identity $login -Confirm:$false
}

Write-Host "Suppression des utilisateurs terminée."
