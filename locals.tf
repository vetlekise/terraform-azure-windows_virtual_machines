/*
locals {
  domain_join = {
    config = {
      domain         = "domain.com"
      ou_path        = "OU=Azure,DC=domain,DC=no"
      account_name   = "adjoin-account" # the account name used by the service account that can domain join the machine
      account_secret = "adjoin-account-password" # the name of the secret holding the password for the service account
    }
  }
}
*/
