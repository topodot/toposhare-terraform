# Azure Terraform Setup

This guide explains how to install prerequisites, configure Azure credentials, and run the **TopoShare Azure Terraform** configuration to provision infrastructure in Azure.

# Pre-requisites

1. **Install Terraform**  
	Follow the official Terraform installation instructions for your OS:  
	[Install | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/install)

	After installation, confirm that `terraform` is available on your `PATH`:
	```
	terraform version
	```

2. **Install Azure CLI**  
	Follow the official Azure CLI installation steps:  
	[How to install the Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
  
	Verify the Azure CLI is installed:
	```
	az version
	```
## Configure Azure Credentials

1. Sign in with `az login`.
2. Run `az account show` and confirm the subscription. To switch, run `az account set --subscription "<subscription-id>"` and check it again.
3. Set `ARM_SUBSCRIPTION_ID` to that subscription's ID in the terminal where you run Terraform. The AzureRM provider requires an explicit subscription ID.

   PowerShell (Windows)

   ```powershell
   $env:ARM_SUBSCRIPTION_ID = "your-subscription-id-here"
   ```

   Bash or Zsh (macOS/Linux)

   ```bash
   export ARM_SUBSCRIPTION_ID="your-subscription-id-here"
   ```

## Get the TopoShare Azure Terraform Files

Clone or download the repository. If you download an archive, extract it first. Open the `Azure` subdirectory, which contains `main.tf`. Adjust these example paths to match where you put the files.

PowerShell (Windows)

```powershell
cd C:\repos\toposhare-terraform\Azure
```

Bash or Zsh (macOS/Linux)

```bash
cd ~/repos/toposhare-terraform/Azure
```

## Choose a Storage Account Name

Terraform appends six digits to `bucket_name` to form the storage account name. The default prefix is `mytoposhare`. A custom prefix must contain 1 to 18 lowercase letters or digits. Azure requires the full name to be globally unique. If the generated name is taken on a first deployment, choose a different prefix.

To override the default, set `bucket_name` in `Azure/terraform.tfvars` before the first plan.

```hcl
bucket_name = "yourtoposhare"
```

For an existing deployment, keep using the original prefix and Terraform state. Changing the prefix makes Terraform plan to replace the storage account.

## Initialize and Apply Terraform
> **Important:** Ensure you are in the directory that contains the `main.tf` (and other `.tf`) files before running these commands.

1. **Initialize Terraform**  
	This downloads required providers (including the Azure provider) and sets up the working directory:
	```
	terraform init
	```
	On success, you should see something like `Terraform has been successfully initialized!`.
2. **Review the execution plan (recommended)**  
	Generate and review a plan of the changes Terraform will make:
	```
	terraform plan
	```
	* Confirm the resources to be created/updated/destroyed match expectations.
	* If something looks wrong, stop and review the configuration before continuing.
3. **Apply the configuration**  
	Apply the Terraform configuration to create/update the Azure resources:
	```
	terraform apply
	```
	Terraform will:
	* Show you an execution plan.
	* Prompt: `Do you want to perform these actions?`
		* Type `yes` and press Enter to proceed.

## Retrieve the TopoShare Connection String

Terraform hides the storage account connection string in the normal apply output. After apply completes, retrieve it when you're ready to store it securely.

```sh
terraform output -raw primary_connection_string
```

This command prints the connection string in plain text. Store it in an approved secrets manager and keep it out of logs and Git. Keep the Terraform state and its backups in a secure location because they contain the connection string too.

## Updating or Destroying Infrastructure
Use the same Terraform state, working directory, and Azure subscription as the original deployment.
1. **Update changes**  
	If the Terraform configuration or variables change:
	```
	terraform plan
	terraform apply
	```
2. **Destroy all resources (use with care)**  
	To tear down all resources managed by this Terraform configuration:
	```
	terraform destroy
	```
	Review the list of resources to be destroyed and type `yes` only if you are certain.

## Troubleshooting

### `terraform` or `az` is not found

Confirm both tools are installed and on your `PATH`. Open a new terminal after installation.

### `No configuration files`

Run Terraform from the `Azure/` directory and check that it contains `main.tf`.

### Terraform proposes recreating existing resources or outputs are missing

Stop before applying. Check that you're in the original deployment's working directory and cloud account, then run `terraform state list`. If the expected resources are missing from state, locate the original state or recover it from a backup. If you can't recover the state, [import the existing resources](https://developer.hashicorp.com/terraform/cli/import) into state and review the plan before applying.

### Provider download fails during `terraform init`

Check your network connection and proxy settings, then retry `terraform init`. Use `terraform init -upgrade` when you intend to select newer provider versions allowed by the configuration.

### Wrong Azure subscription or an authorization error

Run `az account show` and confirm the tenant and subscription. Check that `ARM_SUBSCRIPTION_ID` matches the intended subscription in the terminal running Terraform. If both are correct and you still get `AuthorizationFailed`, check with your Azure administrator that your role allows the action named in the error.

### `MissingSubscriptionRegistration` or `RequestDisallowedByPolicy`

For a registration error, ask your Azure administrator to check whether the provider named in the error, such as `Microsoft.Storage`, is registered in the target subscription. For a policy error, ask the administrator to review the policy assignment named in the error and identify which setting it blocks.

### TopoShare rejects the storage account connection string

If Azure returns `KeyBasedAuthenticationNotPermitted`, check with your Azure administrator whether the storage account allows Shared Key access. The connection string generated by this configuration uses an account key and cannot authenticate while Shared Key access is disallowed.
