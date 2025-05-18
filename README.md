# Module Name

> Insert one-liner description here.
>
> Example: This Terraform module deploys an APPLICATION on PROVIDER using SERVICE.

## Usage

Below is a basic example of how to use this module. For more detailed examples, please refer to the [examples](./examples) directory.

```terraform
module "example" {
  # Use commit hash to prevent supply chain attacks.
  # source = "github.com/organization/repository-name?ref=v1.0.0
  source = "github.com/organization/repository?ref=a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0"
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
