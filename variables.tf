variable "region" {
  type    = string
  default = "ewr" # New York
}

variable "vultr_rate_limit" {
  type    = number
  default = 100
}

variable "vultr_retry_limit" {
  type    = number
  default = 3
}

variable "name_prefix" {
  type    = string
  default = "compute"
}

variable "vpc_ip_type" {
  type    = string
  default = "v4"
}

variable "vpc_ip_block" {
  type    = string
  default = "10.0.0.0"
}

variable "vpc_prefix_length" {
  type    = number
  default = 24
}

variable "cluster_pool_sizes" {
  type        = map(number)
  description = "Configuration for master and worker pool sizes for the K8s cluster"
  default = {
    master = 2
    worker = 3
  }
}

variable "etcd_nodes" {
  type        = list(string)
  default     = ["worker0", "worker1", "worker2"]
  description = "List of nodes to deploy etcd to; used during Ansible inventory rendering"
}

variable "instance_enable_ipv6" {
  type    = bool
  default = false
}

variable "instance_plan" {
  type        = string
  description = "Instance type and size to use"
  default     = "vc2-4c-8gb"
}

variable "instance_os_name" {
  type        = string
  description = "Name of the OS to use for cluster nodes"
  default     = "Debian 12 x64 (bookworm)"
}

variable "instance_os_id" {
  type        = number
  description = "OS ID to use for the instances"
  default     = 0
}

variable "instance_backup_state" {
  type    = string
  default = "disabled"
}

variable "instance_backup_schedule" {
  type    = string
  default = "daily"
}

variable "instance_ddos_protection" {
  type    = bool
  default = false
}

variable "instance_activation_email" {
  type    = bool
  default = false
}

variable "ssh_key_ids" {
  type        = list(string)
  default     = ["d5c629be-b141-41a7-8363-71re4022713b"]
  description = "IDs of *existing* Vultr SSH keys"
}
