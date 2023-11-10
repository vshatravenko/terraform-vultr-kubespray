data "vultr_os" "main" {
  filter {
    name   = "name"
    values = [var.instance_os_name]
  }
}

resource "vultr_instance" "masters" {
  count = var.cluster_pool_sizes["master"]

  plan   = var.instance_plan
  region = var.region
  os_id  = var.instance_os_id == 0 ? data.vultr_os.main.id : var.instance_os_id
  label  = "${var.name_prefix}-${random_id.main.hex}-master"
  tags   = ["${var.name_prefix}-${random_id.main.hex}-master"]

  hostname    = "${var.name_prefix}-${random_id.main.hex}-master-${count.index}"
  enable_ipv6 = var.instance_enable_ipv6

  ssh_key_ids = var.ssh_key_ids

  vpc2_ids = [vultr_vpc2.main.id]

  backups = var.instance_backup_state
  dynamic "backups_schedule" {
    for_each = var.instance_backup_state == "enabled" ? [1] : []
    content {
      type = var.instance_backup_schedule
    }
  }

  ddos_protection  = var.instance_ddos_protection
  activation_email = var.instance_activation_email
}

resource "vultr_instance" "workers" {
  count = var.cluster_pool_sizes["worker"]

  plan   = var.instance_plan
  region = var.region
  os_id  = var.instance_os_id == 0 ? data.vultr_os.main.id : var.instance_os_id
  label  = "${var.name_prefix}-${random_id.main.hex}-worker"
  tags   = ["${var.name_prefix}-${random_id.main.hex}-worker"]

  hostname    = "${var.name_prefix}-${random_id.main.hex}-worker-${count.index}"
  enable_ipv6 = var.instance_enable_ipv6

  ssh_key_ids = var.ssh_key_ids

  vpc2_ids = [vultr_vpc2.main.id]

  backups = var.instance_backup_state
  dynamic "backups_schedule" {
    for_each = var.instance_backup_state == "enabled" ? [1] : []
    content {
      type = var.instance_backup_schedule
    }
  }

  ddos_protection  = var.instance_ddos_protection
  activation_email = var.instance_activation_email
}

resource "local_file" "inventory" {
  filename = "inventory.ini"
  content = templatefile("tpl/inventory.ini.tftpl", {
    masters    = vultr_instance.masters[*],
    workers    = vultr_instance.workers[*],
    etcd_nodes = var.etcd_nodes,
  })
}
