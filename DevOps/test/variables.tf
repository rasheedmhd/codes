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
}

resource "aws_vpc" "apps_net" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags             = {
    Name = var.vpc_name
  }
}

# resource "aws_instance" "stac_server" {
#   ami           = var.instance_ami
#   instance_type = var.instance_type

#   tags          = {
#     Name = var.instance_name
#   }
# }

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
  bgp_asn         = var.cgw_bgp_asn
  ip_address      = var.cgw_ip_address
  type            = "ipsec.1"

  tags = {
    Name = var.customer_gateway
  }
}

# Step 2: Virtual Private Gateway
resource "aws_vpn_gateway" "main" {
  vpc_id             = aws_vpc.apps_net.id
#   amazon_side_asn    = 
#   availability_zone  =

  tags = {
    Name = var.vpn_gateway
  }
}

# Step 5: A VPN connection
resource "aws_vpn_connection" "stac_ai_vpn" {
  customer_gateway_id                     = aws_customer_gateway.main.id
  vpn_gateway_id                          = aws_vpn_gateway.main.id
  type                                    = "ipsec.1"

  tags = {
    Name = var.vpn_connection
  }
}


