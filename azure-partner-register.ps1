<#
.SYNOPSIS
    This script interacts with Azure AD to manage the registration of Partner IDs.
    
.DESCRIPTION
    The script allows users to perform the following actions:
    - Check the current Partner ID registration status
    - Register a new Partner ID
    - Update an existing Partner ID
    - Remove a Partner ID
    - Exit the script

    The script prompts the user for the Azure AD tenant ID and Partner ID (with a default value of 748759 (Covenant Technology Partners)), authenticates using Azure, and allows users to choose an action from a menu.

.PARAMETER TenantId
    The Azure AD Tenant ID to authenticate against.

.PARAMETER PartnerId
    The Partner ID to register, update, or remove. If no Partner ID is provided, the default value of 748759 (Covenant Technology Partners) will be used.

.INPUTS
    None

.OUTPUTS
    The script outputs the results of the selected operation (such as a confirmation message or error details).

.NOTES
    This script requires the following Azure PowerShell modules to be installed:
    - Az.Accounts (for Azure authentication using Connect-AzAccount)
    - Az.ManagementPartner (for managing Partner IDs using Get-AzManagementPartner, New-AzManagementPartner, Update-AzManagementPartner, and Remove-AzManagementPartner)
    
    You can install the required modules using the following commands:
    
    # Install the main Az module (which includes all sub-modules)
    Install-Module -Name Az -AllowClobber -Force
    
    # Or if you only want to install the required sub-modules
    Install-Module -Name Az.Accounts -AllowClobber -Force
    Install-Module -Name Az.ManagementPartner -AllowClobber -Force

    The user must have the following permissions to manage Partner IDs:
    - Azure Subscription Roles: Owner, Contributor, or User Access Administrator.


.EXAMPLE
    .\azure-partner-register.ps1
    - Prompts the user for Tenant ID and Partner ID (with a default of 748759) and allows the user to check, register, update, or remove a Partner ID.
#>

# Authenticate against the Azure AD tenant
# Prompt the user for the tenant ID
$TenantId = Read-Host -Prompt 'Input your Tenant ID'

# Prompt the user for the partner ID with a default value
# Default partner ID is 748759 if no input is provided
$PartnerId = Read-Host -Prompt 'Input your Partner ID (Press Enter for default: 748759)'
if ([string]::IsNullOrWhiteSpace($PartnerId)) {
    $PartnerId = '748759'
}

# Authenticate using the provided Tenant ID
Connect-AzAccount -TenantId $TenantId

# Function to display the menu and get the user's selection
function Select-PartnerAction {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Options
    )

    # Display the options to the user.
    for ($i = 0; $i -lt $Options.Count; $i++) {
        Write-Host "${i}: $($Options[$i])"
    }

    # Prompt the user to select an option.
    do {
        $index = Read-Host "Select an action (default is 0)"
        if ([string]::IsNullOrWhiteSpace($index)) {
            $index = 0
        }

        # Validate if the input is a valid index.
        $isValid = $index -match '^\d+$' -and $index -ge 0 -and $index -lt $Options.Count
        if (-not $isValid) {
            Write-Host "Invalid selection. Please enter a number between 0 and $($Options.Count - 1)."
        }
    } while (-not $isValid)

    return $Options[[int]$index]
}

# Define the available options
$actions = @(
    "Check partner registration status",
    "Register partner ID",
    "Update partner ID",
    "Remove partner ID",
    "Exit"
)

# Loop until the user chooses to exit
while ($true) {
    $selectedAction = Select-PartnerAction -Options $actions
    #Write-Host "Selected action: $selectedAction"  # Debugging statement

    switch ($selectedAction) {
        "Check partner registration status" {
            # Check the current partner registration status
            Write-Host "Checking partner registration status..."
            try {
                Get-AzManagementPartner -ErrorAction Stop
            } catch {
                Write-Host "An error occurred while checking partner registration: $($_.Exception.Message)"
            }
        }
        "Register partner ID" {
            # Register the partner ID
            Write-Host "Registering partner ID..."
            try {
                New-AzManagementPartner -PartnerId $PartnerId -ErrorAction Stop
                Write-Host "Partner ID registered successfully."
            } catch {
                if ($_.Exception.Message -like "*already linked*") {
                    Write-Host "This Partner ID is already registered."
                } else {
                    Write-Host "An error occurred during registration: $($_.Exception.Message)"
                }
            }
        }
        "Update partner ID" {
            # Update the partner ID
            Write-Host "Updating partner ID..."
            try {
                Update-AzManagementPartner -PartnerId $PartnerId -ErrorAction Stop
                Write-Host "Partner ID updated successfully."
            } catch {
                Write-Host "An error occurred during the update: $($_.Exception.Message)"
            }
        }
        "Remove partner ID" {
            # Remove the partner ID
            Write-Host "Removing partner ID..."
            try {
                Remove-AzManagementPartner -PartnerId $PartnerId -ErrorAction Stop
                Write-Host "Partner ID removed successfully."
            } catch {
                Write-Host "An error occurred during the removal: $($_.Exception.Message)"
            }
        }
        "Exit" {
            # Exit the loop
            Write-Host "Exiting..."
            break  # Break out of the loop
        }
        default {
            Write-Host "Invalid choice. Please try again."
        }
    }

    # Exit the script entirely if the "Exit" option is selected
    if ($selectedAction -eq "Exit") {
        exit
    }
}
