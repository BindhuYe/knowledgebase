resource "aws_db_instance" "database" {
  allocated_storage          = var.allocated_storage
  db_name                    = var.db_name
  engine                     = var.db_engine
  engine_version             = var.db_engine_version
  instance_class             = var.db_instance_class
  username                   = var.db_username
  password                   = var.db_password
  parameter_group_name       = "default.mysql8.0"
  skip_final_snapshot        = true
  auto_minor_version_upgrade = var.auto_minor_version_upgrade 
  backup_retention_period    = var.backup_retention_period
  publicly_accessible        = var.publicly_accessible
  port                       = var.port
  db_subnet_group_name       = var.db_subnet_group_name
  vpc_security_group_ids     = var.vpc_security_group_ids
}

