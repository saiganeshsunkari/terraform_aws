variable "rds_mysql_sg_id" {}
variable "rds_mysql_subnet_id" {}

resource "aws_db_subnet_group" "mysqlDbSubnetGroup" {
  name = "dev_proj_1_rds_subnet_group"
  subnet_ids = var.rds_mysql_subnet_id
}

resource "aws_db_instance" "mysqlRdsInstance" {
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  engine                  = "mysql"
  engine_version          = "8.0"
  identifier              = "mydb"
  username                = "dbuser"
  password                = "dbpassword"
  vpc_security_group_ids  = [var.rds_mysql_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.mysqlDbSubnetGroup.name
  db_name                 = "devprojdb"
  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false
}