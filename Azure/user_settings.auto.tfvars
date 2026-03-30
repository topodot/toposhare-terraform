# Use available region names from https://learn.microsoft.com/en-us/azure/reliability/regions-list
region_code = "East US"

# The name of the resource group in which to create the storage account.
# Changing this forces a new resource to be created.
resource_group_name = "my-toposhare-resource-group"

# A random integer is appended to the end of the chosen bucket name for uniqueness
# Can only consist of lowercase letters and numbers, and must be between 3 and 18 characters long
bucket_name = "toposharerepo"

# Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.
# Changing this after the resource has been created
# forces a new resource to be created when types LRS, GRS and RAGRS
# are changed to ZRS, GZRS or RAGZRS and vice versa.
storage_redundancy = "LRS"

# Defines the access tier for StorageV2 accounts.
# Valid options are Hot, Cool, Cold and Premium
access_tier = "Hot"
