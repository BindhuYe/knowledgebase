
provider "vsphere" {
    user           = "${var.vusername}"
    password       = "${var.vpassword}"
    vsphere_server = "${var.vcenter}"
    allow_unverified_ssl = "${var.allow_unverified_ssl}"
}

/*
    Variables
*/

#The template to use for creation of new Virtual Machine
variable "Template" { default = "template1" }
#The Resource Pool where the new VM should be created
variable "ResourcePool" { default = "Self-Service" }
#The folder where the new VM should be located
variable "Folder" { default = "prod" }

/*  
    VM Build
*/
data "vsphere_datacenter" "dc" {
    name = "DC"
}

data "vsphere_datastore" "datastore" {
    name          = "LDS1"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
    name          = "${var.ResourcePool}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_network" "network" {
    name = "prod102"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
    name          = "${var.Template}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# clone from template
resource "vsphere_virtual_machine" "Clone" {
    name             = "${var.VM}"
    resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
    datastore_id     = "${data.vsphere_datastore.datastore.id}"
    wait_for_guest_net_timeout = 0
    num_cpus = 1
    memory   = 4096
    firmware = "efi"
    guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
    scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

    network_interface {
        network_id = "${data.vsphere_network.network.id}"
        adapter_type = "vmxnet3"
    }

    disk {
        label             = "${var.VM}.vmdk"
        size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
        eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
        thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    }

    clone {
            template_uuid = "${data.vsphere_virtual_machine.template.id}"

        customize {

            windows_options {
                computer_name = "${var.VM}"
                join_domain    = "${var.join_domain}"
                domain_admin_user = "${var.domain_admin_user}"
                domain_admin_password = "${var.domain_admin_password}"
                admin_password = "Passw0rd@123"
            }

        network_interface {
            ipv4_address = "192.168.1.15"
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