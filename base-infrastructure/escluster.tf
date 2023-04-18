#ES Cluster
resource "aws_elasticsearch_domain" "es" {
  domain_name = local.es_domain
  elasticsearch_version = "7.10"
  cluster_config {
      instance_count = 2
      instance_type = "t3.small.elasticsearch"
      zone_awareness_enabled = true
      zone_awareness_config {
        availability_zone_count = 2
      }
  }
  vpc_options {
      subnet_ids = [
        aws_subnet.nat_1.id,
        aws_subnet.nat_2.id
      ]
      security_group_ids = [
          aws_security_group.es.id
      ]
  }
  ebs_options {
      ebs_enabled = true
      volume_type = "gp2"
      volume_size = 10
  }
  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "es:*",
          "Principal": "*",
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.es_domain}/*"
      }
  ]
}
  CONFIG
  snapshot_options {
      automated_snapshot_start_hour = 23
  }
  tags = {
      Domain = local.es_domain
  }
  #depends_on = [aws_iam_service_linked_role.es]
}

#to push the statefile to s3 and lock with dynamodb table

# terraform {
#   backend "s3" {
#     bucket = "cyd-bucket"
#     key    = "cyd/s3/terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "cyd-dynamodb"
#   }
# }