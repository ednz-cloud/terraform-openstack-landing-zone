terraform {
  # version requirements
  required_version = ">= 1.0.0"

  # providers requirements
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.54"
    }
  }
}

#! data sources
data "openstack_identity_project_v3" "this" {
  name      = var.project_name
  domain_id = var.project_domain
}

#! subnetpools
resource "openstack_networking_subnetpool_v2" "this" {
  count      = var.create_subnetpool ? 1 : 0
  name       = "${var.project_name}-subnetpool"
  is_default = false
  ip_version = 4
  prefixes   = var.subnetpool_cidr_blocks
}

#! networks & subnets
resource "openstack_networking_network_v2" "frontend" {
  count          = var.architecture_tiers > 0 ? 1 : 0
  name           = "${var.project_name}-frontend-network"
  description    = "Terraform managed."
  tenant_id      = data.openstack_identity_project_v3.this.id
  shared         = false
  admin_state_up = "true"
  mtu            = 1450
}

resource "openstack_networking_network_v2" "backend" {
  count          = var.architecture_tiers > 1 ? 1 : 0
  name           = "${var.project_name}-backend-network"
  description    = "Terraform managed."
  tenant_id      = data.openstack_identity_project_v3.this.id
  shared         = false
  admin_state_up = "true"
  mtu            = 1450
}

resource "openstack_networking_network_v2" "database" {
  count          = var.architecture_tiers == 3 ? 1 : 0
  name           = "${var.project_name}-database-network"
  description    = "Terraform managed."
  tenant_id      = data.openstack_identity_project_v3.this.id
  shared         = false
  admin_state_up = "true"
  mtu            = 1450
}

resource "openstack_networking_subnet_v2" "frontend" {
  count           = var.architecture_tiers > 0 ? 1 : 0
  name            = "${var.project_name}-frontend-subnet-${count.index + 1}"
  description     = "Terraform managed."
  tenant_id       = data.openstack_identity_project_v3.this.id
  network_id      = openstack_networking_network_v2.frontend[0].id
  prefix_length   = var.frontend_subnet_prefix_len
  ip_version      = 4
  subnetpool_id   = var.create_subnetpool ? openstack_networking_subnetpool_v2.this[0].id : var.public_subnetpool_id
  dns_nameservers = var.public_nameservers
}

resource "openstack_networking_subnet_v2" "backend" {
  count           = var.architecture_tiers > 1 ? 1 : 0
  name            = "${var.project_name}-backend-subnet-${count.index + 1}"
  description     = "Terraform managed."
  tenant_id       = data.openstack_identity_project_v3.this.id
  network_id      = openstack_networking_network_v2.backend[0].id
  prefix_length   = var.backend_subnet_prefix_len
  ip_version      = 4
  subnetpool_id   = var.create_subnetpool ? openstack_networking_subnetpool_v2.this[0].id : var.public_subnetpool_id
  dns_nameservers = var.public_nameservers
}

resource "openstack_networking_subnet_v2" "database" {
  count           = var.architecture_tiers == 3 ? 1 : 0
  name            = "${var.project_name}-database-subnet-${count.index + 1}"
  description     = "Terraform managed."
  tenant_id       = data.openstack_identity_project_v3.this.id
  network_id      = openstack_networking_network_v2.database[0].id
  prefix_length   = var.database_subnet_prefix_len
  ip_version      = 4
  subnetpool_id   = var.create_subnetpool ? openstack_networking_subnetpool_v2.this[0].id : var.database_subnetpool_id
  dns_nameservers = var.public_nameservers
}

#! router
resource "openstack_networking_router_v2" "this" {
  count               = var.architecture_tiers > 0 ? 1 : 0
  name                = "${var.project_name}-main-${count.index + 1}"
  description         = "Terraform managed."
  tenant_id           = data.openstack_identity_project_v3.this.id
  external_network_id = var.attach_to_external ? var.external_network_id : null
  admin_state_up      = true
}

resource "openstack_networking_router_interface_v2" "frontend" {
  count     = var.architecture_tiers > 0 ? 1 : 0
  router_id = openstack_networking_router_v2.this[0].id
  subnet_id = openstack_networking_subnet_v2.frontend[0].id
}

resource "openstack_networking_router_interface_v2" "backend" {
  count     = var.architecture_tiers > 1 ? 1 : 0
  router_id = openstack_networking_router_v2.this[0].id
  subnet_id = openstack_networking_subnet_v2.backend[0].id
}

resource "openstack_networking_router_interface_v2" "database" {
  count     = var.architecture_tiers == 3 ? 1 : 0
  router_id = openstack_networking_router_v2.this[0].id
  subnet_id = openstack_networking_subnet_v2.database[0].id
}

#! security groups
resource "openstack_networking_secgroup_v2" "frontend" {
  count = (
    var.architecture_tiers > 0 &&
    var.create_default_secgroups
  ) ? 1 : 0

  name                 = "${var.project_name}-frontend-secgroup"
  description          = "Terraform managed."
  tenant_id            = data.openstack_identity_project_v3.this.id
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "frontend_egress" {
  count = (
    var.architecture_tiers > 0 &&
    var.create_default_secgroups
  ) ? 1 : 0

  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.frontend[0].id
}

resource "openstack_networking_secgroup_rule_v2" "frontend_ingress" {
  count = (
    var.architecture_tiers > 0 &&
    var.create_default_secgroups
  ) ? 1 : 0

  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.frontend[0].id
}

resource "openstack_networking_secgroup_v2" "backend" {
  count = (
    var.architecture_tiers > 1 &&
    var.create_default_secgroups
  ) ? 1 : 0
  name                 = "${var.project_name}-backend-secgroup"
  description          = "Terraform managed."
  tenant_id            = data.openstack_identity_project_v3.this.id
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "backend_egress" {
  count = (
    var.architecture_tiers > 1 &&
    var.create_default_secgroups
  ) ? 1 : 0

  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.backend[0].id
}

resource "openstack_networking_secgroup_rule_v2" "backend_ingress" {
  count = (
    var.architecture_tiers > 1 &&
    var.create_default_secgroups
  ) ? 1 : 0

  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.frontend[0].id
  security_group_id = openstack_networking_secgroup_v2.backend[0].id
}

resource "openstack_networking_secgroup_v2" "database" {
  count = (
    var.architecture_tiers == 3 &&
    var.create_default_secgroups
  ) ? length(local.db_secgroups) : 0
  name                 = "${var.project_name}-database-${local.db_secgroups[count.index].type}-secgroup"
  description          = "Terraform managed."
  tenant_id            = data.openstack_identity_project_v3.this.id
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "database_egress" {
  count = (
    var.architecture_tiers == 3 &&
    var.create_default_secgroups
  ) ? length(local.db_secgroups) : 0

  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.database[count.index].id
}

resource "openstack_networking_secgroup_rule_v2" "database_ingress" {
  count = (
    var.architecture_tiers == 3 &&
    var.create_default_secgroups
  ) ? length(local.db_secgroups) : 0

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = local.db_secgroups[count.index].ingress_port
  port_range_max    = local.db_secgroups[count.index].ingress_port
  remote_group_id   = openstack_networking_secgroup_v2.backend[0].id
  security_group_id = openstack_networking_secgroup_v2.database[count.index].id
}
