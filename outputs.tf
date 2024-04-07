output "frontend_network" {
  value       = openstack_networking_network_v2.frontend.*
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "frontend_subnet" {
  value       = openstack_networking_subnet_v2.frontend.*
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "backend_network" {
  value       = openstack_networking_network_v2.backend.*
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "backend_subnet" {
  value       = openstack_networking_subnet_v2.backend.*
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "database_network" {
  value       = openstack_networking_network_v2.database.*
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "database_subnets" {
  value       = openstack_networking_subnet_v2.database.*
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "frontend_secgroups" {
  value       = openstack_networking_secgroup_v2.frontend.*
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "backend_secgroups" {
  value       = openstack_networking_secgroup_v2.backend.*
  sensitive   = false
  description = "description"
  depends_on  = []
}

output "database_secgroups" {
  value       = openstack_networking_secgroup_v2.database.*
  sensitive   = false
  description = "description"
  depends_on  = []
}
