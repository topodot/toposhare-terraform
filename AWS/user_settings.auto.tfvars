iam_user                 = "toposhare-user"

iam_group                = "toposhare-user-group"

# Use available region code from https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html
aws_region_code          = "us-east-1"

# A random integer is appended to this bucket name for global uniqueness
bucket_name              = "my-toposhare-repository"

# Set to false to use the defined AWS storage tier below
use_default_storage_tier = true

# ----------------------------------------------------------------------------------------------------
#  Sets a 0 day bucket lifecycle policy to adjust uploaded file storage class
#  See https://registry.terraform.io/providers/hashicorp/aws/4.2.0/docs/resources/s3_bucket_lifecycle_configuration#transition for valid storage_classes
#  TopoShare is NOT compatible with DEEP_ARCHIVE, GLACIER, or GLACIER_IR
# ----------------------------------------------------------------------------------------------------
storage_tier = "INTELLIGENT_TIERING"