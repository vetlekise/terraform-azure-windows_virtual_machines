variable "vm_windows_config" {
  type = map(object({
    name                           = string
    size                           = string
    private_ip                     = string
    accelerated_networking_enabled = optional(bool)
    proximity_placement_group_id   = optional(string)
    enable_domain_joining          = bool
    domain_join = optional(object({
      domain_name    = string
      ou_path        = string
      account_name   = string
      account_secret = string
    }))
    os_disk = object({
      size    = number
      caching = string
      sa_type = string
    })
    os_image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    availability_set_id = optional(string)
    zone                = optional(number)
    kv_id               = string
    license_type        = string
    vm_tags             = map(string)
  }))
}

variable "network_config" {
  type = object({
    vnet_rg     = string
    vnet_name   = string
    subnet_name = string
  })
}
variable "rg_name" {
  type = string
}

variable "data_disks" {
  type = map(object({
    disk_name     = string
    vm_key        = string
    seq_num       = string
    lun           = number
    size          = number
    create_option = string
    caching       = string
    sa_type       = string
    zone          = optional(number)
  }))
}

variable "tags" {
  type = object({
    ManagedBy       = string
    Environment     = string
    ServiceName     = string
    ServiceProvider = string
    Region          = string
  })
}
