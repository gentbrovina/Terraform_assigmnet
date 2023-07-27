/*Define two EC2 Instance in the Cloud with Security Groups 
with t2.micro(free tier) and a Bash Script with a simple
html file and we use python to start HTTP on port 8080 */
resource "aws_instance" "instance_1" {
  ami = "ami-2024024020435"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.id]
  security_groups = [aws_security_group.instance.name]
  use_data = <<-EOF
      #!/bin/bash
      echo "Hello World 1" >index.html
      python3 -m http.server 8080 &
      EOF
}
resource "aws_instance" "instance_2" {
  ami = "ami-2024024020435w2e"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.name]
  use_data = <<-EOF
      #!/bin/bash
      echo "Hello World 2" >index.html
      python3 -m http.server 8080 &
      EOF
}
