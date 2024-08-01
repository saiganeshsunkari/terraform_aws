module "networking" {
  source               = "./networking"
  cidr_private_subnet  = var.cidr_private_subnet
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
}

module "security_group" {
  source                = "./securityGroups"
  publicSubnetCidrBlock = tolist(module.networking.publicSubnetCidrBlock)
  vpc_id                = module.networking.webAppVpcId
}

module "ec2" {
  source                       = "./ec2"
  public_key                   = var.public_key
  pythonApiSgId                = module.security_group.pythonApiSecurityGroupId
  webAppSgId                   = module.security_group.webAppSecurityGroupId
  webAppSubnetId               = tolist(module.networking.webAppPublicSubnetId)[0]
  user_data_install_python_api = templatefile("./template/ec2_python_app.sh", {})
}

module "rds" {
  source              = "./rds"
  rds_mysql_sg_id     = module.security_group.dbSecurityGroupId
  rds_mysql_subnet_id = tolist(module.networking.dbPrivateSubnetId)
}