# Azure Partner ID Management Script

This repository contains a PowerShell script that allows you to manage Partner ID registrations in your Azure Active Directory tenant. The script provides options to check, register, update, or remove a Partner ID for a given Azure tenant.

## Features

- Check the current Partner ID registration status
- Register a new Partner ID
- Update an existing Partner ID
- Remove a Partner ID
- User-friendly menu for selecting actions

## Prerequisites

### Azure PowerShell Modules

To run this script, you need the following Azure PowerShell modules installed:

- **Az.Accounts**: For Azure authentication using `Connect-AzAccount`.
- **Az.ManagementPartner**: For managing Partner IDs with `Get-AzManagementPartner`, `New-AzManagementPartner`, `Update-AzManagementPartner`, and `Remove-AzManagementPartner`.

You can install these modules using the following commands:

```powershell
# Install the main Az module (which includes all sub-modules)
Install-Module -Name Az -AllowClobber -Force

# Or install just the required sub-modules
Install-Module -Name Az.Accounts -AllowClobber -Force
Install-Module -Name Az.ManagementPartner -AllowClobber -Force
```

### Permissions

Ensure you have the appropriate Azure AD and Azure subscription roles to manage Partner IDs:

- **Azure AD Roles**: Global Administrator, Privileged Role Administrator, or Partner Center Admin.
- **Azure Subscription Roles**: Owner, Contributor, or User Access Administrator.

## Usage

1. Clone the repository:

   ```powershell
   git clone https://github.com/ctp-data-ai/azure-partner-record-management.git
   cd your-repo-name
   ```

2. Run the script:

   ```powershell
   ./azure-partner-register.ps1
   ```

3. Follow the prompts to:
   - Input your Azure Tenant ID.
   - Input your Partner ID (or use the default Partner ID `748759`).
   - Select an action from the menu:
     - **Check Partner Registration Status**
     - **Register Partner ID**
     - **Update Partner ID**
     - **Remove Partner ID**
     - **Exit**

## Example

Here's a sample session of running the script:

```text
Input your Tenant ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Input your Partner ID (Press Enter for default: 748759):
Select an action (default is 0):
0: Check partner registration status
1: Register partner ID
2: Update partner ID
3: Remove partner ID
4: Exit
```

## Troubleshooting

- **Error Handling**: If an error occurs (e.g., the Partner ID is already linked), the script will inform you and prevent the operation from proceeding.
- **Exit**: The script will loop through the menu until you select "Exit," which will terminate the script.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
