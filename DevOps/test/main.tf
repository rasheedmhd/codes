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

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  #   profile = "stac-ai"
}

# resource "aws_instance" "stac_ai_server" {
#   ami           = "ami-0b0ea68c435eb488d"
#   instance_type = "t2.micro"

#   tags = {
#     Name = var.aws_instance_name
#   }
# }

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# SITE-TO-SITE VPN STEPS
# Step 1: Create a customer gateway
# Step 2: Create a target gateway
# Step 3: Configure routing
# Step 4: Update your security group
# Step 5: Create a VPN connection
# Step 6: Download the configuration file
# Step 7: Configure the customer gateway device

# Step 1: Customer gateway
resource "aws_customer_gateway" "main" {
  bgp_asn         = 65000
  ip_address      = "172.83.124.10"
  type            = "ipsec.1"
#   type            = 
#   device_name     =
#   certificate_arn =

  tags = {
    Name = var.customer_gateway
  }
}

# Step 2: Virtual Private Gateway
resource "aws_vpn_gateway" "main" {
  vpc_id             = aws_vpc.main.id
#   amazon_side_asn    = 
#   availability_zone  =

  tags = {
    Name = "main"
  }
}

# Step 5: A VPN connection
resource "aws_vpn_connection" "stac_ai_vpn" {
  customer_gateway_id                     = aws_customer_gateway.main.id
  vpn_gateway_id                          = aws_vpn_gateway.main.id
#   outside_ip_address_type                 = "PrivateIpv4"
  type                                    = "ipsec.1"

  tags = {
    Name = "stac_ai_ipsec_vpn"
  }
}


