variable "cidr_vpc" {
  type = string
}
variable "public_subnets_cidr" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "region" {
  type = string
}
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}
variable "vpc_id" {
    type = string
}
variable "public_subnet" {
  type        = list(string)
}
variable "private_subnet" {
  type        = list(string)
}
variable "security_groups" {
}