#Create EC2 instance
resource "aws_instance" "my-ec2" {
  ami                    = "ami-0d7a109bf30624c99"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.mysecgrp.id]
  instance_type          = "t2.micro"
  #key_name               = "terraform-key"
  count = 2
  #user_data = file("apache-install.sh")
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
    EOF

  tags = {
    "Name" = "myec2vm-${count.index}"

  }
}



/*# Resource Block: Create Random pet name
resource "random_pet" "uniquebucket" {
  length = 5
  separator = "-"
}

# Resource Block: Create bucket
resource "aws_s3_bucket" "example" {
  bucket = random_pet.uniquebucket.id
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
} */