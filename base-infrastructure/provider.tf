variable "region"{
  type = string
  description = "Region to deploy Elasticsearch cluster."
  default = "us-east-1"
}

locals{
  common_prefix = "cyd"
  es_domain = "${local.common_prefix}-es-domain"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}
provider "aws" {
  region = var.region
}

variable "instance_type" {
  type = string
  default = "t2.medium"
}

variable "root_ebs_volume_size" {
  default =  50
  type    = number
}

variable "vpc_id" {
  type = string
  default = "aws_vpc.cyd.id"
}
