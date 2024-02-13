variable  "ec2_instance_type" {
  type        = string 
  default     = "t2.micro"
  description = "An AWS EC2 Instance Type"
}


variable "instance_name" {
    description = "Value for the name tag of an EC2 instance"
    type        = string
    default     = "InstanceNameByVariable"
}