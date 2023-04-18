#output es & kibana endpoints
output "es_endpoint" {
  value = aws_elasticsearch_domain.es.endpoint
}
output "es_kibana_endpoint" {
  value = aws_elasticsearch_domain.es.kibana_endpoint
}


#output ec2 AMI ID
output "ami_id" {
  value = data.aws_ami.ubuntu_20_04.id
}