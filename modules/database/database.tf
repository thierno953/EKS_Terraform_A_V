resource "aws_db_subnet_group" "tfDBSubnetGroup" {
  name = "tf-db-subnet-group"
  subnet_ids = [
    var.tf_private_subnets[0].id,
    var.tf_private_subnets[1].id
  ]
  tags = {
    Name    = "tfDBSubnetGroup"
    Project = "TF Project"
  }
}

resource "aws_security_group" "tfDBSecurityGroup" {
  name   = "tf-db-security-group"
  vpc_id = var.tf_vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [
      var.tf_private_subnet_cidrs[0],
      var.tf_private_subnet_cidrs[1]
    ]
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
  engine_version         = "5.7"
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
