# Set terraform and provider settings: https://www.terraform.io/docs/configuration/terraform.html#specifying-provider-requirements

terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
