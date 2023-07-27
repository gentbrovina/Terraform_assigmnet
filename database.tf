/*We define our database instance,
this configuration sets up a MYSQL
RDS instance in our region */
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "my_db"  
  db_subnet_group_name = aws_db_subnet.private_subnet.id
  vpc_security_group_ids  = [aws_security_group.id]
  username             = "admin"
  password             = "admin"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
/*Next, we define a backup plane that
runs every day at noon */
resource "aws_backup_plan" "example" {
  name = "tf_example_backup_plan"

  rule {
    rule_name         = "tf_example"
    target_vault_name = "vault-name"
    schedule          = "cron(0 12 * * ? *)"
  }
}
/*Next, we need to assign the backup
plan to our RDS instance */
resource "aws_backup_selection" "example" {
  name             = "tf_example_backup_selection"
  backup_plan_id   = aws_backup_plan.example.id
  iam_role_arn     = "arn:aws:iam::123456789012:role/service-role/AWSBackupDefaultServiceRole"

  resources = [
    aws_db_instance.example.arn
  ]
}