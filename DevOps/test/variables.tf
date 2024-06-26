# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.16"
#     }
#   }

#   required_version = ">= 1.2.0"
# }

# provider "aws" {
#   region  = "us-east-1"
# }

# resource "aws_vpc" "apps_net" {
#   cidr_block       = "10.0.0.0/24"
#   instance_tenancy = "default"

#   tags             = {
#     Name = var.vpc_name
#   }
# }

# # Step 2: Switching from using a Private Gateway to an Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id 			= aws_vpc.apps_net.id

#   tags = {
#     Name 			= var.internet_gateway
#   }
# }

# # SUBNETS
# resource "aws_subnet" "PublicSubnet" {
#   vpc_id              				= aws_vpc.apps_net.id
#   cidr_block          				= "10.0.0.0/24"
#   availability_zone   				= "us-east-1a"
#   # Specify true to indicate that instances launched into the subnet should be assigned a public IP address.
#   map_public_ip_on_launch     = true

#   tags = {
#     Name = "PublicSubnet"
#   }
# }

# resource "aws_subnet" "Applications" {
#   vpc_id              				= aws_vpc.apps_net.id
#   cidr_block          				= "10.0.1.0/24"
#   availability_zone   				= "us-east-1b"
#   # Specify true to indicate that instances launched into the subnet should be assigned a public IP address.
#   map_public_ip_on_launch     = false

#   tags = {
#     # Applications
#     Name = "ApplicationsPrivateSubnet"
#   }
# }

# resource "aws_subnet" "DataServices" {
#   vpc_id              				= aws_vpc.apps_net.id
#   cidr_block          				= "10.0.2.0/24"
#   availability_zone   				= "us-east-1c"
#   # Specify true to indicate that instances launched into the subnet should be assigned a public IP address.
#   map_public_ip_on_launch     = false

#   tags = {
#     # Data Services
#     Name = "DataServicesIsolatedSubnet"
#   }
# }

# # resource "aws_instance" "stac_server" {
# #   ami           = var.instance_ami
# #   instance_type = var.instance_type

# #   tags          = {
# #     Name = var.instance_name
# #   }
# # }

# # SITE-TO-SITE VPN STEPS
# # Step 1: Create a customer gateway
# # Step 2: Create a target gateway
# # Step 3: Configure routing
# # Step 4: Update your security group
# # Step 5: Create a VPN connection
# # Step 6: Download the configuration file
# # Step 7: Configure the customer gateway device

# # Step 1: Customer gateway
# resource "aws_customer_gateway" "main" {
#   bgp_asn         = var.cgw_bgp_asn
#   ip_address      = var.cgw_ip_address
#   type            = "ipsec.1"

#   tags = {
#     Name = var.customer_gateway
#   }
# }

# # Step 2: Virtual Private Gateway
# # resource "aws_vpn_gateway" "main" {
# #   vpc_id             = aws_vpc.apps_net.id
# #   amazon_side_asn    =
# #   availability_zone  =

# #   tags = {
# #     Name = var.vpn_gateway
# #   }
# # }
# #


# # Step 5: A VPN connection
# resource "aws_vpn_connection" "stac_ai_vpn" {
#   customer_gateway_id                     = aws_customer_gateway.main.id
#   # vpn_gateway_id                          = aws_vpn_gateway.main.id
#   transit_gateway_id 										= aws_internet_gateway.igw.id
#   type                                    = "ipsec.1"

#   tags = {
#     Name = var.vpn_connection
#   }
# }


# // FARGATE
# variable "aws_access_key" {
#   description = "The IAM public access key"
# }

# variable "aws_secret_key" {
#   description = "IAM secret access key"
# }

# variable "aws_region" {
#   default     = "us-east-1"
#   description = "The AWS region of the Infrastructure"
# }

# variable "ec2_task_execution_role_name" {
#   description = "ECS task execution role name"
#   default = "myEcsTaskExecutionRole"
# }

# variable "ecs_auto_scale_role_name" {
#   description = "ECS auto scale role name"
#   default = "myEcsAutoScaleRole"
# }

# variable "az_count" {
#   default = "3"
#   description = "Number of AZs to cover in a given region"
# }

# variable "app_image" {
#   description = "Docker image to run in the ECS cluster"
#   default     = "nginx:latest"
# }

# variable "app_port" {
#   description = "Port exposed by the docker image to redirect traffic to"
#   default = 9000

# }

# variable "app_count" {
#   description = "Number of docker containers to run"
#   default = 3
# }

# variable "health_check_path" {
# default = "/"
# }

# variable "fargate_cpu" {
#   description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
#   default = "1024"
# }

# variable "fargate_memory" {
#   description = "Fargate instance memory to provision (in MiB)"
#   default = "2048"
# }
