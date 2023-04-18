variable "region" {
  type = string
  default = "us-east-1"
}

variable "dynamodb-table-name" {
  type = string
  default = "cyd-dynamodb"
}

variable "read_capacity" {
  type    = string
  default = "5"
}

variable "write_capacity" {
  type    = string
  default = "5"
}

variable "bucket-name" {
  type = string
  default = "cyd-bucket"
}

variable "versioning_enable" {
  type    = string
  default = true
}

variable "tags" {
  type = map(string)
  default = {
    Owner       = "cyd"
    Project     = "cyd-project"
    Environment = "Dev"
    Create_By   = "Terraform"
  }
}