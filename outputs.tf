output "frontend_network" {
  value       = length(openstack_networking_network_v2.frontend) > 0 ? openstack_networking_network_v2.frontend.* : null
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "frontend_subnet" {
  value       = length(openstack_networking_subnet_v2.frontend) > 0 ? openstack_networking_subnet_v2.frontend.* : null
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "backend_network" {
  value       = length(openstack_networking_network_v2.backend) > 0 ? openstack_networking_network_v2.backend.* : null
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "backend_subnet" {
  value       = length(openstack_networking_subnet_v2.backend) > 0 ? openstack_networking_subnet_v2.backend.* : null
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "database_network" {
  value       = length(openstack_networking_network_v2.database) > 0 ? openstack_networking_network_v2.database.* : null
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "database_subnets" {
  value       = length(openstack_networking_subnet_v2.database) > 0 ? openstack_networking_subnet_v2.database.* : null
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "frontend_secgroups" {
  value       = length(openstack_networking_secgroup_v2.frontend) > 0 ? openstack_networking_secgroup_v2.frontend.* : null
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "backend_secgroups" {
  value       = length(openstack_networking_secgroup_v2.backend) > 0 ? openstack_networking_secgroup_v2.backend.* : null
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "database_secgroups" {
  value       = length(openstack_networking_secgroup_v2.database) > 0 ? openstack_networking_secgroup_v2.database.* : null
  sensitive   = false
  description = "description"
  depends_on  = []
}
