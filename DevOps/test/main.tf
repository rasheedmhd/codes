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
resource "aws_internet_gateway" "igw" {
  vpc_id 			= aws_vpc.apps_net.id

  tags = {
    Name 			= var.internet_gateway
  }
}

# Step 5: A VPN connection
resource "aws_vpn_connection" "main_vpn" {
  customer_gateway_id                     = aws_customer_gateway.main.id
  aws_internet_gateway                    = aws_internet_gateway.igw.id
  vpn_gateway_id                          = aws_vpn_gateway.main.id
  type                                    = "ipsec.1"

  tags = {
    Name = var.vpn_connection
  }
}

# SUBNETS
resource "aws_subnet" "PublicSubnet" {
  vpc_id              				= aws_vpc.apps_net.id
  cidr_block          				= "10.0.0.0/24"
  availability_zone   				= "us-east-1a"
  # Specify true to indicate that instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch     = true

  tags = {
    Name = "PublicSubnet"
  }
}


resource "aws_subnet" "Applications" {
  vpc_id              				= aws_vpc.apps_net.id
  cidr_block          				= "10.0.0.0/24"
  availability_zone   				= "us-east-1c"
  # Specify true to indicate that instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch     = false

  tags = {
    # Applications
    Name = "ApplicationsPrivateSubnet"
  }
}

resource "aws_subnet" "DataServices" {
  vpc_id              				= aws_vpc.apps_net.id
  cidr_block          				= "10.0.0.0/24"
  availability_zone   				= "us-east-1f"
  # Specify true to indicate that instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch     = false

  tags = {
    # Data Services
    Name = "DataServicesIsolatedSubnet"
  }
}

// EC2 instance to be spinned up in the Public Subnet
resource "aws_instance" "public_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.PublicSubnet.id

  tags          = {
    Name = var.instance_name
  }
}

// EC2 instance to be spinned up in the Private Subnet
// For the Purpose of hosting applications
resource "aws_instance" "applications_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.Applications.id

  tags          = {
    Name = "private-applicatations-server"
  }
}

// EC2 instance to be spinned up in the Isolated Subnet
// For the Purpose of hosting data
resource "aws_instance" "isolated_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.DataServices.id

  tags          = {
    Name = "isolated-data-server"
  }
}
