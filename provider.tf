#################################################################################
# PROVIDER NEEDED IF NOT USING AZURE CLI THAT HAS ALREADY BEEN AUTHENTICATED 
#################################################################################

# Need to create a service principle in the Azure subscription for this to work
# FROM CLI: az ad sp create-for-rbac --name="TerraformSP" --role="Contributor" --scopes="/subscriptions/<subID>"
# This results in an application ID, client secret, and tenant ID that can be used below for login:

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.54.0"
    }
  }
}

provider "azurerm" {
  features {}
}