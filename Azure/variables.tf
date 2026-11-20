variable "region_code" {
  type        = string
  description = "Region to create the new bucket"
  default     = "East US"
}
variable "resource_group_name" {
  type        = string
  description = "Name for the resource group"
  default     = "my-toposhare-resource-group"
}
variable "bucket_name" {
  type        = string
  description = "Storage account name prefix before the six-digit suffix"
  default     = "mytoposhare"

  validation {
    condition     = can(regex("^[a-z0-9]{1,18}$", var.bucket_name))
    error_message = "The storage account name prefix must be 1 to 18 lowercase letters or digits."
  }
}
variable "storage_redundancy" {
  type        = string
  description = "Storage replication type"
  default     = "LRS"
}
variable "access_tier" {
  type        = string
  description = "Access tier"
  default     = "Hot"
}
