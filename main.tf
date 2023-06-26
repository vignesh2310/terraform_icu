resource "aws_instance" "nv_public" {
    ami = "ami-022e1a32d3f742bd8"
    instance_type = var.instance_type
    availability_zone = var.availability_zone.zoneb
    vpc_security_group_ids = [aws_security_group.nv_sg.id]
    subnet_id = aws_subnet.pub_subnet_02.id
    tags = {
        Name = "nv_public_instance"
    }
} 

resource "aws_instance" "nv_private" {
    ami = "ami-022e1a32d3f742bd8"
    instance_type = var.instance_type
    availability_zone = var.availability_zone.zoneb
    vpc_security_group_ids = [aws_security_group.nv_sg.id]
    subnet_id = aws_subnet.pvt_subnet_02.id
    tags = {
        Name = "nv_private_instance"
    }
} 

resource "aws_vpc" "nv_vpc" {
    cidr_block = "16.0.0.0/20"
    instance_tenancy = "default"
    tags = {
        Name = "nv_vpc"
    }  
}

resource "aws_subnet" "pub_subnet_01" {
      vpc_id = aws_vpc.nv_vpc.id
      cidr_block = "16.0.0.0/24"
      availability_zone = var.availability_zone.zonea
      tags = {
        Name = "public_subnet_01"
      }
}

resource "aws_subnet" "pub_subnet_02" {
      vpc_id = aws_vpc.nv_vpc.id
      cidr_block = "16.0.1.0/24"
      availability_zone = var.availability_zone.zoneb
      tags = {
        Name = "public_subnet_02"
      }
}

resource "aws_subnet" "pub_subnet_03" {
      vpc_id = aws_vpc.nv_vpc.id
      cidr_block = "16.0.2.0/24"
      availability_zone = var.availability_zone.zonec
      tags = {
        Name = "public_subnet_03"
      }
}

resource "aws_subnet" "pvt_subnet_01" {
      vpc_id = aws_vpc.nv_vpc.id
      cidr_block = "16.0.3.0/24"
      availability_zone = var.availability_zone.zonea
      tags = {
        Name = "private_subnet_01"
      }
}

resource "aws_subnet" "pvt_subnet_02" {
      vpc_id = aws_vpc.nv_vpc.id
      cidr_block = "16.0.4.0/24"
      availability_zone = var.availability_zone.zoneb
      tags = {
        Name = "private_subnet_02"
      }
}

resource "aws_subnet" "pvt_subnet_03" {
      vpc_id = aws_vpc.nv_vpc.id
      cidr_block = "16.0.5.0/24"
      availability_zone = var.availability_zone.zonec
      tags = {
        Name = "private_subnet_03"
      }
}

resource "aws_internet_gateway" "nv_igw" {
  vpc_id = aws_vpc.nv_vpc.id

  tags = {
    Name = "north_virigina-igw"
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.nv_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nv_igw.id
  }

   tags = {
    Name = "public_route-table"
  }
}

resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.nv_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nv_igw.id
  }

   tags = {
    Name = "private_route-table"
  }
}

resource "aws_route_table_association" "pub_rt-asso" {
  subnet_id      = ["aws_subnet.pub_subnet_01.id", "aws_subnet.pub_subnet_02.id", "aws_subnet.pub_subnet_03.id"]
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pvt_rt-asso" {
  subnet_id      = ["aws_subnet.pvt_subnet_01.id", "aws_subnet.pvt_subnet_02.id", "aws_subnet.pvt_subnet_03.id"]
  route_table_id = aws_route_table.pvt_rt.id
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