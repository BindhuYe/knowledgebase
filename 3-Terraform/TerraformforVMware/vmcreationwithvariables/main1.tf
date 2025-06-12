provider "vsphere" {
  user           = "${var.vusername}"
  password       = "${var.vpassword}"
  vsphere_server = "${var.vcenter}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "DC"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "NC"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "LDS1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "prod102"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "template1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.VM}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  firmware = var.vm_firmware
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
 

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = false
    thin_provisioned = true
    
   
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
                computer_name = "${var.VM}"
                join_domain    = "${var.join_domain}"
                domain_admin_user = "${var.domain_admin_user}"
                domain_admin_password = "${var.domain_admin_password}"
                admin_password = "${var.domain_admin_password}"
                time_zone = 004
            }

        network_interface {
            ipv4_address = "192.168.1.50"
            ipv4_netmask = "24"
            dns_server_list = ["192.168.1.10"]
            dns_domain = "dc.com"
        }
        ipv4_gateway    = "192.168.1.254"
    }
  }
}

output "ID" {
    value = "${data.vsphere_network.network.id}"
}
