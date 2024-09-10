terraform {
  required_version = ">= 1.0.0"
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 2.1.0"
    }
  }
}

provider "vault" {
  address         = "https://active.vault.service.consul:8200"
  skip_tls_verify = true
}

provider "openstack" {
  auth_url                      = data.vault_kv_secret_v2.openstack_provider_region.data["auth_url"]
  region                        = data.vault_kv_secret_v2.openstack_provider_region.data["region_name"]
  tenant_name                   = data.vault_kv_secret_v2.openstack_provider_project_info.data["tenant_name"]
  application_credential_id     = data.vault_kv_secret_v2.openstack_provider_project_user.data["application_credential_id"]
  application_credential_secret = data.vault_kv_secret_v2.openstack_provider_project_user.data["application_credential_secret"]
}

data "vault_kv_secret_v2" "openstack_provider_region" {
  mount = "kv"
  name  = "infrastructure/openstack/regions/dc3_a"
}

data "vault_kv_secret_v2" "openstack_provider_project_user" {
  mount = "kv"
  name  = "infrastructure/openstack/projects/pcp_dawxdax/users/tofu"
}

data "vault_kv_secret_v2" "openstack_provider_project_info" {
  mount = "kv"
  name  = "infrastructure/openstack/projects/pcp_dawxdax/info"
}

data "openstack_networking_network_v2" "ext_floating" {
  name = "ext-floating1"
}

module "landing_zone" {
  source = "../../"

  project_name   = local.project_name
  project_domain = local.project_domain
  project_tags   = local.project_tags

  architecture_tiers                 = local.architecture_tiers
  create_application_subnetpool      = local.create_application_subnetpool
  application_subnetpool_cidr_blocks = local.application_subnetpool_cidr_blocks
  create_database_subnetpool         = local.create_database_subnetpool
  database_subnetpool_cidr_blocks    = local.database_subnetpool_cidr_blocks
  frontend_subnet_prefix_len         = local.frontend_subnet_prefix_len
  backend_subnet_prefix_len          = local.backend_subnet_prefix_len
  database_subnet_prefix_len         = local.database_subnet_prefix_len
  public_nameservers                 = local.public_nameservers

  create_default_secgroups = local.create_default_secgroups

  attach_to_external  = local.attach_to_external
  external_network_id = local.external_network_id
}
