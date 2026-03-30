variable "iam_user" {
  type        = string
  description = "IAM User to create"
  default     = "toposhare_user"
}
variable "iam_group" {
  type        = string
  description = "IAM User Group to create"
  default     = "toposhare-user-group"
}
variable "iam_group_permission_policy_name" {
  type        = string
  description = "Name for created permission policy"
  default     = "toposhare_minimum_user_permissions_policy"
}
variable "aws_region_code" {
  type        = string
  description = "AWS Region to create the new bucket"
  default     = "us-east-1"
}
variable "bucket_name" {
  type        = string
  description = "AWS bucket name for new bucket"
  default     = "my-toposhare-repo"
}
variable "use_default_storage_tier" {
  type        = bool
  description = "Bool to utilize the default storage tier on the bucket. If true, skips setting bucket lifecycle policy."
  default     = false
}
variable "bucket_lifecycle_policy_name" {
  type        = string
  description = "Bucket lifecycle policy name for setting the default 0 day storage tier"
  default     = "toposhare-default-storage-tier"
}
variable "storage_tier" {
  type        = string
  description = "Storage tier to set for 0 day lifecycle attached to bucket (applies as soon as it's uploaded)"
  default     = "INTELLIGENT_TIERING"
}
