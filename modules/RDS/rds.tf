# This section will create the subnet group for the RDS instance using the private subnet
resource "aws_db_subnet_group" "ACS-rds" {
  name       = "acs-rds"
  subnet_ids = var.private_subnets

  tags = merge(
    var.tags,
    {
    Name = "ACS-rds"
    },
  ) 
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "ACS-rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  #instance_class        = var.db_instance_class
  name                   = var.dbname
  master-username        = var.master-username
  master-password        = var.master-password
  parameter_group_name   = "default.mysql5.7"
  #db_subnet_group_name   = aws_db_subnet_group.ACS-rds.name
  db_subnet_group_name  = var.db_subnet_group.ACS-rds
  skip_final_snapshot    = true
  vpc_security_group_ids = var.db-sg
  multi_az               = "true"
}