variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}
variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  type        = string
}
variable "public_key_path" {
  description = "Path to the public key file for the SSH key pair"
  type        = string
}
variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}
variable "security_group_id" {
  description = "List of security group IDs to associate with the EC2 instance"
  type        = list(string)
}