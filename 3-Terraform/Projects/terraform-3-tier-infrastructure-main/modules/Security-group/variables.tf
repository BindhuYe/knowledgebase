variable "security_group_name_frontend" {
  description = "Name of the frontend security group"
  type        = string
}
variable "security_group_name_backend" {
  description = "Name of the backend security group"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}
variable "ssh_cidr_ipv4" {
  description = "List of CIDR blocks for SSH access"
  type        = string
}
variable "db_sg_name" {
  description = "Name of the database security group"
  type        = string
}