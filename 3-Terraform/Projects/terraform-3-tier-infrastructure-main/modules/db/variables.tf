variable "db_name" {
  description = "The name of the database to create"
  type        = string

}
variable "db_instance_class" {
  description = "The instance class for the database"
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
variable "allocated_storage" {
  description = "The amount of storage (in GB) to allocate for the database"
  type        = number
}
variable "auto_minor_version_upgrade" {
  description = "Whether to enable auto minor version upgrades for the database"
  type        = bool
  default     = true
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
variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate with the database"
  type        = list(string)
}
variable "port" {
  description = "The port on which the database is accessible"
  type        = number
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