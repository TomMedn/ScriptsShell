# Import the Active Directory module
Import-Module ActiveDirectory

# Define the CSV file path
$csvFilePath = "users_data.csv"

# Define the column names based on the headers of the CSV file
$columnNames = @{
    "First Name" = "Prenom"
    "Last Name"  = "Nom"
}

# Define the server and share names
$adServerName = "FR-AD22-1"  # Replace with the actual server name
$shareName = "HomeDirectories"

# Construct the path to the shared folder
$sharedFolderPath = "\\$adServerName\$shareName"

# Read the CSV file
$userData = Import-Csv -Path $csvFilePath -Delimiter ";"

# Iterate through each user and delete them
foreach ($user in $userData) {
    $firstName = $user.$($columnNames["First Name"])
    $lastName  = $user.$($columnNames["Last Name"])
    $username  = "$($firstName.Substring(0, 1))$($lastName)"
    
    try {
        # Find the user in Active Directory
        $existingUser = Get-ADUser -Filter { (GivenName -eq $firstName) -and (Surname -eq $lastName) }

        # If the user is found, remove the user
        if ($existingUser) {
            Remove-ADUser -Identity $existingUser -Confirm:$false
            Write-Output "User $($username) deleted successfully."

            # Remove the user's home directory based on the modified username
            $homeDirectoryPath = Join-Path $sharedFolderPath $username
            if (Test-Path $homeDirectoryPath -PathType Container) {
                Remove-Item -Path $homeDirectoryPath -Recurse -Force
                Write-Output "Home directory for $($username) deleted successfully."
            } else {
                Write-Output "Home directory for $($username) not found."
            }
        } else {
            Write-Output "User $($username) not found in Active Directory."
        }
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Output "Error deleting user $($username): $($errorMessage)"
    }
}
