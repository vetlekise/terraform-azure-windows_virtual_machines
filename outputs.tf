##########################
# Outputs
##########################
output "vm_ids" {
  description = "IDs of the provisioned VMs."
  value       = { for k, vm in azurerm_windows_virtual_machine.vm_windows : k => vm.id }
}

output "vm_passwords" {
  description = "Admin passwords of the provisioned VMs."
  value       = { for k, vm in azurerm_windows_virtual_machine.vm_windows : k => random_password.password.result }
  sensitive   = true
}

output "nic_ids" {
  description = "IDs of the provisioned NICs."
  value       = { for k, nic in azurerm_network_interface.vm_windows_nic : k => nic.id }
}

output "vm_windows_config" {
  description = "Windows VMs configuration."
  value       = var.vm_windows_config
}
