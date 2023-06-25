resource "aws_instance" "nv_demo" {
    ami = "ami-022e1a32d3f742bd8"
    instance_type = var.instance_type
    availability_zone = var.availability_zone
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
      vpc_id = "aws_vpc.nv_vpc.id"
      cidr_block = "16.0.0.0/24"
      tags = {
        Name = "nv_subnet"
      }
}