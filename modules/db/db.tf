


resource "aws_db_instance" "postgres_instance" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  identifier             = "impactes-mobile-dev"
  db_name                = "impactes"
  username               = var.instance_username
  password               = var.instance_password
  parameter_group_name   = aws_db_parameter_group.custom_rds_parameter_group.name
  publicly_accessible    = false
  vpc_security_group_ids = [var.rds_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.id
  skip_final_snapshot = true
}


resource "aws_db_subnet_group" "rds_subnet" {
  name       = "impactes-mobile-dev"
  subnet_ids = var.subnet_ids
}

resource "aws_db_parameter_group" "custom_rds_parameter_group" {
  name        = "impactes-mobile-custom-rds-parameter-group-dev"
  family      = "postgres16"
  description = "Custom parameter group without rds.force_ssl"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

output "db_address" {
  value = aws_db_instance.postgres_instance.address
}