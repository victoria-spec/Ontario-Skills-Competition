function Install-ADDomain {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DomainName,

        [Parameter(Mandatory=$true)]
        [string]$SafeModePassword
    )

    try {
        # Install AD DS role with management tools
        Write-Output "Installing Active Directory Domain Services..."
        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -ErrorAction Stop

        # Import ADDSDeployment module
        Write-Output "Importing ADDSDeployment module..."
        Import-Module ADDSDeployment -ErrorAction Stop

        # Convert password to SecureString
        $SecurePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force

        # Promote server to Domain Controller and create a new forest
        Write-Output "Promoting server to Domain Controller and creating new forest: $DomainName"
        Install-ADDSForest `
            -DomainName $DomainName `
            -CreateDnsDelegation:$false `
            -DatabasePath "C:\Windows\NTDS" `
            -LogPath "C:\Windows\NTDS" `
            -SysvolPath "C:\Windows\SYSVOL" `
            -InstallDns:$true `
            -SafeModeAdministratorPassword $SecurePassword `
            -Force:$true -ErrorAction Stop

        Write-Output "Active Directory Domain Controller installation completed successfully."
    }
    catch {
        Write-Error "An error occurred during AD DS installation: $_"
    }
}
