resource "azurerm_resource_group" "toposhare" {
  name     = var.resource_group_name
  location = var.region_code
}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.bucket_name}${random_integer.suffix.result}" # Must be globally unique
  resource_group_name      = azurerm_resource_group.toposhare.name
  location                 = azurerm_resource_group.toposhare.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.storage_redundancy
  access_tier              = var.access_tier
  is_hns_enabled           = false

  # Enabling shared access keys (Default is true, but good to be explicit)
  shared_access_key_enabled = true
}

# Helper to ensure the storage name is unique
resource "random_integer" "suffix" {
  min = 100000
  max = 999999
}
