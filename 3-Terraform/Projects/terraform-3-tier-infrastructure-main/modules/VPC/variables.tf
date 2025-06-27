variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

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
variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}
variable "private_subnet_ids" {
  description = "List of private subnet IDs for the DB subnet group"
  type        = list(string)
}