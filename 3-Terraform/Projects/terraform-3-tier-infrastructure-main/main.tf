
resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

}

module "ec2-frontend" {
  source            = "./modules/EC2"
  ami_id            = var.ami_id
  instance_name     = "frontend-instance"
  instance_type     = var.instance_type
  key_name          = var.key_name
  public_key_path   = var.public_key_path
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = [module.security_groups.frontend_security_group_id]

  depends_on = [module.vpc]
}

module "ec2-backend" {
  source            = "./modules/EC2"
  instance_name     = "backend-instance"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  public_key_path   = var.public_key_path
  subnet_id         = module.vpc.private_subnet_ids[0]
  security_group_id = [module.security_groups.backend_security_group_id]

  depends_on = [module.vpc]
}

module "vpc" {
  source = "./modules/VPC"

  vpc_cidr_block             = var.vpc_cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zones         = var.availability_zones
  db_subnet_group_name       = var.db_subnet_group_name
  private_subnet_ids         = module.vpc.private_subnet_ids
}
module "security_groups" {
  source                       = "./modules/Security-group"
  vpc_id                       = module.vpc.vpc_id
  ssh_cidr_ipv4                = var.ssh_cidr_ipv4
  db_sg_name                   = var.db_sg_name
  security_group_name_frontend = var.security_group_name_frontend
  security_group_name_backend  = var.security_group_name_backend


  depends_on = [module.vpc]

}
module "db" {
  source                     = "./modules/db"
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  db_engine                  = var.db_engine
  db_engine_version          = var.db_engine_version
  db_instance_class          = var.db_instance_class
  allocated_storage          = var.allocated_storage
  port                       = var.port
  db_subnet_group_name       = var.db_subnet_group_name
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  backup_retention_period    = var.backup_retention_period
  vpc_security_group_ids     = [module.security_groups.db_security_group_id]
  publicly_accessible        = var.publicly_accessible

  depends_on = [module.vpc, module.security_groups]
}
