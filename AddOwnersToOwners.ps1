# Import the SharePoint Online module
#Connect-SPOService -Url https://yourtenant-admin.sharepoint.com

# Define the path to the CSV file
$csvFilePath = "E:\Scripts\SPO\userlist.csv"

# Read the CSV file
$userList = Import-Csv -Path $csvFilePath

# Loop through each row in the CSV file
foreach ($userRow in $userList) {
    $siteUrl = $userRow.SiteUrl
    $userEmails = $userRow.Useremail -split ';'

    # Get the default "Members" group
    $group = Get-SPOSiteGroup -Site $siteUrl | Where-Object { $_.Roles -contains "Full Control" } | Select-Object -ExpandProperty Title

    foreach ($userEmail in $userEmails) {
        $userEmail = $userEmail.Trim()

            # Add the user to the group
            Add-SPOUser -Site $siteUrl -LoginName $userEmail -Group $group
            Write-Host "User with email $userEmail added to the default 'Owners' group in site $siteUrl"
       
    }
}

# Disconnect from SharePoint Online
#Disconnect-SPOService