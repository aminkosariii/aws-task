module "vpc" {
  source               = "./vpc"
  cidr_vpc             = var.cidr_vpc
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones
}
module "s3" {
  source = "./s3"
}
module "alb" {
  source = "./alb"
 vpc_id          = var.vpc_id
}
module "elb" {
  source = "./elb"
  vpc_id      =  var.vpc_id

}
