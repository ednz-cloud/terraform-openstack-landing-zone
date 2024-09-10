output "apps_subnetpool" {
  value       = length(openstack_networking_subnetpool_v2.apps) > 0 ? openstack_networking_subnetpool_v2.apps.* : null
  sensitive   = false
  description = "The application subnetpool object (as a list), if created"
  depends_on  = []
}

output "database_subnetpool" {
  value       = length(openstack_networking_subnetpool_v2.database) > 0 ? openstack_networking_subnetpool_v2.database.* : null
  sensitive   = false
  description = "The database subnetpool object (as a list), if created"
  depends_on  = []
}

output "frontend_network" {
  value       = length(openstack_networking_network_v2.frontend) > 0 ? openstack_networking_network_v2.frontend.* : null
  sensitive   = false
  description = "The frontend network object (as a list), if created"
  depends_on  = []
}

output "frontend_subnet" {
  value       = length(openstack_networking_subnet_v2.frontend) > 0 ? openstack_networking_subnet_v2.frontend.* : null
  sensitive   = false
  description = "The frontend subnet object (as a list), if created"
  depends_on  = []
}

output "backend_network" {
  value       = length(openstack_networking_network_v2.backend) > 0 ? openstack_networking_network_v2.backend.* : null
  sensitive   = false
  description = "The backend network object (as a list), if created"
  depends_on  = []
}

output "backend_subnet" {
  value       = length(openstack_networking_subnet_v2.backend) > 0 ? openstack_networking_subnet_v2.backend.* : null
  sensitive   = false
  description = "The backend subnet object (as a list), if created"
  depends_on  = []
}

output "database_network" {
  value       = length(openstack_networking_network_v2.database) > 0 ? openstack_networking_network_v2.database.* : null
  sensitive   = false
  description = "The database network object (as a list), if created"
  depends_on  = []
}

output "database_subnet" {
  value       = length(openstack_networking_subnet_v2.database) > 0 ? openstack_networking_subnet_v2.database.* : null
  sensitive   = false
  description = "The database subnet object (as a list), if created"
  depends_on  = []
}

output "frontend_secgroups" {
  value       = length(openstack_networking_secgroup_v2.frontend) > 0 ? openstack_networking_secgroup_v2.frontend.* : null
  sensitive   = false
  description = "The frontend security group objects (as a list), if created"
  depends_on  = []
}

output "backend_secgroups" {
  value       = length(openstack_networking_secgroup_v2.backend) > 0 ? openstack_networking_secgroup_v2.backend.* : null
  sensitive   = false
  description = "The backend security group objects (as a list), if created"
  depends_on  = []
}

output "database_secgroups" {
  value       = length(openstack_networking_secgroup_v2.database) > 0 ? openstack_networking_secgroup_v2.database.* : null
  sensitive   = false
  description = "The database security group objects (as a list), if created"
  depends_on  = []
}

output "router" {
  value       = length(openstack_networking_router_v2.this) > 0 ? openstack_networking_router_v2.this.* : null
  sensitive   = false
  description = "The entire router object (as a list), if created"
  depends_on  = []
}
