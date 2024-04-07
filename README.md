# terraform-openstack-lz

Terraform module to deploy a completely customizable OpenStack<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.0.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_openstack"></a> [openstack](#provider_openstack) | n/a |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [openstack_networking_network_v2.backend](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_network_v2) | resource |
| [openstack_networking_network_v2.database](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_network_v2) | resource |
| [openstack_networking_network_v2.frontend](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_network_v2) | resource |
| [openstack_networking_router_interface_v2.backend](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_router_interface_v2) | resource |
| [openstack_networking_router_interface_v2.database](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_router_interface_v2) | resource |
| [openstack_networking_router_interface_v2.frontend](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_router_interface_v2) | resource |
| [openstack_networking_router_v2.this](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_router_v2) | resource |
| [openstack_networking_secgroup_rule_v2.backend_egress](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [openstack_networking_secgroup_rule_v2.backend_ingress](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [openstack_networking_secgroup_rule_v2.database_egress](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [openstack_networking_secgroup_rule_v2.database_ingress](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [openstack_networking_secgroup_rule_v2.frontend_egress](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [openstack_networking_secgroup_rule_v2.frontend_ingress](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [openstack_networking_secgroup_v2.backend](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_v2) | resource |
| [openstack_networking_secgroup_v2.database](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_v2) | resource |
| [openstack_networking_secgroup_v2.frontend](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_v2) | resource |
| [openstack_networking_subnet_v2.backend](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_subnet_v2) | resource |
| [openstack_networking_subnet_v2.database](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_subnet_v2) | resource |
| [openstack_networking_subnet_v2.frontend](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_subnet_v2) | resource |
| [openstack_networking_subnetpool_v2.this](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_subnetpool_v2) | resource |
| [openstack_identity_project_v3.this](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/identity_project_v3) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture_tiers"></a> [architecture_tiers](#input_architecture_tiers) | The type of architecture.<br>Can be either 0, 1, 2 or 3.<br>Tier 0 will not create any subnets or networks.<br>Tier 1 will only create a single frontend subnet.<br>Tier 2 will create a frontend and backend subnet.<br>Tier 3 will create a frontend, backend and database subnet. | `number` | `1` | no |
| <a name="input_attach_to_external"></a> [attach_to_external](#input_attach_to_external) | Whether the frontend subnet should be routed or not to the external LAN.<br>This options implies that you have sufficient permissions to configure static route on the backbone infrastructure.<br>This will create an static route entry in the route table of the backbone router, in order to make your project available from the outside. | `bool` | `false` | no |
| <a name="input_backend_subnet_prefix_len"></a> [backend_subnet_prefix_len](#input_backend_subnet_prefix_len) | The prefix length of the backend subnet. Must be between 20 and 32. | `number` | `24` | no |
| <a name="input_create_default_secgroups"></a> [create_default_secgroups](#input_create_default_secgroups) | Whether to create default security groups or not.<br>Depending on your choice of architecture tiering, will create security groups so that each tier can connect to the one below.<br>Security groups for the database tier will be created for mariadb, postgresql and redis.<br>A default security group allowing ssh connection will also be created. | `bool` | `false` | no |
| <a name="input_create_subnetpool"></a> [create_subnetpool](#input_create_subnetpool) | Whether the module should create a subnet pool for this project, or use an existing one. | `bool` | `true` | no |
| <a name="input_database_secgroup_strict"></a> [database_secgroup_strict](#input_database_secgroup_strict) | Defines whether the security groups for the database network should be strict.<br>In strict mode, egress is only allowed to the backend network. | `bool` | `false` | no |
| <a name="input_database_subnet_prefix_len"></a> [database_subnet_prefix_len](#input_database_subnet_prefix_len) | The prefix length of the database subnet. Must be between 24 and 32. | `number` | `24` | no |
| <a name="input_database_subnetpool_id"></a> [database_subnetpool_id](#input_database_subnetpool_id) | The id of the subnetpool to create the databse network from.<br>Since this module can route private subnets to the backbone, it needs to make sure it's not creating overlapping subnets. | `string` | `null` | no |
| <a name="input_external_network_id"></a> [external_network_id](#input_external_network_id) | The id of the external network to connect the frontend router to. | `string` | `null` | no |
| <a name="input_external_subnet_id"></a> [external_subnet_id](#input_external_subnet_id) | The id of the external subnet to connect the frontend router to. | `string` | `null` | no |
| <a name="input_frontend_subnet_prefix_len"></a> [frontend_subnet_prefix_len](#input_frontend_subnet_prefix_len) | The prefix length of the frontend subnet. Must be between 20 and 32. | `number` | `24` | no |
| <a name="input_project_domain"></a> [project_domain](#input_project_domain) | The domain where this project will be created | `string` | `"default"` | no |
| <a name="input_project_name"></a> [project_name](#input_project_name) | The name of the project | `string` | n/a | yes |
| <a name="input_project_tags"></a> [project_tags](#input_project_tags) | The tags to append to this project | `list(string)` | `[]` | no |
| <a name="input_public_subnetpool_id"></a> [public_subnetpool_id](#input_public_subnetpool_id) | The id of the subnetpool to create the public (first 2 tier) networks from.<br>Since this module can route private subnets to the backbone, it needs to make sure it's not creating overlapping subnets. | `string` | `null` | no |
| <a name="input_subnetpool_cidr_blocks"></a> [subnetpool_cidr_blocks](#input_subnetpool_cidr_blocks) | The CIDR block for the subnet pool | `list(string)` | <pre>[<br>  "192.168.0.0/21"<br>]</pre> | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_network"></a> [backend_network](#output_backend_network) | description |
| <a name="output_backend_secgroups"></a> [backend_secgroups](#output_backend_secgroups) | description |
| <a name="output_backend_subnet"></a> [backend_subnet](#output_backend_subnet) | description |
| <a name="output_database_network"></a> [database_network](#output_database_network) | description |
| <a name="output_database_secgroups"></a> [database_secgroups](#output_database_secgroups) | description |
| <a name="output_database_subnets"></a> [database_subnets](#output_database_subnets) | description |
| <a name="output_frontend_network"></a> [frontend_network](#output_frontend_network) | description |
| <a name="output_frontend_secgroups"></a> [frontend_secgroups](#output_frontend_secgroups) | description |
| <a name="output_frontend_subnet"></a> [frontend_subnet](#output_frontend_subnet) | description |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
