variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}
variable "key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  type        = string
}
variable "public_key_path" {
  description = "Path to the public key file for the SSH key pair"
  type        = string
  sensitive   = true
}
variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"

}
variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)

}
variable "availability_zones" {
  description = "List of availability zones for the public subnets"
  type        = list(string)
}
variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "ssh_cidr_ipv4" {
  description = "CIDR block for SSH access"
  type        = string
}
variable "security_group_name_frontend" {
  description = "Name of the frontend security group"
  type        = string
}
variable "security_group_name_backend" {
  description = "Name of the backend security group"
  type        = string
}
variable "db_engine" {
  description = "The database engine to use"
  type        = string
}
variable "db_engine_version" {
  description = "The version of the database engine to use"
  type        = string
}
variable "db_instance_class" {
  description = "The instance class for the database"
  type        = string
}
variable "allocated_storage" {
  description = "The amount of storage (in GB) to allocate for the database"
  type        = number
}
variable "auto_minor_version_upgrade" {
  description = "Whether to enable auto minor version upgrades for the database"
  type        = bool
}
variable "backup_retention_period" {
  description = "The number of days to retain backups for the database"
  type        = number
  default     = 7
}
variable "db_subnet_group_name" {
  description = "The name of the DB subnet group to use for the database"
  type        = string
}
variable "publicly_accessible" {
  description = "Whether the database should be publicly accessible"
  type        = bool
  default     = false
}
variable "port" {
  description = "The port on which the database is accessible"
  type        = number
}
variable "db_sg_name" {
  description = "Name of the database security group"
  type        = string
}
variable "db_name" {
  description = "The name of the database to create"
  type        = string
}
variable "db_username" {
  description = "The username for the database"
  type        = string
}
variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}