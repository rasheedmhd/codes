provider "aws" {
    profile = "default"
    region  = "us-east-1"
}

resource "aws_instance" "test_server" {
    ami                 = "ami-0b0ea68c435eb488d"
    instance_type       = var.ec2_instance_type

    tags = {
        Name = var.instance_name
    }
}