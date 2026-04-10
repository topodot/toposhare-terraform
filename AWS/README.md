# AWS Terraform Setup

This guide explains how to install prerequisites, configure AWS credentials, and run the **TopoShare AWS Terraform** configuration to provision infrastructure.

* * *

# Pre-requisites

1. **Install Terraform**
  Follow the official Terraform installation instructions for your OS:
  [![](https://developer.hashicorp.com/favicon.ico)Install | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/install)
  After installation, confirm that `terraform` is available on your `PATH`:
  ```
  terraform version
  ```
2. **Install AWS CLI**
  Follow the official AWS CLI v2 installation steps:
  [![](https://docs.aws.amazon.com/assets/images/favicon.ico)Installing or updating to the latest version of the AWS CLI - AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
  Verify the AWS CLI is installed:
  ```
  aws --version
  ```
  

* * *

## Configure AWS Credentials

You must authenticate the AWS CLI before running Terraform so that Terraform can create and modify AWS resources on your behalf.

1. **Login to AWS**
  If your environment uses SSO and supports `aws login`, run:
  ```
  aws login
  ```
  Otherwise, configure credentials manually using:
  ```
  aws configure
  ```
  You will be prompted for:
  * `AWS Access Key ID`
  * `AWS Secret Access Key`
  * `Default region name` (for example: `us-east-1`)
  * `Default output format` (for example: `json`)
2. **Verify credentials**
  Confirm that your AWS credentials are working by listing your caller identity:
  ```
  aws sts get-caller-identity
  ```
  You should see your AWS account and user/role information in the output.
  

## Get the TopoShare AWS Terraform Files

1. Clone or download the TopoShare Terraform files.
2. Extract/unzip the archive (if applicable) to a local directory, for example:
  * Windows: `C:\repos\toposhare-terraform`
  * macOS/Linux: `~/repos/toposhare-terraform`
3. Open a terminal / PowerShell session in that directory.
  Examples:
  **PowerShell (Windows)**
  ```
  cd C:\repos\toposhare-terraform
  ```
  **bash (macOS/Linux)**
  ```
  cd ~/repos/toposhare-terraform
  ```
  

* * *

## Initialize and Apply Terraform

> **Important:** Ensure you are in the directory that contains the `main.tf` (and other `.tf`) files before running these commands.

1. **Initialize Terraform**
  This downloads required providers and sets up the working directory:
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
  Apply the Terraform configuration to create/update the AWS resources:
  ```
  terraform apply
  ```
  Terraform will:
  * Show you an execution plan.
  * Prompt: `Do you want to perform these actions?`
  Type `yes` and press Enter to proceed.
4. **Wait for completion**
  When finished, Terraform will display:
  * A summary of resources `added`, `changed`, or `destroyed`.
  * Any defined **outputs** (for example, URLs, ARNs, or IDs of created resources).
  Capture any important outputs for later use (e.g., endpoint URLs).
  

* * *

## Updating or Destroying Infrastructure

Use the same directory and AWS profile/credentials as when you first applied.

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
  

* * *

## Troubleshooting

* `terraform` or `aws` not found
  * Ensure both tools are installed and added to your `PATH`.
  * Open a new terminal after installation so the PATH changes take effect.
* **Authentication or permission errors**
  * Re‑run:
    ```
    aws sts get-caller-identity
    ```
  * Confirm you’re logged in to the correct AWS account and have required permissions for the resources being created.
* **Provider or plugin download issues during** `terraform init`
  * Check your network connection and proxy settings.
  * Re‑run:
    ```
    terraform init -upgrade
    ```