variable "public_key" {
  type        = string
  description = "DevOps Project 1 Public key for EC2 instance"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public subnets"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private subnets"
}

variable "eu_availability_zone" {
  type        = list(string)
  description = "Availability zones"
}