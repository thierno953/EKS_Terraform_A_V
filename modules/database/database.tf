resource "aws_db_subnet_group" "tfDBSubnetGroup" {
  name       = "tf_db_subnet_group"
  subnet_ids = var.tf_private_subnets

  tags = {
    Name    = "tfDBSubnetGroup"
    Project = "TF Project"
  }
}

resource "aws_security_group" "tfDBSecurityGroup" {
  name   = "tf_db_security_group"
  vpc_id = var.tf_vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "tfDBSecurityGroup"
    Project = "TF Project"
  }
}

resource "aws_db_instance" "tfRDS" {
  availability_zone      = var.db_az
  db_subnet_group_name   = aws_db_subnet_group.tfDBSubnetGroup.name
  vpc_security_group_ids = [aws_security_group.tfDBSecurityGroup.id]
  allocated_storage      = 20
  storage_type           = "standard"
  engine                 = "mysql"
  engine_version         = "8.0.35"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_user_name
  password               = var.db_user_password
  skip_final_snapshot    = true

  tags = {
    Name    = "tfRDS"
    Project = "TF Project"
  }
}

