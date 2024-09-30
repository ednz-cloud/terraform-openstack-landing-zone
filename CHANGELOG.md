## v0.2.0 (2024-09-30)

### Feat

- add network_internal_domain_name variable to allow declaring internal dns resolution for networks

### Fix

- correctly tag resources

## v0.1.0 (2024-09-10)

### Feat

- add tests to module
- add versioning requirements, and automatic documentation pipeline
- update provider requirement to be more flexible
- **outputs**: add router output and edit descriptions
- add variable for configuring public DNS upstreams on subnets
- **variables**: remove ext_subnet_id variable
- **outputs**: add subnetpool in outputs
- **outputs**: add conditions to output in case resources aren't being created
- **initial**: add openstack provider version constraint
- **initial**: add initial version of the openstack lz module
- **initial**: add initial version of the openstack lz module

### Fix

- add readme for test module
- do not make subnetpool default to avoid permission issues on public cloud
- subnetpool resource is indexed requires index number in reference
