terraform {
    required_providers {
        vultr = {
            source = "vultr/vultr"
            version = "2.17.1"
        }
    }
}

provider "vultr" {
    rate_limit = var.vultr_rate_limit
    retry_limit = var.vultr_retry_limit
}
