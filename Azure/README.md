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
* `terraform` or `az` not found
	* Ensure both tools are installed and added to your `PATH`.
	* Open a new terminal after installation so the PATH changes take effect.
* **Authentication or permission errors**
	* Re‑run:
	    ```
	    az account show
	    ```
	* Confirm you’re logged in to the correct Azure tenant and subscription and have the required permissions (e.g., Contributor/Owner or appropriate custom role) for the resources being created.
* **Provider or plugin download issues during** `terraform init`
	* Check your network connection and proxy settings.
	* Re‑run:
	    ```
	    terraform init -upgrade
	    ```