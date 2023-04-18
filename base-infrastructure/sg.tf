#SG to allow traffic to and from the ES cluster
resource "aws_security_group" "es" {
  name = "${local.common_prefix}-es-sg"
  description = "Allow traffic to and from Elasticsearch"
  vpc_id = aws_vpc.cyd.id

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# #ES Service-Linked Role. (optional)
# resource "aws_iam_service_linked_role" "es" {
#   aws_service_name = "es.amazonaws.com"
# }

#SG for EC2 Instance
resource "aws_security_group" "cyd_ec2" {
  description = "Allow traffic"
  vpc_id      = aws_vpc.cyd.id

  tags = {
    Name = "cyd_ec2-instance-sg"
  }
}

resource "aws_security_group_rule" "webserver_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cyd_ec2.id
}

resource "aws_security_group_rule" "jenkins_server" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cyd_ec2.id
}

resource "aws_security_group_rule" "apache_web_server1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cyd_ec2.id
}

resource "aws_security_group_rule" "apache_web_server2" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cyd_ec2.id
}

resource "aws_security_group_rule" "webserver_allow_all_ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cyd_ec2.id
}

resource "aws_security_group_rule" "webserver_allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cyd_ec2.id
}




