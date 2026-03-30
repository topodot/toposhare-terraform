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
  description = "Name for new bucket"
  default     = "my-toposhare-repository"
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
