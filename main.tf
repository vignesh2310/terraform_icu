resource "aws_instance" "nv_demo" {
    ami = "ami-022e1a32d3f742bd8"
    instance_type = var.instance_type
    availability_zone = var.availability_zone
    security_groups = aws_security_group.nv_sg.id
    subnet_id = aws_subnet.nv_subnet.id
    tags = {
        Name = "nv_instance"
    }
} 

resource "aws_vpc" "nv_vpc" {
    cidr_block = "16.0.0.0/20"
    instance_tenancy = "default"
    tags = {
        Name = "nv_vpc"
    }  
}

resource "aws_subnet" "nv_subnet" {
      vpc_id = aws_vpc.nv_vpc.id
      cidr_block = "16.0.0.0/24"
      availability_zone = var.availability_zone
      tags = {
        Name = "nv_subnet"
      }
}

resource "aws_security_group" "nv_sg" {
  name        = "nv_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.nv_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.nv_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}