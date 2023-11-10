<!-- BEGIN_TF_DOCS -->
# Terraform Vultr Kubespray Base Module

This repository contains a Terraform module for [Vultr](vultr.io) that provides a minimal infra base for [kubespray](https://github.com/kubernetes-sigs/kubespray) to provision a Kubernetes cluster.

## Usage

Before starting, be sure to [create a Vultr API key](https://my.vultr.com/settings/#settingsapi) and export it to your shell session:
``` sh
$ export VULTR_API_KEY=*api_key*
```

Also, make sure there is at least one SSH key created on Vultr prior to infra provisioning.

### Listing available resources

If you'd like to see what's on the menu for available regions, instance types, and beyond, look no further:
* [Regions](https://www.vultr.com/api/#operation/list-regions):
```sh
curl "https://api.vultr.com/v2/regions" \
  -X GET \
  -H "Authorization: Bearer ${VULTR_API_KEY}"
```
* [Instance Types](https://www.vultr.com/api/#tag/plans):
```sh
curl "https://api.vultr.com/v2/plans" \
  -X GET \
  -H "Authorization: Bearer ${VULTR_API_KEY}"
```
* [Operating Systems](https://www.vultr.com/api/#operation/list-os):
```sh
curl "https://api.vultr.com/v2/os" \
  -X GET \
  -H "Authorization: Bearer ${VULTR_API_KEY}"
```

### Provisioning

After that, the workflow is pretty simple:
1. Configure `terraform.tfvars` to your heart's content, available variables are described below
2. Fetch Terraform provider plugins and initialize state - `terraform init`
3. Apply the configuration - `terraform apply`

If you'd like to apply a specific change of the IaC without affecting other resources, use targeting:
```sh
$ terraform apply -target *e.g. vultr_instance.masters*
```

### Cluster Setup

After the infra is provisioned, an Ansible inventory file would be rendered and available at `inventory.ini`
This file can be used as is for the kubespray playbook or customized prior to that.

        Pro tip: Make sure to disable the firewall when using iptables-based firewall rules in kubespray

To disable the default firewall(e.g. `ufw`), you can simply run:
```sh
$ ansible -i inventory.ini -m command -a "ufw disable" -u root all
```

Then, you can copy `inventory.ini` to an existing Ansible workspace, or create a new one by copying the [sample inventory]():
```sh
$ git clone https://github.com/kubernetes-sigs/kubespray -b v2.23.1
$ cp -R kubespray/inventory/sample *ansible_workspace_path*/inventory
$ cp inventory.ini *ansible_workspace_path*/inventory
```

Finally, after setting all the desired values in Kubespray config files, initiate the cluster setup:
```sh
$ ansible-playbook -i *ansible_workspace_path*/inventory.ini --user=root --become --become-user=root cluster.yml -v
```

To connect to the cluster, simply SSH to any master node, copy `/etc/kubernets/admin.conf` to your machine, and run `kubectl get nodes`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_vultr"></a> [vultr](#requirement\_vultr) | 2.17.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_vultr"></a> [vultr](#provider\_vultr) | 2.17.1 |

## Resources

| Name | Type |
|------|------|
| [local_file.inventory](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_id.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [vultr_instance.masters](https://registry.terraform.io/providers/vultr/vultr/2.17.1/docs/resources/instance) | resource |
| [vultr_instance.workers](https://registry.terraform.io/providers/vultr/vultr/2.17.1/docs/resources/instance) | resource |
| [vultr_vpc2.main](https://registry.terraform.io/providers/vultr/vultr/2.17.1/docs/resources/vpc2) | resource |
| [vultr_os.main](https://registry.terraform.io/providers/vultr/vultr/2.17.1/docs/data-sources/os) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_pool_sizes"></a> [cluster\_pool\_sizes](#input\_cluster\_pool\_sizes) | Configuration for master and worker pool sizes for the K8s cluster | `map(number)` | <pre>{<br>  "master": 2,<br>  "worker": 3<br>}</pre> | no |
| <a name="input_etcd_nodes"></a> [etcd\_nodes](#input\_etcd\_nodes) | List of nodes to deploy etcd to; used during Ansible inventory rendering | `list(string)` | <pre>[<br>  "worker0",<br>  "worker1",<br>  "worker2"<br>]</pre> | no |
| <a name="input_instance_activation_email"></a> [instance\_activation\_email](#input\_instance\_activation\_email) | n/a | `bool` | `false` | no |
| <a name="input_instance_backup_schedule"></a> [instance\_backup\_schedule](#input\_instance\_backup\_schedule) | n/a | `string` | `"daily"` | no |
| <a name="input_instance_backup_state"></a> [instance\_backup\_state](#input\_instance\_backup\_state) | n/a | `string` | `"disabled"` | no |
| <a name="input_instance_ddos_protection"></a> [instance\_ddos\_protection](#input\_instance\_ddos\_protection) | n/a | `bool` | `false` | no |
| <a name="input_instance_enable_ipv6"></a> [instance\_enable\_ipv6](#input\_instance\_enable\_ipv6) | n/a | `bool` | `false` | no |
| <a name="input_instance_os_id"></a> [instance\_os\_id](#input\_instance\_os\_id) | OS ID to use for the instances | `number` | `0` | no |
| <a name="input_instance_os_name"></a> [instance\_os\_name](#input\_instance\_os\_name) | Name of the OS to use for cluster nodes | `string` | `"Debian 12 x64 (bookworm)"` | no |
| <a name="input_instance_plan"></a> [instance\_plan](#input\_instance\_plan) | Instance type and size to use | `string` | `"vc2-4c-8gb"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `string` | `"compute"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"ewr"` | no |
| <a name="input_ssh_key_ids"></a> [ssh\_key\_ids](#input\_ssh\_key\_ids) | IDs of *existing* Vultr SSH keys | `list(string)` | <pre>[<br>  "d5c629be-b141-41a7-8363-71re4022713b"<br>]</pre> | no |
| <a name="input_vpc_ip_block"></a> [vpc\_ip\_block](#input\_vpc\_ip\_block) | n/a | `string` | `"10.0.0.0"` | no |
| <a name="input_vpc_ip_type"></a> [vpc\_ip\_type](#input\_vpc\_ip\_type) | n/a | `string` | `"v4"` | no |
| <a name="input_vpc_prefix_length"></a> [vpc\_prefix\_length](#input\_vpc\_prefix\_length) | n/a | `number` | `24` | no |
| <a name="input_vultr_rate_limit"></a> [vultr\_rate\_limit](#input\_vultr\_rate\_limit) | n/a | `number` | `100` | no |
| <a name="input_vultr_retry_limit"></a> [vultr\_retry\_limit](#input\_vultr\_retry\_limit) | n/a | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_master_private_ips"></a> [master\_private\_ips](#output\_master\_private\_ips) | n/a |
| <a name="output_master_public_ips"></a> [master\_public\_ips](#output\_master\_public\_ips) | n/a |
| <a name="output_worker_private_ips"></a> [worker\_private\_ips](#output\_worker\_private\_ips) | n/a |
| <a name="output_worker_public_ips"></a> [worker\_public\_ips](#output\_worker\_public\_ips) | n/a |
<!-- END_TF_DOCS -->
