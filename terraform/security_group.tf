# -----------------------
# Security Group
# -----------------------
# Web Server Security Group
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "web front role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-web-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "web_in_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_in_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_out_tcp3000" {
  from_port                = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  to_port                  = 3000
  type                     = "egress"
  source_security_group_id = aws_security_group.app_sg.id
}

# App Security Group
resource "aws_security_group" "app_sg" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "application server role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "app_in_tcp3000" {
  from_port                = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  to_port                  = 3000
  type                     = "ingress"
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "app_out_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.app_sg.id
  to_port           = 80
  type              = "egress"
  prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
}

resource "aws_security_group_rule" "app_out_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.app_sg.id
  to_port           = 443
  type              = "egress"
  prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
}

resource "aws_security_group_rule" "app_out_tcp3306" {
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  to_port                  = 3306
  type                     = "egress"
  source_security_group_id = aws_security_group.db_sg.id
}

# opmng Security Group
resource "aws_security_group" "opmng_sg" {
  name        = "${var.project}-${var.environment}-opmng-sg"
  description = "operation and management server role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-opmng-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "opmng_in_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.opmng_sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_in_tcp3000" {
  from_port         = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.opmng_sg.id
  to_port           = 3000
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_out_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.opmng_sg.id
  to_port           = 80
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_out_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.opmng_sg.id
  to_port           = 443
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# db security group
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "database server role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "db_in_tcp3306" {
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  to_port                  = 3306
  type                     = "ingress"
  source_security_group_id = aws_security_group.app_sg.id
}