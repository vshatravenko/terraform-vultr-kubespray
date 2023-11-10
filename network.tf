resource "vultr_vpc2" "main" {
  description   = "${var.name_prefix}-${random_id.main.hex}"
  region        = var.region
  ip_type       = var.vpc_ip_type
  ip_block      = var.vpc_ip_block
  prefix_length = var.vpc_prefix_length
}
