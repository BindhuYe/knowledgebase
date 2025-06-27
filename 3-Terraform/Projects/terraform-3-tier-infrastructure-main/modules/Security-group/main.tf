resource "aws_security_group" "frontend-sg" {
  name        = var.security_group_name_frontend
  description = "Security group for frontend access"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "frontend-sg-ingress-ssh" {
  security_group_id = aws_security_group.frontend-sg.id
  description       = "Allow SSH access"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.ssh_cidr_ipv4
}
resource "aws_vpc_security_group_ingress_rule" "frontend-sg-ingress-http" {
  security_group_id = aws_security_group.frontend-sg.id
  description       = "Allow HTTP traffic"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "frontend-sg-ingress-https" {
  security_group_id = aws_security_group.frontend-sg.id
  description       = "Allow HTTPS traffic"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "frontend-sg-egress" {
  security_group_id = aws_security_group.frontend-sg.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "backend-sg" {
  name        = var.security_group_name_backend
  description = "Security group for backend access"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "backend-sg-ingress-http" {
  security_group_id            = aws_security_group.backend-sg.id
  description                  = "Allow HTTP traffic from frontend"
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
  referenced_security_group_id = aws_security_group.frontend-sg.id
}
resource "aws_vpc_security_group_egress_rule" "backend-sg-egress" {
  security_group_id = aws_security_group.backend-sg.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "db-sg" {
  name        = var.db_sg_name
  description = "Security group for database access"
  vpc_id      = var.vpc_id
}
resource "aws_vpc_security_group_ingress_rule" "db-sg-ingress" {
  security_group_id            = aws_security_group.db-sg.id
  description                  = "Allow access from backend security group"
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.backend-sg.id
}