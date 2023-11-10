ssh_key_ids = ["a5d649be-b541-42a7-8e3e-713e4022713b"]

<!-- BEGIN_TF_DOCS -->
cluster_pool_sizes = {
  "master": 2,
  "worker": 3
}
etcd_nodes = [
  "worker0",
  "worker1",
  "worker2"
]
instance_activation_email = false
instance_backup_schedule  = "daily"
instance_backup_state     = "disabled"
instance_ddos_protection  = false
instance_enable_ipv6      = false
instance_os_id            = 0
instance_os_name          = "Debian 12 x64 (bookworm)"
instance_plan             = "vc2-4c-8gb"
name_prefix               = "compute"
region                    = "ewr"
ssh_key_ids = [
  "d5c629be-b141-41a7-8363-71re4022713b"
]
vpc_ip_block      = "10.0.0.0"
vpc_ip_type       = "v4"
vpc_prefix_length = 24
vultr_rate_limit  = 100
vultr_retry_limit = 3
<!-- END_TF_DOCS -->