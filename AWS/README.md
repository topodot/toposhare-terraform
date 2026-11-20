# AWS Terraform Setup

This guide explains how to install prerequisites, configure AWS credentials, and run the **TopoShare AWS Terraform** configuration to provision infrastructure.

* * *
# Pre-requisites

1. **Install Terraform**
	Follow the official Terraform installation instructions for your OS:
	[Install | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/install)
	After installation, confirm that `terraform` is available on your `PATH`:
	```
	terraform version
	```
2. **Install AWS CLI**
	Follow the official AWS CLI v2 installation steps:
	[Installing or updating to the latest version of the AWS CLI - AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
	Verify the AWS CLI is installed:
	```
	aws --version
	```

* * *
## Configure AWS Credentials

Choose the sign-in method that matches your AWS account access. The identity you use for Terraform needs permission to provision the S3 and IAM resources in this configuration.

- **IAM Identity Center (SSO)**. Run `aws configure sso --profile toposhare` the first time, then run `aws sso login --profile toposhare` to sign in.
- **AWS Management Console credentials**. With AWS CLI v2.32.0 or later, run `aws login --profile toposhare` if your identity supports that sign-in method.
- **Access keys**. If your organization provides access keys for provisioning, run `aws configure --profile toposhare`.

Set the same profile for AWS CLI and Terraform commands in the terminal you use for deployment.

PowerShell (Windows)

```powershell
$env:AWS_PROFILE = "toposhare"
```

Bash or Zsh (macOS/Linux)

```bash
export AWS_PROFILE="toposhare"
```

Run `aws sts get-caller-identity` and confirm the account and identity before running Terraform.

## Get the TopoShare AWS Terraform Files

Clone or download the repository. If you download an archive, extract it first. Open the `AWS` subdirectory, which contains `main.tf`. Adjust these example paths to match where you put the files.

PowerShell (Windows)

```powershell
cd C:\repos\toposhare-terraform\AWS
```

Bash or Zsh (macOS/Linux)

```bash
cd ~/repos/toposhare-terraform/AWS
```

## Choose an AWS Region

Terraform uses `aws_region_code`, which defaults to `us-east-1`, for the deployment. To select a different region, set it in `AWS/terraform.tfvars` before the first plan. If the file already exists, edit the setting there.

```hcl
aws_region_code = "us-west-2"
```

For an existing deployment, keep using its original region.

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
		* Type `yes` and press Enter to proceed.

## Retrieve the TopoShare Credentials

After apply completes, run `terraform output` for the bucket name, region, and access key ID. Terraform hides the secret access key in the normal output. Retrieve it when you're ready to store it securely.

```sh
terraform output -raw secret_key
```

This command prints the secret in plain text. Store it in an approved secrets manager and keep it out of logs and Git. Keep the Terraform state and its backups in a secure location because they contain the secret too.

* * *
## Updating or Destroying Infrastructure

Use the same Terraform state, working directory, AWS account, and region as the original deployment.

1. **Update changes**
	If the Terraform configuration or variables change:
	```
	terraform plan
	terraform apply
	```
2. **Destroy all resources (use with care)**
	Before running destroy, confirm that any S3 data you need is backed up and that the bucket is empty. With this configuration, a nonempty bucket prevents Terraform from deleting the bucket, and other resources may already have been removed when that error occurs.

	To tear down the resources managed by this Terraform configuration:
	```
	terraform destroy
	```
	Review the list of resources to be destroyed and type `yes` only if you are certain.

* * *
## Troubleshooting

### `terraform` or `aws` is not found

Confirm both tools are installed and on your `PATH`. Open a new terminal after installation.

### `No configuration files`

Run Terraform from the `AWS/` directory and check that it contains `main.tf`.

### Terraform proposes recreating existing resources or outputs are missing

Stop before applying. Check that you're in the original deployment's working directory and cloud account, then run `terraform state list`. If the expected resources are missing from state, locate the original state or recover it from a backup. If you can't recover the state, [import the existing resources](https://developer.hashicorp.com/terraform/cli/import) into state and review the plan before applying.

### Provider download fails during `terraform init`

Check your network connection and proxy settings, then retry `terraform init`. Use `terraform init -upgrade` when you intend to select newer provider versions allowed by the configuration.

### `ExpiredToken`, `InvalidClientTokenId`, or the wrong AWS account

If you use temporary credentials, renew the session using the same sign-in method and profile you configured earlier. Run `aws configure list` to check where the credentials come from, then run `aws sts get-caller-identity` to verify the account and role. If you intend to use a named profile, check for old credential environment variables in the same terminal. They can override the profile's credentials. If the identity is correct but AWS returns `AccessDenied`, check that it has permission for the S3 or IAM action named in the error.

### `BucketNotEmpty` during destroy

Terraform may already have removed other resources before S3 rejected the bucket deletion. Back up any data you need and verify that the bucket is empty, including any existing object versions and delete markers. Run `terraform plan -destroy` to review what remains before retrying.
