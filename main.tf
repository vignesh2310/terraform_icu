resource "aws_instance" "nv_demo" {
    ami = "ami-022e1a32d3f742bd8"
    instance_type = var.instance_type
    availability_zone = var.availability_zone
    tags = {
        name = "n.v_ins_demo"
    }
} 