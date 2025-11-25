function Add-OrganizationUnit {
    param(
        [Parameter(Mandatory = $true)]
        [string]$OUName,

        [Parameter(Mandatory = $true)]
        [string]$ParentDN   # Example: "DC=skills,DC=local"
    )

    # Build full DN
    $OUPath = "OU=$OUName,$ParentDN"

    try {
        # Check if OU already exists
        $existingOU = Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OUPath'" -ErrorAction SilentlyContinue

        if ($existingOU) {
            Write-Output "OU '$OUName' already exists at: $OUPath"
            return
        }

        # Create the OU
        New-ADOrganizationalUnit -Name $OUName -Path $ParentDN -ErrorAction Stop

        Write-Output "OU '$OUName' successfully created under: $ParentDN"
    }
    catch {
        Write-Error "Failed to create OU: $_"
    }
}
