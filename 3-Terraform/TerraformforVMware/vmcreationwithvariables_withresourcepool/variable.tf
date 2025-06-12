variable "vusername" {
 type = string  
 description = "Enter username for vcenter"
 default = "vmadmin@dc.com"
  }

  variable "vpassword" {
    type = string
    description = "Enter password for vcenter"
    default = "Passw0rd@123"
  }

  variable "vcenter" {
    type = string
    description = "Enter vcenter name or ip"
    default = "vcsa01.dc.com"
  }

  variable "VM" {
    type = string
    description = "Enter VM Name"
    
  }

  variable "join_domain" {
    type = string
    description = "Enter domain name"
    default = "dc.com"
  }

  variable "domain_admin_user" {
    type = string
    description = "Enter domain admin user"
    default = "administrator@dc.com"
    
  }

  variable "domain_admin_password" {
   type = string
   description = "enter domain admin password"
   default = "Passw0rd@123"
}

variable "allow_unverified_ssl" {
  type = bool
  default = true
}

