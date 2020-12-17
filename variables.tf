locals {
  work = terraform.workspace == "default" ? "no-workspace" : terraform.workspace
  # expects workspace to be set to 'env-group', for instance dev-devops which meand environment - dev, for devops purposes"


  env   = element(split("-", local.work), 0)
  group = element(split("-", local.work), 1)


  region_map = {
    "dev-devops"     = "us-east-1"
  }

  region = lookup(local.region_map, local.work, "us-east-1")

  vpc_cidr_map = {
    "dev-devops"     = "172.16.0.0/21"
  }
  vpc_cidr = lookup(local.vpc_cidr_map, local.work, "172.16.0.0/21")
  azs_map = {
    "dev-devops"     = "us-east-1a,us-east-1b,us-east-1c"
  }
  azs = lookup(local.azs_map, local.work, "us-east-1a,us-east-1b,us-east-1c")

  private_subnets_map = {
    "dev-devops"     = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  }
  private_subnets = lookup(local.private_subnets_map, local.work, "")

  public_subnets_map = {
    "dev-devops"     = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  }
  public_subnets = lookup(local.public_subnets_map, local.work, "")

  single_nat_gateway_map = {
    "dev-devops"     = true
  }
  single_nat_gateway = lookup(local.single_nat_gateway_map, local.work, "true")

  enable_flow_logs_map = {
    "dev-devops"     = true
  }
  enable_flow_logs = lookup(local.enable_flow_logs_map, local.work, "false")
  flow_logs_bucket_map = {
    "dev-devops"  = "flow_logs_test_bucket"

  }
  flow_logs_bucket = lookup(local.flow_logs_bucket_map, local.work, "flow_logs_test_bucket")
}
