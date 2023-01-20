terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.38.0"
    }
  }
}

provider "azurerm" {
  # Configuration options for the above-mentioned Azure Provider 

subscription_id = "d7f702bf-9da6-45cf-b201-e2f546f03408"
tenant_id = "dfe21b68-66ac-46dd-9af5-dbc58545a2c4"
client_id = "a83f335a-5eca-40c8-ba17-5baf0d0c381d"
client_secret = "ROI8Q~n-QLwYYN_gpalDTakNicMCvRyIPAKFsce3"

features {}
 
}

terraform {
  
  backend "azurerm" {
    resource_group_name = "RG-TFBE-STORAGE"
    storage_account_name = "stotfbe"
    container_name = "devtfstate"
    key = "dev.tfstate"

  }

}