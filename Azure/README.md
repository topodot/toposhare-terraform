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
You must authenticate the Azure CLI before running Terraform so that Terraform can create and modify Azure resources on your behalf.
1. **Login to Azure**
	```
	az login
	```

2. **Verify credentials**
	Confirm that your Azure credentials are working and that the correct subscription is active:
	```
	az account show
	```
	You should see your Azure subscription and account information in the output.

3. **Set Subscription ID as Environment Variable**  
	  Copy the id of the subscription you wish to run these accounts under from the command above and set that as an environment variable:
	```
	$env:ARM_SUBSCRIPTION_ID="your-subscription-id-here"
	```

## Get the TopoShare Azure Terraform Files
1. Clone or download the TopoShare Terraform files.
2. Extract/unzip the archive (if applicable) to a local directory, for example:
* Windows: `C:\repos\toposhare-terraform-azure`
* macOS/Linux: `~/repos/toposhare-terraform-azure`
3. Open a terminal / PowerShell session in that directory.
Examples:
**PowerShell (Windows)**
	```powershell
	cd C:\repos\toposhare-terraform-azure
	```
**bash (macOS/Linux)**
	```bash
	cd ~/repos/toposhare-terraform-azure
	```

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
4. **Wait for completion**
	When finished, Terraform will display:
	* A summary of resources `added`, `changed`, or `destroyed`.
	* Any defined **outputs** (for example, resource IDs, endpoint URLs, or connection strings of created resources).
	Capture any important outputs for later use (e.g., endpoint URLs).
 
## Updating or Destroying Infrastructure
Use the same directory and Azure account/subscription as when you first applied.
1. **Update changes**  
	If the Terraform configuration or variables change:
	```
	terraform plan terraform apply
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