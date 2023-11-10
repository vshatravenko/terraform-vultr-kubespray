output "master_public_ips" {
  value = vultr_instance.masters[*].main_ip
}

output "master_private_ips" {
  value = vultr_instance.masters[*].internal_ip
}

output "worker_public_ips" {
  value = vultr_instance.workers[*].main_ip
}

output "worker_private_ips" {
  value = vultr_instance.workers[*].internal_ip
}
