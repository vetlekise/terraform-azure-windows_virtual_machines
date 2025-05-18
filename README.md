# Terraform - Azure - Windows Virtual Machines

A Terraform module for deploying one or more Windows virtual machines in Azure, supporting configuration of multiple data disks, MSSQL installation, and Active Directory domain joining. 

## Usage

Below is a basic example of how to use this module. For more detailed examples, please refer to the [examples](./examples) directory.

This example includes all possible inputs. Some are marked as optional and can be omitted from the code.
```Terraform
module "windows_virtual_machines" {
  source = "github.com/vetlekise/terraform-azure-windows_virtual_machines"

  rg_name = azurerm_resource_group.rg_example.name # you'll need to create this resource group separately

  network_config = {
    vnet_rg     = azurerm_resource_group.rg_example.name
    vnet_name   = azurerm_virtual_network.vnet_example.name
    subnet_name = azurerm_subnet.snet_example.name
  }
  vm_windows_config = {
    "wvm01" # vm_key = {
      name                          = "example-name"
      size                          = "example-size"
      private_ip                    = "0.0.0.0"
      enable_accelerated_networking = false # optional
      proximity_placement_group_id  = azurerm_proximity_placement_group.ppg_example.id # optional
      enable_domain_joining         = false # change this to "true" if you want to use the domain join extension
      domain_join = {
        # see the locals.tf
        domain_name    = local.domain_join.config.domain
        ou_path        = local.domain_join.config.ou_path
        account_name   = local.domain_join.config.account_name
        account_secret = local.domain_join.config.account_secret
      }
      os_disk = {
        size    = 128
        caching = "ReadWrite"
        sa_type = "Premium_LRS"
      }
      license_type = "None"
      os_image = {
        publisher = "microsoftsqlserver"
        offer     = "sql2022-ws2022"
        sku       = "standard-gen2"
        version   = "latest"
      }
      availability_set_id = azurerm_availability_set.as_example.name # optional
      zone  = 2 # optional
      kv_id = azurerm_key_vault.kv_example.id
      vm_tags = {
        Username    = "admin"
        OSType      = "Windows"
        Description = "SQL Std 2022"
      }
    }
  }

  data_disks = {
    wvm01_datadisk_01 = { # example name - the name for this data disk would be "vmname-datadisk-01". "vmname" is the VM name of the specified vm_key value
      vm_key        = "wvm01"
      disk_name     = "datadisk"
      seq_num       = "01"
      lun           = 1
      size          = 600
      create_option = "Empty"
      caching       = "None"
      sa_type       = "PremiumV2_LRS"
      zone          = 2 # optional
    }
  }

  # if you don't want any data disks you'll need to add this line:
  # data_disks = {}

  tags = local.tags # optional

  depends_on = [
    azurerm_resource_group.rg_example,
  ]
}
```

> Beginning of generated docs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.29.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.vm_windows_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_managed_disk.vm_windows_data_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.vm_windows_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.vm_windows_data_disks_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.vm_windows_domain_join](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.vm_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_key_vault_secret.vm_windows_domain_join_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_resource_group.vm_windows_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.vm_windows_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | n/a | <pre>map(object({<br/>    disk_name     = string<br/>    vm_key        = string<br/>    seq_num       = string<br/>    lun           = number<br/>    size          = number<br/>    create_option = string<br/>    caching       = string<br/>    sa_type       = string<br/>    zone          = optional(number)<br/>  }))</pre> | n/a | yes |
| <a name="input_network_config"></a> [network\_config](#input\_network\_config) | n/a | <pre>object({<br/>    vnet_rg     = string<br/>    vnet_name   = string<br/>    subnet_name = string<br/>  })</pre> | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | <pre>object({<br/>    ManagedBy       = string<br/>    Environment     = string<br/>    ServiceName     = string<br/>    ServiceProvider = string<br/>    Region          = string<br/>  })</pre> | n/a | yes |
| <a name="input_vm_windows_config"></a> [vm\_windows\_config](#input\_vm\_windows\_config) | n/a | <pre>map(object({<br/>    name                           = string<br/>    size                           = string<br/>    private_ip                     = string<br/>    accelerated_networking_enabled = optional(bool)<br/>    proximity_placement_group_id   = optional(string)<br/>    enable_domain_joining          = bool<br/>    domain_join = optional(object({<br/>      domain_name    = string<br/>      ou_path        = string<br/>      account_name   = string<br/>      account_secret = string<br/>    }))<br/>    os_disk = object({<br/>      size    = number<br/>      caching = string<br/>      sa_type = string<br/>    })<br/>    os_image = object({<br/>      publisher = string<br/>      offer     = string<br/>      sku       = string<br/>      version   = string<br/>    })<br/>    availability_set_id = optional(string)<br/>    zone                = optional(number)<br/>    kv_id               = string<br/>    license_type        = string<br/>    vm_tags             = map(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nic_ids"></a> [nic\_ids](#output\_nic\_ids) | IDs of the provisioned NICs. |
| <a name="output_vm_ids"></a> [vm\_ids](#output\_vm\_ids) | IDs of the provisioned VMs. |
| <a name="output_vm_passwords"></a> [vm\_passwords](#output\_vm\_passwords) | Admin passwords of the provisioned VMs. |
| <a name="output_vm_windows_config"></a> [vm\_windows\_config](#output\_vm\_windows\_config) | Windows VMs configuration. |
<!-- END_TF_DOCS -->

> End of generated docs

## Contributing
Start by reviewing [CONTRIBUTING.md](./docs/CONTRIBUTING.md) for guidelines on how to contribute to this project.
