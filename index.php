// SITE WEB DE CONNEXION  
 <?php
// Les informations de connexion à la base de données
$host = '172.19.7.11';
$dbname = 'Medigroup';
$username = 'root';
$password = 'admin';

// Connexion à la base de données
try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
} catch (PDOException $e) {
    die("Erreur de connexion à la base de données: " . $e->getMessage());
}

// Fonction pour vérifier les identifiants de connexion
function verifyCredentials($prenom, $nom, $motdepasse, $pdo) {
    $stmt = $pdo->prepare("SELECT MotDePasse FROM Utilisateurs WHERE Prenom = :prenom AND Nom = :nom");
    $stmt->bindParam(':prenom', $prenom, PDO::PARAM_STR);
    $stmt->bindParam(':nom', $nom, PDO::PARAM_STR);
    $stmt->execute();
    
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($row) {
        // Vérifier le mot de passe avec password_verify
        if (password_verify($motdepasse, $row['MotDePasse'])) {
            return true;
        }
    }
    
    return false;
}

// Vérifier si le formulaire est soumis
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Récupérer les valeurs du formulaire
    $prenom = $_POST['prenom'];
    $nom = $_POST['nom'];
    $motdepasse = $_POST['motdepasse'];

    // Vérifier les identifiants de connexion
    if (verifyCredentials($prenom, $nom, $motdepasse, $pdo)) {
        echo "Connexion réussie!";
    } else {
        echo "Identifiants incorrects.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion Utilisateur</title>
</head>
<body>

<h2>Connexion Utilisateur</h2>

<form method="post" action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>">
    <label for="prenom">Prénom :</label>
    <input type="text" name="prenom" required>
    <br>

    <label for="nom">Nom :</label>
    <input type="text" name="nom" required>
    <br>

    <label for="motdepasse">Mot de passe :</label>
    <input type="password" name="motdepasse" required>
    <br>

    <button type="submit">Se connecter</button>
</form>

</body>
</html>
