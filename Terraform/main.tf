# Define Terraform provider and backend
terraform {
  backend "azurerm" {
    resource_group_name  = "manageRG"
    storage_account_name = "mencloudtfstate21421"
    container_name       = "tfstate"
    key                  = "dev.actions.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "examples_adb-lakehouse" {
  source  = "databricks/examples/databricks//modules/adb-lakehouse"
  version = "0.2.10"

  # https://registry.terraform.io/modules/databricks/examples/databricks/latest/submodules/adb-lakehouse?tab=inputs

  access_connector_name           = "MenUnity_Connector"
  databricks_workspace_name       = "MenDWS"
  data_factory_name               = "MenAnalyticsADF"
  environment_name                = "dev"
  key_vault_name                  = "MenUnityVault"
  location                        = "northeurope"
  managed_resource_group_name     = "MenAnalyticsMgr-RG"
  metastore_storage_name          = "mentastore"
  private_subnet_address_prefixes = ["10.0.3.0/24"]
  project_name                    = "MenAdvancedAnalytics"
  public_subnet_address_prefixes  = ["10.0.4.0/24"]
  shared_resource_group_name      = "MenAnalytics-RG"
  spoke_resource_group_name       = "MenAnalyticsSpoke-RG"
  spoke_vnet_address_space        = "10.0.0.0/16"
  storage_account_names           = ["menmassstorage"]
  tags = { 
    environment = "dev",
    MEN = "Data"
  }
}

resource "azurerm_purview_account" "purviewtmp" {
  name                = "mengovernance"
  resource_group_name = "MenAnalyticsSpoke-RG"
  location            = "southafricanorth"

  identity {
    type = "SystemAssigned"
  }
}