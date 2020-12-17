provider "aws" {
  alias = "main"

  region  = local.region
  version = "~> 3.2.0"
}

module "network" {
  providers = {
    aws = aws.main
  }

  source = "./modules"

  vpc_cidr           = local.vpc_cidr
  azs                = local.azs
  env                = local.env
  group              = local.group
  region             = local.region
  public_subnets     = local.public_subnets
  private_subnets    = local.private_subnets
  single_nat_gateway = local.single_nat_gateway
  enable_flow_logs   = local.enable_flow_logs
  flow_logs_bucket   = local.flow_logs_bucket

  default_tags = {
    tf_control_path = join("/", slice(split("/", path.cwd), index(split("/", path.cwd), "terraform"), length(split("/", path.cwd))))
    env             = local.env
    region          = local.region
    group           = local.group
  }
}

