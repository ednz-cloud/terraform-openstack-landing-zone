#! global variables
variable "project_name" {
  type        = string
  description = "The name of the project"
  validation {
    condition     = can(regex("^[0-9A-Za-z-_]+$", var.project_name))
    error_message = "For the project_name value only a-z, A-Z, 0-9, - and _ are allowed."
  }
}

variable "project_domain" {
  type        = string
  description = "The domain where this project will be created"
  default     = "default"
}

variable "project_tags" {
  type        = list(string)
  description = "The tags to append to this project"
  default     = []
}

#! architecture tiering variables
variable "architecture_tiers" {
  type        = number
  description = <<-EOT
    The type of architecture.
    Can be either 0, 1, 2 or 3.
    Tier 0 will not create any subnets or networks.
    Tier 1 will only create a single frontend subnet.
    Tier 2 will create a frontend and backend subnet.
    Tier 3 will create a frontend, backend and database subnet.
  EOT
  default     = 1
  validation {
    condition = (
      var.architecture_tiers > 0 &&
      var.architecture_tiers <= 3
    )
    error_message = "The architecture_tiers must be between 0 and 3."
  }
}

#! subnetpool creation
variable "create_subnetpool" {
  type        = bool
  description = "Whether the module should create a subnet pool for this project, or use an existing one."
  default     = true
}

variable "subnetpool_cidr_blocks" {
  type        = list(string)
  description = "The CIDR block for the subnet pool"
  default     = ["192.168.0.0/21"]
  validation {
    condition = alltrue([
      for i in var.subnetpool_cidr_blocks : can(cidrhost(i, 0))
    ])
    error_message = "The subnetpool_cidr_blocks must be a valid IPv4 CIDR"
  }
}

#! networking variables
variable "frontend_subnet_prefix_len" {
  type        = number
  description = "The prefix length of the frontend subnet. Must be between 20 and 32."
  default     = 24
  validation {
    condition = (
      var.frontend_subnet_prefix_len >= 20 &&
      var.frontend_subnet_prefix_len <= 32
    )
    error_message = "The prefix length must be between 20 and 32."
  }
}

variable "backend_subnet_prefix_len" {
  type        = number
  description = "The prefix length of the backend subnet. Must be between 20 and 32."
  default     = 24
  validation {
    condition = (
      var.backend_subnet_prefix_len >= 20 &&
      var.backend_subnet_prefix_len <= 32
    )
    error_message = "The prefix length must be between 20 and 32."
  }
}

variable "database_subnet_prefix_len" {
  type        = number
  description = "The prefix length of the database subnet. Must be between 24 and 32."
  default     = 24
  validation {
    condition = (
      var.database_subnet_prefix_len >= 24 &&
      var.database_subnet_prefix_len <= 32
    )
    error_message = "The prefix length must be between 24 and 32."
  }
}

variable "public_nameservers" {
  type        = list(string)
  description = <<-EOT
    A list of public DNS servers to upstreams requests to in your subnets.
    This is not necessary if your openstack deployment already has configured default upstreams for neutron.
  EOT
  default     = []
}

#! security variables
variable "create_default_secgroups" {
  type        = bool
  description = <<-EOT
    Whether to create default security groups or not.
    Depending on your choice of architecture tiering, will create security groups so that each tier can connect to the one below.
    Security groups for the database tier will be created for mariadb, postgresql and redis.
    A default security group allowing ssh connection will also be created.
  EOT
  default     = false
}

variable "database_secgroup_strict" {
  type        = bool
  description = <<-EOT
    Defines whether the security groups for the database network should be strict.
    In strict mode, egress is only allowed to the backend network.
  EOT
  default     = false
}

locals {
  db_secgroups = [
    {
      type         = "mariadb"
      ingress_port = 3306
    },
    {
      type         = "postgresql"
      ingress_port = 5432
    },
    {
      type         = "mysql"
      ingress_port = 3306
    },
    {
      type         = "redis"
      ingress_port = 6379
    }
  ]
}

#! subnetpool variables & validation
variable "public_subnetpool_id" {
  type        = string
  description = <<-EOT
    The id of the subnetpool to create the public (first 2 tier) networks from.
    Since this module can route private subnets to the backbone, it needs to make sure it's not creating overlapping subnets.
  EOT
  default     = null
}

variable "database_subnetpool_id" {
  type        = string
  description = <<-EOT
    The id of the subnetpool to create the databse network from.
    Since this module can route private subnets to the backbone, it needs to make sure it's not creating overlapping subnets.
  EOT
  default     = null
}

locals {
  validate_public_subnetpool_ids = (
    var.architecture_tiers > 0 &&
    var.create_subnetpool == false &&
    var.public_subnetpool_id == null
  ) ? tobool("You have to either create or specify an existing subnetpool to create the public subnets from") : true
  validate_database_subnetpool_ids = (
    var.architecture_tiers > 2 &&
    var.create_subnetpool == false &&
    var.database_subnetpool_id == null
  ) ? tobool("You have to either create or specify an existing subnetpool to create the database subnets from") : true
}

#! public network attachement variables
variable "attach_to_external" {
  type        = bool
  description = <<-EOT
    Whether the frontend subnet should be routed or not to the external LAN.
    This options implies that you have sufficient permissions to configure static route on the backbone infrastructure.
    This will create an static route entry in the route table of the backbone router, in order to make your project available from the outside.
  EOT
  default     = false
}

variable "external_network_id" {
  type        = string
  description = "The id of the external network to connect the frontend router to."
  default     = null
}

locals {
  validate_external_network_id = (
    var.architecture_tiers > 0 &&
    var.attach_to_external &&
    var.external_network_id == null
  ) ? tobool("Please pass in the external network ID to attach the frontend router to.") : true
}
