locals {
  project_name                       = data.vault_kv_secret_v2.openstack_provider_project_info.data["tenant_name"]
  project_domain                     = var.project_domain
  project_tags                       = var.project_tags
  architecture_tiers                 = var.architecture_tiers
  create_application_subnetpool      = var.create_application_subnetpool
  application_subnetpool_cidr_blocks = var.application_subnetpool_cidr_blocks
  create_database_subnetpool         = var.create_database_subnetpool
  database_subnetpool_cidr_blocks    = var.database_subnetpool_cidr_blocks
  frontend_subnet_prefix_len         = var.frontend_subnet_prefix_len
  backend_subnet_prefix_len          = var.backend_subnet_prefix_len
  database_subnet_prefix_len         = var.database_subnet_prefix_len
  public_nameservers                 = var.public_nameservers
  create_default_secgroups           = var.create_default_secgroups
  database_secgroup_strict           = var.database_secgroup_strict
  attach_to_external                 = var.attach_to_external
  external_network_id                = data.openstack_networking_network_v2.ext_floating.id
}
