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