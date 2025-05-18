##########################
# Data
##########################
data "azurerm_resource_group" "vm_windows_rg" {
  name = var.rg_name
}

data "azurerm_subnet" "vm_windows_subnet" {
  name                 = var.network_config.subnet_name
  virtual_network_name = var.network_config.vnet_name
  resource_group_name  = var.network_config.vnet_rg
}
