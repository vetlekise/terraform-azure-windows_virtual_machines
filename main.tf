# main.tf

##########################
# Virtual Machines
##########################
resource "azurerm_windows_virtual_machine" "vm_windows" {
  for_each = var.vm_windows_config

  name                         = each.value.name
  location                     = data.azurerm_resource_group.vm_windows_rg.location
  resource_group_name          = data.azurerm_resource_group.vm_windows_rg.name
  size                         = each.value.size
  admin_username               = "adminuser"
  admin_password               = random_password.password[each.key].result
  availability_set_id          = each.value.availability_set_id # Optional
  zone                         = each.value.zone                # Optional
  license_type                 = each.value.license_type
  proximity_placement_group_id = each.value.proximity_placement_group_id
  network_interface_ids = [
    azurerm_network_interface.vm_windows_nic[each.key].id,
  ]

  # Patching configuration
  patch_mode            = "AutomaticByOS"
  patch_assessment_mode = "AutomaticByPlatform"
  provision_vm_agent    = true
  hotpatching_enabled   = false

  encryption_at_host_enabled = true

  os_disk {
    name                     = "${each.value.name}-osdisk01"
    caching                  = each.value.os_disk.caching
    storage_account_type     = each.value.os_disk.sa_type
    disk_size_gb             = each.value.os_disk.size
    security_encryption_type = "PlatformManagedKey"
  }

  source_image_reference {
    publisher = each.value.os_image.publisher
    offer     = each.value.os_image.offer
    sku       = each.value.os_image.sku
    version   = each.value.os_image.version
  }

  lifecycle {
    ignore_changes = [
      identity,
      location,
      admin_password
    ]
  }

  tags = merge(var.tags, each.value.vm_tags)
}

##########################
# Network Interface Cards
##########################
resource "azurerm_network_interface" "vm_windows_nic" {
  for_each = var.vm_windows_config

  name                = "${each.value.name}-nic01"
  location            = data.azurerm_resource_group.vm_windows_rg.location
  resource_group_name = data.azurerm_resource_group.vm_windows_rg.name

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = data.azurerm_subnet.vm_windows_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.private_ip
  }
  accelerated_networking_enabled = each.value.accelerated_networking_enabled

  lifecycle {
    ignore_changes = [
      location
    ]
  }
  tags = var.tags
}

##########################
# Managed Data Disks
##########################
resource "azurerm_managed_disk" "vm_windows_data_disk" {
  for_each = var.data_disks

  name                = "${azurerm_windows_virtual_machine.vm_windows[each.value.vm_key].name}-${each.value.disk_name}${each.value.seq_num}"
  location            = data.azurerm_resource_group.vm_windows_rg.location
  resource_group_name = data.azurerm_resource_group.vm_windows_rg.name

  storage_account_type = each.value.sa_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.size
  zone                 = each.value.zone

  # Fix for CKV_AZURE_251: Ensure Azure Virtual Machine disks are configured without public network access
  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [
      location
    ]
  }
}


##########################
# Managed Data Disks - Attachments
##########################
resource "azurerm_virtual_machine_data_disk_attachment" "vm_windows_data_disks_attachment" {
  for_each = var.data_disks

  managed_disk_id    = azurerm_managed_disk.vm_windows_data_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_windows[each.value.vm_key].id
  lun                = each.value.lun
  caching            = each.value.caching
}

##########################
# Generated Passwords
##########################
resource "random_password" "password" {
  for_each = var.vm_windows_config

  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

##########################
# Secrets
##########################
resource "azurerm_key_vault_secret" "vm_windows_password" {
  for_each = var.vm_windows_config

  name         = "${each.value.name}-password"
  value        = random_password.password[each.key].result
  key_vault_id = each.value.kv_id

  content_type = "text/plain"

  tags = merge(var.tags, {
    Username    = "adminuser"
    Description = "Admin password for ${each.value.name}"
  })
}

data "azurerm_key_vault_secret" "vm_windows_domain_join_password" {
  for_each = {
    for k, vm in var.vm_windows_config : k => vm
    if vm.enable_domain_joining != false && vm.domain_join != null
  }

  name         = each.value.domain_join.account_secret
  key_vault_id = each.value.kv_id
}

##########################
# Domain Join
##########################
resource "azurerm_virtual_machine_extension" "vm_windows_domain_join" {
  for_each = {
    for k, vm in var.vm_windows_config : k => vm
    if vm.enable_domain_joining != false && vm.domain_join != null
  }

  name                 = "ADDomainJoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm_windows[each.key].id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  settings             = <<SETTINGS
     {
         "Name": "${each.value.domain_join.domain_name}",
         "OUPath": "${each.value.domain_join.ou_path}",
         "User": "${each.value.domain_join.domain_name}\\${each.value.domain_join.account_name}",
         "Restart": "true",
         "Options": "3"
     }
 SETTINGS

  protected_settings = jsonencode({
    "Password" : data.azurerm_key_vault_secret.vm_windows_domain_join_password[each.key].value
  })

  lifecycle {
    ignore_changes = [
      protected_settings
    ]
  }

  tags = merge(var.tags, {
    Description = "VM extension for joining an existing domain"
  })
}
